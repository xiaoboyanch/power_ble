
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
