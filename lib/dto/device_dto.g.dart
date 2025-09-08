// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDto _$DeviceDtoFromJson(Map<dynamic, dynamic> json) {
  int typeInt = RHNull.getInt(json['deviceType']);
  RHDeviceType typeEnum = RHDeviceType.fromInt(typeInt);
  return DeviceDto(
    RHNull.getInt(json['id']),
    RHNull.getInt(json['deviceId']),
    RHNull.getStr(json['bluetooth']),
    RHNull.getStr(json['deviceName']),
    RHNull.getStr(json['deviceDescribe']),
    RHNull.getStr(json['iosKey']),
    RHNull.getStr(json['androidKey']),
    RHNull.getInt(json['companyId']),
    RHNull.getInt(json['deviceCode']),
    typeEnum.value,
    typeEnum,
    RHNull.getStr(json['picUrl']),
    RHNull.getStr(json['customName'])
  );
}

Map<String, dynamic> _$DeviceDtoToJson(DeviceDto instance) => <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'bluetooth': instance.bluetooth,
      'deviceName': instance.deviceName,
      'deviceDescribe': instance.deviceDescribe,
      'iosKey': instance.iosKey,
      'androidKey': instance.androidKey,
      'companyId': instance.companyId,
      'deviceCode': instance.deviceCode,
      'deviceType': instance.deviceType,
      'photoPath': instance.photoPath,
      'customName': instance.customName
    };
