
import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_nav_bar.dart';
import 'package:flutter/material.dart';

class RHPage extends StatelessWidget {

  bool canBack;
  bool isStack; //  false:body就能直接排在NavBar下面; true:body顶到最顶部
  Widget body;
  bool showNavBar;
  bool showBackArrow;
  Color? backgroundColor;
  Color? navBarColor;
  RHNavBar? navBar;
  String title;
  List<Widget> backViews;
  List<Widget> frontViews;
  double leftSpace = 0;
  double topSpace = 0;
  double botSpace = 0;  /// 只在isStack=true的情况下生效
  List<Widget>? rightBtn;
  String backIcon = '';
  VoidCallback? backAction;
  RHPage({
    required this.body,
    this.title = '',
    this.showNavBar = true,
    this.showBackArrow = true,
    this.navBar,
    this.backgroundColor,
    this.canBack = true,
    this.isStack = false,
    this.backViews = const [],
    this.frontViews = const [],
    this.leftSpace = 18,
    this.topSpace = 0,
    this.botSpace = 0,
    this.rightBtn,
    this.navBarColor,
    this.backIcon = '',
    this.backAction,
    super.key,
  }) {
    backgroundColor ??= RHColor.white;
    // navBarColor ??= RHColor.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (showNavBar) {
      navBar ??= RHNavBar(
        title: title,
        rightBtns: rightBtn,
        color: navBarColor,
        backIcon: backIcon,
        backAction: backAction,
        showBackIcon: showBackArrow,
      );
    }

    Widget wd;
    if (isStack) {
      wd = Stack(
        alignment: Alignment.center,
        children: [
          for (Widget obj in backViews)
            (obj is Positioned) ? obj : Positioned.fill(child: obj),
          Positioned(
            left: leftSpace,
            top: topSpace,
            right: leftSpace,
            bottom: botSpace,
            child: body,
          ),
          if (showNavBar)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: navBar!,
            ),
          for (Widget obj in frontViews)
            (obj is Positioned) ? obj : Positioned.fill(child: obj),
        ],
      );
    }else {
      if (backViews.isNotEmpty || frontViews.isNotEmpty) {
        wd = Stack(
          alignment: Alignment.center,
          children: [
            for (Widget obj in backViews)
              Positioned.fill(child: obj),
            Column(
              children: [
                if (showNavBar)
                  navBar!,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(leftSpace, topSpace, leftSpace, 0),
                    child: body,
                  ),
                )
              ],
            ),
            for (Widget obj in frontViews)
              (obj is Positioned) ? obj : Positioned.fill(child: obj),
          ],
        );
      }else {
        wd = Column(
          children: [
            if (showNavBar)
              navBar!,
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(leftSpace, topSpace, leftSpace, 0),
                child: body,
              ),
            )
          ],
        );
      }
    }
    Widget finalBody = GestureDetector(
      onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); // 隐藏键盘
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: wd,
      ),
    );
    if (canBack) {
      return finalBody;
    }else {
      return WillPopScope(child: finalBody, onWillPop: ( ) async {
        return false;
      });
    }
  }
}