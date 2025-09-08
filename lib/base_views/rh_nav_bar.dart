import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_image.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RHNavBar extends StatelessWidget {
  double leftRightSpace;
  Color? color;
  RxInt? alphaFlag;
  String backIcon;
  bool showBackIcon;
  String title;
  List<Widget>? rightBtns;
  double barHeight;
  VoidCallback? backAction;

  RHNavBar({
    super.key,
    this.color,
    this.leftRightSpace = 16,
    this.backIcon = '',
    this.title = '',
    this.showBackIcon = true,
    this.barHeight = 44,
    this.rightBtns,
    this.alphaFlag,
    this.backAction,
  }) {
    color ??= RHColor.white;
  }
  static const int  _juli = 200;

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    Size size = MediaQuery.of(context).size;
    List<Widget> rrr = [];
    if (rightBtns != null && rightBtns!.isNotEmpty) {
      rrr = rightBtns!;
    }else {
      rrr.add(const SizedBox(width: 44,));
    }
    Widget backWd;
    backAction ??= Get.back;
    if (showBackIcon) {
      backWd = backIcon.isNotEmpty ? RHImage(
        height: 20,
        width: 22,
        imageName: backIcon,
        bigAlignment: Alignment.centerLeft,
        bigHeight: 44,
        bigWidth: barHeight,
        onTap: backAction,
      ) : RHImage.backIcon(context, isDark: 2, callback: backAction);
    }else {
      backWd = const Gap(44);
    }
    if (alphaFlag == null) {
      Widget bar = Container(
        height: barHeight+padding.top,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: color!,
            // border: Border(bottom: BorderSide(color: RHColor.grey_EB, width: 0.5))
        ),
        padding: EdgeInsets.fromLTRB(leftRightSpace-7, 0, leftRightSpace, 0 ),
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            backWd,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // 隐藏键盘
                },
                behavior: HitTestBehavior.translucent,
                child: (title.isNotEmpty) ? RHText(
                  fontSize: 16,
                  bigHeight: barHeight,
                  fontWeight: 6,
                  fontColor: RHColor.black,
                  text:  title,
                  // fontColor: isDark==0 ? Colors.black : Colors.white,
                  // textKey: title,
                ) : const SizedBox(),
              ),
            ),
            for (int i=0; i<rrr.length; i++)
              rrr[i],
          ],
        ),
      );
      return bar;
    }
    return Obx(() {
      int pointX = (alphaFlag!=null) ? alphaFlag!.value : 0;
      if (pointX < 0) {
        pointX *= -1;
      }

      double alpha = pointX / _juli;
      if (alpha > 1) {
        alpha = 1;
      }
      double boardAlpha = alpha;
      Color backColor = color!.withOpacity(alpha);
      Widget bar = Container(
        height: barHeight+padding.top,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: backColor,
          border: Border(bottom: BorderSide(color: RHColor.grey_EB.withOpacity(boardAlpha), width: 0.5))
        ),
        padding: EdgeInsets.fromLTRB(leftRightSpace-7, 0, leftRightSpace, 0 ),
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            backWd,
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // 隐藏键盘
                },
                behavior: HitTestBehavior.translucent,
                child: (title.isNotEmpty) ? RHText(
                  fontSize: 16,
                  bigHeight: barHeight,
                  fontWeight: 6,
                  // fontColor: isDark==0 ? Colors.black : Colors.white,
                  textKey: title,
                ) : const SizedBox(),
              ),
            ),
            for (int i=0; i<rrr.length; i++)
              rrr[i],
          ],
        ),
      );
      return bar;
    });
  }
}
