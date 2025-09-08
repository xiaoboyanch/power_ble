
import 'dart:async';

import 'package:cabina_ble/base_tool/rh_string.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RHImage extends StatelessWidget {
  double width;
  double? height;
  double bigWidth=0;
  double? bigHeight;
  Alignment? bigAlignment;
  Alignment? imgAlignment;
  VoidCallback? onTap;
  VoidCallback? onLongTap;
  VoidCallback? onLongPress;
  VoidCallback? onLonePressEnd;
  VoidCallback? onLoadComplete;
  String imageName;
  String imageUrl;
  BoxFit? boxFit;
  bool isDark;
  bool showDefault;
  String? defaultImage;
  Rect? centerSlice;
  double radius;
  double? scale;
  bool isSelected;
  Color? backgroundColor;

  RHImage({
    this.isDark = false,
    this.showDefault = true,
    this.width = 40,
    this.height,
    this.bigWidth=0,
    this.bigAlignment=Alignment.center,
    this.imgAlignment=Alignment.center,
    this.bigHeight,
    this.onTap,
    this.imageUrl = '',
    this.imageName = '',
    this.boxFit,
    this.defaultImage,
    this.radius=0,
    this.scale,
    this.centerSlice,
    this.isSelected = false,
    this.onLongTap,
    this.backgroundColor,
    this.onLongPress,
    this.onLonePressEnd,
    this.onLoadComplete,
    super.key});
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    defaultImage ??= "image_holder";

    Widget child;
    if (imageName.isNotEmpty) {
      String iconName = imageName.toAssetsImage;
      if (isDark) {
        iconName = iconName.replaceAll('.png', '-dk.png');
      }
      if (isSelected) {
        iconName = iconName.replaceAll('.png', '-sel.png');
      }
      child = Image.asset(
        iconName,
        scale: scale,
        centerSlice: centerSlice,
        width: width,
        height: height,
        fit: boxFit,
        alignment: imgAlignment!,
      );
    } else if (imageUrl.length > 5) {
      String url = imageUrl.substring(0, 4);
      if (url == 'http') {
        url = imageUrl;
      }else {
        url = "https://usaimages.oss-us-west-1.aliyuncs.com/17546/product/20250526/SPERAX_P1_VIBRATING_WALKING_PAD_1748244382839_1.jpg_w720.jpg";
      }
      child = CachedNetworkImage(
        imageUrl: url,
        alignment: imgAlignment!,
        fit: boxFit,
        placeholder: showDefault ? (context, url) => Image.asset(
          defaultImage!.toAssetsImage,
          width: width,
          height: height,
          fit: boxFit,
        ) : null,
        errorWidget: (context, url, error) => Image.asset(
          defaultImage!.toAssetsImage,
          width: width,
          height: height,
          fit: boxFit,
        ),
        imageBuilder: onLoadComplete != null ? (context, imageProvider) {
          onLoadComplete!();
          return Image(
              // centerSlice: centerSlice,
              fit: boxFit,
              alignment: Alignment.center,
              image: imageProvider
          );
        }: null,
      );
    }else if (defaultImage != null && defaultImage!.length > 1) {
      child = Image.asset(
        defaultImage!.toAssetsImage,
        width: width,
        height: height,
        fit: boxFit,
        alignment: imgAlignment!,
      );
    }else {
      child = const SizedBox();
    }
    if (bigWidth > 0) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        onLongPressStart: (e) {
          if (onLongPress != null) {
            onLongPress!();
          }
          if (onLongTap != null) {
            timer ??= Timer.periodic(const Duration(milliseconds: 200), (timer) {
              // print("执行");
              onLongTap!();
            });
          }
        },
        onLongPressCancel: () {
          if (onLonePressEnd != null) {
            onLonePressEnd!();
          }
          if (timer != null) {
            timer!.cancel();
            timer = null;
          }
        },
        onLongPressEnd: (onLongTap != null) ? (e) {
          if (onLonePressEnd != null) {
            onLonePressEnd!();
          }
          if (timer != null) {
            timer!.cancel();
            timer = null;
          }
        } : null,
        child: Container(
          width: bigWidth,
          height: bigHeight,
          alignment: bigAlignment,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(radius))
          ),
          child: child,
        ),
      );
    }else {
      Widget ct = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor, // Colors.blue,//
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: child,
          onLongPressStart: (e) {
            if (onLongPress != null) {
              onLongPress!();
            }
            if (onLongTap != null) {
              timer ??= Timer.periodic(const Duration(milliseconds: 200), (timer) {
                // print("执行");
                onLongTap!();
              });
            }
          },
          onLongPressCancel: () {
            // print("取消");
            if (timer != null) {
              timer!.cancel();
              timer = null;
            }
            if (onLonePressEnd != null) {
              onLonePressEnd!();
            }
          },
          onLongPressEnd: (e) {
            // print("结束");
            if (timer != null) {
              timer!.cancel();
              timer = null;
            }
            if (onLonePressEnd != null) {
              onLonePressEnd!();
            }
          },
        ),
      );
      if (radius > 0) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: ct,
        );
      }else {
        return ct;
      }
    }
  }

  static loginIcon(String icon) {
    return RHImage(
      width: 16,
      bigWidth: 25,
      bigAlignment: Alignment.centerLeft,
      imageName: icon,
    );
  }

  static customIcon(Color color, {double bigSize=30, double imgSize=21}) {
    return RHImage(
      height: imgSize,
      width: imgSize,
      radius: 6,
      backgroundColor: color,
      bigWidth: bigSize,
      bigHeight: bigSize,
      boxFit: BoxFit.fitWidth,
      imageName: 'logo65-dk',
    );
  }

  static backIcon(BuildContext context, {int isDark = 2, VoidCallback? callback}) {
    String imgName = '';
    switch (isDark) {//  0固定亮色背景,1固定黑色背景,2自动
      case 2:
        imgName = 'assets/img/arrow_back.png';
        break;
      case 1:
        imgName = 'assets/img/arrow_back-dk.png';
        break;
      case 0:
        imgName = 'assets/img/arrow_back.png';
        break;
    }
    callback ??= (() => Navigator.of(context).pop());
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: callback,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.centerLeft,
        // padding: EdgeInsets.only(left: 3),
        child: Image.asset(
          imgName,
          width: 17,
          height: 17,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
