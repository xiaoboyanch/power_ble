import 'dart:convert';

class RHNull{
  static RHNull? _instance;
  factory RHNull.mgr() {
    _instance ??= RHNull._();
    return _instance!;
  }
  RHNull._();
  static bool getBool(dynamic any) {
    if (any is int || any is double) {
      return (any == 1);
    }else if (any is String) {
      if (any.isNotEmpty) {
        return any != 'false';
      }
    }else if (any is bool) {
      return any;
    }
    return false;
  }
  static int getInt(dynamic any) {
    if (any is int) {
      return any;
    }else if (any == null) {
      return 0;
    }else if (any is double) {
      return any.round(); //  四舍五入
    }else if (any is String) {
      if (any.isNotEmpty) {
        bool containsHello = any.contains(".");
        if (containsHello) {
          var list = any.split('.');
          if (list.isNotEmpty) {
            String clearedString = list[0].replaceAll(RegExp(r'\D'), '');
            return int.parse(clearedString);
          }
        }
        String clearedString = any.replaceAll(RegExp(r'\D'), '');
        if (clearedString.isEmpty) {
          return 0;
        }
        return int.parse(clearedString);
      }
    }
    return 0;
  }
  static double getDoub(dynamic any){
    if (any is int) {
      return any * 1.0;
    }else if (any == null) {
      return 0.0;
    }else if (any is double) {
      return any;
    }else if (any is String) {
      if (any.isNotEmpty) {
        var list = any.split('.');
        if (list.isNotEmpty) {
          String leftStr = list[0].replaceAll(RegExp(r'\D'), '');
          int left = RHNull.getInt(leftStr);
          String right = '0';
          if (list.length > 1) {
            right = list[1].replaceAll(RegExp(r'\D'), '');
          }
          return double.parse('$left.$right');
        }
      }
    }
    return 0.0;
  }
  static String getStr(dynamic any) {
    if (any is String) {
      return any as String;
    }else if (any is int) {
      return any.toString();
    }else if (any is double) {
      return any.toString();
    }else if (any == null) {
      return '';
    }else {
      return '';
    }
  }
  static Map<T, E> getMap<T, E>(dynamic any) {
    if (any is Map) {
      return any as Map<T, E>;
    }else if (any is String) {
      if (any.length > 2) {
        if (any[0] == '{' && any[any.length-1] == '}') {
          dynamic n = jsonDecode(any);
          if (n is! String) {
            return getMap(n);
          }
          n = jsonDecode(n);
          if (n is! String) {
            return getMap(n);
          }
        }
      }
    }
    return <T,E>{};
  }

  static List<T> getList<T> (dynamic any) {
    if (any is List) {
      return any as List<T>;
    }else if (any is String) {
      if (any.length > 2) {
        dynamic n = jsonDecode(any);
        if (n is! String) {
          return getList<T>(n);
        }
        n = jsonDecode(n);
        if (n is! String) {
          return getList<T>(n);
        }
      }
    }
    return [];
  }
}