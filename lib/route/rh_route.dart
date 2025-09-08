import 'package:cabina_ble/app/home/home_page.dart';
import 'package:cabina_ble/app/power_detail/power_detail_page.dart';
import 'package:cabina_ble/route/bindings.dart';
import 'package:get/get.dart';

class RHRoute {
  static const homePage = "/homePageCtrl";
  static const powerDetailPage = "/powerDetailCtrl";

  static List<GetPage> getPages = [

    GetPage(name: homePage, page: () => HomePage(), binding: BDHomeBinding()),
    GetPage(name: powerDetailPage, page: () => PowerDetailPage(), binding: BDPowerDetailBinding()),
  ];
}