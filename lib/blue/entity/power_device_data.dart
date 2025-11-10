
import '../base/base_device_data.dart';

class PowerDeviceData extends BaseDeviceData {
  Map toJson () {
    Map m = {
      'leftCount' : leftCount,
      'rightCount' : rightCount,
      'leftFrequency' : leftFrequency,
      'rightFrequency' : rightFrequency,
      'leftLength' : leftLength,
      'rightLength' : rightLength,
      'leftWeightOriginal' : leftWeightOriginal,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      // 'leftCount_____' : leftCount,
      'gear' : leftLevel,
      // 'leftCount_____' : leftCount,
      'mode' : mode,
      'deviceCode' : deviceCode,
      'brandCode' : brandCode,
    };
    return m;
  }

  //  收到的操作回调
  // List<BlueAckEnum> ackList = [];

  int isStart = 0;
  int isStart2 = 0;
  int errorTimes = 0;

  /// 这些配置应该配置到deviceInfo上去,但是一开始没处理好,弄成运动参数去了,后期再改
  int bobaoFlag = 0;
  int changeInStart = 0;  //  启动的时候调整配重
  int handleMode = 0; //  手柄遥控设置,0是停止启动,1是单击加减重量,长安停止
  int bobaoVolume = -1; //  -1为未获取到音量,大于0才是有值的时候
  int isKG = 0;
  int bbv() {
    int newInt = bobaoVolume;
    bobaoVolume = -1;
    return newInt;
  }
  /// 这些配置应该配置到deviceInfo上去,但是一开始没处理好,弄成运动参数去了,后期再改

  int leftCount = 0;
  int rightCount = 0;

  int leftFrequency = 0;
  int rightFrequency = 0;

  int leftLength = 0;
  int rightLength = 0;

  //  这个功率是 W,不是千瓦
  int leftPower = 0;
  int rightPower = 0;
  int leftKcal = 0;
  int rightKcal = 0;

  // int leftSeed = 0;
  // int rightSeed = 0;
  int leftWeightOriginal = 30;
  int rightWeightOriginal = 30;
  int realTimeLeft = 1;
  int realTimeRight = 1;

  int leftRPM = 0;
  int rightRPM = 0;

  int get leftWeight => leftWeightOriginal ~/ 10;
  int get rightWeight => rightWeightOriginal ~/ 10;

  int leftLevel = 1;

  int brandCode = 0;
  int deviceCode = 0;
  int deviceType = 31;
  String? deviceName = '';
  String musicName = '';

  void setBlueName(String? name) {
    if (name != null) {
      deviceName = name;
    }else {
      deviceName = '';
    }
  }
  // int numberOfMotors = 0;
  //  当前模式,恒力,离心,弹力,速度
  int mode = 6;
  /// 0x01 超速, 0x02 突然超速，0x03 短路保护(请重新上电)
  /// 0x04 过热(设备过热,请休息一会再开始运动)
  /// 0x05 收绳过多, 0x06拉绳过多
  /// 0x07 编码器错误, 请检查绳子或联系客服
  int errorCode = 0;
  int version = 4;
  int subVersion = 0;

  int weightStepOriginal = 10;
  double get weightStep => weightStepOriginal / 10;

  int maxWeightOriginal = 300;
  int get maxWeight => maxWeightOriginal ~/ 10;

  int minWeightOriginal = 30;
  int get minWeight => minWeightOriginal ~/ 10;

  int maxLevel = 2;
  int minLevel = 1;
  int supportMode = 0;  //  支持的设备类型
}
