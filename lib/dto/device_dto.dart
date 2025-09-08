import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../base_tool/rh_cache.dart';
import '../base_tool/rh_null.dart';
import '../blue/enum/device_type.dart';
part 'device_dto.g.dart';

@JsonSerializable()
class DeviceDto {

  static int Label_L8 = 2;
  static int Label_L5 = 5;
  static int Label_L2 = 3;

  int id;
  int deviceId;
  String bluetooth;
  String deviceName;
  String iosKey;
  String androidKey;
  int companyId;
  int deviceCode; //  23001  现在替换成10000 。。以此类推
  int deviceType;
  String photoPath;
  String deviceDescribe;
  String customName;

  RHDeviceType typeEnum = RHDeviceType.none;


  factory DeviceDto.fromJson(Map<dynamic, dynamic> json) =>
      _$DeviceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDtoToJson(this);


  @override
  String toString() {
    return '[$deviceCode-$deviceName]';
  }


  DeviceDto(
      this.id,
      this.deviceId,
      this.bluetooth,
      this.deviceName,
      this.deviceDescribe,
      this.iosKey,
      this.androidKey,
      this.companyId,
      this.deviceCode,
      this.deviceType,
      this.typeEnum,
      this.photoPath,
      this.customName
      );

  bool isEqual(DeviceDto other) {
    if (deviceType == other.deviceType) {
      if (deviceCode == other.deviceCode) {
        return true;
      }
    }
    return false;
  }

  int _hashCode = 0;
  int get identify {  //  用来判断两台设备是不是同一台,用在保存最后使用的设备
    if (_hashCode == 0) {
      _hashCode = int.parse('${deviceType}0${deviceCode}0$companyId');
    }
    return _hashCode;
  }

  static int identifyFromMap(Map mp) {
    return RHNull.getInt('${mp['deviceType']}0${mp['deviceCode']}0${mp['companyId']}');
  }
}
