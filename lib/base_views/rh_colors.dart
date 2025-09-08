import 'dart:ui';

import 'package:flutter/material.dart';

class RHColor {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color grey999 = Color(0xFF999999);
  static const Color fontDark000 = Color(0xFF333333);
  static const Color primary = Color(0xFFFF4444);
  static const Color grey_d8d8 = Color(0xFFd8d8d8);
  static const Color fontF5F5 = Color(0xFFF5F5FA);
  static const Color pageBack = Color(0xFFF7F7FB);
  static const Color font3333 = Color(0xFF333333);
  static const Color black_34 = Color(0xFF343434);
  static const Color unSelect = Color(0xFFAAAFBC);
  static const Color grey_EB = Color(0xFFEBEBEB);
  static const Color defaultRed = Color(0xFFFF4444);

  static const Color line_1 = Color(0xFF157F05);
  static const Color line_2 = Color(0xFF00C0FC);

  static const Color contentColorLightPink = Color(0xFFFF69B4);
  static const Color contentColorDarkPink = Color(0xFFFF1493);
  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.08),
        // offset: const Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 2,
      )
    ];
  }
}