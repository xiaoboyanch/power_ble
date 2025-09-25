import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
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
  late PowerAdvancedData powerData;

  RxInt motorType = 1.obs;
  RxInt trainingMode = 0.obs;
  RxInt eccentricPer = 20.obs;
  RxDouble powerWeight = 20.0.obs;
  RxInt statusType = 1.obs;
  RxInt backSeatStatus = 0.obs;

  RxInt listUpdate = 0.obs;
  List<double>  leftWeight = [220, 330, 380, 330, 220, 110, 180, 260, 330, 330,];
  List<double> rightWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0,];
  List<double>  leftRope = [490, 300, 120, 433, 400, 200, 600, 340, 440, 230, ];
  List<double> rightRope = [122, 100, 230, 170, 400, 500, 600, 300, 800, 500, ];
  // List<double> leftWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  // List<double> rightWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  // List<double> leftRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  // List<double> rightRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  //backrest seat
  TextEditingController backCtrl = TextEditingController();
  TextEditingController seatCtrl = TextEditingController();

  //side slider
  TextEditingController leftSideCtrl = TextEditingController();
  TextEditingController rightSideCtrl = TextEditingController();
  //standard mode
  TextEditingController standardCtrl = TextEditingController();
  //eccentric mode
  TextEditingController eccentricCtrl = TextEditingController();
  TextEditingController concernCtrl = TextEditingController();
  //elastic mode
  TextEditingController initialCtrl = TextEditingController();
  TextEditingController maxCtrl = TextEditingController();
  TextEditingController springCtrl = TextEditingController();
  //isokinetic mode
  TextEditingController velocityCtrl = TextEditingController();
  //isometric mode
  TextEditingController cableCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    powerModel = BleFactory.createModel(RHDeviceType.powerAdvanced) as PowerAdvancedModel;
    powerData = powerModel.mPowerData;
    powerModel.bleDeviceStateController.stream.listen((msg) {

    });
    powerModel.bleDeviceDataController.stream.listen((msg) {
      switch (msg) {
        case BleDeviceDataMsg.statusUpdate_0x02: {

        }
        case BleDeviceDataMsg.dataQueryUpdate_0x10: {
          //status mode
        }
        case BleDeviceDataMsg.dateQueryUpdate_0x12: {
          //update backrest  seat
          backSeatStatus.value++;
        }
        case BleDeviceDataMsg.dataQueryUpdate_0x14: {
          // power data
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

  getUnitStr() {
    return powerData.unit == 0 ? "KG" : "LB";
  }

  setBackSeatDegree() {
    int back = int.parse(backCtrl.text);
    int seat = int.parse(seatCtrl.text);
    if (back >= 0 && back <= 255 && seat >= 0 && seat <= 255) {
      powerModel.setBackSeatDegree(back, seat);
    }
  }

  setSideSlider() {
    int left = int.parse(leftSideCtrl.text);
    int right = int.parse(rightSideCtrl.text);
    powerModel.setSideSlider(left * 10, right * 10);
  }
}