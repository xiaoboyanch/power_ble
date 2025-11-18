import 'dart:async';
import 'dart:math';

import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
import 'package:cabina_ble/blue/enum/power_mode.dart';
import 'package:cabina_ble/blue/model/power_adv_model.dart';
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
  RxInt motorType = 0.obs;
  ///Training mode status
  RxInt trainingMode = 0.obs;
  ///Device is Start or Stop
  RxBool isStart = false.obs;
  ///Motor status
  RxInt statusType = 1.obs;
  ///Backrest and seat, including slide rail status
  RxInt backSeatStatus = 0.obs;
  ///Data update:
  RxInt paramUpdate = 0.obs;

  RxInt logUpdate = 0.obs;

  RxInt handlePress = 0.obs;

  List<double>  leftWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> rightWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double>  leftRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> rightRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> legWeight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> legRope = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
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

  Timer? logTimer;

  int minRPM = 0;
  int minVelocity = 0;
  int leftMinRPM = 0;
  int rightMinRPM = 0;
  int leftMinVelocity = 0;
  int rightMinVelocity = 0;

  @override
  void onInit() {
    super.onInit();
    powerModel = BleFactory.createModel(RHDeviceType.powerAdvanced) as PowerAdvancedModel;
    powerData = powerModel.mPowerData;
    standardCtrl.text = "5";
    eccentricCtrl.text = "8";
    concernCtrl.text = "5";
    initialCtrl.text = "5";
    maxCtrl.text = "10";
    springCtrl.text = "200";
    velocityCtrl.text = "200";
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
            // if (powerData.isStart) {
            //   // if (powerData.curMode != )
            // }
          }
          if (powerData.isStart) {
            powerModel.startParamTimer();
          }else {
            powerModel.stopParamTimer();
            cleanParamData();
          }
          if (isStart.value) {
            if (motorType.value != powerData.curMotorGroup) {
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
          onDataCallBack(powerData);
          if (motorType.value == 2) {
            if (powerData.legLinearVelocity < minVelocity) {
              minVelocity = powerData.legLinearVelocity;
            }
            if (powerData.legRPM < minRPM){
              minRPM = powerData.legRPM;
            }
          }else {
            if (powerData.curLeftRPM < leftMinRPM) {
              leftMinRPM = powerData.curLeftRPM;
            }
            if (powerData.curRightRPM < rightMinRPM){
              rightMinRPM = powerData.curRightRPM;
            }
            if (powerData.curLeftLinearVelocity < leftMinVelocity) {
              leftMinVelocity = powerData.curLeftLinearVelocity;
            }
            if (powerData.curRightLinearVelocity < rightMinVelocity){
              rightMinVelocity = powerData.curRightLinearVelocity;
            }
          }
          paramUpdate.value++;
        }
        case BleDeviceDataMsg.dataQueryUpdate_0x0B: {
          //update slider
          if (powerData.handlePress != 0) {
            startOrStopPower();
          }
          handlePress.value++;
        }
        default: {}
      }
    });
    startLogTimer();
  }

  cleanParamData() {
    powerData.curRightWeight = 0;
    powerData.curLeftWeight = 0;
    powerData.curLeftCount = 0;
    powerData.curRightCount = 0;
    powerData.curLeftCableLength = 0;
    powerData.curRightCableLength = 0;
    powerData.curRightLinearVelocity = 0;
    powerData.curLeftLinearVelocity = 0;
    powerData.curLeftRPM = 0;
    powerData.curRightRPM = 0;
    powerData.legWeight = 0;
    powerData.legCounts = 0;
    powerData.legCableLength = 0;
    powerData.legLinearVelocity = 0;
    powerData.legRPM = 0;
    paramUpdate.value++;
    minRPM = 0;
    minVelocity = 0;
    leftMinRPM = 0;
    rightMinRPM = 0;
    leftMinVelocity = 0;
    rightMinVelocity = 0;
  }

  startLogTimer() {
    logTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (statusType.value == 2) {
        logUpdate.value++;
      }
    });
  }

  onDataCallBack(PowerAdvancedData data) {
    if (motorType.value != 2) {
      leftRope.add(data.curLeftCableLength.toDouble());
      rightRope.add(data.curRightCableLength.toDouble());
      if (leftRope.length > 80) {
        leftRope.removeAt(0);
        rightRope.removeAt(0);
      }
      leftWeight.add(data.curLeftWeight.toDouble());
      rightWeight.add(data.curRightWeight.toDouble());
      if (leftWeight.length > 80) {
        leftWeight.removeAt(0);
        rightWeight.removeAt(0);
      }
    }else {
      legRope.add(data.legCableLength.toDouble());
      legWeight.add(data.legWeight.toDouble());
      if (legRope.length > 80) {
        legRope.removeAt(0);
      }
      if (legWeight.length > 80) {
        legWeight.removeAt(0);
      }
    }

    // LogUtils.d("实时配重： ${data.realTimeLeft} : ${data.realTimeRight} : ${data.leftWeightOriginal}");
  }

  @override
  void onClose() {
    super.onClose();
    powerModel.stopConnect();
    logTimer?.cancel();
    logTimer = null;
  }

  getUnitStr() {
    return powerData.unit == 0 ? "KG" : "LB";
  }

  setBackSeatDegree() {
    int back = int.parse(backCtrl.text);
    int seat = int.parse(seatCtrl.text);
    if (seat >= powerData.seatMinDegree && seat <= powerData.seatMaxDegree && back >= powerData.backMinDegree && back <= powerData.backMaxDegree) {
      powerModel.setBackSeatDegree(back, seat);
    }else {
      RHToast.showToast(msg: "The degree is out of range");
    }
  }


  /// Start applying Power or releasing force
  startOrStopPower() {
    if (powerData.isStart) {
      //stop Power
      // List<int> modeData = [00, 32, 00, 00, 00, 00];
      List<int> modeData = [];
      switch (PowerMode.fromInt(trainingMode.value)) {
        case PowerMode.standard: {
          //standard mode
          int power = int.parse(standardCtrl.text);
          if (power <= 0) {
            RHToast.showToast(msg: "Power must be greater than 0");
            return;
          }
          modeData.add((power * 10)~/256);
          modeData.add((power * 10)%256);
          modeData.addAll([00,00,00,00]);
        }
        case PowerMode.eccentric: {
          //eccentric mode
          int eccentric = int.parse(eccentricCtrl.text);
          int concern = int.parse(concernCtrl.text);
          if (eccentric <= 0 || concern <= 0) {
            RHToast.showToast(msg: "Eccentric and concern must be greater than 0");
            return;
          }
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
          if (initial <= 0 || max <= 0 || spring <= 0) {
            RHToast.showToast(msg: "Initial, max and spring must be greater than 0");
            return;
          }
          modeData.add((initial * 10)~/256);
          modeData.add((initial * 10)%256);
          modeData.add((max * 10)~/256);
          modeData.add((max * 10)%256);
          modeData.add((spring)~/256);
          modeData.add((spring)%256);
        }
        case PowerMode.isokinetic: {
          //isokinetic mode
          int velocity = int.parse(velocityCtrl.text);
          if (velocity <= 0) {
            RHToast.showToast(msg: "Velocity must be greater than 0");
            return;
          }
          modeData.add((velocity)~/256);
          modeData.add((velocity)%256);
          modeData.addAll([00,00,00,00]);
        }
        case PowerMode.isometric: {
          //isometric mode
          int cable = int.parse(cableCtrl.text);
          if (cable <= 0) {
            RHToast.showToast(msg: "Cable must be greater than 0");
            return;
          }
          modeData.add((cable)~/256);
          modeData.add((cable)%256);
          modeData.addAll([00,00,00,00]);
        }
      }
      powerModel.setPowerMode(motorType.value, 0, powerData.curMode.value, modeData);
    }else {
      //start Power
      List<int> modeData = [];
      switch (PowerMode.fromInt(trainingMode.value)) {
        case PowerMode.standard: {
          //standard mode
          int power = int.parse(standardCtrl.text);
          if (power <= 0) {
            RHToast.showToast(msg: "Power must be greater than 0");
            return;
          }
          modeData.add((power * 10)~/256);
          modeData.add((power * 10)%256);
          modeData.addAll([00,00,00,00]);
        }
        case PowerMode.eccentric: {
          //eccentric mode
          int eccentric = int.parse(eccentricCtrl.text);
          int concern = int.parse(concernCtrl.text);
          if (eccentric <= 0 || concern <= 0) {
            RHToast.showToast(msg: "Eccentric and concern must be greater than 0");
            return;
          }
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
          if (initial <= 0 || max <= 0 || spring <= 0) {
            RHToast.showToast(msg: "Initial, max and spring must be greater than 0");
            return;
          }
          modeData.add((initial * 10)~/256);
          modeData.add((initial * 10)%256);
          modeData.add((max * 10)~/256);
          modeData.add((max * 10)%256);
          modeData.add((spring)~/256);
          modeData.add((spring)%256);
        }
        case PowerMode.isokinetic: {
          //isokinetic mode
          int velocity = int.parse(velocityCtrl.text);
          if (velocity <= 0) {
            RHToast.showToast(msg: "Velocity must be greater than 0");
            return;
          }
          modeData.add((velocity)~/256);
          modeData.add((velocity)%256);
          modeData.addAll([00,00,00,00]);
        }
        case PowerMode.isometric: {
          //isometric mode
          int cable = int.parse(cableCtrl.text);
          if (cable <= 0) {
            RHToast.showToast(msg: "Cable must be greater than 0");
            return;
          }
          modeData.add((cable)~/256);
          modeData.add((cable)%256);
          modeData.addAll([00,00,00,00]);
        }
      }
      powerModel.setPowerMode(motorType.value, 1, trainingMode.value, modeData);
    }
  }

  getModeParameter() {
    switch (PowerMode.fromInt(powerData.curMode.value)) {
      case PowerMode.standard: {
        //standard mode
        return "${"weight".tr}: ${(powerData.modeStandardWeight/ 10).toStringAsFixed(1)} ${powerData.unitStr()}";
      }
      case PowerMode.eccentric: {
        //eccentric mode
        return "${"eccentric_force".tr}: ${(powerData.modeEccentricForce/ 10).toStringAsFixed(1)} ${powerData.unitStr()} \n ${"concentric_force".tr}: ${(powerData.modeConcentricForce/ 10).toStringAsFixed(1)} ${powerData.unitStr()} ";
      }
      case PowerMode.elastic: {
        //elastic mode
        return "${"initial_force".tr}: ${(powerData.modeInitialForce/ 10).toStringAsFixed(1)}${powerData.unitStr()} \n ${"maximum_force".tr}: ${(powerData.modeMaximumForce/ 10).toStringAsFixed(1)}${powerData.unitStr()}  \n ${"spring_length".tr}: ${powerData.modeSpringLength} mm";
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