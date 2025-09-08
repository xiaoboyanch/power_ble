
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/base_views/rh_dialog.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../base_tool/rh_cache.dart';

class RHPermission {

  // 检查位置信息服务是否启用
  static Future<bool> checkLocationService() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      // 显示提示对话框，建议用户去打开位置信息服务
      RHDialog(
        titleKey: 'permission_location_title',
        content: 'permission_location_detail'.tr,
        confirmKey: "go_location_setting",
        showCancel:true,
        onCancelClick: () {
        },
        onConfirmClick: () async {
          await Geolocator.openLocationSettings();
        },
      ).show();
      return false;
    } else {
      // 位置信息服务已启用，可以执行后续操作
      return true;
    }
  }

  static Future<bool> checkBluetoothPermission() async {
    if (Platform.isAndroid) {
      return _checkLocationAndroid();
    } else {
      return checkBluetoothiOS();
    }
  }

  static Future<bool> _checkLocationAndroid() async {
    const String cacheKey = '_checkLocationAndroid_0913';
    int locatFlag = RHCache.getInt(cacheKey);
    LogUtils.d("cacheKey: $locatFlag");
    Future<bool> locatCheck() async {
      RHDialog(
        titleKey: 'permission_bluetooth_title',
        content: 'permission_bluetooth_detail'.tr,
        confirmKey: "OK",
        showCancel:true,
        onCancelClick: () {
          locatFlag = 2;
        },
        onConfirmClick: () async {
          final status = await Permission.locationWhenInUse.request();
          if (status != PermissionStatus.granted) {
            locatFlag = 2;
            AppSettings.openAppSettings();
          } else {
            await Permission.locationWhenInUse.request();
            locatFlag = 1;
            RHCache.setInt(cacheKey, 1);
          }
        },
      ).show();

      while (locatFlag == 0) {
        await Future.delayed( const Duration(milliseconds: 300));
      }
      return locatFlag == 1;
    }

    if (locatFlag != 1) { //  查找定位权限
      return locatCheck();
    }else {
      final status = await Permission.locationWhenInUse.status;
      if (status != PermissionStatus.granted) {
        locatFlag = 0;
        return locatCheck();
      } else {
        return await _androidBlue();
      }
    }
  }

  static Future<bool> _androidBlue() async {
    final isOn = await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    if (!isOn) {
      _blueOpenDialog(contentKey: 'permission_bluetooth_open_check');
      return false;
    } else {
      final status = await Permission.bluetooth.request();
      if (status != PermissionStatus.granted) {
        // return _checkBluetoothPermission();安卓不需要蓝牙权限,直接用
      }
      return true;
    }
  }

  static Future<bool> checkBluetoothiOS({bool showDialog=true}) async {
    final isOn = await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    if (!isOn) {  //  iOS不需要判断蓝牙权限，只需要判断是否打开开关
      if (showDialog) {
        _blueOpenDialog(contentKey: 'permission_bluetooth_open_check');
      }
    }
    Permission.bluetooth.request();
    return isOn;
  }

  static void _blueOpenDialog({required String contentKey}) {
    var dialog = RHDialog(
      content: contentKey,
      confirmKey: "OK",
      showCancel: true,
      onConfirmClick: () async {
        AppSettings.openAppSettings(type: AppSettingsType.bluetooth);//.openBluetoothSettings(asAnotherTask: true);
      },
    );
    dialog.show();
  }

  static Future<bool> checkLocationPermission() {
    return _checkPermission(
        'permission_location_use_check',
        'permission_location_use_check',
        Permission.locationWhenInUse
    );
  }

  static Future<bool> checkStoragePermission() async {
    bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      String cacheKey = 'checkStoragePermission';
      int flag = RHCache.getInt(cacheKey);
      if (flag == 0) {
        var dialog = RHDialog(
          content: 'permission_sd_storage_check'.tr,
          confirmKey: "OK",
          showCancel: true,
          onCancelClick: () {
            flag = 2;
          },
          onConfirmClick: () async {
            Permission.storage.request();
            RHCache.setInt(cacheKey, 1);
            flag = 1;
          },
        );
        dialog.show();
        while (flag == 0) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
      return flag == 1;
    }
    return true;
  }


  static Future<bool> _checkPermission(
      String contentKey,
      String grantedContentKey,
      Permission permission,
      {bool isShow=true}
      ) async {
    final static = await permission.status;
    if (static != PermissionStatus.granted) {
      if (isShow) {
        RHDialog(
          content: contentKey,
          confirmKey: "OK",
          showCancel:true,
          onConfirmClick: () async {
            final status = await permission.request();
            if (status != PermissionStatus.granted) {
              AppSettings.openAppSettings();
            } else {
              permission.request();
            }
          },
        ).show();
      }
      return false;
    }
    return true;
  }


  static bool _isShow = false;
  static netErrorDialog({int delay = 0}) {
    if (_isShow) {
      return;
    }
    _isShow = true;
    Future.delayed(Duration(seconds: delay), () {
      RHDialog(
        titleKey: 'net_null',
        onConfirmClick: () {
          _isShow = false;
        },
      ).show();
    });
  }
}