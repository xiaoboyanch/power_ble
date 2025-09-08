import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/material.dart';

class RHButton extends StatelessWidget {
  double? height;
  double width;
  double? minWidth;
  int fontWeight;
  VoidCallback? onTap;
  String textKey;
  Color? backgroundColor;
  Color? borderColor;
  double borderWidth;
  Color? textColor;
  double fontSize;
  double radius;

  RHButton({
    this.textKey = '',
    this.textColor,
    this.onTap,
    this.backgroundColor,
    this.width = double.maxFinite,
    this.minWidth,
    this.fontWeight = 5,
    this.height = 46,
    this.borderColor,
    this.borderWidth = 1.0,
    this.radius = 23,
    this.fontSize = 14,
    super.key
  }) {
    textColor ??= RHColor.white;
    backgroundColor ??= RHColor.primary;
  }

  @override
  Widget build(BuildContext context) {
    textColor = textColor ?? Colors.grey;

    Widget child = RHText(
      textKey: textKey,
      fontColor: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );

    Decoration dec = BoxDecoration(
        color: backgroundColor,
        // gradient: backgroundColor ==null ? LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     RHColor.btnLeftColor,
        //     RHColor.btnRightColor,
        //   ],
        //   stops: const [0.0, 1.0], // 默认是从0到1均匀分布
        // ) : null,
        border: borderColor!=null ? Border.all( // 添加所有边框
          color: borderColor!, // 边框颜色
          width: borderWidth, // 边框宽度
        ) : null,
        borderRadius: BorderRadius.all(Radius.circular(radius))
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        alignment: Alignment.center,
        constraints: minWidth == null ? null : BoxConstraints(minWidth: minWidth!),
        width: minWidth == null ? width : null,
        height: height,
        decoration: dec,
        child: child
      ),
    );
  }
}