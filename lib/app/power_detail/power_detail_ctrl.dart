import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
import 'package:cabina_ble/blue/enum/power_mode.dart';
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

  ///Motor type
  RxInt motorType = 1.obs;
  ///Training mode status
  RxInt trainingMode = 0.obs;
  ///Device is Start or Stop
  RxBool isStart = false.obs;
  ///Motor status
  RxInt statusType = 1.obs;
  ///Backrest and seat, including slide rail status
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
        case BleDeviceDataMsg.dataQueryUpdate_0x02: {
        }
        case BleDeviceDataMsg.dataQueryUpdate_0x10: {
          //device status include training mode, motor status,
          if (isStart.value != powerData.isStart) {
            isStart.value = powerData.isStart;
          }
          if (isStart.value) {
            if (powerData.curMotorGroup != 0 && motorType.value != powerData.curMotorGroup) {
              motorType.value = powerData.curMotorGroup;
            }
          }
        }
        case BleDeviceDataMsg.dateQueryUpdate_0x12: {
          //update backrest  seat  slider
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

  /// Start applying Power or releasing force
  startOrStopPower() {
    if (powerData.isStart) {
      //stop Power
      List<int> modeData = [00, 00, 00, 00, 00, 00];
      powerModel.setPowerMode(motorType.value, 2, powerData.curMode.value, modeData);
    }else {
      //start Power
      List<int> modeData = [];
      switch (PowerMode.fromInt(trainingMode.value)) {
        case PowerMode.standard: {
          //standard mode
          int power = int.parse(standardCtrl.text);
          modeData.add((power * 10)~/256);
          modeData.add((power * 10)%256);
          modeData.addAll([00,00,00,00]);
        }
        case PowerMode.eccentric: {
          //eccentric mode
          int eccentric = int.parse(eccentricCtrl.text);
          int concern = int.parse(concernCtrl.text);
          modeData.add((eccentric * 10)~/256);
          modeData.add((eccentric * 10)%256);
          modeData.add((concern * 10)~/256);
          modeData.add((concern * 10)%256);
          modeData.addAll([00,00]);
        }
        case PowerMode.elastic: {
          //elastic mode
          int initial = int.parse(initialCtrl.text);
          int max = int.parse(maxCtrl.text);
          int spring = int.parse(springCtrl.text);
          modeData.add((initial * 10)~/256);
          modeData.add((initial * 10)%256);
          modeData.add((max * 10)~/256);
          modeData.add((max * 10)%256);
          modeData.add((spring * 10)~/256);
          modeData.add((spring * 10)%256);
        }
        case PowerMode.isokinetic: {
          //isokinetic mode
          int velocity = int.parse(velocityCtrl.text);
          modeData.add((velocity * 10)~/256);
          modeData.add((velocity * 10)%256);
          modeData.addAll([00,00,00,00]);
        }
        case PowerMode.isometric: {
          //isometric mode
          int cable = int.parse(cableCtrl.text);
          modeData.add((cable * 10)~/256);
          modeData.add((cable * 10)%256);
          modeData.addAll([00,00,00,00]);
        }
      }
      powerModel.setPowerMode(motorType.value, 4, powerData.curMode.value, modeData);
    }
  }

  getModeParameter() {
    switch (PowerMode.fromInt(powerData.curMode.value)) {
      case PowerMode.standard: {
        //standard mode
        return "${"weight".tr}: ${powerData.modeStandardWeight} ${powerData.unitStr()}";
      }
      case PowerMode.eccentric: {
        //eccentric mode
        return "${"eccentric_force".tr}: ${powerData.modeEccentricForce} ${powerData.unitStr()} \n ${"concentric_force".tr}: ${powerData.modeConcentricForce} ${powerData.unitStr()}";
      }
      case PowerMode.elastic: {
        //elastic mode
        return "${"initial_force".tr}: ${powerData.modeInitialForce} ${powerData.unitStr()} \n ${"maximum_force".tr}: ${powerData.modeMaximumForce} ${powerData.unitStr()} \n ${"spring_length".tr}: ${powerData.modeSpringLength} mm";
      }
      case PowerMode.isokinetic: {
        //isokinetic mode
        return "${"linear_velocity".tr}: ${powerData.modeLinearVelocity} mm/s";
      }
      case PowerMode.isometric: {
        return "${"cable_length".tr}: ${powerData.modeCableLength} mm";
      }
    }
  }
}