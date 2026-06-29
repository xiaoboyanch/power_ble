import 'dart:async';

import 'package:cabina_ble/blue/entity/power_device_data.dart';
import 'package:cabina_ble/blue/enum/device_type.dart';
import 'package:cabina_ble/blue/factory/ble_factory.dart';
import 'package:cabina_ble/blue/model/power_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../blue/enum/ble_device_data_msg.dart';

class TableDetailCtrl extends GetxController {

  late PowerModel powerModel;
  late PowerDeviceData powerData;
  TextEditingController protectWeightCtrl = TextEditingController();
  TextEditingController protectRopeCtrl = TextEditingController();
  TextEditingController protectTimeCtrl = TextEditingController();
  TextEditingController ropeBackCtrl = TextEditingController();

  StreamSubscription? stateStream;
  StreamSubscription? dataStream;

  RxInt updateFlag = 0.obs;

  @override
  void onInit() {
    super.onInit();
    powerModel = BleFactory.createModel(RHDeviceType.powerBoard) as PowerModel;

    powerData = powerModel.mPowerData;
    protectWeightCtrl.text = '0';
    protectRopeCtrl.text = '0';
    protectTimeCtrl.text = '0';
    ropeBackCtrl.text = '0';
    stateStream = powerModel.bleDeviceStateController.stream.listen((msg) {

    });
    dataStream = powerModel.bleDeviceDataController.stream.listen((msg) {
        switch (msg) {
          case BleDeviceDataMsg.dataQueryUpdate_0x06: {
            updateFlag.value++;
          }
          default:
        }
    });
    powerModel.getDeviceConfig();
  }


  setProtectState(int state) {
    powerModel.setDeviceConfig(protectState: state);
    powerModel.getDeviceConfig();
  }

  setRopeState(int state) {
    powerModel.setDeviceConfig(ropeState: state);
    powerModel.getDeviceConfig();
  }

  setProtectWeight() {
    int weight = int.parse(protectWeightCtrl.text) * 10;
    powerModel.setDeviceConfig(protectWeight: weight);
    powerModel.getDeviceConfig();
  }

  setProtectRope() {
    int rope = int.parse(protectRopeCtrl.text);
    powerModel.setDeviceConfig(protectRope: rope);
    powerModel.getDeviceConfig();
  }

  setProtectTime() {
    int time = int.parse(protectTimeCtrl.text) * 10;
    powerModel.setDeviceConfig(protectTime: time);
    powerModel.getDeviceConfig();
  }

  setRopeBackSpeed() {
    int speed = int.parse(ropeBackCtrl.text);
    powerModel.setDeviceConfig(ropeSpeed:  speed);
    powerModel.getDeviceConfig();
  }
}