import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/blue/model/power_adv_model.dart';
import 'package:cabina_ble/blue/model/power_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../blue/entity/power_device_data.dart';
import '../../blue/enum/ble_device_data_msg.dart';
import '../../blue/enum/device_type.dart';
import '../../blue/factory/ble_factory.dart';

class PowerDetailCtrl extends GetxController {

  late PowerAdvancedModel powerModel;

  RxDouble backDegree = 20.0.obs;
  RxDouble seatDegree = 20.0.obs;
  RxInt motorType = 1.obs;
  RxInt trainingMode = 1.obs;
  RxInt eccentricPer = 20.obs;
  RxDouble powerWeight = 20.0.obs;
  RxInt statusType = 1.obs;

  RxInt listUpdate = 0.obs;
  List<double> leftWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> rightWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> leftRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> rightRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  TextEditingController backCtrl = TextEditingController();
  TextEditingController seatCtrl = TextEditingController();
  TextEditingController leftSideCtrl = TextEditingController();
  TextEditingController rightSideCtrl = TextEditingController();
  TextEditingController standardCtrl = TextEditingController();
  TextEditingController eccentricCtrl = TextEditingController();
  TextEditingController concernCtrl = TextEditingController();
  TextEditingController initialCtrl = TextEditingController();
  TextEditingController maxCtrl = TextEditingController();
  TextEditingController springCtrl = TextEditingController();
  TextEditingController velocityCtrl = TextEditingController();
  TextEditingController cableCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    powerModel = BleFactory.createModel(RHDeviceType.powerAdvanced) as PowerAdvancedModel;
    powerModel.bleDeviceStateController.stream.listen((msg) {

    });
    powerModel.bleDeviceDataController.stream.listen((msg) {
      switch (msg) {
        case BleDeviceDataMsg.dataQueryUpdate_0x04: {
          // onDataCallBack(powerModel.mPowerData);
        }
        case BleDeviceDataMsg.statusUpdate_0x02: {

        }
        default: {}
      }
    });
  }

  onDataCallBack(PowerDeviceData data) {
    leftRope.add(data.leftLength.toDouble());
    rightRope.add(data.rightLength.toDouble());
    if (leftRope.length > 150) {
      leftRope.removeAt(0);
      rightRope.removeAt(0);
    }
    leftWeight.add(data.realTimeLeft.toDouble());
    rightWeight.add(data.realTimeRight.toDouble());
    if (leftWeight.length > 80) {
      leftWeight.removeAt(0);
      rightWeight.removeAt(0);
    }
    // LogUtils.d("实时配重： ${data.realTimeLeft} : ${data.realTimeRight} : ${data.leftWeightOriginal}");
    listUpdate.value++;
  }

  @override
  void onClose() {
    super.onClose();
    powerModel.stopConnect();

  }
}