import 'dart:async';

import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/blue/ble_manager.dart';
import 'package:cabina_ble/blue/enum/device_type.dart';
import 'package:cabina_ble/blue/factory/ble_factory.dart';
import 'package:cabina_ble/blue/model/ota_model.dart';
import 'package:get/get.dart';

import '../../base_views/rh_toast.dart';
import '../../blue/entity/rh_blue_scan_result.dart';
import '../../blue/enum/ble_device_state_msg.dart';
import '../../route/rh_route.dart';

class OtaCtrl extends GetxController {
  RxInt flag = 0.obs;
  RxBool scanningFlag = false.obs;
  late OtaModel otaModel;
  List<RHBlueScanResult> bleResultList = [];
  StreamSubscription? scanningSubscription;
  StreamSubscription? _stream;
  @override
  void onInit() {
    super.onInit();
    otaModel = BleFactory.createModel(RHDeviceType.ota) as OtaModel;
    scanningSubscription = BleManager.instance.scanningStreamController.stream.listen((isScanning) {
      if (isScanning) {
        scanningFlag.value = true;
      } else {
        RHToast.dismiss();
        scanningFlag.value = false;
      }
    });
    _stream = otaModel.bleDeviceStateController.stream.listen((msg) {
      switch (msg) {
      //一切都准备好了
        case BleDeviceStateMsg.deviceScanResult: {
          RHToast.dismiss();
          bleResultList.clear();
          bleResultList.addAll(otaModel.bleResultList);
          flag.value++;
        }
        case BleDeviceStateMsg.deviceCheckSuccess: {
          Get.toNamed(RHRoute.otaDetailPage);
        }
        default:
          break;
      }
    });
  }

  btnStartScan() {
    if (scanningFlag.value) {
      BleManager.instance.stopScan();
    } else {
      otaModel.startScan();
    }
  }

  connectDevice(RHBlueScanResult rhBlueScanResult) {
    otaModel.isDispose = false;
    otaModel.selectDevice(rhBlueScanResult);
  }

  @override
  void onClose() {
    super.onClose();
    scanningSubscription?.cancel();
    _stream?.cancel();
    BleFactory.unregisterModel(RHDeviceType.ota);
  }
}