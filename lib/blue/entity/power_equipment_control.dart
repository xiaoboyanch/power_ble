
import '../entity/power_device_sport_mode.dart';

class PowerDeviceControl {
  /// 工厂专用
  static const int TYPE_Weight = 1;
  static const int TYPE_Reset = 2;
  static const int TYPE_ReCode = 3;
  static const int TYPE_ReBLE = 4;
  static const int TYPE_ReMusicName = 5;
  static const int TYPE_SetSNCode = 1;
  static const int TYPE_ReadSNCode = 2;
  static const int TYPE_PlayAudio = 21;
  static const int TYPE_ReBoot = 12;
  int dt = 31;
  int brand = 168;
  int deviceCode = 23002;
  String valueStr = '';
  String BLEName = '';
  void setDeviceCode({required int type, required int brand, required int deviceCode}) {
    this.type = TYPE_ReCode;
    dt = type;
    this.brand = brand;
    this.deviceCode = deviceCode;
    deviceMode = PowerDeviceMode.factoryConfig;
  }

  void setPlayAudio(int music) {
    type = TYPE_PlayAudio;
    leftLevel = music;
  }

  void rebootBlue() {
    type = TYPE_ReBoot;
    deviceMode = PowerDeviceMode.factoryConfig;
  }

  void readSNCode() {
    deviceMode = PowerDeviceMode.snCode;
    type = TYPE_ReadSNCode;
  }
  void setSNCode({required String codeStr}) {
    deviceMode = PowerDeviceMode.snCode;
    type = TYPE_SetSNCode;
    valueStr = codeStr;
  }

  void setBLEName({required String name}) {
    type = TYPE_ReBLE;
    BLEName = name;
    deviceMode = PowerDeviceMode.factoryConfig;
  }

  void setMusicName({required String name}) {
    type = TYPE_ReMusicName;
    BLEName = name;
    deviceMode = PowerDeviceMode.factoryConfig;
  }
  /// 工厂专用

  //  0设置音量,
  //  1设置播报,
  int type = 0;
  PowerDeviceMode deviceMode = PowerDeviceMode.none;
  bool isReset = false;
  bool goStart = false;
  double leftWeight = 3;

  int bobao = 0;
  int handleMode = 0;
  int changeInStart = 0;
  bool isKG = true;


  double leftInitWeight = 1;
  int leftLevel = 2;  //  这个不仅承担档位的数据,还承接了很多播报控制

  void setResetDevice() {
    this.isReset = true;
  }

  void setHengLiCMD(double weight) {
    deviceMode = PowerDeviceMode.hengLi;
    this.leftWeight = weight;
  }
  
  void setSpeedCMD(double weight) {
    deviceMode = PowerDeviceMode.speed;
    leftWeight = weight;
  }

  void setLiXinCMD(double weight) {
    deviceMode = PowerDeviceMode.liXin;
    leftWeight = weight;
  }

  void setTanLiCMD(double weight) {
    deviceMode = PowerDeviceMode.tanLi;
    this.leftWeight = weight;
  }

  void setGearCMD({int leftLevel=1}) {
    deviceMode = PowerDeviceMode.fluidForce;
    this.leftLevel = leftLevel;
  }

  void setLLZDeviceConfig(int bb, int hm, bool cis, bool is1KG) {
    deviceMode = PowerDeviceMode.deviceConfig;
    bobao = bb;
    handleMode = hm;
    changeInStart = cis ? 1 : 0;
    isKG = is1KG;
  }

  void setVolumeControl(int volume) {
    deviceMode = PowerDeviceMode.bobao;
    leftLevel = volume;
  }
  void getVolumeValue() {
    deviceMode = PowerDeviceMode.bobaoVolume;
  }

  void setOutageCmd(bool goToStart) {
    deviceMode = PowerDeviceMode.goStart;
    goStart = goToStart;
  }
}
