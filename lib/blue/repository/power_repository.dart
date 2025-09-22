import 'dart:async';
import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../commands/power_commands.dart';
import '../entity/device_info.dart';
import '../entity/power_device_data.dart';
import '../entity/rh_blue_scan_result.dart';
import '../enum/ble_device_data_msg.dart';
import '../enum/ble_device_state_msg.dart';
import '../enum/blue_ack_enum.dart';
import '../enum/device_type.dart';
import '../tools/rh_log.dart';
import '../scan/scan_device_tools.dart';
import '../tools/tools.dart';

class PowerRepository {

  static const int CODE_KG_CHANGE = 1;


  static const int cmdIndex = 3;
  static const int cmdDataIndex = 4;

  static const int subCmdIndex = 4;
  static const int subCmdDataIndex_5 = 5;
  static const int sportModeDataIndex = 11;

  static const int sportLevelIndex = 20;

  PowerRepository(StreamController<BleDeviceStateMsg> controller) {
    bleDeviceStateController = controller;
  }

  ///蓝牙notify返回来的数据处理后传到ui层
  late StreamController<BleDeviceStateMsg> bleDeviceStateController;
  StreamController<BleDeviceDataMsg> bleDeviceDataController = StreamController.broadcast();

  Future<List<RHBlueScanResult>> sortScanResult(List<ScanResult> result, List<RHDeviceType> type) async{
     final list = await ScanDeviceTools.sortDeviceInfo(result, type);
     return Future.value(list);
  }

  static int _times = 0;
  int handleCharacteristic(List<int> value, PowerDeviceData deviceData, RHBluetoothDeviceInfo deviceInfo) {
    switch (value[cmdIndex]) {
      case PowerCommands.cmdQueryParam_0x01:
        _handleDeviceInfo(value, deviceData, deviceInfo);
        break;
      case PowerCommands.cmdQueryData_0x09:
      //获取设备的状态
        switch (value[subCmdIndex]) {
          case PowerCommands.queryDataState_0x02:
            {
              _times = 0;
              return _handleDeviceStatus(value, deviceData);
            }
          case PowerCommands.queryDataSport_0x04:
            {
              if (_times++%20 == 0) {
                print('BBBB  $value');
              }
              switch (deviceInfo.type) {
                case 30:
                case 31:
                case 32:
                  if (deviceData.version > 5) {
                    _handleDeviceData_V6(value, deviceData);
                  }else {
                    _handleDeviceData(value, deviceData);
                  }
                  break;
                case 33:
                  _handleSportData_33(value, deviceData);
                  break;
              }
            }
          // case PowerCommands.queryDataSport_0x06:
          //   {
          //     _handleHCJData(value, deviceData);
          //     break;
          //   }
        }
        break;
      case PowerCommands.cmdDeviceConf_0x0C:
        {
          int subOrder = value[4];
          switch (subOrder) {
            case 0x03:
              deviceData.ackList.add(BlueAckEnum.blueName);
              break;
            case 0x06:
              deviceData.ackList.add(BlueAckEnum.musicName);
              break;
            case 0x0D:
              deviceData.ackList.add(BlueAckEnum.bobaoVolume);
              break;
            case 0x0B:
              _handleDeviceVolume(value, deviceData);
              return 0;
          }
          bleDeviceDataController.add(BleDeviceDataMsg.deviceAck_0xD0);
        }
        break;
      case PowerCommands.cmdResponse_0xD0:
        int mainOrder = value[4];
        switch (mainOrder) {
          case 0x02:
            deviceData.ackList.add(BlueAckEnum.changeCode);
            break;
          case 0x03:
            deviceData.ackList.add(BlueAckEnum.bobao_KG);
            break;
          case 0x05:
            int subOrder = value[5];
            if (subOrder > 6) {
              deviceData.ackList.add(BlueAckEnum.modeAndWeight);
            }else{
              deviceData.ackList.add(BlueAckEnum.forceLoading);
            }
            break;
        }
        bleDeviceDataController.add(BleDeviceDataMsg.deviceAck_0xD0);
        break;
      case PowerCommands.cmdError:
        {
          // [F5, 09, 00, 0E, 00, F0, 0C, 9A, FA]
          // 指令不支持	0x00
          // 格式不正确	0x02
          // CRC 失败	0x04
          // 系统忙	0x06
          // 数值不在范围内	0x08
          //   bleDeviceDataController.add(BleDeviceDataMsg.orderError_0x0E);
        }
        break;
    }
    return 0;
  }

  _handleDeviceInfo(List<int> value, PowerDeviceData data, RHBluetoothDeviceInfo deviceInfo) {
    // 健身站数据       llz类型    品牌吗       机型吗
    // [245, 30, 0, 1, 0, 30,  0, 168,     （89, 217,【0x59D9=23001】）
    //电机，异步 模式  步长
    // 2, 0,    128, 0,   （0, 0）, （0, 0）, 0, （0, 0）, （0, 0）, （30, 1）,  10, 24, 240, 13, 250]
    //新版[245, 20, 0, 1, 0, 31, 0, 168, 89, 218, 15, 1, 44, 0, 30, 10, 3, 130, 92, 250]
    deviceInfo.type = Tools.getTwoByteByBigEndian(
        value[cmdDataIndex], value[cmdDataIndex + 1]);
    data.brandCode = Tools.getTwoByteByBigEndian(
        value[cmdDataIndex + 2], value[cmdDataIndex + 3]);
    data.deviceCode = Tools.getTwoByteByBigEndian(
        value[cmdDataIndex + 4], value[cmdDataIndex + 5]);
    data.deviceType = deviceInfo.type;
    data.setBlueName(deviceInfo.bluetoothName!);
    data.supportMode = value[cmdDataIndex + 6];

    data.maxWeightOriginal = Tools.getTwoByteByBigEndian(
        value[cmdDataIndex + 7], value[cmdDataIndex + 8]);
    data.minWeightOriginal = Tools.getTwoByteByBigEndian(
        value[cmdDataIndex + 9], value[cmdDataIndex + 10]);
    data.weightStepOriginal = value[cmdDataIndex + 11];

    data.maxLevel = data.maxWeightOriginal;
    data.minLevel = data.minWeightOriginal;
    data.version = Tools.getSignNumber(value[cmdDataIndex + 12]);
    data.subVersion = Tools.getSignNumber(value[cmdDataIndex + 13]);

    //  转化为2进制的String类型
    deviceInfo.deviceConfigStr = data.supportMode.toRadixString(2).padLeft(8,'0');
    RHLog.i("蓝牙通知-收到查询设备信息指令000 $value  ");
    //  是否自发电
    deviceInfo.isZiFaDian = _isSupport(deviceInfo.deviceConfigStr, 0);
    deviceInfo.supportKGTransform = _isSupport(deviceInfo.deviceConfigStr, 1); //  1为磅,0为kg

    deviceInfo.weightStep = data.weightStep;
    deviceInfo.maxWeight = data.maxWeight;
    deviceInfo.minWeight = data.minWeight;

    deviceInfo.minLevel = data.minLevel;
    deviceInfo.maxLevel = data.maxLevel;
    deviceInfo.version = data.version;

    bleDeviceStateController.add(BleDeviceStateMsg.deviceCheckSuccess);
    bleDeviceDataController.add(BleDeviceDataMsg.deviceInfoUpdate_0x01);
  }

  _isSupport(String value, int index) {
    return value[index] == "1";
  }

  _handleDeviceVolume(List<int> value, PowerDeviceData data) {
    data.bobaoVolume = value[5];
  }

  _handleHCJData(List<int> value, PowerDeviceData data) {
    if (value.length > 10) {
      int num = value[cmdDataIndex + 1];
      if (num == 1) {
        data.leftKcal = Tools.getTwoByteByBigEndian(
            value[cmdDataIndex + 10], value[subCmdDataIndex_5 + 11]);
      }else {
        data.rightKcal = Tools.getTwoByteByBigEndian(
            value[cmdDataIndex + 10], value[subCmdDataIndex_5 + 11]);
      }
    }
  }

  _handleSportData_33(List<int> value, PowerDeviceData data) {
    if (value.length < 23) {
      return;
    }
    data.isStart = value[subCmdDataIndex_5]; //  2停止，4启动
    data.mode = value[subCmdDataIndex_5+1];
    data.errorCode = value[subCmdDataIndex_5+3];

    int weight = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 4],
        value[subCmdDataIndex_5 + 5]
    );
    data.leftWeightOriginal = weight;

    data.realTimeLeft = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5+6], value[subCmdDataIndex_5 + 7]);
    data.realTimeRight = data.realTimeLeft;

    data.leftCount = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 8], value[subCmdDataIndex_5 + 9]);
    data.rightCount = data.leftCount;
    data.leftFrequency = value[subCmdDataIndex_5 + 10];
    data.rightFrequency = data.leftFrequency;

    data.leftLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 11], value[subCmdDataIndex_5 + 12]);
    data.rightLength = data.leftLength;

    int leftPower = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5+13], value[subCmdDataIndex_5 + 14]);
    String powerStr = leftPower.toRadixString(2).padLeft(16,'0');
    if (leftPower > 32767) {
      powerStr = powerStr.replaceAll('0', '6');
      powerStr = powerStr.replaceAll('1', '0');
      powerStr = powerStr.replaceAll('6', '1');
      data.leftPower = -int.parse(powerStr, radix: 2);
    }else {
      data.leftPower = leftPower;
    }
    data.rightPower = data.leftPower;

    int leftRPM = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5+15], value[subCmdDataIndex_5 + 16]);
    String leftStr = leftRPM.toRadixString(2).padLeft(16,'0');
    if (leftRPM > 32767) {
      leftStr = leftStr.replaceAll('0', '6');
      leftStr = leftStr.replaceAll('1', '0');
      leftStr = leftStr.replaceAll('6', '1');
      data.leftRPM = -int.parse(leftStr, radix: 2);
    }else {
      data.leftRPM = leftRPM;
    }
    data.rightRPM = data.leftRPM;
    bleDeviceDataController.add(BleDeviceDataMsg.dataQueryUpdate_0x04);
  }

  _handleDeviceData_V6(List<int> value, PowerDeviceData data) {
    if (value.length < 40) {
      return;
    }
    //  类型  品牌，机型， 电机
    // [245, 25, 0, 9,   4, 12, 0, 0, 0,
    // 0, 0, 0, 0,    0, 0, 0, 0,     0, 0, 0, 2, 2,     45, 228, 250]
    //6版的数据 [245, 40, 0, 9, 4, 2, 2, 6, 6, 0, 0, 最后为错误
    // 0, 80, 0, 80,重量 0, 200, 0, 200, 实时重0, 77, 0, 71,次数 7, 53, 3, 50,
    // 3, 56, 0, 0, 0, 0,
    // 0, 0, 0, 0, 244, 28, 250]
    // 是否已启动,开始给电机通电
    data.isStart = value[subCmdDataIndex_5]; //  2停止，4启动
    data.isStart2 = value[subCmdDataIndex_5+1]; //  2停止，4启动
    data.errorCode = value[subCmdDataIndex_5+5];
    data.mode = value[subCmdDataIndex_5+2];

    data.leftCount = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 14], value[subCmdDataIndex_5 + 15]);
    data.rightCount = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 16], value[subCmdDataIndex_5 + 17]);

    data.leftFrequency = value[subCmdDataIndex_5 + 18];
    data.rightFrequency = value[subCmdDataIndex_5 + 19];

    data.leftLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 20], value[subCmdDataIndex_5 + 21]);
    data.rightLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 22], value[subCmdDataIndex_5 + 23]);

    int weight = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+6], value[subCmdDataIndex_5 + 7]);
    switch (data.mode) {
      case PowerCommands.hengLiMode:
      case PowerCommands.liXinLiMode:
      case PowerCommands.speedMode:
      case PowerCommands.tanLiMode:
        {
          data.leftWeightOriginal = weight;
          break;
        }
      case PowerCommands.gearMode:
        {
          data.leftLevel = weight;
          // RHLog.i("蓝牙-收到查询运动数据档位模式222:${data.leftWeightOriginal}");
          break;
        }
    }
    data.leftPower = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+24], value[subCmdDataIndex_5 + 25]);
    data.rightPower = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+26], value[subCmdDataIndex_5 + 27]);
    data.realTimeLeft = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+10], value[subCmdDataIndex_5 + 11]);
    data.realTimeRight = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+12], value[subCmdDataIndex_5 + 13]);

    int leftRPM = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+28], value[subCmdDataIndex_5 + 29]);
    String leftStr = leftRPM.toRadixString(2).padLeft(16,'0');
    if (leftRPM > 32767) {
      leftStr = leftStr.replaceAll('0', '6');
      leftStr = leftStr.replaceAll('1', '0');
      leftStr = leftStr.replaceAll('6', '1');
      data.leftRPM = -int.parse(leftStr, radix: 2);
    }else {
      data.leftRPM = leftRPM;
    }
    int rightRPM = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+30], value[subCmdDataIndex_5 + 31]);
    String rightStr = rightRPM.toRadixString(2).padLeft(16,'0');
    if (rightRPM > 32767) {
      rightStr = rightStr.replaceAll('0', '6');
      rightStr = rightStr.replaceAll('1', '0');
      rightStr = rightStr.replaceAll('6', '1');
      data.rightRPM = -int.parse(rightStr, radix: 2);
    }else {
      data.rightRPM = rightRPM;
    }
    bleDeviceDataController.add(BleDeviceDataMsg.dataQueryUpdate_0x04);
  }

  _handleDeviceData(List<int> value, PowerDeviceData data) {
    if (value.length < 20) {
      return;
    }
    //  类型  品牌，机型， 电机
    // [245, 25, 0, 9,   4, 12, 0, 0, 0,
    // 0, 0, 0, 0,    0, 0, 0, 0,     0, 0, 0, 2, 2,     45, 228, 250]
    // 是否已启动,开始给电机通电
    data.isStart = value[subCmdDataIndex_5]; //  2停止，4启动
    /// index=1的是电池电量
    data.errorCode = value[subCmdDataIndex_5+2];
    data.mode = value[subCmdDataIndex_5+3];

    data.leftCount = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 6], value[subCmdDataIndex_5 + 7]);
    data.rightCount = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 8], value[subCmdDataIndex_5 + 9]);

    data.leftFrequency = value[subCmdDataIndex_5 + 10];
    data.rightFrequency = value[subCmdDataIndex_5 + 11];

    data.leftLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 12], value[subCmdDataIndex_5 + 13]);
    data.rightLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 14], value[subCmdDataIndex_5 + 15]);

    int weight = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+4], value[subCmdDataIndex_5 + 5]);
    switch (data.mode) {
      case PowerCommands.hengLiMode:
      case PowerCommands.liXinLiMode:
      case PowerCommands.speedMode:
      case PowerCommands.tanLiMode:
        {
          data.leftWeightOriginal = min(weight, 800);
          break;
        }
      case PowerCommands.gearMode:
        {
          data.leftLevel = weight;
          break;
        }
    }
    if (value.length > 33) {
      data.leftPower = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+16], value[subCmdDataIndex_5 + 17]);
      data.rightPower = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+18], value[subCmdDataIndex_5 + 19]);
      data.realTimeLeft = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+24], value[subCmdDataIndex_5 + 25]);
      data.realTimeRight = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+26], value[subCmdDataIndex_5 + 27]);

      int leftRPM = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+28], value[subCmdDataIndex_5 + 29]);
      String leftStr = leftRPM.toRadixString(2).padLeft(16,'0');
      if (leftRPM > 32767) {
        leftStr = leftStr.replaceAll('0', '6');
        leftStr = leftStr.replaceAll('1', '0');
        leftStr = leftStr.replaceAll('6', '1');
        data.leftRPM = -int.parse(leftStr, radix: 2);
      }else {
        data.leftRPM = leftRPM;
      }

      int rightRPM = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5+30], value[subCmdDataIndex_5 + 31]);
      String rightStr = rightRPM.toRadixString(2).padLeft(16,'0');
      if (rightRPM > 32767) {
        rightStr = rightStr.replaceAll('0', '6');
        rightStr = rightStr.replaceAll('1', '0');
        rightStr = rightStr.replaceAll('6', '1');
        data.rightRPM = -int.parse(rightStr, radix: 2);
      }else {
        data.rightRPM = rightRPM;
      }
    }
    bleDeviceDataController.add(BleDeviceDataMsg.dataQueryUpdate_0x04);
  }

  int _handleDeviceStatus(List<int> value, PowerDeviceData data) {
    int retCode = 0;
    int state = value[cmdDataIndex + 1];
    if (state == 2 || state == 4) {
      if (data.version > 5) {
        data.version = 4;
      } //  部分L2的固件版本给的10的版本号
    }
    if (value.length > 12) {
      data.bobaoFlag = (value[cmdDataIndex + 4] == 1) ? 1 : 2;
      data.handleMode = value[cmdDataIndex + 5];
      data.changeInStart = value[cmdDataIndex + 6];
      int newKG = value[cmdDataIndex + 7];
      if (newKG != data.isKG) {
        retCode = CODE_KG_CHANGE;
      }
      data.isKG = value[cmdDataIndex + 7];
    }
    bleDeviceDataController.add(BleDeviceDataMsg.statusUpdate_0x02);
    return retCode;
  }

  void dispose() {
    bleDeviceDataController.close();
  }
}