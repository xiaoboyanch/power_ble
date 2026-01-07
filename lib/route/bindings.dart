
import 'package:cabina_ble/app/ai/ai_ctrl.dart';
import 'package:cabina_ble/app/ai_workout/ai_workout_ctrl.dart';
import 'package:get/get.dart';

import '../app/home/home_ctrl.dart';
import '../app/power_detail/power_detail_ctrl.dart';

class BDHomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeCtrl());
  }
}

class BDPowerDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PowerDetailCtrl());
  }
}

class BDAIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AIController());
  }
}

class BDAIWorkoutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AIWorkoutCtrl());
  }
}