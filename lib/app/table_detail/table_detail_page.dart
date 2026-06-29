import 'package:cabina_ble/app/power/power_ctrl.dart';
import 'package:cabina_ble/app/table_detail/table_detail_ctrl.dart';
import 'package:cabina_ble/base_views/rh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../base_views/rh_colors.dart';
import '../../base_views/rh_text.dart';
import '../../base_views/rh_text_input.dart';

class TableDetailPage extends GetView<TableDetailCtrl> {

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.powerModel.mDevice == null? 'ble_name'.tr : controller.powerModel.mDevice!.platformName),
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
                      text: controller.powerModel.mDevice == null? '' : controller.powerModel.mDevice!.remoteId.str,
                      fontSize: 18,
                      fontColor: RHColor.black,
                    )
                  ],
                ),
              ),
              const Gap(10),
              Obx(() {
                int flag = controller.updateFlag.value;
                return Column(
                  children: [
                    RHText(
                      text: "安全保护重量: ${(controller.powerData.protectWeight / 10).toStringAsFixed(1)} KG",
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    const Gap(5),
                    RHText(
                      text: "安全保护绳长: ${controller.powerData.protectRopeLength} mm",
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    const Gap(5),
                    RHText(
                      text: "安全保护时间: ${(controller.powerData.protectTime / 10).toStringAsFixed(1)} S",
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    const Gap(5),
                    RHText(
                      text: "脱手回绳速度: ${controller.powerData.ropeBackSpeed} mm/s",
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        RHText(
                          text: "安全保护: ",
                          fontSize: 16,
                          fontColor: RHColor.black,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.setProtectState(1);
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: controller.powerData.protectState == 1 ? RHColor.primary : RHColor.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  text: "开启",
                                  fontColor: RHColor.black,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                        const Gap(30),
                        GestureDetector(
                          onTap: () {
                            controller.setProtectState(0);
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: controller.powerData.protectState == 0 ? RHColor.primary : RHColor.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  text: "关闭",
                                  fontColor: RHColor.black,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                        const Gap(30),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        RHText(
                          text: "脱手开关: ",
                          fontSize: 16,
                          fontColor: RHColor.black,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.setRopeState(1);
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: controller.powerData.ropeBackState == 1 ? RHColor.primary : RHColor.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  text: "开启",
                                  fontColor: RHColor.black,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                        const Gap(30),
                        GestureDetector(
                          onTap: () {
                            controller.setRopeState(0);
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: controller.powerData.ropeBackState == 0 ? RHColor.primary : RHColor.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  text: "关闭",
                                  fontColor: RHColor.black,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                        const Gap(30),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        RHText(
                          text: "安全保护重量",
                          fontSize: 16,
                          fontColor: RHColor.black,
                        ),
                        const Spacer(),
                        RHTextInput(
                          text: controller.protectWeightCtrl.text,
                          textCtrl: controller.protectWeightCtrl,
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
                          text: 'KG',
                          fontWeight: 7,
                          fontSize: 18,
                        ),
                        const Gap(42),
                        GestureDetector(
                          onTap: () {
                            controller.setProtectWeight();
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: RHColor.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  textKey: "setup",
                                  fontColor: RHColor.white,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        RHText(
                          text: "安全保护绳长",
                          fontSize: 16,
                          fontColor: RHColor.black,
                        ),
                        const Spacer(),
                        RHTextInput(
                          text: controller.protectRopeCtrl.text,
                          textCtrl: controller.protectRopeCtrl,
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
                          textKey: "mm",
                          fontWeight: 7,
                          fontSize: 18,
                        ),
                        const Gap(42),
                        GestureDetector(
                          onTap: () {
                            controller.setProtectRope();
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: RHColor.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  textKey: "setup",
                                  fontColor: RHColor.white,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        RHText(
                          text: "自动卸力时间",
                          fontSize: 16,
                          fontColor: RHColor.black,
                        ),
                        const Spacer(),
                        RHTextInput(
                          text: controller.protectTimeCtrl.text,
                          textCtrl: controller.protectTimeCtrl,
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
                          textKey: "秒",
                          fontWeight: 7,
                          fontSize: 18,
                        ),
                        const Gap(42),
                        GestureDetector(
                          onTap: () {
                            controller.setProtectTime();
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: RHColor.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  textKey: "setup",
                                  fontColor: RHColor.white,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        RHText(
                          text: "回绳速度",
                          fontSize: 16,
                          fontColor: RHColor.black,
                        ),
                        const Spacer(),
                        RHTextInput(
                          text: controller.ropeBackCtrl.text,
                          textCtrl: controller.ropeBackCtrl,
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
                        const Gap(10),
                        GestureDetector(
                          onTap: () {
                            controller.setRopeBackSpeed();
                          },
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: RHColor.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: RHText(
                                  textKey: "setup",
                                  fontColor: RHColor.white,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    RHButton(
                      width: 100,
                      textKey: "查询",
                      onTap: () {
                        controller.powerModel.getDeviceConfig();
                      },
                    )
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }

}