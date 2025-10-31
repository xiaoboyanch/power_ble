import 'package:cabina_ble/app/power_detail/power_detail_ctrl.dart';
import 'package:cabina_ble/app/power_detail/view/message_dialog.dart';
import 'package:cabina_ble/app/power_detail/view/power_line_chart.dart';
import 'package:cabina_ble/app/power_detail/view/power_weight_chart.dart';
import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:cabina_ble/base_views/rh_text_input.dart';
import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../base_views/rh_colors.dart';
import '../../blue/entity/power_advanced_data.dart';

class PowerDetailPage extends GetView<PowerDetailCtrl> {
  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).padding.bottom;
    Widget lineChart() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RHText(
            text: "Cable Position",
            fontSize: 18,
            fontColor: RHColor.black,
          ),
          Obx(() {
            int flag = controller.listUpdate.value;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  height: 100,
                  child: PowerLineChart(list1: controller.leftRope, list2: controller.rightRope,),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RHText(
                      text: "L ${controller.powerModel.mPowerData.curLeftCableLength}mm",
                      fontSize: 18,
                      fontColor: RHColor.line_1,
                      fontWeight: 7,
                    ),
                    const Gap(10),
                    RHText(
                      text: "R ${controller.powerModel.mPowerData.curRightCableLength}mm",
                      fontSize: 18,
                      fontColor: RHColor.line_2,
                      fontWeight: 7,
                    ),
                  ],
                )
              ],
            );
          }),
          const Gap(20),
          RHText(
            text: "Strength Measurement",
            fontSize: 18,
            fontColor: RHColor.black,
          ),
          Obx(() {
            int flag = controller.listUpdate.value;
            return Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  height: 100,
                  child: PowerWeightChart(list1: controller.leftWeight, list2: controller.rightWeight),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RHText(
                      // text: "L ${(controller.powerModel.mPowerData.realTimeLeft / 10).toStringAsFixed(1)}kg",
                      text: "L 0${controller.getUnitStr()}",
                      fontSize: 18,
                      fontColor: RHColor.line_1,
                      fontWeight: 7,
                    ),
                    const Gap(10),
                    RHText(
                      // text: "R ${(controller.powerModel.mPowerData.realTimeRight / 10).toStringAsFixed(1)}kg",
                      text: "R 0${controller.getUnitStr()}",
                      fontSize: 18,
                      fontColor: RHColor.line_2,
                      fontWeight: 7,
                    ),
                  ],
                )
              ],
            );
          }),
        ],
      );
    }


    Widget cmdLog() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: RHColor.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RHText(text: "--> This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod testThis is cmd lod testThis is cmd lod testThis is cmd lod testThis is cmd lod testThis is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test： ", fontColor: RHColor.line_2, fontSize: 18),
                RHText(text: "-->This is cmd lod test： ", fontColor: RHColor.line_1, fontSize: 18),
                RHText(text: "<--This is cmd lod test1  ", fontColor: RHColor.line_2, fontSize: 18)
              ],
            ),
          ),
        ),
      );
    }

    final PowerAdvancedData powerAdvancedData = PowerAdvancedData();
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.powerModel.mDevice == null? 'ble_name'.tr : controller.powerModel.mDevice!.platformName),
        backgroundColor: RHColor.primary,
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: IconButton(onPressed: () {
              MessageDialog.showMessageDialog(context, powerAdvancedData);
            }, icon: Icon(Icons.message_outlined)),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    RHText(
                      text: 'mac_address'.tr,
                      fontSize: 18,
                      fontWeight: 5,
                    ),
                    RHText(
                      text: controller.powerModel.mDevice == null? 'ble_name'.tr : controller.powerModel.mDevice!.remoteId.str,
                      fontSize: 18,
                      fontColor: RHColor.black,
                    )
                  ],
                ),
              ),
              const Gap(10),
              RHText(
                textKey: 'used_motors',
                fontSize: 20,
                fontWeight: 7,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: RHColor.black,
                margin: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Obx(() {
                int type = controller.motorType.value;
                return Row(
                  children: [
                    CheckboxMenuButton(value: type == 1, onChanged: (value) {
                      if (controller.powerData.isStart) {
                        RHToast.showToast(msg: "setting_before_tips");
                        return;
                      }
                      bool check = value ?? false;
                      if (check) {
                        controller.motorType.value = 1;
                      }
                    }, child: RHText(textKey: 'main', fontSize: 18, fontColor: RHColor.black,)),
                    CheckboxMenuButton(value: type == 2, onChanged: (value) {
                      if (controller.powerData.isStart) {
                        RHToast.showToast(msg: "setting_before_tips");
                        return;
                      }
                      bool check = value ?? false;
                      if (check) {
                        controller.motorType.value = 2;
                      }
                    }, child: RHText(textKey: 'arm', fontSize: 18, fontColor: RHColor.black,)),
                    CheckboxMenuButton(value: type == 3, onChanged: (value) {
                      if (controller.powerData.isStart) {
                        RHToast.showToast(msg: "setting_before_tips");
                        return;
                      }
                      bool check = value ?? false;
                      if (check) {
                        controller.motorType.value = 3;
                      }
                    }, child: RHText(textKey: 'leg', fontSize: 18, fontColor: RHColor.black,))
                  ],
                );
              }),

              const Gap(10),
              RHText(
                textKey: 'machine_adjustment',
                fontSize: 20,
                fontWeight: 7,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: RHColor.black,
                margin: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Obx(() {
                int type = controller.backSeatStatus.value;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            RHText(
                              textKey: "back",
                              fontSize: 16,
                              fontColor: RHColor.black,
                            ),
                            RHText(
                              text: "${controller.powerData.curBackDegree} Degree",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            RHText(
                              textKey: "seat",
                              fontSize: 16,
                              fontColor: RHColor.black,
                            ),
                            RHText(
                              text: "${controller.powerData.curSeakDegree} Degree",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            RHText(
                              textKey: "left_slider",
                              fontSize: 16,
                              fontColor: RHColor.black,
                              textAlign: TextAlign.center,
                            ),
                            RHText(
                              text: "${controller.powerData.curLeftSlider} mm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            RHText(
                              textKey: "right_slider",
                              fontSize: 16,
                              fontColor: RHColor.black,
                              textAlign: TextAlign.center,
                            ),
                            RHText(
                              text: "${controller.powerData.curRightSlider} mm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const Gap(15),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            RHText(
                              textKey: "back",
                              fontSize: 16,
                              fontColor: RHColor.black,
                            ),
                            const Spacer(),
                            RHTextInput(
                              text: controller.backCtrl.text,
                              textCtrl: controller.backCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: " Degree",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            RHText(
                              textKey: "seat",
                              fontSize: 16,
                              fontColor: RHColor.black,
                            ),
                            const Spacer(),
                            RHTextInput(
                              text: controller.seatCtrl.text,
                              textCtrl: controller.seatCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: " Degree",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            RHText(
                              textKey: "left_slider",
                              fontSize: 16,
                              fontColor: RHColor.black,
                            ),
                            const Spacer(),
                            RHTextInput(
                              text: controller.leftSideCtrl.text,
                              textCtrl: controller.leftSideCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: "cm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const  Gap(35),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            RHText(
                              textKey: "right_slider",
                              fontSize: 16,
                              fontColor: RHColor.black,
                            ),
                            const Spacer(),
                            RHTextInput(
                              text: controller.rightSideCtrl.text,
                              textCtrl: controller.rightSideCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: "cm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const  Gap(35),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                            color: RHColor.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            controller.setBackSeatDegree();
                          },
                          child: Center(
                            child: RHText(
                              textKey: "setup",
                              fontColor: RHColor.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ),
                      const Gap(60),
                      Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                              color: RHColor.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: GestureDetector(
                            onTap: () {
                              controller.setSideSlider();
                            },
                            child: Center(
                              child: RHText(
                                textKey: "setup",
                                fontColor: RHColor.white,
                                fontSize: 16,
                              ),
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
              const Gap(10),
              RHText(
                textKey: 'training_mode',
                fontSize: 20,
                fontWeight: 7,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: RHColor.black,
                margin: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Obx(() {
                int mode = controller.trainingMode.value;
                return Column(
                  children: [
                    RHText(
                      text: '${"current_mode".tr} ${"standard_mode".tr}',
                      fontSize: 18,
                      fontWeight: 6,
                    ),
                    const Gap(5),
                    RHText(
                      text: '${"Weight".tr}: 20kg',
                      fontSize: 16,
                      fontWeight: 6,
                      textAlign: TextAlign.center,
                    ),
                    CheckboxMenuButton(value: mode == 0, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.trainingMode.value = 0;
                      }
                    }, child: RHText(textKey: 'standard_mode', fontSize: 18, fontColor: RHColor.black,)),
                    if (mode == 0)
                    Row(
                      children: [
                        const Gap(40),
                        RHText(text: '${"Weight".tr}：', fontSize: 18, fontColor: RHColor.black,),
                        const Spacer(),
                        RHTextInput(
                          text: controller.standardCtrl.text,
                          textCtrl: controller.standardCtrl,
                          width: 80,
                          height: 40,
                          isPassword: false,
                          isPhone: true,
                          radius: 10,
                          backColor: RHColor.greyF0,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                        RHText(
                          text: controller.getUnitStr(),
                          fontWeight: 7,
                          fontSize: 18,
                        ),
                        const Gap(20),
                      ],
                    ),
                    CheckboxMenuButton(value: mode == 1, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.trainingMode.value = 1;
                      }
                    }, child: RHText(textKey: 'eccentric_mode', fontSize: 18, fontColor: RHColor.black,)),
                    if (mode == 1)
                    Column(
                      children: [
                        Row(
                          children: [
                            const Gap(40),
                            RHText(textKey: 'eccentric_force', fontSize: 18, fontColor: RHColor.black,),
                            const Spacer(),
                            RHTextInput(
                              text: controller.eccentricCtrl.text,
                              textCtrl: controller.eccentricCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: controller.getUnitStr(),
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const Gap(20),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            const Gap(40),
                            RHText(textKey: 'concentric_force', fontSize: 18, fontColor: RHColor.black,),
                            const Spacer(),
                            RHTextInput(
                              text: controller.concernCtrl.text,
                              textCtrl: controller.concernCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: controller.getUnitStr(),
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const Gap(20),
                          ],
                        ),
                      ],
                    ),

                    CheckboxMenuButton(value: mode == 2, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.trainingMode.value = 2;
                      }
                    }, child: RHText(textKey: 'elastic_mode', fontSize: 18, fontColor: RHColor.black,)),
                    if (mode == 2)
                    Column(
                      children: [
                        Row(
                          children: [
                            const Gap(40),
                            RHText(textKey: 'initial_force', fontSize: 18, fontColor: RHColor.black,),
                            const Spacer(),
                            RHTextInput(
                              text: controller.initialCtrl.text,
                              textCtrl: controller.initialCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: controller.getUnitStr(),
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const Gap(20),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            const Gap(40),
                            RHText(textKey: 'maximum_force', fontSize: 18, fontColor: RHColor.black,),
                            const Spacer(),
                            RHTextInput(
                              text: controller.maxCtrl.text,
                              textCtrl: controller.maxCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: controller.getUnitStr(),
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const Gap(20),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            const Gap(40),
                            RHText(textKey: 'spring_length', fontSize: 18, fontColor: RHColor.black,),
                            const Spacer(),
                            RHTextInput(
                              text: controller.springCtrl.text,
                              textCtrl: controller.springCtrl,
                              width: 80,
                              height: 40,
                              isPassword: false,
                              isPhone: true,
                              radius: 10,
                              backColor: RHColor.greyF0,
                              onChange: (ctrl, value) {
                                return null;
                              },
                            ),
                            RHText(
                              text: "mm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                            const Gap(20),
                          ],
                        ),
                      ],
                    ),
                    CheckboxMenuButton(value: mode == 3, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.trainingMode.value = 3;
                      }
                    }, child: RHText(textKey: 'strength_measurement', fontSize: 18, fontColor: RHColor.black,)),
                    if (mode == 3)
                    Row(
                      children: [
                        const Gap(40),
                        RHText(textKey: 'linear_velocity', fontSize: 18, fontColor: RHColor.black,),
                        const Spacer(),
                        RHTextInput(
                          text: controller.velocityCtrl.text,
                          textCtrl: controller.velocityCtrl,
                          width: 80,
                          height: 40,
                          isPassword: false,
                          isPhone: true,
                          radius: 10,
                          backColor: RHColor.greyF0,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                        RHText(
                          text: "mm/s",
                          fontWeight: 7,
                          fontSize: 18,
                        ),
                        const Gap(20),
                      ],
                    ),
                    CheckboxMenuButton(value: mode == 4, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.trainingMode.value = 4;
                      }
                    }, child: RHText(textKey: 'isometric_mode', fontSize: 18, fontColor: RHColor.black,)),
                    if (mode == 4)
                    Row(
                      children: [
                        const Gap(40),
                        RHText(textKey: 'cable_length', fontSize: 18, fontColor: RHColor.black,),
                        const Spacer(),
                        RHTextInput(
                          text: controller.cableCtrl.text,
                          textCtrl: controller.cableCtrl,
                          width: 80,
                          height: 40,
                          isPassword: false,
                          isPhone: true,
                          radius: 10,
                          backColor: RHColor.greyF0,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                        RHText(
                          text: "mm",
                          fontWeight: 7,
                          fontSize: 18,
                        ),
                        const Gap(20),
                      ],
                    ),
                  ],
                );
              }),
              const Gap(20),
              Obx(() {
                bool isStart = controller.isStart.value;
                return Center(
                  child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                          color: RHColor.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: GestureDetector(
                        onTap: () {
                          controller.startOrStopForce();
                        },
                        child: Center(
                          child: RHText(
                            textKey: isStart? "stop" : "start",
                            fontColor: RHColor.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                  ),
                );
              }),
              const Gap(20),
              Obx(() {
                int update = controller.listUpdate.value;
                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RHText(
                          textKey: "counts",
                          fontColor: RHColor.black,
                          fontSize: 18,
                          fontWeight: 6,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RHText(
                              text: "${"left".tr}: ${controller.powerModel.mPowerData.curLeftCount}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                            RHText(
                              text: "${"right".tr}: ${controller.powerModel.mPowerData.curRightCount}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RHText(
                          textKey: "linear_velocity",
                          fontColor: RHColor.black,
                          fontSize: 18,
                          fontWeight: 6,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RHText(
                              text: "${"left".tr}: ${controller.powerModel.mPowerData.curLeftLinearVelocity}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                            RHText(
                              text: "${"right".tr}: ${controller.powerModel.mPowerData.curRightLinearVelocity}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RHText(
                          textKey: "rpm",
                          fontColor: RHColor.black,
                          fontSize: 18,
                          fontWeight: 6,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RHText(
                              text: "${"left".tr}: ${controller.powerModel.mPowerData.curLeftRPM}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                            RHText(
                              text: "${"right".tr}:  ${controller.powerModel.mPowerData.curRightRPM}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const Gap(10),
              Obx(() {
                  int status = controller.statusType.value;
                  return Row(
                    children: [
                      RHText(
                        textKey: 'motor_status',
                        fontSize: 20,
                        fontWeight: 7,
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: () {
                          controller.statusType.value = status == 1 ? 2 : 1;
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: RHColor.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                RHText(
                                  textKey: status == 1 ? 'cmd_log' : 'waveform',
                                  fontSize: 18,
                                  fontColor: RHColor.black,
                                ),
                                Icon(
                                  status == 1 ?Icons.keyboard_double_arrow_right : Icons.keyboard_double_arrow_left,
                                  size: 25,
                                )
                              ],
                            )
                        ),
                      ),
                      if (status == 2)
                        const Gap(10),
                    ],
                  );
                }
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: RHColor.black,
                margin: EdgeInsets.only(top: 10, bottom: 15),
              ),
              // Obx(() {
              Obx(() {
                int status = controller.statusType.value;
                return status == 1 ? lineChart() : cmdLog();
              }),

              // });
              Gap(bottom + 20),
            ],
          ),
        ),
      ),
    );
  }


}