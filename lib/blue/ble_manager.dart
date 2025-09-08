import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../base_tool/log_utils.dart';
import '../base_views/rh_dialog.dart';
import '../base_views/rh_permission.dart';
import '../base_views/rh_toast.dart';
import 'enum/device_type.dart';

typedef ScanResultCallback = void Function(List<ScanResult> result);

class BleManager {

  static const String TAG = "BleManager";

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  // late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  // late StreamSubscription<bool> _isScanningSubscription;

  StreamSubscription<List<ScanResult>>? _scanResultSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  late List<RHDeviceType> _deviceType;


  StreamController<BluetoothConnectionState> connectionStateStreamController = StreamController.broadcast();
  StreamController<bool> scanningStreamController = StreamController.broadcast();

  RHDialog? _tipDialog;

  void _startScanStream() {
    FlutterBluePlus.isScanning.listen((isScanning) {
      scanningStreamController.add(isScanning);
      LogUtils.d("扫描状态: $isScanning");
    });
  }

  RHDialog? showTipDialog() {
    _tipDialog ??= RHDialog(content: 'scan_device_no_found'.tr);
    return _tipDialog;
  }


  void init(){
    FlutterBluePlus.setLogLevel(LogLevel.error, color: false);
    FlutterBluePlus.adapterState.listen((state) {
      LogUtils.d("监听蓝牙的状态: $state");
      _adapterState = state;
    });
  }

  startScan(List<Guid> withServices, List<String> withNames, List<RHDeviceType> typeList, ScanResultCallback callback) async{
    _deviceType = typeList;
    _registerScanResultStream(callback);
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6), withServices: withServices, withNames: withNames);
    } catch (e) {
      print("扫描失败: $e");
    }
  }

  _registerScanResultStream(ScanResultCallback callback) async {
    if (_scanResultSubscription != null) {
      stopScan();
    }
    _scanResultSubscription = FlutterBluePlus.scanResults.listen((results) {
      callback(results);
    }, onError: (error) {
      print("扫描失败: $error");
    });
  }

  List<RHDeviceType> get scanDeviceType => _deviceType;

  Future stopScan() async{
    await FlutterBluePlus.stopScan();
    _scanResultSubscription?.cancel();
    _scanResultSubscription = null;
  }

  /// 蓝牙连接和断开监听
  void registerDeviceStreamSubscription(BluetoothDevice device) {
    unregisterDeviceStreamSubscription();
    _connectionStateSubscription = device.connectionState.listen((state) async {
      connectionStateStreamController.add(state);
    });
  }
  void unregisterDeviceStreamSubscription() {
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;
  }

  static Future<bool> checkPermission() async {
    if (BleManager.instance.bluetoothState != BluetoothAdapterState.on) {
      RHToast.showToast(msg: "bleNotOn");
      // BleManager.instance.
      return false;
    }
    if (Platform.isAndroid) {
      if (!(await RHPermission.checkLocationService())) {
        return false;
      }
    }
    if (!(await RHPermission.checkBluetoothPermission())) {
      return false;
    }
    return true;
  }

  /// 获取蓝牙开关状态
  get bluetoothState => _adapterState;

  getConnectedDevice() {
    return FlutterBluePlus.connectedDevices;
  }

  static final BleManager _instance = BleManager._internal();
  static BleManager get instance => _instance;
  factory BleManager._() { return _instance; }
  BleManager._internal() {
    _startScanStream();
  }

}