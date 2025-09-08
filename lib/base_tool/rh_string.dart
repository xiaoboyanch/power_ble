import 'package:cabina_ble/base_tool/rh_null.dart';
import 'package:get/get.dart';

extension RHString on String {
  String trExt(List list) {
    String newStr = this.tr;
    for (int i=0; i<list.length; i++) {
      String targetStr = '{{value$i}}';
      newStr = newStr.replaceAll(targetStr, RHNull.getStr(list[i]));
    }
    return newStr;
  }
  String get fixHost{
    if (this.contains('http')) {
      return this;
    }else {
      return 'http://43.136.69.79:8081/prod-api$this';
    }
  }
  String get toAssetsImage {
    return "assets/img/${this}.png";
  }
  String get toGifImage {
    return "assets/img/${this}.gif";
  }
  String get darkImage {
    return "assets/img/${this}.png";
  }

  String get toAssetsImageSelected {
    return "assets/img/${this}-sel.png";
  }

  bool get isImage {
    return indexOf("gif") > -1;
  }

  bool get isNickname {
    String regexEmail = "^[A-Za-z0-9-－]+\$";
    if (isEmpty) return false;
    if (length < 4 || length > 20) {
      return false;
    }
    return RegExp(regexEmail).hasMatch(this);
  }


  String get onlyNumber {
    return replaceAll(RegExp(r'\D'), '');
  }
}

extension RHInt on int {

  String get intToWeek {
    switch (this) {
      case 1:
        return 'week_mon';
      case 2:
        return 'week_tue';
      case 3:
        return 'week_wed';
      case 4:
        return 'week_thu';
      case 5:
        return 'week_fri';
      case 6:
        return 'week_sat';
      case 7:
        return 'week_sun';
    }
    return 'week_sun';
  }

  bool get isBool {
    return this == 1;
  }

  String get leftZero {
    int seconds = this;
    return seconds.toString().padLeft(2, '0');
  }

  String get hourAndMinute {
    int seconds = this;
    int hour = seconds ~/ 60;
    int minute = seconds % 60;

    String h = hour.toString().padLeft(2,'0');
    String m = minute.toString().padLeft(2,'0');

    return "$h:$m";
  }

  String get formatSportTime {
    int seconds = this;
    int hour = seconds ~/ 3600;
    int minute = (seconds - hour * 3600) ~/ 60;
    int second = seconds % 60;

    String h = hour > 0
        ? hour > 9
        ? '$hour'
        : '0$hour'
        : '00';
    String m = minute > 9 ? '$minute' : '0$minute';
    String s = second > 9 ? '$second' : '0$second';

    // if (hour == 0) {
    //   return '$m:$s';
    // }
    return "$h:$m:$s";
  }

  String numToK ({int fix=0}) {
    if (this > 1000000) {
      return (this/1000000).toStringAsFixed(fix)+'M';
    }else if (this > 1000) {
      return (this/1000).toStringAsFixed(fix) + 'K';
    }else {
      return this.toStringAsFixed(fix);
    }
  }

  String formatWithUnit() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    }
  }

  String formatWithUnitChart() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      return '${(this / 1000).toStringAsFixed(0)}K';
    } else {
      return '${(this / 1000000).toStringAsFixed(0)}M';
    }
  }

  String toCommaSeparatedString() {
    if (this == 0) {
      return '0';
    }

    List<String> parts = [];
    int num = this;
    while (num > 0) {
      parts.add((num % 1000).toString());
      num = num ~/ 1000;
    }

    return parts.reversed.join(',');
  }

  String get toMinAndSecond {
    int seconds = this;
    int minute = seconds ~/ 60;
    int second = seconds % 60;

    String m = minute > 9 ? '$minute' : '0$minute';
    String s = second > 9 ? '$second' : '0$second';

    return "$m:$s";
  }
  String get paceTime {
    int seconds = this;
    int minute = seconds ~/ 60;
    int second = seconds % 60;

    String m = minute > 9 ? '$minute' : '0$minute';
    String s = second > 9 ? '$second' : '0$second';

    return "$m'$s\"";
  }

  String get oneUnitTime {
    if (this < 100) { //  99秒
      return this.toString();
    }else if (this < 5940) {  //  99分钟
      int minute = this ~/ 60;
      return minute.toString();
    }else if (this < 356400) {  //  99小时
      int hour = this ~/ 3600;
      return hour.toString();
    }else {
      return '∞';
    }
  }

  String get formatTime {
    int seconds = this;
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    String m = min > 0 ? '$min\'' : '';
    String s = sec > 9 ? '$sec' : '0$sec';
    return "$m$s\"";
  }

  static const double ft2cm = 30.48;
  static const double kg2lbs = 2.20462;
  String get kgToLb {
    return (this * kg2lbs).toStringAsFixed(0);
  }

  String get lbToKg {
    return (this / kg2lbs).toStringAsFixed(0);
  }
}
