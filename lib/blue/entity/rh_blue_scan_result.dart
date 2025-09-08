import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_info.dart';

class RHBlueScanResult {
  late BluetoothDevice bluetoothDevice;
  late ScanResult scanResult;
  late RHBluetoothDeviceInfo deviceInfo;

  Map<String, dynamic> toRHDeviceJson () {
    Map<String, dynamic> mp = {
      'deviceType': deviceInfo.type,
      'deviceCode': deviceInfo.deviceCode,
      'companyId': deviceInfo.brand,
      'serial': deviceInfo.serial,
      'deviceId': deviceInfo.deviceId,
      'bluetooth': bluetoothDevice.platformName,
      'deviceName': bluetoothDevice.platformName,
    };
    if (Platform.isIOS) {
      mp['iosKey'] = bluetoothDevice.remoteId.str;
      mp['androidKey'] = '';
    }else {
      mp['iosKey'] = '';
      mp['androidKey'] = bluetoothDevice.remoteId.str;
    }
    return mp;
  }
}
