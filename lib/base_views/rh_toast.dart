
import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

///吐司工具类
class RHToast {
  static bool isShow = false;
  static String identify = '';
  static int _dismissFlag = 0;
  ///显示吐司
  static showToast({required String msg}) {
    String title = msg.isEmpty ?  'loading...' : msg.tr;
    String newIDStr = 'text1-$msg';
    if (newIDStr != identify) {
      _dismissFlag ++;
      identify = newIDStr;
      EasyLoading.showToast(title);
    }
    _cleanIdentify(_dismissFlag);
  }

  static showNetError(bool isOK, String msg, String ext) {
    if (!isOK) {
      showToast(msg: '${msg}_$ext');
    }else {
      RHToast.dismiss();
    }
  }

  static _cleanIdentify(int flag) {
    Future.delayed(const Duration(seconds: 2), () {
      if (flag == _dismissFlag) {
        identify = '';
      }
    });
  }

  static showLoading({String msg='', bool canTouch = true}) {
    String title = msg.isEmpty ?  'loading...' : msg.tr;
    String newIDStr = 'load-$msg';
    if (newIDStr != identify) {
      identify = newIDStr;
      EasyLoading.show(status: title);
    }
  }

  static showProgress({int current=0, int total=1, String? msg, bool canTouch=false}) {
    EasyLoading.instance.textStyle = const TextStyle(fontFamily: 'Monospace');
    const maxLength = 6; // 可根据实际情况调整
    String displayMsg = msg ?? '';
    while (displayMsg.length < maxLength) {
      displayMsg = ' ' * (maxLength - displayMsg.length) + displayMsg;
    }
    EasyLoading.showProgress(
        current/total,
        status: displayMsg,
        maskType: canTouch ? EasyLoadingMaskType.none : EasyLoadingMaskType.black
    );
  }

  static dismiss() {
    identify = "";
    EasyLoading.dismiss();
  }

  static setup() {
    EasyLoading ins = EasyLoading.instance;
    ins.loadingStyle = EasyLoadingStyle.custom;
    ins.progressColor = Colors.grey;
    ins.indicatorType = EasyLoadingIndicatorType.threeBounce;
    ins.backgroundColor = RHColor.white;
    ins.indicatorColor = RHColor.white;
    ins.textColor = RHColor.black;
    ins.maskType = EasyLoadingMaskType.black;
    ins.boxShadow = RHColor.cardShadow;
    EasyLoading.instance.textStyle = const TextStyle(fontFamily: 'Monospace');  //  等宽字体,每个字符宽度一致
    EasyLoading.instance.indicatorWidget = Image.asset(
      'assets/img/common/loading.gif',
      width: 90,
      height: 60,
      fit: BoxFit.cover, // 可选参数，控制图片缩放适应方式
    );
    EasyLoading.instance.radius = 15;
  }
}
