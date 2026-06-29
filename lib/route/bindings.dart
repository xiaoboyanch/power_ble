
import 'package:cabina_ble/app/ai/ai_ctrl.dart';
import 'package:cabina_ble/app/ai_workout/ai_workout_ctrl.dart';
import 'package:get/get.dart';

import '../app/home/home_ctrl.dart';
import '../app/ota/ota_ctrl.dart';
import '../app/ota_detail/ota_detail_ctrl.dart';
import '../app/power/power_ctrl.dart';
import '../app/power_detail/power_detail_ctrl.dart';
import '../app/table/table_ctrl.dart';
import '../app/table_detail/table_detail_ctrl.dart';

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

class BDOtaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtaCtrl());
  }
}

class BDPowerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PowerCtrl());
  }
}

class BDOtaDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtaDetailCtrl());
  }
}

class BDTableBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TableCtrl());
  }
}

class BDTableDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TableDetailCtrl());
  }
}