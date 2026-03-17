import 'package:cabina_ble/base_tool/rh_null.dart';
import 'package:cabina_ble/blue/enum/device_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ota_dto.g.dart';

@JsonSerializable()
class OtaDto {
  int id;
  RHDeviceType deviceType;
  String manufacturer;
  int chipNumber;
  int majorVersion;
  int minorVersion;
  String fullVersion;
  String downloadUrl;

  OtaDto({
      this.id = 0,
      this.deviceType = RHDeviceType.powerAdvanced,
      this.manufacturer = '',
      this.chipNumber = 0,
      this.majorVersion = 0,
      this.minorVersion = 0,
      this.fullVersion = '',
      this.downloadUrl = ''
  });

  factory OtaDto.fromJson(Map<String, dynamic> json) => _$OtaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtaDtoToJson(this);
}