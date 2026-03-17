// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ota_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtaDto _$OtaDtoFromJson(Map<String, dynamic> json) {
  String chipHex = RHNull.getStr(json['chipNumber']);
  int chipNumber = int.parse(chipHex, radix: 16);
  return OtaDto(
    id: RHNull.getInt(json['id']),
    deviceType: RHDeviceType.fromInt(RHNull.getInt(json['deviceType'])),
    manufacturer: RHNull.getStr(json),
    chipNumber: chipNumber,
    majorVersion: RHNull.getInt(json['majorVersion']),
    minorVersion: RHNull.getInt(json['minorVersion']),
    fullVersion: RHNull.getStr(json['fullVersion']),
    downloadUrl: RHNull.getStr(json['downloadUrl']),
  );
}

Map<String, dynamic> _$OtaDtoToJson(OtaDto instance) => <String, dynamic>{
};