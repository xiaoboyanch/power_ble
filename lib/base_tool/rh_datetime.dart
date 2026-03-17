
import 'package:intl/intl.dart';

extension RHDatetime on DateTime {
  String get newFormatDate {
    String format = 'yyyy/MM/dd';
    return DateFormat(format).format(this);
  }
  String get formatDate {
    String format = 'yyyy-MM-dd';
    return DateFormat(format).format(this);
  }
  String get formatYMDHms {
    String format = 'yyyy-MM-dd HH:mm:ss';
    return DateFormat(format).format(this);
  }
  String get formatMD {
    String format = 'MM.dd';
    return DateFormat(format).format(this);
  }

  static nowYMDHms () {
    String format = 'yyyy-MM-dd HH:mm:ss';
    String timeStr = DateFormat(format).format(DateTime.now());
    return timeStr;
  }

  static String nowOnlyYMD () {
    String format = 'yyyy-MM-dd';
    String timeStr = DateFormat(format).format(DateTime.now());
    return timeStr;
  }

  static nowZeroTime() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool isYMDEqual(DateTime date) {
    if (date.year == year) {
      if (date.month == month) {
        if (date.day == day) {
          return true;
        }
      }
    }
    return false;
  }

  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  static String intToWeek(int day) {
    switch (day) {
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
      case 0:
        return 'week_sun';
    }
    return 'week_sun';
  }
}