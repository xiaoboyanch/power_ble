class BlueUUID {
  static const String FS_UUID = "FFF0";
  static const String FTMS_UUID = "1826";

  static const String HEART_RATE_SERVICE = "180D";
  static const String HEART_RATE_NOTIFY = "2A37";

  static const String POWER_WRITE = "FFF2";
  static const String POWER_NOTIFY = "FFF1";

  ///野小兽走步机服务和特征值
  ///设备信息服务
  static const String serviceWalkInfo = "180A";
  ///设备型号
  static const String walkDeviceModel = "2A24";
  ///序列号码
  static const String walkSerialNumber = "2A25";
  ///固件版本号
  static const String walkFirmwareVersion  = "2A26";
  ///硬件版本号
  static const String walkHardwareVersion  = "2A27";
  ///软件版本号
  static const String walkSoftwareVersion  = "2A28";

  ///走步机运动数据 服务1826
  ///设备支持的能力
  static const String walkMachineFeature = "2ACC";
  ///走步机实时运动数据
  static const String walkQueryData = "2ACD";
  ///设备运动状态
  static const String walkState = "2AD3";
  ///支持的速度范围
  static const String walkSpeedRange = "2AD4";
  ///设备运行状态变更
  static const String walkDeviceStateChange = "2ADA";
  ///
  static const String walkWrite = "2AD9";

  static const String snakeWrite = "FFF2";
  static const String snakeNotify = "FFF3";
}