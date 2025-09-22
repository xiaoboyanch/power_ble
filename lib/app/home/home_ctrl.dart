import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:cabina_ble/blue/model/power_adv_model.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base_tool/log_utils.dart';
import '../../blue/ble_manager.dart';
import '../../blue/entity/rh_blue_scan_result.dart';
import '../../blue/enum/ble_device_state_msg.dart';
import '../../blue/enum/device_type.dart';
import '../../blue/factory/ble_factory.dart';
import '../../blue/model/power_model.dart';
import '../../route/rh_route.dart';

class HomeCtrl extends GetxController {
  RxInt flag = 0.obs;
  RxBool scanningFlag = false.obs;
  late PowerAdvancedModel powerModel;
  List<RHBlueScanResult> bleResultList = [];
  @override
  void onInit() {
    super.onInit();
    powerModel = BleFactory.createModel(RHDeviceType.powerAdvanced) as PowerAdvancedModel;
    BleManager.instance.scanningStreamController.stream.listen((isScanning) {
      if (isScanning) {
        scanningFlag.value = true;
      } else {
        RHToast.dismiss();
        scanningFlag.value = false;
      }
    });
    powerModel.bleDeviceStateController.stream.listen((msg) {
      switch (msg) {
      //一切都准备好了
        case BleDeviceStateMsg.deviceScanResult: {
          RHToast.dismiss();
          bleResultList.clear();
          bleResultList.addAll(powerModel.bleResultList);
          flag.value++;
        }
        case BleDeviceStateMsg.deviceCheckSuccess: {
          Get.toNamed(RHRoute.powerDetailPage);
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
      powerModel.startScan();
    }
  }

  connectDevice(RHBlueScanResult rhBlueScanResult) {
    powerModel.selectDevice(rhBlueScanResult);
  }
}