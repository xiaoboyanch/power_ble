import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base_tool/rh_null.dart';

typedef TextFieldChange = String? Function(TextEditingController ctrl, String text);

class RHTextInput extends StatelessWidget {
  EdgeInsets margin;
  EdgeInsets padding;
  double width;
  double height;
  double fontSize;
  int fontWeight;
  TextAlign textAlign;
  Color? textColor;
  String text;
  String placeHolderText;
  Color? placeHolderColor;
  double radius;
  Color? borderColor;
  Color backColor;
  bool isPassword;
  bool isPhone;
  bool? isCode;
  bool? isEmail;
  Widget? leftView;
  Widget? rightView;
  TextEditingController? textCtrl;
  TextInputType? keyboardType;
  int? maxLength;
  Color cursorColor;
  FocusNode? focusNode;
  TextFieldChange onChange;

  RHTextInput({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.fromLTRB(18, 10, 18, 10),
    this.width = 0,
    this.height = 46,
    this.fontSize = 16,
    this.fontWeight = 5,
    this.textAlign = TextAlign.left,
    this.textColor,
    this.leftView,
    this.rightView,
    this.text = '',
    this.placeHolderText = '',
    this.placeHolderColor,
    this.radius = 23,
    this.borderColor,
    this.backColor = const Color(0xFFFFFFFF),
    this.isPassword = false,
    this.maxLength,
    this.textCtrl,
    this.keyboardType,
    this.isCode,
    this.isEmail,
    this.isPhone = false,
    this.cursorColor = const Color(0xFFFE2B1A),
    this.focusNode,
    required this.onChange,
  }) {
    textColor ??= RHColor.fontDark000;
    placeHolderColor ??= RHColor.font999;
    textCtrl ??= TextEditingController(text: text);
    if (text.isNotEmpty) {
      textCtrl!.value = TextEditingValue(
          text: text,
          selection: TextSelection.fromPosition(
              TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: text.length
              )
          )
      );
    }
    if (keyboardType == null) {
      if (isEmail == true) {
        keyboardType = TextInputType.emailAddress;
      }
      if (isPhone == true) {
        keyboardType = TextInputType.phone;
      }
      if (isCode == true) {
        keyboardType = const TextInputType.numberWithOptions(decimal: false);
        maxLength = 6;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FontWeight fw;
    switch (fontWeight) {
      case 5:
        fw = FontWeight.w500;
        break;
      case 6:
        fw = FontWeight.w600;
        break;
      case 7:
        fw = FontWeight.w700;
        break;
      default:
        fw = FontWeight.w500;
        break;
    }
    Widget tf = TextField(
      cursorColor: cursorColor,
      scrollPadding: EdgeInsets.zero,
      textAlign: textAlign,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        hintStyle: TextStyle(color: placeHolderColor, fontWeight: FontWeight.w400, fontSize: 14),
        hintText: placeHolderText.tr,
        enabledBorder: null,
        focusedBorder: null,
      ),
      style: TextStyle(fontSize: fontSize, color: textColor, fontWeight: fw, height: 1.0),
      obscureText: isPassword,
      controller: textCtrl,
      focusNode: focusNode,
      onChanged: (text) { /// 输入框内容变化回调
        if (isPhone) {
          int? newInt = int.tryParse(text);
          if (text.isNotEmpty) {
            if (newInt != null) {
              text = newInt.toString();
            }else {
              String clearedString = text.replaceAll(RegExp(r'\D'), '');
              text = clearedString;
            }
          }
        }
        String? newText = onChange(textCtrl!, RHNull.getStr(text));
        if (newText != null) {
          textCtrl!.value = TextEditingValue(
              text: newText,
              selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: newText.length
                  )
              )
          );
        }
      },
    );
    bool isRow = (leftView != null || rightView != null);
    List<Widget> list = [Expanded(child: tf),];
    if (isRow) {
      if (leftView != null) {
        list.insert(0, leftView!);
      }
      if (rightView != null) {
        list.add(rightView!);
      }
    }
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      alignment: Alignment.center,
      width: width > 0 ? width : double.infinity,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: (borderColor != null) ?
          Border.all(color: borderColor!, width: 1) : null,
      ),
      child: isRow ?
        Row(
          children: list,
        ) : tf
    );
  }
}
