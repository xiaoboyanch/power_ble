

import '../enum/device_type.dart';

class RHBluetoothDeviceInfo {

  String toJson () {
    Map mp = {
      'type': type,
      'deviceCode': deviceCode,
      'brand': brand,
      'serial': serial,
      'deviceId':deviceId,
      'deviceCountdown': deviceCountdown,
      'bluetoothName': bluetoothName,
      'moduleType': moduleType,
      'hardwareVersion': hardwareVersion,
      'softwareVersion': softwareVersion,
      'maxSpeed': maxSpeed,
      'maxSlope': maxSlope,
      'maxResistance': maxResistance,
      'maxWeight':maxWeight,
      'maxLevel':maxLevel,

    };
    return mp.toString();
  }
  int type = 0; // 设备类型
  int deviceCode = 0;
  int brand = 0;
  int serial = 0;
  int deviceId = 0;
  int deviceCountdown = 0;
  String? bluetoothName;
  String deviceSNCode = '';
  String? mac;
  String? moduleType;
  String? moduleFactory;
  String? hardwareVersion;
  String? softwareVersion;

  bool get isPowerClass =>
          type == RHDeviceType.powerBoard.value
    ;

  int maxSpeed = 0;
  int minSpeed = 0;
  int maxSlope = 0;
  int minSlope = 0;
  int maxResistance = 0;
  int minResistance = 0;

  bool get canControlSpeed => maxSpeed > 0;

  bool get canControlSlope => maxSlope > 0;

  bool get canControlResistance => maxResistance > 0;

  String deviceConfigStr = "";
  int version = 0;

  double weightStep = 1;
  int maxWeight = 30;

  int minWeight = 3;

  int maxLevel = 30;
  int minLevel = 1;
  bool isZiFaDian = false;
  bool supportKGTransform = false;

  bool isRHWalking = false;
}
