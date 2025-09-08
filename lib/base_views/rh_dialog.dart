
import 'package:cabina_ble/base_views/rh_button.dart';
import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RHDialog extends StatelessWidget {
  static String iconWarning = 'common/warning';
  String titleKey;
  String content;
  String? cancelKey;
  String? confirmKey;
  String icon;
  Size iconSize;
  VoidCallback? onConfirmClick;
  VoidCallback? onCancelClick;
  bool isDelete;
  bool showCancel;
  double fontSize;
  Color? fontColor;

  RHDialog({super.key,
    this.titleKey = '',
    this.content = '',
    this.icon = '',
    this.iconSize = const Size(51, 51),
    this.cancelKey = "a_cancel",
    this.confirmKey = "a_confirm",
    this.onConfirmClick,
    this.onCancelClick,
    this.isDelete = false,
    this.showCancel = false,
    this.fontSize = 13,
    this.fontColor = RHColor.grey999,
  });

  @override
  Widget build(BuildContext context) {
    String title = "";
    if (titleKey.isNotEmpty) {
      title = titleKey.tr;
    }

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          // width: 353,
          margin: const EdgeInsets.only(left: 18, right: 18),
          constraints: const BoxConstraints(minHeight: 100, maxWidth: 440),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: RHColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(15))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon.isNotEmpty)
                // RHImage(
                //   imageName: icon,
                //   width: iconSize.width,
                //   height: iconSize.height,
                // ),
              if (icon.isNotEmpty)
                const SizedBox(height: 16,),
              if (title.isNotEmpty)
              RHText(
                  text: title,
                  fontSize: 18,
                  fontWeight: 6,
              ),
              if (title.isNotEmpty)
                const SizedBox(height: 21),
              if (content.isNotEmpty)
                RHText(
                  text: content,
                  rowSpace: 1.2,
                  // textAlign: TextAlign.center,
                  fontColor: fontColor,
                  fontSize: fontSize,
                ),
              if (content.isNotEmpty)
                const SizedBox(height: 28,),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                      visible: cancelKey != null && showCancel == true,
                      child: Expanded(
                        child: RHButton(
                          height: 42,
                          borderColor: RHColor.grey_d8d8,
                          backgroundColor: RHColor.white,
                          textColor: RHColor.fontDark000,
                          textKey: cancelKey ?? "",
                          onTap: () {
                            Navigator.pop(context);
                            onCancelClick?.call();
                          },
                        ),
                      )),
                  Visibility(
                      visible: cancelKey != null && showCancel == true,
                      child: const SizedBox( width: 25, )
                  ),

                  Expanded(
                      child: isDelete ? RHButton(
                        height: 42,
                        borderColor: RHColor.primary,
                        backgroundColor: RHColor.primary.withOpacity(0.1),
                        textColor: RHColor.primary,
                        textKey: confirmKey ?? "",
                        onTap: () {
                          Navigator.pop(context);
                          if (onConfirmClick != null) {
                            onConfirmClick!.call();
                          }
                        },
                      ) : RHButton(
                        height: 42,
                        backgroundColor: RHColor.primary,
                        textColor: RHColor.white,
                        textKey: confirmKey ?? "",
                        onTap: () {
                          Navigator.pop(context);
                          if (onConfirmClick != null) {
                            onConfirmClick!.call();
                          }
                        },
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showWithReturn() {
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,  //  点击空白区域隐藏
        builder: (builder) {
          return WillPopScope(
            child: this,
            onWillPop: () async {
              return false;
            },
          );
        }
    );
  }
  bool isShow = false;
  void show() {
    isShow = true;
    showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return ScaleTransition(scale: animation, child: child);
        },
        context: Get.context!,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return WillPopScope(
            child: this,
            onWillPop: () async {
              return false;
            },
          );
        }).then((value) {
          isShow = false;
    });
    // showDialog(
    //     context: Get.context!,
    //     barrierDismissible: false,  //  点击空白区域隐藏
    //     builder: (builder) {
    //       return WillPopScope(
    //         child: this,
    //         onWillPop: () async {
    //           return false;
    //         },
    //       );
    //     }
    // );
  }

}