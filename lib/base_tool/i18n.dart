
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class i18n {

  static i18n? _instance;
  static i18n getInstance() {
    _instance ??= i18n();
    return _instance!;
  }

  static Map<String, Map> langDic () {
    return const {
      'en' : {
        'title' : 'English',
        'file'  : 'en_US',
        'country' : 'US',
        'flag': 'user/flag_en',
      },
      'zh' : {
        'title' : '中文',
        'file'  : 'zh_CN',
        'country' : 'CN',
        'flag': 'user/flag_cn',
      },
    };
  }

  static String get currentLangStr {
    // AppModel apmd = AppModel.getMgr();
    // Map mpp = RHNull.getMap(langDic()[apmd.language]);
    // if (mpp.length > 3) {
    //   return mpp['title'];
    // }
    return 'English';
  }

  // static String get postLang {
  //   AppModel apmd = AppModel.getMgr();
  //   return apmd.language;
  // }

  init() async {
    Map<String, String> baseMap = {};

    for (String key in langDic().keys) {
      Map mmp = langDic()[key]!;
      Map<String, String> newMpp = await _loadLocalJson(mmp['file'], baseMap);
      if (key == 'en') {
        baseMap = newMpp;
      }
    }
    Get.appendTranslations(_keys);
  }

  Locale get currentLocal {
    String systemLanguage = Platform.localeName.split('_').first;
    if (systemLanguage == 'zh') {
      return const Locale("zh", "CN");
    } else {
      // 除中文外其余全返回英文
      return const Locale("en", "US");
    }
  }

  final Map<String, Map<String, String>> _keys = {};
  Future<Map<String, String>> _loadLocalJson(String fileName, Map<String, String> oriMap) async {
    try {
      String data = await rootBundle.loadString('assets/i18n/$fileName.json');
      if (data != "") {
        Map<String, dynamic> decoded = jsonDecode(data) as Map<String, dynamic>;
        Map<String, String> localMap = decoded.map(
                (key, value) => MapEntry<String, String>(key, value as String)
        );
        Map<String, String> newMap = Map.fromEntries(oriMap.entries);
        localMap.forEach((key2, value) {
          if (value.isNotEmpty) {
            newMap[key2] = value;
          }
        });
        _keys[fileName] = newMap;
        return newMap;
      }
    } catch (e) {
      print('error multilingual configuration:${e.toString()}');
    }
    return oriMap;
  }

  static is_086() {
    return _instance!.getCountry == 'CN';
  }

  get getCountry {
    List ary = Platform.localeName.split('_');
    if (ary.length > 1) {
      return ary.last;
    }else {
      return 'CN';
    }
  }

}