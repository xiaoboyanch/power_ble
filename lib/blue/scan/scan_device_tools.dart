import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../base_tool/log_utils.dart';
import '../entity/device_info.dart';
import '../entity/rh_blue_scan_result.dart';
import '../enum/device_code.dart';
import '../enum/device_type.dart';
import '../tools/tools.dart';
import '../uuid/ble_uuid.dart';

class ScanDeviceTools {

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
      }else {
        checkRHDeviceInfo(item, deviceType, list);
      }
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