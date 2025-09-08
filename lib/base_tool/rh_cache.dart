
import 'package:cabina_ble/base_tool/rh_null.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RHCache {


  static Future<bool> setValue(String key, dynamic value) async {
    bool result = await _CacheUtil.getInstance().setValue(key, value ?? "");
    return result;
  }
  static dynamic getValue(String key, {dynamic def}) {
    var result = _CacheUtil.getInstance().get(key);
    return result ?? def;
  }

  static dynamic getList(String key) {
    String result = _CacheUtil.getInstance().get(key) ?? '[]';
    if (result.length > 2) {
      return RHNull.getList(result);
    }
    return [];
  }

  static void setBool(String key, bool value) {
    _CacheUtil.getInstance().setBool(key, value);
  }
  static dynamic getBool(String key, {bool def = false}) {
    var result = _CacheUtil.getInstance().getBool(key, def: def);
    return result;
  }
  static void setInt(String key, int value) {
    _CacheUtil.getInstance().setInt(key, value);
  }
  static dynamic getInt(String key) {
    var result = _CacheUtil.getInstance().getInt(key);
    return result;
  }


  // static void setEmail(String? email) {
  //   _CacheUtil.getInstance().setValue(emailKey, email ?? "");
  // }
  //
  // static String getEmail() {
  //   String result = _CacheUtil.getInstance().get(emailKey) ?? '/';
  //   return result;
  // }

  static init() async {
    await _CacheUtil.getInstance().init();
  }

  RHCache._a();
}

class _CacheUtil {
  static _CacheUtil? _instance;
  SharedPreferences? _sharedPreferences;

  _CacheUtil._();

  init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static _CacheUtil getInstance() {
    _instance ??= _CacheUtil._();
    return _instance!;
  }

  Future<bool> setValue(String key, dynamic value) async {
    bool result = await _sharedPreferences?.setString(key, value) as bool;
    return result;
  }

  T? get<T>(String key) {
    var value = _sharedPreferences?.get(key);
    return value as T?;
  }

  bool getBool<T>(String key, {bool def = false}) {
    var value = _sharedPreferences?.getBool(key);
    return (value != null) ? value : def;
  }

  setBool(String key, bool value) async {
    await _sharedPreferences?.setBool(key, value);
  }

  int getInt<T>(String key) {
    var value = _sharedPreferences?.getInt(key);
    return value ?? 0;
  }

  setInt(String key, int value) async {
    await _sharedPreferences?.setInt(key, value);
  }

  remove(String key) {
    _sharedPreferences?.remove(key);
  }
}