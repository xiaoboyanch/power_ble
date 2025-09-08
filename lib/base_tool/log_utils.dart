class LogUtils {
  static const String TAG = "LogUtils";

  static void d(String msg, {String tag = TAG}) {
    print("$tag: $msg");
  }

  static void e(String msg, {String tag = TAG}) {
    print("$tag: $msg");
  }

  static void w(String msg, {String tag = TAG}) {
    print("$tag: $msg");
  }
}