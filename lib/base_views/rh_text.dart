import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'rh_colors.dart';

class RHText extends StatelessWidget {

  static const String FONT_Number6 = "fontNumber";

  String? fontFamily;
  String textKey;
  Color? backgroundColor;
  TextStyle? style;
  VoidCallback? onTap;
  VoidCallback? onLongPress;
  String text;
  double fontSize;
  Color? fontColor;
  TextAlign? textAlign;
  int fontWeight = 0;
  double rowSpace;
  int? maxLine;
  double bigWidth = 0;
  double bigHeight = 0;
  bool isEllipsis;
  Alignment bigAlignment;
  EdgeInsets edge;
  Shadow? shadow;
  bool isIgnore;

  RHText({
    this.textKey = '',
    this.fontFamily = '',//FONT_OpenSans,
    this.backgroundColor,
    this.style,
    this.onTap,
    this.onLongPress,
    this.bigWidth=0,
    this.bigHeight=0,
    this.rowSpace = 1.2,
    this.bigAlignment = Alignment.center,
    this.text = '',
    this.fontSize = 15,
    this.fontColor,
    this.textAlign,
    this.fontWeight = 4,
    this.isEllipsis = false,
    this.maxLine,
    this.edge = EdgeInsets.zero,
    this.shadow,
    this.isIgnore = false,
    super.key
  });

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    fontColor ??= RHColor.fontDark000;
    Color? color = fontColor;
    var message = "";
    if (textKey.isNotEmpty) {
      message = textKey.tr;
    } else if (text.isNotEmpty) {
      message = text;
    }

    FontWeight? fw;
    switch (fontWeight) {
      case 3:
        fw = FontWeight.w300;
        break;
      case 4:
        fw = FontWeight.w400;
        break;
      case 5:
        fw = FontWeight.w500;
        break;
      case 6:
        fw = FontWeight.w600;
        break;
      case 7:
        fw = FontWeight.w700;
        break;
      case 9:
        fw = FontWeight.w900;
        break;
      default:
        break;
    }
    var tttext = Text(
      message,
      maxLines: maxLine,
      overflow: isEllipsis == true ? TextOverflow.ellipsis : null,
      style: style ??
          TextStyle(
              fontSize: fontSize ?? 14,
              color: color,
              fontWeight: fw,
              height: rowSpace,
              fontFamily: fontFamily,
              shadows: shadow != null ?[
                shadow!
              ] : [],
              overflow: isEllipsis == true ? TextOverflow.ellipsis : null
          ),
      textAlign: textAlign,

    );
    if (bigHeight > 0 || bigWidth > 0 || backgroundColor!=null || edge != EdgeInsets.zero) {
      return GestureDetector(
        onTap: onTap,
        onLongPressStart: (LongPressStartDetails details) {
          if (onLongPress != null) {
            timer ??= Timer.periodic(const Duration(milliseconds: 200), (timer) {
              // print("执行");
              onLongPress!();
            });
          }
        },
        onLongPressCancel: () {
          // print("取消");
          if (timer != null) {
            timer!.cancel();
            timer = null;
          }
        },
        onLongPressEnd: (e) {
          // print("结束");
          if (timer != null) {
            timer!.cancel();
            timer = null;
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: edge,
          color: backgroundColor,
          alignment: bigAlignment,
          height: (bigHeight > 0)? bigHeight : null,
          width: (bigWidth > 0)? bigWidth : null,
          child: tttext,
        ),
      );
    }else if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: tttext,
      );
    }else {
      return tttext;
    }
  }
}