import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:cabina_ble/blue/commands/power_commands.dart';
import 'package:cabina_ble/blue/model/power_adv_model.dart';
import 'package:cabina_ble/blue/tools/tools.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base_tool/log_utils.dart';
import '../../blue/ble_manager.dart';
import '../../blue/entity/rh_blue_scan_result.dart';
import '../../blue/enum/ble_device_state_msg.dart';
import '../../blue/enum/device_type.dart';
import '../../blue/factory/ble_factory.dart';
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
    // Future.delayed(Duration(milliseconds: 500), () {
    //   powerModel.startScan();
    // });
    LogUtils.d("03: ${Tools.getNiceHexArray(PowerCommands.getMainInfo_03Data())}");
    LogUtils.d("1: ${Tools.getNiceHexArray(PowerCommands.getDeviceStatus())}");
    LogUtils.d("2: ${Tools.getNiceHexArray(PowerCommands.getMotorData(2))}");
    LogUtils.d("2: ${Tools.getNiceHexArray(PowerCommands.getHandle())}");
    List<int> modeData = [];
    int power = 30;
    // modeData.add((power * 10)~/256);
    // modeData.add((power * 10)%256);
    // modeData.addAll([00,00,00,00]);

    int eccentric = 20;
    int concern = 25;
    modeData.add((eccentric * 10)~/256);
    modeData.add((eccentric * 10)%256);
    modeData.add((concern * 10)~/256);
    modeData.add((concern * 10)%256);
    modeData.addAll([00,00]);
    ;
    // LogUtils.d("40kg: ${Tools.getNiceHexArray(PowerCommands.setPowerMode(0, 1, 1, modeData))}");
    LogUtils.d("40kg: ${Tools.getNiceHexArray(PowerCommands.setPowerMode(0, 1, 1, modeData))}");
    LogUtils.d("key: ${Tools.getNiceHexArray(PowerCommands.pushHandle(1))}");
    // LogUtils.d("3: ${Tools.getNiceHexArray(PowerCommands.setBackSeat(30, 5))}");
    // LogUtils.d("4: ${Tools.getNiceHexArray(PowerCommands.getDeviceConfig(true))}");
    // LogUtils.d("4: ${Tools.getNiceHexArray(PowerCommands.getDeviceConfig(false))}");
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