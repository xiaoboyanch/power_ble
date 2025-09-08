class RHLog {
  static bool _debugMode = !bool.fromEnvironment('dart.vm.product');
  static int _maxLen = 128;

  static void d(Object? object) {
    if (_debugMode) {
      print(object.toString());
    }
  }

  static void e(Object? object) {
    if (_debugMode) {
      _printLog(object, "error");
    }
  }

  static void i(Object? object) {
    if (_debugMode) {
      _printLog(object, "info");
    }
  }

  static void _printLog(Object? object, String remark) {
    String da = object?.toString() ?? 'null';

    while (da.isNotEmpty) {
      if (da.length > _maxLen) {
        print('$remark| ${da.substring(0, _maxLen)}');
        da = da.substring(_maxLen, da.length);
      } else {
        print('$remark| $da');
        da = '';
      }
    }
  }

  // static errorReport(String contactStr) async {
  //   UserApi userApi = UserApi();
  //   final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   String deviceStr = '';
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo infoModel = await deviceInfo.androidInfo;
  //     deviceStr += '${infoModel.model}, ${infoModel.brand}\n';
  //     deviceStr += '${infoModel.version.sdkInt}}';
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo infoModel = await deviceInfo.iosInfo;
  //     deviceStr += '${infoModel.utsname.machine}--${infoModel.systemName}${infoModel.systemVersion}';
  //   }
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String version = '${packageInfo.version} - ${packageInfo.buildNumber}';
  //   ToastUtil.showLoading();
  //   String account = RHCache.getValue(RHCache.Login_Account, def: '');
  //   if (contactStr.length > 2000) {
  //     contactStr = contactStr.substring(0, 2000);
  //   }
  //   Map<String, dynamic> params = {
  //     "uid": RHCache.getUid(),
  //     "content": contactStr,
  //     "account": account,
  //     "region": Platform.localeName,
  //     "appVersion": version,
  //     "device": deviceStr,
  //     "osInfo": Platform.operatingSystem,
  //     "resolution": "${RHNull.getInt(Get.width)} : ${RHNull.getInt(Get.height)}"
  //   };
  //   userApi.errorReport(params);
  // }
}