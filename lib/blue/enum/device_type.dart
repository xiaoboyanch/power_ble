

import '../../base_tool/rh_null.dart';

enum RHDeviceType {
  none(-1),// 无

  // ///跑步机
  // treadmill(0),
  //
  // ///椭圆机
  // elliptical(1),
  //
  // ///健身车
  // exercise(2),
  //
  // ///划船机
  // rowing(3),
  //
  // ///动感单车
  // bicycle(4),

  /// 律动机
  vibration(5),

  /// 走步机
  walking(6),

  /// 跑步机
  running(7),

  ///力量板-自发电
  powerBoard(31),
  ///训练凳
  trainBench(32),
  ///柔力机
  softPower(33),

  /// 心率手表
  bracelet(99);

  final int value;

  const RHDeviceType(this.value);

  bool get isLLZ {
    return this == RHDeviceType.powerBoard;
  }

  static RHDeviceType fromInt(dynamic value) {
    int type = RHNull.getInt(value);
    switch (type) {
      // case 0:
      //   return RHDeviceType.treadmill;
      // case 1:
      //   return RHDeviceType.elliptical;
      // case 2:
      //   return RHDeviceType.exercise;
      // case 3:
      //   return RHDeviceType.rowing;
      // case 4:
      //   return RHDeviceType.bicycle;
      case 5:
        return RHDeviceType.vibration;
      case 6:
        return RHDeviceType.walking;
      case 7:
        return RHDeviceType.running;
      case 30:
      case 31:
        return RHDeviceType.powerBoard;
      case 32:
        return RHDeviceType.trainBench;
      case 33:
        return RHDeviceType.softPower;
    }
    return RHDeviceType.none;
  }

  /// 这个方法主要是给首页用的
  String get name {
    switch (this) {
      // case RHDeviceType.treadmill:
      //   return 'treadmill';
      // case RHDeviceType.elliptical:
      //   return 'elliptical_trainer';
      // case RHDeviceType.exercise:
      //   return 'exercise_bike';
      // case RHDeviceType.rowing:
      //   return 'rowing_machine';
      // case RHDeviceType.bicycle:
      //   return 'indoor_bike';
      case RHDeviceType.powerBoard:
        return 'power_device';
      case RHDeviceType.bracelet:
        return 'bracelet';

      case RHDeviceType.vibration:
        return 'device_vibration';
      case RHDeviceType.walking:
        return 'walking';
      case RHDeviceType.running:
        return "running";
      case RHDeviceType.trainBench:
      case RHDeviceType.softPower:
        return 'Un Define';
      case RHDeviceType.none:
        break;
    }
    return 'Test';
  }
  /// 这个方法主要是给首页用的
  String get tagName{
    switch (this) {
      // case RHDeviceType.treadmill:
      //   return 'treadmill';
      // case RHDeviceType.elliptical:
      //   return 'elliptical_trainer';
      // case RHDeviceType.exercise:
      //   return 'exercise_bike';
      // case RHDeviceType.rowing:
      //   return 'rowing_machine';
      // case RHDeviceType.bicycle:
      //   return 'indoor_bike';
      case RHDeviceType.powerBoard:
        return 'power_device';
      case RHDeviceType.softPower:
        return 'rouli_ji';
      case RHDeviceType.trainBench:
        return 'train_bench';
      case RHDeviceType.vibration:
        return 'device_vibration';
      case RHDeviceType.walking:
        return 'walking';
      case RHDeviceType.running:
        return "running";
      case RHDeviceType.none:
        break;
      case RHDeviceType.bracelet:
        return 'bracelet';
    }
    return 'unknow (${this.value})';
  }

  //  真实设备照片
  String get deviceIcon{
    switch (this) {
      // case RHDeviceType.treadmill:
      //   return 'device_running';
      // case RHDeviceType.elliptical:
      //   return 'elliptical_trainer';
      // case RHDeviceType.exercise:
      //   return 'exercise_bike';
      // case RHDeviceType.rowing:
      //   return 'home_top_hcj';
      // case RHDeviceType.bicycle:
      //   return 'indoor_bike';
      case RHDeviceType.powerBoard:
        return 'device_power';
      case RHDeviceType.none:
        break;
      case RHDeviceType.bracelet:
        return 'icon_watch';

      case RHDeviceType.vibration:
        return "device_vibration";
      case RHDeviceType.walking:
        return "device_walking";
      case RHDeviceType.running:
        return "device_running";
      case RHDeviceType.trainBench:
      case RHDeviceType.softPower:
        return 'img-power';
    }
    return 'img-power';
  }

  //  训练模版的拟物图
  String get tempIcon{
    switch (this) {
      case RHDeviceType.running:
        return "icon_temp_running";
      case RHDeviceType.walking:
        return 'icon_temp_walking';
      case RHDeviceType.powerBoard:
        return 'icon_temp_power';
      default: {
        return 'icon_temp_running';
    }
    }
  }

  String get tempSmallIcon{
    switch (this) {
      // case RHDeviceType.bicycle:
      //   return "workout/icon_temp_small_time";
      case RHDeviceType.running:
      case RHDeviceType.walking:
        return 'workout/icon_temp_small_time';
      case RHDeviceType.powerBoard:
        return 'workout/icon_temp_small_power';
      default: {
        return 'workout/icon_temp_small_time';
      }
    }
  }


  String get detailBmp{
    switch (this) {
      // case RHDeviceType.bicycle:
      //   return "workout/icon_detail_bike";
      case RHDeviceType.running:
      case RHDeviceType.walking:
        return 'workout/icon_detail_walking';
      case RHDeviceType.powerBoard:
        return 'workout/icon_detail_power';
      default: {
        return 'workout/icon_detail_power';
      }
    }
  }
}
