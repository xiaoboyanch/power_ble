import 'package:cabina_ble/route/rh_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'base_tool/i18n.dart';
import 'base_tool/rh_cache.dart';
import 'base_views/rh_colors.dart';
import 'blue/ble_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RHCache.init();
  await i18n.getInstance().init();
  BleManager.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 只允许竖屏
  ]).then((_) {
    runApp( MyApp());
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    i18n i18Util = i18n.getInstance();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      initialRoute: RHRoute.homePage,
      getPages: RHRoute.getPages,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        //其它Locales
      ],
      locale: i18Util.currentLocal,
      fallbackLocale: const Locale("en","US"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        //一定要配置,否则iphone手机长按编辑框有白屏卡着的bug出现
      ],
      defaultTransition: Transition.cupertino,
      builder: (context, widget) {
        double bili = 1.0;
        double width = MediaQuery.of(context).size.width;
        if (width < 390) {
        // LogUtils.d("widget : $width");
          bili = 0.8;
        }
        return MediaQuery(
          ///设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(bili)
          ), // 设置固定的textScaleFactor为1.0
          child: FlutterEasyLoading(child: widget),
        );
      },
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Cabina Ble",
//         theme: ThemeData(
//           // fontFamily: "PingFang SC",
//           textSelectionTheme: TextSelectionThemeData(
//             selectionHandleColor: RHColor.primary,
//           ),
//           primaryColor: RHColor.primary,
//           bottomNavigationBarTheme: BottomNavigationBarThemeData(
//             selectedItemColor: RHColor.black_34,
//             unselectedItemColor: RHColor.unSelect,
//             backgroundColor: RHColor.pageBack,
//           ),
//           textTheme: const TextTheme(
//             displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
//             titleLarge: TextStyle(fontSize: 36),
//             bodyMedium: TextStyle(fontSize: 14),
//           ),
//         ),
//       initialRoute: RHRoute.homePage,
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         //一定要配置,否则iphone手机长按编辑框有白屏卡着的bug出现
//       ],
//       supportedLocales: const [
//         Locale('en', 'US'),
//         //其它Locales
//       ],
//       defaultTransition: Transition.cupertino,
//       getPages: RHRoute.getPages,
//     );
//   }
// }


