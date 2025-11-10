import 'dart:async';

import 'package:cabina_ble/base_tool/rh_int.dart';
import 'package:cabina_ble/blue/commands/power_commands.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
import 'package:cabina_ble/blue/enum/power_mode.dart';

import '../entity/device_info.dart';
import '../enum/ble_device_data_msg.dart';
import '../enum/ble_device_state_msg.dart';
import '../tools/tools.dart';

class PowerAdvancedRepository {
  PowerAdvancedRepository(StreamController<BleDeviceStateMsg> controller) {
    bleDeviceStateController = controller;
  }

  static const int cmdIndex = 3;
  static const int cmdDataIndex = 4;

  static const int subCmdIndex = 4;
  static const int subCmdDataIndex_5 = 5;

  late PowerAdvancedData powerAdvancedData;

  late StreamController<BleDeviceStateMsg> bleDeviceStateController;
  StreamController<BleDeviceDataMsg> bleDeviceDataController =
      StreamController.broadcast();

  handleCharacteristic(
    List<int> value,
    PowerAdvancedData data,
    RHBluetoothDeviceInfo deviceInfo,
  ) {
    switch (value[cmdIndex]) {
      case PowerCommands.cmdQueryParam_0x01:
        _handleDeviceInfo(value, data, deviceInfo);
        break;
      case PowerCommands.cmdQueryExtParam_0x03:
        _handleExtendedParams(value, data, deviceInfo);
      case PowerCommands.cmdQueryData_0x09:
        switch (value[subCmdIndex]) {
          case PowerCommands.queryDataState_0x02: {
              data.unit = value[subCmdDataIndex_5];
              bleDeviceStateController.add(BleDeviceStateMsg.deviceUnitState);
            }
          case PowerCommands.queryDataSport_0x10: {
              _handleDataSport0x10(value, data, deviceInfo);
            }
          case PowerCommands.queryDataSport_0x12: {
              _handleDataSport0x12(value, data, deviceInfo);
            }
          case PowerCommands.queryDataSport_0x14: {
              _handleDataSport0x14(value, data, deviceInfo);
            }
          default:
            break;
        }
        break;
      case PowerCommands.cmdQueryData_0x0A:

      default:
        break;
    }
  }

  _handleDeviceInfo(
    List<int> value,
    PowerAdvancedData data,
    RHBluetoothDeviceInfo deviceInfo,
  ) {
    deviceInfo.type = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex],
      value[cmdDataIndex + 1],
    );
    data.brandCode = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 2],
      value[cmdDataIndex + 3],
    );
    data.deviceCode = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 4],
      value[cmdDataIndex + 5],
    );
    data.deviceType = deviceInfo.type;
    data.version = Tools.getSignNumber(value[cmdDataIndex + 6]);
    data.subVersion = Tools.getSignNumber(value[cmdDataIndex + 7]);

    data.motorGroupNumber = value[cmdDataIndex + 8];
    data.mainMotorCount = value[cmdDataIndex + 9];
    data.mainMinWeightMe = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 10],
      value[cmdDataIndex + 11],
    );
    data.mainMaxWeightMe = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 12],
      value[cmdDataIndex + 13],
    );
    data.mainStepSizeMe = value[cmdDataIndex + 14];
    data.mainMinWeightIm = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 15],
      value[cmdDataIndex + 16],
    );
    data.mainMaxWeightIm = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 17],
      value[cmdDataIndex + 18],
    );
    data.mainStepSizeIm = value[cmdDataIndex + 19];

    data.armMotorCount = value[cmdDataIndex + 20];
    data.armMinWeightMe = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 21],
      value[cmdDataIndex + 22],
    );
    data.armMaxWeightMe = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 23],
      value[cmdDataIndex + 24],
    );
    data.armStepSizeMe = value[cmdDataIndex + 25];
    data.armMinWeightIm = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 26],
      value[cmdDataIndex + 27],
    );
    data.armMaxWeightIm = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 28],
      value[cmdDataIndex + 29],
    );
    data.armStepSizeIm = value[cmdDataIndex + 30];

    data.legMotorCount = value[cmdDataIndex + 31];
    data.legMinWeightMe = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 32],
      value[cmdDataIndex + 33],
    );
    data.legMaxWeightMe = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 34],
      value[cmdDataIndex + 35],
    );
    data.legStepSizeMe = value[cmdDataIndex + 36];
    data.legMinWeightIm = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 37],
      value[cmdDataIndex + 38],
    );
    data.legMaxWeightIm = Tools.getTwoByteByBigEndian(
      value[cmdDataIndex + 39],
      value[cmdDataIndex + 40],
    );
    data.legStepSizeIm = value[cmdDataIndex + 41];

    bleDeviceStateController.add(BleDeviceStateMsg.deviceCheckSuccess);
    bleDeviceDataController.add(BleDeviceDataMsg.deviceInfoUpdate_0x01);
  }

  _handleExtendedParams(
    List<int> value,
    PowerAdvancedData data,
    RHBluetoothDeviceInfo deviceInfo,
  ) {
    data.backMinDegree = value[cmdDataIndex];
    data.backMaxDegree = value[cmdDataIndex + 1];
    data.seakMinDegree = value[cmdDataIndex + 2];
    data.seakMaxDegree = value[cmdDataIndex + 3];
    bleDeviceDataController.add(BleDeviceDataMsg.dataQueryUpdate_0x03);
  }

  _handleDataSport0x10(
      List<int> value,
      PowerAdvancedData data,
      RHBluetoothDeviceInfo deviceInfo,
      ) {
    bool hasChanged = false;

    data.errorCode.updateIfChanged(
      value[subCmdDataIndex_5], (val) => data.errorCode = val);

    hasChanged |= data.mainStatus.updateIfChanged(
      value[subCmdDataIndex_5 + 8], (val) => data.mainStatus = val);

    hasChanged |= data.mainMode.updateIfChanged(
      value[subCmdDataIndex_5 + 9], (val) => data.mainMode = val);

    hasChanged |= data.armStatus.updateIfChanged(
      value[subCmdDataIndex_5 + 10], (val) => data.armStatus = val);

    hasChanged |= data.armMode.updateIfChanged(
      value[subCmdDataIndex_5 + 11], (val) => data.armMode = val);

    hasChanged |= data.legStatus.updateIfChanged(
      value[subCmdDataIndex_5 + 12], (val) => data.legStatus = val);

    hasChanged |= data.legMode.updateIfChanged(
      value[subCmdDataIndex_5 + 13], (val) => data.legMode = val);

    if (hasChanged) {
      // Corresponding notifications can be added
      data.updateMotorStatus();
      bleDeviceDataController.add(BleDeviceDataMsg.dataQueryUpdate_0x10);
    }
  }

  _handleDataSport0x12(
      List<int> value,
      PowerAdvancedData data,
      RHBluetoothDeviceInfo deviceInfo,
      ){
    bool hasChanged = false;

    hasChanged |= data.curBackDegree.updateIfChanged(
      value[subCmdDataIndex_5],
          (val) => data.curBackDegree = val,
    );

    hasChanged |= data.curSeakDegree.updateIfChanged(
      value[subCmdDataIndex_5 + 1],
          (val) => data.curSeakDegree = val,
    );

    hasChanged |= data.curLeftArmSwing.updateIfChanged(
      value[subCmdDataIndex_5 + 2],
          (val) => data.curLeftArmSwing = val,
    );

    hasChanged |= data.curRightArmSwing.updateIfChanged(
      value[subCmdDataIndex_5 + 3],
          (val) => data.curRightArmSwing = val,
    );

    if (hasChanged) {
      bleDeviceDataController.add(BleDeviceDataMsg.dateQueryUpdate_0x12);
    }
  }

  _handleDataSport0x14(List<int> value, PowerAdvancedData data, RHBluetoothDeviceInfo deviceInfo) {
    switch (data.curMode) {
      case PowerMode.standard:
        data.modeStandardWeight = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5],
          value[subCmdDataIndex_5 + 1],
        );
      case PowerMode.eccentric:
        data.modeEccentricForce = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5],
          value[subCmdDataIndex_5 + 1],
        );
        data.modeConcentricForce = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5 + 2],
          value[subCmdDataIndex_5 + 3],
        );
      case PowerMode.elastic:
        data.modeInitialForce = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5],
          value[subCmdDataIndex_5 + 1],
        );
        data.modeMaximumForce = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5 + 2],
          value[subCmdDataIndex_5 + 3],
        );
        data.modeSpringLength = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5 + 4],
          value[subCmdDataIndex_5 + 5],
        );
      case PowerMode.isokinetic:
        data.modeLinearVelocity = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5],
          value[subCmdDataIndex_5 + 1],
        );
      case PowerMode.isometric:
        data.modeCableLength = Tools.getTwoByteByBigEndian(
          value[subCmdDataIndex_5],
          value[subCmdDataIndex_5 + 1],
        );
    }

    if (data.curMotorGroup == 0) return;

    if (data.curMotorGroup == 3) {
      data.legWeight = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 7],
        value[subCmdDataIndex_5 + 8],
      );
      data.legCounts = value[subCmdDataIndex_5 + 9];
      data.legCableLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 10],
        value[subCmdDataIndex_5 + 11],
      );
      int cableVelocity = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5 + 12], value[subCmdDataIndex_5 + 13]);
      String velocityStr = cableVelocity.toRadixString(2).padLeft(16,'0');
      if (cableVelocity > 32767) {
        velocityStr = velocityStr.replaceAll('0', '6');
        velocityStr = velocityStr.replaceAll('1', '0');
        velocityStr = velocityStr.replaceAll('6', '1');
        data.legLinearVelocity = -int.parse(velocityStr, radix: 2);
      }else {
        data.legLinearVelocity = cableVelocity;
      }
      int rpm = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5 + 14], value[subCmdDataIndex_5 + 15]);
      String rpmStr = rpm.toRadixString(2).padLeft(16,'0');
      if (rpm > 32767) {
        rpmStr = rpmStr.replaceAll('0', '6');
        rpmStr = rpmStr.replaceAll('1', '0');
        rpmStr = rpmStr.replaceAll('6', '1');
        data.legLinearVelocity = -int.parse(rpmStr, radix: 2);
      }else {
        data.legLinearVelocity = rpm;
      }
    }else {
      data.curLeftWeight = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 7],
        value[subCmdDataIndex_5 + 8],
      );
      data.curLeftCount = value[subCmdDataIndex_5 + 9];
      data.curLeftCableLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 10],
        value[subCmdDataIndex_5 + 11],
      );
      int cableVelocity = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5 + 12], value[subCmdDataIndex_5 + 13]);
      String velocityStr = cableVelocity.toRadixString(2).padLeft(16,'0');
      if (cableVelocity > 32767) {
        velocityStr = velocityStr.replaceAll('0', '6');
        velocityStr = velocityStr.replaceAll('1', '0');
        velocityStr = velocityStr.replaceAll('6', '1');
        data.curLeftLinearVelocity = -int.parse(velocityStr, radix: 2);
      }else {
        data.curLeftLinearVelocity = cableVelocity;
      }
      int rpm = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5 + 14], value[subCmdDataIndex_5 + 15]);
      String rpmStr = rpm.toRadixString(2).padLeft(16,'0');
      if (rpm > 32767) {
        rpmStr = rpmStr.replaceAll('0', '6');
        rpmStr = rpmStr.replaceAll('1', '0');
        rpmStr = rpmStr.replaceAll('6', '1');
        data.curLeftRPM = -int.parse(rpmStr, radix: 2);
      }else {
        data.curLeftRPM = rpm;
      }

      data.curLeftWeight = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 17],
        value[subCmdDataIndex_5 + 18],
      );
      data.curLeftCount = value[subCmdDataIndex_5 + 19];
      data.curLeftCableLength = Tools.getTwoByteByBigEndian(
        value[subCmdDataIndex_5 + 20],
        value[subCmdDataIndex_5 + 21],
      );
      int cableVelocity1 = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5 + 22], value[subCmdDataIndex_5 + 23]);
      String velocityStr1 = cableVelocity1.toRadixString(2).padLeft(16,'0');
      if (cableVelocity1 > 32767) {
        velocityStr1 = velocityStr1.replaceAll('0', '6');
        velocityStr1 = velocityStr1.replaceAll('1', '0');
        velocityStr1 = velocityStr1.replaceAll('6', '1');
        data.curLeftLinearVelocity = -int.parse(velocityStr1, radix: 2);
      }else {
        data.curLeftLinearVelocity = cableVelocity1;
      }
      int rpm1 = Tools.getTwoByteByBigEndian(value[subCmdDataIndex_5 + 24], value[subCmdDataIndex_5 + 25]);
      String rpmStr1 = rpm1.toRadixString(2).padLeft(16,'0');
      if (rpm > 32767) {
        rpmStr1 = rpmStr1.replaceAll('0', '6');
        rpmStr1 = rpmStr1.replaceAll('1', '0');
        rpmStr1 = rpmStr1.replaceAll('6', '1');
        data.curLeftRPM = -int.parse(rpmStr1, radix: 2);
      }else {
        data.curLeftRPM = rpm1;
      }
    }
    bleDeviceDataController.add(BleDeviceDataMsg.dataQueryUpdate_0x14);
  }

  void dispose() {
    bleDeviceDataController.close();
  }


}
