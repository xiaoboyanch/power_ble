
import 'package:get/get.dart';

import '../../base_tool/rh_null.dart';

enum LLZPowerMode {
  none(0),
  hengLi(6),  //  恒定力
  liXin(8), //  离心力
  tanLi(10),  //  弹力
  gear(12),  //  档位模式
  speed(13);  //  速度模式

  final int value;

  const LLZPowerMode(this.value);

  static fromInt(dynamic value) {
    int num = RHNull.getInt(value);
    switch (num) {
      case 6:
        return LLZPowerMode.hengLi;
      case 8:
        return LLZPowerMode.liXin;
      case 10:
        return LLZPowerMode.tanLi;
      case 12:
        return LLZPowerMode.gear;
      case 13:
        return LLZPowerMode.speed;
      default:
        return LLZPowerMode.hengLi;
    }
  }

  toStr() {
    switch (this) {
      case LLZPowerMode.hengLi:
        return 'sport_standard'.tr;
      case LLZPowerMode.liXin:
        return 'sport_lixin'.tr;
      case LLZPowerMode.tanLi:
        return 'sport_tanli'.tr;
      case LLZPowerMode.gear:
        return 'sport_gear'.tr;
      case LLZPowerMode.speed:
        return 'speed'.tr;
      default:
        return 'sport_standard'.tr;
    }
  }

  toDesc() {
    switch (this) {
      case LLZPowerMode.hengLi:
        return 'sport_llzmode_desc_hl';
      case LLZPowerMode.liXin:
        return 'sport_llzmode_desc_lx';
      case LLZPowerMode.tanLi:
        return 'sport_llzmode_desc_tl';
      case LLZPowerMode.gear:
        return 'sport_llzmode_desc_hl';
      case LLZPowerMode.speed:
        return 'sport_llzmode_desc_sd';
      default:
        return 'sport_llzmode_desc_hl';
    }
  }

  //  结尾带有模式两个字
  toStrHasMode() {
    switch (this) {
      case LLZPowerMode.hengLi:
        return 'sport_mode_standard'.tr;
      case LLZPowerMode.liXin:
        return 'sport_mode_lixin'.tr;
      case LLZPowerMode.tanLi:
        return 'sport_mode_tanli'.tr;
      case LLZPowerMode.gear:
        return 'sport_mode_gear'.tr;
      case LLZPowerMode.speed:
        return 'sport_mode_speed'.tr;
      default:
        return 'sport_mode_tanli'.tr;
    }
  }


  String get whiteIcon {
    switch (this) {
      case LLZPowerMode.hengLi:
        return 'free/power_set_hl';
      case LLZPowerMode.liXin:
        return 'free/power_set_lx';
      case LLZPowerMode.tanLi:
        return 'free/power_set_tl';
      case LLZPowerMode.gear:
        return 'free/power_set_hl';
      case LLZPowerMode.speed:
        return 'free/power_set_sd';
      default:
        return 'free/power_set_sd';
    }
  }

  String get greyIcon {
    switch (this) {
      case LLZPowerMode.hengLi:
        return 'free/power_grey_hl';
      case LLZPowerMode.liXin:
        return 'free/power_grey_lx';
      case LLZPowerMode.tanLi:
        return 'free/power_grey_tl';
      case LLZPowerMode.gear:
        return 'free/power_grey_hl';
      case LLZPowerMode.speed:
        return 'free/power_grey_sd';
      default:
        return 'free/power_grey_sd';
    }
  }
}
