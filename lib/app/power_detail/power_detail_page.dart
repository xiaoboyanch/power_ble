import 'package:cabina_ble/app/power_detail/power_detail_ctrl.dart';
import 'package:cabina_ble/app/power_detail/view/power_line_chart.dart';
import 'package:cabina_ble/app/power_detail/view/power_weight_chart.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../base_views/rh_colors.dart';

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
                      text: "L ${controller.powerModel.mPowerData.leftLength}cm",
                      fontSize: 18,
                      fontColor: RHColor.line_1,
                      fontWeight: 7,
                    ),
                    const Gap(10),
                    RHText(
                      text: "R ${controller.powerModel.mPowerData.rightLength}cm",
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
                      text: "L ${(controller.powerModel.mPowerData.realTimeLeft / 10).toStringAsFixed(1)}kg",
                      fontSize: 18,
                      fontColor: RHColor.line_1,
                      fontWeight: 7,
                    ),
                    const Gap(10),
                    RHText(
                      text: "R ${(controller.powerModel.mPowerData.realTimeRight / 10).toStringAsFixed(1)}kg",
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


    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Name'),
        backgroundColor: RHColor.primary,
        foregroundColor: Colors.white,
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
                      // text: controller.powerModel.mDevice!.platformName.isNotEmpty ? controller.powerModel.mDevice!.platformName : controller.powerModel.mDevice!.remoteId.str,
                      text: '',
                      fontSize: 18,
                      fontColor: RHColor.black,
                    )
                  ],
                ),
              ),
              const Gap(10),
              RHText(
                text: 'Used Motors',
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
                      bool check = value ?? false;
                      if (check) {
                        controller.motorType.value = 1;
                      }
                    }, child: RHText(text: 'Main', fontSize: 18, fontColor: RHColor.black,)),
                    CheckboxMenuButton(value: type == 2, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.motorType.value = 2;
                      }
                    }, child: RHText(text: 'Arm', fontSize: 18, fontColor: RHColor.black,)),
                    CheckboxMenuButton(value: type == 3, onChanged: (value) {
                      bool check = value ?? false;
                      if (check) {
                        controller.motorType.value = 3;
                      }
                    }, child: RHText(text: 'Leg', fontSize: 18, fontColor: RHColor.black,))
                  ],
                );
              }),

              const Gap(10),
              RHText(
                text: 'Machine Adjustment',
                fontSize: 20,
                fontWeight: 7,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: RHColor.black,
                margin: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Row(
                children: [
                  Obx(() {
                    double backDegree = controller.backDegree.value;
                    double seatDegree = controller.seatDegree.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            RHText(
                              text: "Back: ",
                              fontSize: 20,
                              fontColor: RHColor.black,
                            ),RHText(
                              text: "$backDegree Degree",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Slider(
                              value: backDegree,
                              min: 3,
                              max: 100,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              onChanged: (value) {
                                controller.backDegree.value = double.parse(value.toStringAsFixed(1));
                              }),
                        ),
                        Row(
                          children: [
                            RHText(
                              text: "Seat: ",
                              fontSize: 20,
                              fontColor: RHColor.black,
                            ),
                            RHText(
                              text: "$seatDegree Degree",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Slider(
                              value: seatDegree,
                              min: 3,
                              max: 90,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              onChanged: (value) {
                                controller.seatDegree.value = double.parse(value.toStringAsFixed(1));
                              }),
                        ),
                        Row(
                          children: [
                            RHText(
                              text: "Left Side Slider: ",
                              fontSize: 20,
                              fontColor: RHColor.black,
                            ),RHText(
                              text: "20cm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Slider(
                              value: 40,
                              min: 3,
                              max: 100,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              onChanged: (value) {
                                // controller.backDegree.value = double.parse(value.toStringAsFixed(1));
                              }),
                        ),
                        Row(
                          children: [
                            RHText(
                              text: "Right Side Slider: ",
                              fontSize: 20,
                              fontColor: RHColor.black,
                            ),RHText(
                              text: "40cm",
                              fontWeight: 7,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Slider(
                              value: 30,
                              min: 3,
                              max: 100,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              onChanged: (value) {
                                // controller.backDegree.value = double.parse(value.toStringAsFixed(1));
                              }),
                        ),
                      ],
                    );
                  }),
                  const Spacer(),
                  Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                        color: RHColor.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Center(
                        child: RHText(
                          text: "Setup",
                          fontColor: RHColor.white,
                          fontSize: 18,
                        ),
                      ),
                    )
                  )
                ],
              ),
              const Gap(10),
              RHText(
                text: 'Training Mode',
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
                int percent = controller.eccentricPer.value;
                return Column(
                  children: [
                    Row(
                      children: [
                        CheckboxMenuButton(value: mode == 1, onChanged: (value) {
                          bool check = value ?? false;
                          if (check) {
                            controller.trainingMode.value = 1;
                          }
                        }, child: RHText(text: 'Standard', fontSize: 18, fontColor: RHColor.black,)),
                        CheckboxMenuButton(value: mode == 2, onChanged: (value) {
                          bool check = value ?? false;
                          if (check) {
                            controller.trainingMode.value = 2;
                          }
                        }, child: RHText(text: 'Chain', fontSize: 18, fontColor: RHColor.black,)),
                        CheckboxMenuButton(value: mode == 3, onChanged: (value) {
                          bool check = value ?? false;
                          if (check) {
                            controller.trainingMode.value = 3;
                          }
                        }, child: RHText(text: 'Speed', fontSize: 18, fontColor: RHColor.black,))
                      ],
                    ),
                    Row(
                      children: [
                        CheckboxMenuButton(value: mode == 4, onChanged: (value) {
                          bool check = value ?? false;
                          if (check) {
                            controller.trainingMode.value = 4;
                          }
                        }, child: RHText(text: 'Eccentric', fontSize: 18, fontColor: RHColor.black,)),
                        Flexible(
                          child: Column(
                            children: [
                              RHText(text: "Eccentric Percent: $percent%", fontSize: 18, fontColor: RHColor.black,),
                              Slider(
                                  value: controller.eccentricPer.value.toDouble(),
                                  min: 3,
                                  max: 75,
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  onChanged: (value) {
                                    controller.eccentricPer.value = value.toInt();
                                  }),
                              RHText(text: "Only applicable to eccentric mode",fontWeight: 6,)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                );
              }),
              const Gap(10),
              RHText(
                text: 'Weight Settings',
                fontSize: 20,
                fontWeight: 7,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: RHColor.black,
                margin: EdgeInsets.only(top: 10, bottom: 15),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  size: 45,
                                  Icons.add_circle_outline_rounded,
                                  color: Colors.deepPurple
                                ),
                              ),
                              const Gap(15),
                              Obx(() {
                                int update = controller.listUpdate.value;
                                return RHText(
                                  text: "${(controller.powerModel.mPowerData.leftWeightOriginal / 10).toStringAsFixed(1)}kg",
                                  fontColor: RHColor.black,
                                  fontSize: 22,
                                );
                              }),
                              const Gap(15),
                              GestureDetector(
                                child: Icon(
                                    size: 45,
                                    Icons.remove_circle_outline_rounded,
                                    color: Colors.deepPurple
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(15),
                        Slider(
                            value: 20,
                            min: 3,
                            max: 75,
                            padding: EdgeInsets.only(left: 0, right: 0),
                            onChanged: (value) {

                            })
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                          color: RHColor.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Center(
                          child: RHText(
                            text: "Start",
                            fontColor: RHColor.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                  )
                ],
              ),
              const Gap(20),
              Obx(() {
                int update = controller.listUpdate.value;
                return Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RHText(
                          text: "Counts:",
                          fontColor: RHColor.black,
                          fontSize: 18,
                          fontWeight: 6,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RHText(
                              text: "Left: ${controller.powerModel.mPowerData.leftCount}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                            RHText(
                              text: "Right: ${controller.powerModel.mPowerData.rightCount}",
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
                          text: "Linear Velocity:",
                          fontColor: RHColor.black,
                          fontSize: 18,
                          fontWeight: 6,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RHText(
                              text: "Left: ${controller.powerModel.mPowerData.leftPower}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                            RHText(
                              text: "Right: ${controller.powerModel.mPowerData.rightPower}",
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
                          text: "RPM:",
                          fontColor: RHColor.black,
                          fontSize: 18,
                          fontWeight: 6,
                        ),
                        const Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RHText(
                              text: "Left: ${controller.powerModel.mPowerData.leftRPM}",
                              fontColor: RHColor.black,
                              fontSize: 18,
                            ),
                            RHText(
                              text: "Right: ${controller.powerModel.mPowerData.rightRPM}",
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
                        text: 'Motor Status',
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
                                  text: status == 1 ? 'Cmd log' : 'Waveform',
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