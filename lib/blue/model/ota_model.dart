import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../../base_tool/log_utils.dart';
import '../../base_views/rh_toast.dart';
import '../base/ble_model.dart';
import '../ble_manager.dart';
import '../commands/ota_commands.dart';
import '../entity/rh_blue_scan_result.dart';
import '../enum/ble_device_data_msg.dart';
import '../enum/ble_device_state_msg.dart';
import '../enum/device_type.dart';
import '../scan/scan_device_tools.dart';
import '../tools/crc_tools.dart';
import '../uuid/ble_uuid.dart';

class OtaModel extends BleModel {

  List<RHBlueScanResult> bleResultList = [];
  List<RHDeviceType> typeList = [RHDeviceType.powerAdvanced];
  // OTA 数据回调接口
  Function(List<int> otaData)? onOtaDataReceived;
  OtaModel() {
    setDeviceType(RHDeviceType.ota);
    // bleDeviceStateController.stream.listen((msg) {
    //
    // });
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
    List<RHBlueScanResult> resultList = await ScanDeviceTools.sortOtaDeviceInfo(result, typeList);
    if (resultList.isNotEmpty){
      scanSize = resultList.length;
      BleManager.instance.stopScan();
      bleResultList.clear();
      if (resultList.isNotEmpty) {
        bleResultList.addAll(resultList);
        bleResultList.sort((a, b) => b.scanResult.rssi.compareTo(a.scanResult.rssi));
      }
      bleDeviceStateController.add(BleDeviceStateMsg.deviceScanResult);
    }
    // if (resultList.isNotEmpty) {
    //   scanSize = resultList.length;
    //   BleManager.instance.stopScan();
    //   // if (isDispose) {
    //   //   return;
    //   // }
    //   if (resultList.length == 1) {
    //     selectDevice(resultList[0]);
    //     connectDevice();
    //   }else{
    //     LogUtils.d("你是又弹出来啦？");
    //     RHToast.dismiss();
    //     showSelectDeviceDialog(resultList, (value) {
    //       Navigator.pop(Get.context!);
    //       selectDevice(value);
    //       connectDevice();
    //     });
    //   }
    // }
  }

  @override
  void selectDevice(RHBlueScanResult scanResult) {
    super.selectDevice(scanResult);
    connectDevice();
  }

  @override
  void connectDevice() {
    if(mDevice == null) return;
    if(isDispose) return;
    bleDeviceStateController.add(BleDeviceStateMsg.bleStartConnect);
    BleManager.instance.registerDeviceStreamSubscription(mDevice!);
    BleManager.instance.stopScan();
    super.connectDevice();
  }

  @override
  void deviceConnected() {
    if (mDevice != null) {
      if (!bleDeviceStateController.isClosed) {
        bleDeviceStateController.add(BleDeviceStateMsg.bleConnect);
        deviceDiscovery(BlueUUID.FS_UUID, BlueUUID.POWER_NOTIFY, write: BlueUUID.POWER_WRITE);
      }
    }
  }

  @override
  void deviceDisconnected() {
  }

  List<int> data = [];
  int header = 0xF5;
  int footer = 0xFA;
  int state = 0;

  @override
  notifyCharacteristicValue(List<int> event) {
    if (event[0] == header && event.last == footer) {
      List<int> value = CrcTools.receiveDecodeCmd(event);
      if (CrcTools.checkCRC(value)) {
        onOtaDataReceived?.call(value);
        // _repository.handleCharacteristic(value, walkDeviceData, mDeviceInfo!);
        // LogUtils.d("返回的数据A： ${Tools.getNiceHexArray(value)}");
        return;
      }
    }
    if (event[0] == header && event.last != footer) {
      data.clear();
      data.addAll(event);
      state = 1;
      return;
    }
    if (event.last == footer && state == 1) {
      state = 2;
      data.addAll(event);
    }
    if (state == 2) {
      List<int> value = CrcTools.receiveDecodeCmd(data);
      if (CrcTools.checkCRC(value)) {
        onOtaDataReceived?.call(value);
        // _repository.handleCharacteristic(value, walkDeviceData, mDeviceInfo!);
        // LogUtils.d("返回的数据B： ${Tools.getNiceHexArray(value)}");
      }
    }
  }

  @override
  void sendMessage(BleDeviceStateMsg msg) {
    bleDeviceStateController.add(msg);
    switch (msg) {
    ///通知设备通道打开后开始初始化
      case BleDeviceStateMsg.deviceOpenCharacter: {
        ///打开通道后发送0x01指令
        bleDeviceStateController.add(BleDeviceStateMsg.deviceCheckSuccess);
      }
      case BleDeviceStateMsg.deviceOpenCharacterError: {

      }
      default:
        break;
    }
    print('AAAAAA  sendMessage $msg');
    bleDeviceStateController.add(msg);
  }

  handshake(int chipNumber, int mode, int packetCount, int fileLength, int versionHigh, int versionLow) {
    otaWrite(OtaCommands.handshake(chipNumber, mode, packetCount, fileLength, versionHigh, versionLow));
  }

  IAPWrite(int chipNumber, int packageNum, int length, List<int> data) {
    otaWrite(OtaCommands.IAPWrite(chipNumber, packageNum, length, data));
  }

  exitBootloader(int chipNumber) {
    otaWrite(OtaCommands.exitBootloader(chipNumber));
  }

  queryChipVersion(int chipNumber) {
    otaWrite(OtaCommands.queryChipVersion(chipNumber));
  }

  readRom(int chipNumber, int addressHigh, int addressLow, int length) {
    otaWrite(OtaCommands.readRom(chipNumber, addressHigh, addressLow, length));
  }

  writeRom(int chipNumber, int addressHigh, int addressLow, int length, List<int> data) {
    otaWrite(OtaCommands.writeRom(chipNumber, addressHigh, addressLow, length, data));
  }

  eraseRom(int chipNumber, int addressHigh, int addressLow) {
    otaWrite(OtaCommands.eraseRom(chipNumber, addressHigh, addressLow));
  }

  @override
  void clean() {
  }

  stopConnect() {
    disconnectDevice(clean:  true);
    disposeConnect();
  }
  
}
