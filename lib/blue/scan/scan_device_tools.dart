import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../base_tool/log_utils.dart';
import '../entity/device_info.dart';
import '../entity/rh_blue_scan_result.dart';
import '../enum/device_code.dart';
import '../enum/device_type.dart';
import '../tools/tools.dart';
import '../uuid/ble_uuid.dart';

class ScanDeviceTools {

  static Future<List<RHBlueScanResult>> sortFoldDeviceInfo(List<ScanResult> result) async{
    List<RHBlueScanResult> list = [];
    for (var item in result) {
      if (item.advertisementData.connectable) {
        if (item.device.platformName.toUpperCase().contains("WLT6200_4012")) {
          RHBlueScanResult rs = RHBlueScanResult();
          RHBluetoothDeviceInfo deviceInfo = RHBluetoothDeviceInfo();
          deviceInfo.type = RHDeviceType.walking.value;
          rs.deviceInfo = deviceInfo;
          rs.bluetoothDevice = item.device;
          list.add(rs);
        }
      }
    }
    return Future.value(list);
  }

  // static Future<List<RHBlueScanResult>> sortWalkDeviceInfo(List<ScanResult> result) async{
  //   List<RHBlueScanResult> list = [];
  //   for (var item in result) {
  //     if (item.advertisementData.connectable && item.advertisementData.serviceUuids.isNotEmpty) {
  //       List<Guid> guidList = item.advertisementData.serviceUuids;
  //       for (var guid in guidList) {
  //         // LogUtils.d("guid: ${guid.toString().toUpperCase()}");
  //         if (guid.toString().toUpperCase().contains(BlueUUID.FTMS_UUID)) {
  //           if (item.device.platformName.toUpperCase().contains("SPERAX_RM-01")) {
  //             list.add(addScanItem(RHDeviceCode.walkP1.value, item.device));
  //           }else if (item.device.platformName.toUpperCase().contains("SPERAX_F1")) {
  //             list.add(addScanItem(RHDeviceCode.walkF1.value, item.device));
  //           }else if (item.device.platformName.toUpperCase().contains("SPERAX_L400")) {
  //             if (item.device.platformName.toUpperCase().contains("SPERAX_L400B")) {
  //               list.add(addScanItem(RHDeviceCode.walkL400B.value, item.device));
  //             }else {
  //               list.add(addScanItem(RHDeviceCode.walkL400.value, item.device));
  //             }
  //           }
  //
  //         }
  //         if (guid.toString().toUpperCase().contains(BlueUUID.FS_UUID)) {
  //           checkRHDeviceInfo(item, RHDeviceType.walking.value, list);
  //         }
  //       }
  //     }
  //   }
  //   return Future.value(list);
  // }

  static RHBlueScanResult addScanItem(int deviceCode, BluetoothDevice device) {
    LogUtils.d("deviceCodeAAAAAAAAAAA: $deviceCode");
    RHBlueScanResult rs = RHBlueScanResult();
    RHBluetoothDeviceInfo deviceInfo = RHBluetoothDeviceInfo();
    deviceInfo.type = RHDeviceType.walking.value;
    deviceInfo.deviceCode = deviceCode;
    deviceInfo.serial = deviceInfo.deviceCode;
    deviceInfo.deviceId = deviceInfo.deviceCode;
    rs.deviceInfo = deviceInfo;
    rs.bluetoothDevice = device;
    return rs;
  }
  static String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }
  static Future<List<RHBlueScanResult>> sortDeviceInfo(List<ScanResult> result, List<RHDeviceType> deviceType) async{
    List<RHBlueScanResult> list = [];
    for (var item in result) {
      if (item.device.platformName.toUpperCase().contains("BT SONY") || item.device.platformName.toUpperCase().contains("BT_SONY") ) {
        list.add(addScanItem(RHDeviceCode.walkP1.value, item.device));
        LogUtils.d("deviceAAAAAAAAAACode: ${list.length}");
      }
      // if (deviceType.contains(RHDeviceType.powerAdvanced)) {
      //   if (item.advertisementData.connectable && item.advertisementData.serviceUuids.isNotEmpty) {
      //     List<Guid> guidList = item.advertisementData.serviceUuids;
      //     for (var guid in guidList) {
        //     LogUtils.d("name: ${guid.toString().toUpperCase()}");
        //     if (guid.toString().toUpperCase().contains(BlueUUID.FS_UUID)) {
        //       if (item.device.platformName.toUpperCase().contains("BT SONY")) {
        //         list.add(addScanItem(RHDeviceCode.walkP1.value, item.device));
        //       }else if (item.device.platformName.toUpperCase().contains("SPERAX_F1")) {
        //         list.add(addScanItem(RHDeviceCode.walkF1.value, item.device));
        //       }else if (item.device.platformName.toUpperCase().contains("SPERAX_L400")) {
        //         if (item.device.platformName.toUpperCase().contains("SPERAX_L400B")) {
        //           list.add(addScanItem(RHDeviceCode.walkL400B.value, item.device));
        //         }else {
        //           list.add(addScanItem(RHDeviceCode.walkL400.value, item.device));
        //         }
        //       }else if (item.device.platformName.toUpperCase().contains("SPERAX__")) {
        //         list.add(addScanItem(RHDeviceCode.walkP1.value, item.device));
        //       }else if (item.device.platformName.toUpperCase().contains("SPERAX") && item.device.platformName.toUpperCase().length > 12) {
        //         list.add(addScanItem(RHDeviceCode.walkP1.value, item.device));
        //       }
        //     }
        //     // if (guid.toString().toUpperCase().contains(BlueUUID.FS_UUID)) {
        //     //   checkRHDeviceInfo(item, deviceType, list);
        //     // }
        //   }
        // }
      // }else {
      //   checkRHDeviceInfo(item, deviceType, list);
      // }
    }
    return Future.value(list);
  }

  static checkRHDeviceInfo(ScanResult item, List<RHDeviceType> typeList, List<RHBlueScanResult> list) {
    final data = Tools.parseManufacturerData(item.advertisementData.manufacturerData);
    if (data.length > 7) {
      final vendorId = Tools.getTwoByteByBigEndian(data[0], data[1]);
      final deviceType = Tools.getTwoByteByBigEndian(data[2], data[3]);

      RHDeviceType dtEnum = RHDeviceType.fromInt(deviceType);
      // LogUtils.d("AAAA   vendorId: $vendorId, deviceType: $deviceType : typeList: ${typeList[0].value}  :  ${typeList.contains(dtEnum)}");
      if (typeList.contains(dtEnum)) {
        if (vendorId == 0xCB90 || vendorId == 0x912F) {
          RHBluetoothDeviceInfo deviceInfo = RHBluetoothDeviceInfo();
          deviceInfo.type = deviceType;
          deviceInfo.brand = Tools.getTwoByteByBigEndian(data[4], data[5]);
          deviceInfo.deviceCode = Tools.getTwoByteByBigEndian(data[6], data[7]);
          deviceInfo.serial = vendorId;
          deviceInfo.deviceId = deviceInfo.deviceCode;
          deviceInfo.mac = item.device.advName;
          deviceInfo.isRHWalking = true;
          RHBlueScanResult rs = RHBlueScanResult();
          rs.deviceInfo = deviceInfo;
          rs.bluetoothDevice = item.device;
          rs.scanResult = item;
          rs.deviceInfo.bluetoothName = item.device.platformName;
          list.add(rs);
        }
      }
    }
  }
}