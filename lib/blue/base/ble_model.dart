import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../enum/device_type.dart';
import '../tools/tools.dart';
import '../../base_tool/log_utils.dart';
import '../../base_views/rh_dialog.dart';
import '../../base_views/rh_permission.dart';
import '../../base_views/rh_toast.dart';
import '../dialog/home_device_select_view.dart';
import '../entity/device_info.dart';
import '../entity/rh_blue_scan_result.dart';
import '../enum/ble_device_state_msg.dart';

import '../ble_manager.dart';
import '../commands/power_commands.dart';

abstract class BleModel {
  static const int scanTime = 3;
  BluetoothDevice? mDevice;
  RHBluetoothDeviceInfo? mDeviceInfo;
  RHBlueScanResult? mScanResult;
  BluetoothCharacteristic? _notifyCharacteristic;
  BluetoothCharacteristic? _writeCharacteristic;
  StreamSubscription? _notifyStream;
  StreamSubscription? _scanStream;
  StreamSubscription? _connectStateStream;
  RHDeviceType deviceType = RHDeviceType.none;

  StreamController<BleDeviceStateMsg> bleDeviceStateController =
      StreamController.broadcast();

  List<List<int>> mCmdData = [];
  List<int> mQueryCmdData = [];
  //律动机的麻烦事
  List<List<int>> mCmdColorData = [];
  List<List<int>> mCmdCtrlData = [];

  /// 设备连接并通道打开后执行0x02指令 循环3次
  Timer? initInfoTimer;
  int infoSendCount = 0;
  bool isDeviceConnect = false;

  Timer? _sendTimer;
  Timer? paramsTimer;

  static const int MAX_SEND_COUNT = 9;
  static const int SEND_DURATION = 299; // 500毫秒

  var _connectCount = 0;
  var scanSize = 0;

  bool isReConnect = false;
  HomeDeviceSelectView? _homeDeviceSelectView;
  late RHDialog disconnectDialog;
  bool isDispose = false;
  BleModel() {
    _init();
  }

  _init() async {
    isDispose = false;
    disconnectDialog = RHDialog(content: 'ble_reconnect_tips'.tr, showCancel: true, confirmKey: "connect", onConfirmClick: () {
      if (BleManager.instance.bluetoothState != BluetoothAdapterState.on) {
        RHToast.showToast(msg: "bleNotOn");
        Future.delayed(const Duration(seconds: 1), () {
          showDisconnectDialog();
        });
      }else {
        if(mDevice != null) {
          if (!mDevice!.isConnected) {
            isReConnect = true;
            RHToast.showLoading(msg: "start_connecting");
            _connectCount = 0;
            _connect();
          }
        }
      }

    },);
    // _scanStream = BleManager.instance.scanningStreamController.stream.listen((isScanning) {
    //   if (isScanning) {
    //     LogUtils.d("蓝牙通知-开始扫描");
    //     scanSize = 0;
    //   } else {
    //     LogUtils.d("蓝牙通知-结束扫描");
    //     if (scanSize == 0) {
    //       RHToast.dismiss();
    //       LogUtils.d("AAAAAAAAAAAAAAa 弹出扫不到框: $deviceType");
    //       if (!isDeviceConnect) {
    //         if (BleManager.instance.scanDeviceType.contains(deviceType)) {
    //           if(deviceType != RHDeviceType.bracelet) {
    //             if (!BleManager.instance.showTipDialog()!.isShow) {
    //               BleManager.instance.showTipDialog()!.show();
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    // });
    bleDeviceStateController.stream.listen((msg) {
      switch (msg) {
        case BleDeviceStateMsg.deviceCheckSuccess: {
          RHToast.dismiss();
        }
        case BleDeviceStateMsg.bleStartConnect: {
          RHToast.showLoading(msg: "start_connecting");
        }
        case BleDeviceStateMsg.bleConnectError: {
          // RHToast.showToast(msg: "连接失败");
          LogUtils.d("连接失败");
          RHToast.dismiss();
          if (isReConnect) {
            showDisconnectDialog();
          }
        }
        case BleDeviceStateMsg.deviceOpenCharacterError: {
          // RHToast.showToast(msg: "open_character_error");
          RHToast.dismiss();
          if(!isReConnect) {
            RHToast.showToast(msg: "bleConnectionError");
          }
        }
        case BleDeviceStateMsg.bleCharacteristicError: {
          checkDeviceConnect();
        }
        default: {}
      }
    });
    _connectStateStream = BleManager.instance.connectionStateStreamController.stream.listen((state) {
      LogUtils.d("蓝牙连接状态 :$state");
      switch (state) {
        case BluetoothConnectionState.connected:
          LogUtils.d("AAAAAAa蓝牙通知-连接成功 : $isDeviceConnect");
          if (isReConnect) {
            bleDeviceStateController.add(BleDeviceStateMsg.bleBleReConnect);
            isReConnect = false;
          }
          // RHToast.dismiss();
          if (!isDeviceConnect) {
            isDeviceConnect = true;
            deviceConnected();
            BleManager.instance.stopScan();
            LogUtils.d("蓝牙通知-连接成功 : $isDeviceConnect");
          }
          break;
        case BluetoothConnectionState.disconnected:
          LogUtils.d("是不是来这里了？ 蓝牙断开");
          if (deviceType == RHDeviceType.walking) {
            if (mDevice != null) {
              if (mDevice!.isConnected) {
                return;
              }else {
              }
            }
          }
          if (isDeviceConnect) {
            isDeviceConnect = false;
            deviceDisconnected();
            bleDeviceStateController.add(BleDeviceStateMsg.bleDisconnect);
            showDisconnectDialog();
            LogUtils.d("蓝牙通知-连接断开 : $isDeviceConnect");
          }
          break;
        default:
          {}
      }
    });
  }

  bool checkDeviceConnect(){
    if (mDevice != null) {
      if (!mDevice!.isConnected) {
        showDisconnectDialog();
        return false;
      }else {
        return true;
      }
    }
    return false;
  }

  setDeviceType(RHDeviceType type) {
    deviceType = type;
  }

  showDisconnectDialog() {
    LogUtils.d("AAAAAAAAAAAAAAa 弹出扫不到框22222222: $deviceType  ${mDevice == null}");
    if(deviceType != RHDeviceType.bracelet) {
      if (!isDispose && mDevice != null) {
        if (!disconnectDialog.isShow) {
          RHToast.dismiss();
          String routing = Get.routing.current;
          // if (routing != RHRoute.mainTabbar) {
          //   disconnectDialog.show();
          // }
        }
      }
    }
  }

  void startScan() {
    // DeviceModel.getMgr().deviceScanModel?.clean();
    // DeviceModel.getMgr().deviceScanModel = null;
    RHToast.showLoading(msg: "start_scanning");
  }

  Future<bool> checkPermission() async {
    if (BleManager.instance.bluetoothState != BluetoothAdapterState.on) {
      RHToast.showToast(msg: "bleNotOn");
      // BleManager.instance.
      return false;
    }
    if (Platform.isAndroid) {
      if (!(await RHPermission.checkLocationService())) {
        return false;
      }
    }
    if (!(await RHPermission.checkBluetoothPermission())) {
      return false;
    }
    return true;
  }

  void showSelectDeviceDialog(List<RHBlueScanResult> list, Function(RHBlueScanResult) callback) {
    _homeDeviceSelectView ??= HomeDeviceSelectView(itemClick: callback);
    _homeDeviceSelectView?.show(list, Get.context!);
  }

  void deviceConnected();

  void deviceDisconnected();

  void sendMessage(BleDeviceStateMsg msg);

  sortScanResult(List<ScanResult> result);

  notifyCharacteristicValue(List<int> event);

  void selectDevice(RHBlueScanResult scanResult) {
    mScanResult = scanResult;
    mDevice = scanResult.bluetoothDevice;
    mDeviceInfo = scanResult.deviceInfo;
  }

  Future<void> disconnectDevice({bool clean = true}) async {
    await mDevice?.disconnect();
    if (clean) {
      mDevice == null;
    }

  }

  void connectDevice() async {
    _connectCount = 0;
    _connect();
  }

  _connect() async {
    try {
      await mDevice?.connect(timeout: const Duration(seconds: scanTime));
    } catch (e) {
      if (_connectCount > 3) {
        bleDeviceStateController.add(BleDeviceStateMsg.bleConnectError);
        LogUtils.d("蓝牙连接失败 ${e.toString()}");
        if (!isReConnect) {
          RHToast.dismiss();
          RHToast.showToast(msg: "bleConnectionError");
        }
      } else {
        _connect();
        _connectCount++;
        // RHToast.showToast(msg: "蓝牙连接失败, 尝试重连");
      }
    }
  }

  startSendTimer() {
    _sendTimer?.cancel();
    _sendTimer =
        Timer.periodic(const Duration(milliseconds: SEND_DURATION), (timer) {
      _senderAction();
    });
  }

  startSendNoQueryTimer(int millisecond) {
    _sendTimer?.cancel();
    _sendTimer =
        Timer.periodic(Duration(milliseconds: millisecond), (timer) {
          _senderCmdAction();
        });
  }

  bool _useCmdDataColor = true;
  _senderCmdAction() {
    if (_useCmdDataColor) {
      if (mCmdCtrlData.isNotEmpty) {
        _write(mCmdCtrlData.removeAt(0));
      } else if (mCmdColorData.isNotEmpty) {
        _write(mCmdColorData.removeAt(0));
      }else {
        if (mCmdData.isNotEmpty) {
          _write(mCmdData.removeAt(0));
        }
      }
    }else {
      if (mCmdCtrlData.isNotEmpty) {
        _write(mCmdCtrlData.removeAt(0));
      } else if (mCmdData.isNotEmpty) {
        _write(mCmdData.removeAt(0));
      }else {
        if (mCmdColorData.isNotEmpty) {
          _write(mCmdColorData.removeAt(0));
        }
      }
    }
    _useCmdDataColor = !_useCmdDataColor;
  }

  _senderAction() {
    if (mCmdData.isEmpty) {
      if (mQueryCmdData.isNotEmpty) {
        _write(mQueryCmdData);
      }
    } else {
      _write(mCmdData.removeAt(0));
    }
  }

  stopSendTimer() {
    _sendTimer?.cancel();
    _sendTimer = null;
  }

  checkDeviceInfo(List<int> value) {
    _write(value);
  }


  void _write(List<int> value) async {
    if (mDevice != null && mDevice!.isConnected) {
      try {
        // LogUtils.d("发送指令: ${Tools.getNiceHexArray(value)}");
        await _writeCharacteristic?.write(value, withoutResponse: true);
      } catch (e) {
        LogUtils.d("下发指令出错： ${e.toString()}");
        bleDeviceStateController.add(BleDeviceStateMsg.bleCharacteristicError);
        // RHLog.i("蓝牙通知-22写入指令出错 $e");
      }
    }
  }

  void deviceDiscovery(String serviceCharacteristic, String notify,
      {String? write}) async {
    var services = await mDevice!.discoverServices();
    final service = services.firstWhereOrNull((element) {
      return element.uuid.toString().toUpperCase() == serviceCharacteristic;
    });
    _notifyCharacteristic = null;
    if (service != null) {
      LogUtils.d("蓝牙通知-发现服务");
      _notifyCharacteristic = service.characteristics.firstWhereOrNull(
          (item) => item.uuid.str.toString().toUpperCase() == notify);
      if (write != null) {
        _writeCharacteristic = service.characteristics.firstWhereOrNull(
            (item) => item.uuid.str.toString().toUpperCase() == write);
      }
    }
    if (_notifyCharacteristic != null) {
      LogUtils.d("蓝牙通知-找到通知通道");
      _setSubNotifyCharacteristic();
      if (write == null) {
        sendMessage(BleDeviceStateMsg.deviceOpenCharacter);
      }
    } else {
      if (write == null) {
        sendMessage(BleDeviceStateMsg.deviceOpenCharacterError);
      }
      LogUtils.d("蓝牙通知-未找到通知通道");
    }
    if (_writeCharacteristic != null) {
      LogUtils.d("蓝牙通知-找到写通道");
      if (_notifyCharacteristic != null) {
        sendMessage(BleDeviceStateMsg.deviceOpenCharacter);
      }
    } else {
      LogUtils.d("蓝牙通知-未找到写通道");
      if (write != null) {
        sendMessage(BleDeviceStateMsg.deviceOpenCharacterError);
      }
    }
  }

  _setSubNotifyCharacteristic() async {
    if (_notifyCharacteristic != null) {
      _notifyStream?.cancel();
      _notifyStream = null;
      await _notifyCharacteristic!.setNotifyValue(true);
      _notifyStream = _notifyCharacteristic!.lastValueStream.listen((event) {
        if (event.isEmpty) return;
        notifyCharacteristicValue(event);
      });
    } else {
      LogUtils.d("蓝牙通知-未找到通知通道");
    }
  }

  startCheckDeviceState() {
    initInfoTimer?.cancel();
    initInfoTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (infoSendCount < 3) {
        infoSendCount++;
        checkDeviceInfo(PowerCommands.getDeviceState0902CMD());
      } else {
        initInfoTimer?.cancel();
        initInfoTimer = null;
        infoSendCount = 0;
        startSendTimer();
      }
    });
  }

  startCheckDeviceInfo() {
    cleanParamsTimer();
    paramsTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      checkDeviceInfo(PowerCommands.getMainInfo_01Data());
    });
  }

  cleanParamsTimer() {
    paramsTimer?.cancel();
    paramsTimer = null;
  }

  dispose() {
    cleanParamsTimer();
    stopSendTimer();
    _scanStream?.cancel();
    _connectStateStream?.cancel();
    bleDeviceStateController.close();
    _notifyStream?.cancel();
    _notifyStream = null;
    isDispose = true;
    clean();
  }

  disposeConnect() {
    cleanParamsTimer();
    stopSendTimer();
    // _scanStream?.cancel();
    // _connectStateStream?.cancel();
    _notifyStream?.cancel();
    _notifyStream = null;
    isDispose = true;
  }

  void clean();
}
