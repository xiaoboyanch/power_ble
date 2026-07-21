import 'package:cabina_ble/base_tool/log_utils.dart';
import 'package:cabina_ble/base_views/rh_button.dart';
import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../base_views/rh_text_input.dart';
import 'ota_detail_ctrl.dart';

class OtaDetailPage extends GetView<OtaDetailCtrl> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('OTA Update'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RHButton(
                    width: 120,
                    height: 35,
                    textKey: '更改音乐蓝牙名',
                    onTap: () {
                      controller.setMusicName('OMNIX1 Music');
                    },
                  ),
                  const Gap(10),
                  RHButton(
                    width: 120,
                    height: 35,
                    textKey: '重启蓝牙',
                    onTap: () {
                      controller.rebootBle();
                    },
                  ),
                ],
              ),
              const Gap(10),
              Obx(() {
                controller.msgFlag.value;
                LogUtils.d("AAAAAA : ${controller.showName}");
                return Column(
                  children: [
                    Row(
                      children: [
                        RHText(
                          text: '当前更新芯片号： ${controller.chipNumber.toRadixString(16).toUpperCase()}',
                          fontSize: 24,
                          fontColor: RHColor.black,
                        ),
                        const Spacer(),
                        RHButton(
                          width: 120,
                          height: 35,
                          textKey: '下一个固件',
                          onTap: () {
                            controller.updateNext();
                          },
                        ),
                      ],
                    ),
                    RHText(
                      text: controller.showName == 1? '表头' : controller.showName == 2 ? '控制器': "未知",
                      fontSize: 20,
                      fontColor: RHColor.font3333,
                    )
                  ],
                );
              }),
              const Gap(10),
              Obx(() {
                controller.msgFlag.value;
                return Row(
                    children: [
                      RHButton(
                        width: 100,
                        height: 35,
                        textKey: '110V',
                        backgroundColor: controller.voltage == 1 ? RHColor.defaultRed : RHColor.grey999,
                        onTap: () {
                          controller.voltage = 1;
                          controller.msgFlag.value++;
                        },
                      ),
                      const Gap(20),
                      RHButton(
                        width: 100,
                        height: 35,
                        textKey: '220V',
                        backgroundColor: controller.voltage == 0 ? RHColor.defaultRed : RHColor.grey999,
                        onTap: () {
                          controller.voltage = 0;
                          controller.msgFlag.value++;
                        },
                      ),
                    ]
                );
              }),
              const Gap(20),
              Container(
                width: size.width,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: RHColor.fontF5F5,
                  borderRadius: BorderRadius.all(Radius.circular(18))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      controller.msgFlag.value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RHText(
                                text: "网络固件包信息",
                                fontSize: 22,
                                fontColor: RHColor.black,
                                fontWeight: 6,
                              ),
                              const Spacer(),
                              RHButton(
                                width: 120,
                                height: 35,
                                textKey: '获取网络固件包',
                                onTap: () {
                                  controller.requestVersionUpdate();
                                },
                              ),
                            ],
                          ),
                          RHText(
                            text: '版本：${controller.currentOta?.fullVersion}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                          RHText(
                            text: '文件名： ${controller.currentOta?.downloadUrl.split('/').last}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                          RHText(
                            text: '芯片号： ${controller.currentOta?.chipNumber.toRadixString(16).toUpperCase()}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                          RHText(
                            text: '电压：： ${controller.currentOta?.voltage == 0 ? '220V' : '110V'}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                        ],
                      );
                    }),
                    Row(
                      children: [
                        const Spacer(),
                        RHButton(
                          width: 120,
                          height: 35,
                          textKey: '下载固件包',
                          onTap: () {
                            controller.startDownload();
                          },
                        ),
                      ],
                    ),
                    const Gap(20),
                    Obx(() {
                      controller.msgFlag.value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RHText(
                            text: "本地地址： ${controller.filePath}",
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                        ],
                      );
                    }),
                    Container(
                        height: 1,
                        width: size.width,
                        margin: EdgeInsets.symmetric( vertical: 18),
                        color: Colors.grey
                    ),
                    Obx(() {
                      controller.msgFlag.value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RHText(
                                text: "设备固件信息：",
                                fontSize: 22,
                                fontColor: RHColor.black,
                                fontWeight: 6,
                              ),
                              const Spacer(),
                              RHButton(
                                width: 140,
                                height: 35,
                                textKey: '获取设备芯片版本',
                                onTap: () {
                                  controller.queryChipVersion();
                                },
                              ),
                            ],
                          ),
                          RHText(
                            text: '版本：${controller.deviceHigh}.${controller.deviceLow}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                          RHText(
                            text: '芯片号： ${controller.deviceChip.toRadixString(16).toUpperCase()}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                          RHText(
                            text: '机型码：： ${controller.otaModel.mDeviceInfo?.deviceCode}',
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                        ],
                      );
                    }),
                    const Gap(20),
                    Row(
                      children: [
                        RHButton(
                          width: 120,
                          height: 35,
                          textKey: '退出BOOTLOAD',
                          backgroundColor: RHColor.font3333,
                          onTap: () {
                            controller.exitBootloader();
                          },
                        ),
                        const Spacer(),
                        RHButton(
                          width: 150,
                          textKey: '握手信号，请求升级',
                          height: 35,
                          onTap: () {
                            controller.btnHandshake();
                          },
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        RHText(
                          text: "进度：",
                          fontSize: 20,
                          fontColor: RHColor.font3333,
                        ),
                        Obx(() {
                          int flag = controller.updateFlag.value;
                          return controller.isOtaUpgrading ? RHText(
                              fontSize: 20,
                              text: "发送包： ${controller.currentPacketNum + 1} / ${controller.totalPacketCount}"
                          ): const SizedBox();
                        }),
                      ],
                    ),
                    const Gap(20),
                    Obx(() {
                      int flag = controller.updateFlag.value;
                      return controller.isOtaUpgrading ? LinearProgressIndicator(
                        value: controller.totalPacketCount > 0
                            ? (controller.currentPacketNum + 1) / controller.totalPacketCount
                            : 0.0,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ): const SizedBox();
                    })
                  ],
                ),
              ),
              const Gap(20),
              Container(
                width: size.width,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: RHColor.fontF5F5,
                    borderRadius: BorderRadius.all(Radius.circular(18))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RHText(
                          text: "芯片号: ",
                          fontSize: 18,
                        ),
                        RHTextInput(
                          text: controller.chipCtrl.text,
                          textCtrl: controller.chipCtrl,
                          width: 140,
                          height: 40,
                          isPassword: false,
                          isPhone: false,
                          radius: 10,
                          backColor: RHColor.white,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        RHText(
                          text: "首址H: ",
                          fontSize: 18,
                        ),
                        RHTextInput(
                          text: controller.adsHCtrl.text,
                          textCtrl: controller.adsHCtrl,
                          width: 80,
                          height: 40,
                          isPassword: false,
                          isPhone: false,
                          radius: 10,
                          backColor: RHColor.white,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                        const Gap(20),
                        RHText(
                          text: "首址L: ",
                          fontSize: 18,
                        ),
                        RHTextInput(
                          text: controller.adsLCtrl.text,
                          textCtrl: controller.adsLCtrl,
                          width: 80,
                          height: 40,
                          isPassword: false,
                          isPhone: false,
                          radius: 10,
                          backColor: RHColor.white,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        RHText(
                          text: '读取ROM',
                          fontSize: 22,
                          fontColor: RHColor.font3333,
                          fontWeight: 6,
                        ),
                        const Spacer()
                      ],
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        RHText(
                          text: "长度: ",
                          fontSize: 18,
                        ),
                        const Gap(5),
                        RHTextInput(
                          text: controller.lengthCtrl.text,
                          textCtrl: controller.lengthCtrl,
                          width: 140,
                          height: 40,
                          isPassword: false,
                          isPhone: false,
                          radius: 10,
                          backColor: RHColor.white,
                          onChange: (ctrl, value) {
                            return null;
                          },
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        RHText(
                          text: "ROM读取的数据",
                          fontSize: 20,
                          fontColor: RHColor.font3333,
                          fontWeight: 6,
                        ),
                        const Spacer(),
                        RHButton(
                          width: 100,
                          height: 35,
                          textKey: '读取ROM',
                          onTap: () {
                            controller.readRom();
                          },
                        ),
                      ],
                    ),
                    const Gap(10),
                    Obx(() {
                      int flag = controller.romFlag.value;
                      return RHText(
                        text: "数据：${controller.readStr}",
                        fontSize: 20,
                        fontColor: RHColor.black,
                      );
                    }),
                    const Gap(10),
                    Row(
                      children: [
                        RHText(
                          text: '写入ROM',
                          fontSize: 22,
                          fontWeight: 6,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Gap(20),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: RHColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller.dataWCtrl,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F\s]')),
                          LengthLimitingTextInputFormatter(300),
                        ],
                        style: TextStyle(fontSize: 20, color: RHColor.fontDark000),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入十六进制数据',
                          hintStyle: TextStyle(color: RHColor.font999, fontSize: 14),
                        ),
                        onChanged: (value) {
                          String formatted = controller.formatHexInput(value);
                          if (formatted != value) {
                            controller.dataWCtrl.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                        },
                      ),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        RHButton(
                          width: 100,
                          height: 35,
                          textKey: '擦除ROM',
                          backgroundColor: RHColor.font3333,
                          onTap: () {
                            controller.eraseRom();
                          },
                        ),
                        const Spacer(),
                        RHButton(
                          width: 100,
                          height: 35,
                          textKey: '写人ROM',
                          onTap: () {
                            controller.writeRom();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

}