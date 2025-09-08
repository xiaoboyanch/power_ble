
import '../../base_tool/log_utils.dart';
import '../enum/device_type.dart';

import '../base/ble_model.dart';
import '../model/power_model.dart';

class BleFactory {
  static final BleFactory _instance = BleFactory._internal();

  factory BleFactory() => _instance;

  BleFactory._internal();

  /**
   * 所有已创建的蓝牙model
   */
  static final Map<RHDeviceType, BleModel> _modelMap = {};

  static BleModel getModel(RHDeviceType type) {
    return _modelMap[type]!;
  }

  static bool hasModel(RHDeviceType type) {
    return _modelMap.containsKey(type);
  }

  static void clear() {
    // _modelMap.clear();
    final keys = _modelMap.keys.toList(); // 复制键列表
    for (var key in keys) {
      LogUtils.d("有没有清除： $key");
      _modelMap[key]?.disconnectDevice();
      _modelMap[key]?.dispose();
      _modelMap.remove(key); // 安全地移除元素
    }
  }


  static void registerModel(RHDeviceType type, BleModel model) {
    _modelMap[type] = model;
  }

  static Future<void> unregisterModel(RHDeviceType type) async {
    if (!hasModel(type)) return;
    _modelMap[type]?.disconnectDevice();
    _modelMap[type]?.dispose();
    _modelMap.remove(type);
    }

  static BleModel createModel(RHDeviceType type) {
    if (hasModel(type)) {
      return _modelMap[type]!;
    }
    BleModel model;
    switch (type) {
      case RHDeviceType.powerBoard:
        model = PowerModel();
        break;
      default:
        model = PowerModel();
        break;
    }
    _modelMap[type] = model;
    return model;
  }
}