import 'package:cabina_ble/app/ai/ai_page.dart';
import 'package:cabina_ble/app/ai_workout/ai_workout_page.dart';
import 'package:cabina_ble/app/home/home_page.dart';
import 'package:cabina_ble/app/power_detail/power_detail_page.dart';
import 'package:cabina_ble/route/bindings.dart';
import 'package:get/get.dart';

class RHRoute {
  static const homePage = "/homePageCtrl";
  static const powerDetailPage = "/powerDetailCtrl";
  static const ai = "/ai";
  static const aiWorkout = "/aiWorkout";

  static List<GetPage> getPages = [

    GetPage(name: homePage, page: () => HomePage(), binding: BDHomeBinding()),
    GetPage(name: powerDetailPage, page: () => PowerDetailPage(), binding: BDPowerDetailBinding()),

    GetPage(name: ai, page: () => AiPage(), binding: BDAIBinding()),
    GetPage(name: aiWorkout, page: () => AIWorkoutPage(), binding: BDAIWorkoutBinding())
  ];
}