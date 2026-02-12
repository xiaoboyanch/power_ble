import 'dart:async';

import 'package:cabina_ble/blue/base/ble_model.dart';
import 'package:cabina_ble/blue/commands/power_commands.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
import 'package:cabina_ble/blue/enum/ble_device_state_msg.dart';
import 'package:cabina_ble/blue/repository/power_adv_repository.dart';
import 'package:cabina_ble/blue/tools/crc_tools.dart';
import 'package:cabina_ble/blue/tools/tools.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../base_tool/log_utils.dart';
import '../../base_views/rh_toast.dart';
import '../ble_manager.dart';
import '../entity/rh_blue_scan_result.dart';
import '../enum/ble_device_data_msg.dart';
import '../enum/device_type.dart';
import '../scan/scan_device_tools.dart';
import '../uuid/ble_uuid.dart';

class PowerAdvancedModel extends BleModel {

  final PowerAdvancedData mPowerData = PowerAdvancedData();
  late PowerAdvancedRepository _repository;
  List<RHBlueScanResult> bleResultList = [];
  StreamController<BleDeviceDataMsg> get bleDeviceDataController => _repository.bleDeviceDataController;
  List<RHDeviceType> typeList = [RHDeviceType.powerAdvanced, RHDeviceType.powerSony];
  Timer? degreeTimer;
  Timer? paramsTimer;
  Timer? curMotorTimer;

  PowerAdvancedModel() {
    setDeviceType(RHDeviceType.powerAdvanced);
    _repository = PowerAdvancedRepository(bleDeviceStateController);
    _repository.powerAdvancedData = mPowerData;
    mQueryCmdData = PowerCommands.getDeviceStatus();
    bleDeviceStateController.stream.listen((msg) {
      switch (msg) {
        case BleDeviceStateMsg.deviceCheckSuccess: {
          RHToast.dismiss();
          cleanParamsTimer();
          sendCmd(PowerCommands.getDeviceState0902CMD());
        }
        case BleDeviceStateMsg.deviceUnitState: {
          sendCmd(PowerCommands.getMainInfo_03Data());
          startSendTimer();
          startDegreeTimer();
          startCurMotorTimer();
          if (mPowerData.deviceType == RHDeviceType.powerAdvanced.value) {
            startParamTimer();
          }
        }
        case BleDeviceStateMsg.bleBleReConnect: {

        }
        default:
          break;
      }
    });
  }
  bool handleCounter = false;
  startDegreeTimer() {
    degreeTimer?.cancel();
    degreeTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      // if (handleCounter) {
        getBackSeatDegree();
      //   handleCounter = false;
      // } else {
      //   getHandleKey();
      //   handleCounter = true;
      // }
    });
  }

  startCurMotorTimer() {
    curMotorTimer?.cancel();
    curMotorTimer = Timer.periodic(const Duration(milliseconds: 210), (timer) {

      if (handleCounter) {
        getCurMotorData();
        handleCounter = false;
      } else {
        getHandleKey();
        handleCounter = true;
      }
      LogUtils.d("AAAAAAAAA");
    });
  }

  startParamTimer() {
    paramsTimer?.cancel();
    paramsTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      sendCmd(PowerCommands.getMotorData(mPowerData.curMotorGroup));
      // sendCmd(PowerCommands.getMotorData(0));
      // sendCmd(PowerCommands.getMotorData(1));
      // sendCmd(PowerCommands.getMotorData(2));
      // sendCmd(PowerCommands.getBackSeatDegree());
    });
  }

  stopParamTimer() {
    paramsTimer?.cancel();
    paramsTimer = null;
  }

  @override
  Future<void> startScan() async {
    if (await checkPermission()) {
      super.startScan();
      int _flag = 0;
      BleManager.instance.startScan([Guid(BlueUUID.FS_UUID)], [], typeList, (result) {
        int newFlag = ++_flag;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (newFlag == _flag) {
            // if (type == RHDeviceType.powerBoard) {
            sortScanResult(result);
            // }
          }
        });

      });
    }
  }

  @override
  sortScanResult(List<ScanResult> result) async{
    List<RHBlueScanResult> resultList = await ScanDeviceTools.sortDeviceInfo(result, typeList);
    if (resultList.isNotEmpty){
      scanSize = resultList.length;
      BleManager.instance.stopScan();
      bleResultList.clear();
      if (resultList.isNotEmpty) {
        bleResultList.addAll(resultList);
      }
      bleDeviceStateController.add(BleDeviceStateMsg.deviceScanResult);
    }
  }

  @override
  void selectDevice(RHBlueScanResult scanResult) {
    super.selectDevice(scanResult);
    connectDevice();
  }

  @override
  void connectDevice() async {
    if (mDevice == null) return;
    bleDeviceStateController.add(BleDeviceStateMsg.bleStartConnect);
    BleManager.instance.registerDeviceStreamSubscription(mDevice!);
    BleManager.instance.stopScan();
    super.connectDevice();
  }

  @override
  void deviceConnected() {
    if (mDevice == null) return;
    if (!bleDeviceStateController.isClosed) {
      bleDeviceStateController.add(BleDeviceStateMsg.bleConnect);
      deviceDiscovery(BlueUUID.FS_UUID, BlueUUID.POWER_NOTIFY, write: BlueUUID.POWER_WRITE);
    }
  }

  @override
  void deviceDisconnected() {
  }

  sendCmd(List<int> value) {
    checkDeviceInfo(value);
  }

  // @override
  // notifyCharacteristicValue(List<int> event) {
  //   if (event.length > 5) {
  //     List<int> value = CrcTools.receiveDecodeCmd(event);
  //     if (CrcTools.checkCRC(value)) {
  //       _repository.handleCharacteristic(value, mPowerData, mDeviceInfo!);
  //     }
  //   }
  // }
  List<int> _buffer = []; // 添加缓冲区

  @override
  notifyCharacteristicValue(List<int> event) {
    // 将新接收到的数据追加到缓冲区
    _buffer.addAll(event);
    // 处理粘包数据
    // List<List<int>> packets = splitPackets(event);
    // 处理缓冲区中的数据包
    List<List<int>> packets = splitPackets(_buffer);

    for (List<int> packet in packets) {
      if (packet.length > 5) {
        List<int> value = CrcTools.receiveDecodeCmd(packet);
        if (CrcTools.checkCRC(value)) {
          _repository.handleCharacteristic(value, mPowerData, mDeviceInfo!);
        }
      }
    }

    // 保留未完成的数据包在缓冲区中
    _buffer = _getRemainingBuffer(_buffer, packets);
  }

  List<List<int>> splitPackets(List<int> rawData) {
    List<List<int>> packets = [];
    int start = 0;

    while (start < rawData.length) {
      // 查找包头 F5
      int headIndex = rawData.indexOf(0xF5, start);
      if (headIndex == -1) break; // 没找到包头，跳出循环

      // 查找从包头开始的包尾 FA
      int tailIndex = rawData.indexOf(0xFA, headIndex);
      if (tailIndex == -1) break; // 没找到包尾，跳出循环，等待更多数据

      // 提取完整数据包
      List<int> packet = rawData.sublist(headIndex, tailIndex + 1);
      packets.add(packet);

      // 更新下次查找的起始位置
      start = tailIndex + 1;
    }

    return packets;
  }

  // 获取剩余未处理的数据（不完整的包）
  List<int> _getRemainingBuffer(List<int> originalData, List<List<int>> extractedPackets) {
    if (extractedPackets.isEmpty) {
      return originalData; // 如果没有提取出任何完整包，返回原始数据
    }

    // 找到最后一个完整包的位置
    int lastPacketEndIndex = 0;
    for (List<int> packet in extractedPackets) {
      int index = _findSublistEndIndex(originalData, packet, lastPacketEndIndex);
      if (index != -1) {
        lastPacketEndIndex = index;
      }
    }

    // 返回未处理的数据部分
    if (lastPacketEndIndex < originalData.length) {
      return originalData.sublist(lastPacketEndIndex);
    }

    return [];
  }

  // 辅助方法：查找子列表在原列表中的结束索引
  int _findSublistEndIndex(List<int> list, List<int> sublist, int startIndex) {
    for (int i = startIndex; i <= list.length - sublist.length; i++) {
      bool found = true;
      for (int j = 0; j < sublist.length; j++) {
        if (list[i + j] != sublist[j]) {
          found = false;
          break;
        }
      }
      if (found) {
        return i + sublist.length;
      }
    }
    return -1;
  }

  // List<List<int>> splitPackets(List<int> rawData) {
  //   List<List<int>> packets = [];
  //   int start = 0;
  //
  //   while (start < rawData.length) {
  //     // 查找包头 F5
  //     int headIndex = rawData.indexOf(0xF5, start);
  //     if (headIndex == -1) break;
  //
  //     // 查找从包头开始的包尾 FA
  //     int tailIndex = rawData.indexOf(0xFA, headIndex);
  //     if (tailIndex == -1) break;
  //
  //     // 提取完整数据包
  //     List<int> packet = rawData.sublist(headIndex, tailIndex + 1);
  //     packets.add(packet);
  //
  //     // 更新下次查找的起始位置
  //     start = tailIndex + 1;
  //   }
  //
  //   return packets;
  // }

  @override
  void sendMessage(BleDeviceStateMsg msg) {
    bleDeviceStateController.add(msg);
    switch (msg) {
    ///The initialization begins after the notification device channel is opened
      case BleDeviceStateMsg.deviceOpenCharacter:
        {
          ///After opening the Characteristic, send the 0x01 instruction
          bleDeviceStateController.add(BleDeviceStateMsg.deviceChecking);
          startCheckDeviceInfo();
        }
      case BleDeviceStateMsg.deviceOpenCharacterError:
        {}
      default:
        break;
    }
    bleDeviceStateController.add(msg);
  }

  ///Set parameters
  ///

  setBackSeatDegree(int backDegree, int seatDegree) {
    // mCmdData.clear();
    List<int> cmdData = PowerCommands.setBackSeat(backDegree, seatDegree);
    LogUtils.d("发送扬升： ${Tools.getNiceHexArray(cmdData)}");
    sendCmd(cmdData);
  }

  setUnit(bool isKG) {
    mCmdData.add(PowerCommands.getDeviceConfig(isKG));
  }

  setPowerMode(int motorNumber, int status, int mode, List<int> modeList) {
    // mCmdData.clear();
    // mCmdData.add();
    LogUtils.d("下发： 数据：aaaaaaa");
    sendCmd(PowerCommands.setPowerMode(motorNumber, status, mode, modeList));
  }

  getBackSeatDegree() {
    sendCmd(PowerCommands.getBackSeatDegree());
  }

  getHandleKey() {
    sendCmd(PowerCommands.getHandle());
  }

  getCurMotorData() {
    sendCmd(PowerCommands.getCurMotor());
  }

  @override
  void clean() {
    _repository.dispose();
  }

  stopConnect() {
    degreeTimer?.cancel();
    degreeTimer = null;
    disconnectDevice(clean:  true);
    disposeConnect();
    _buffer.clear();
  }

}