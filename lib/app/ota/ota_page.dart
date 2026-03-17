import 'package:cabina_ble/app/ota/ota_ctrl.dart';
import 'package:cabina_ble/base_views/rh_button.dart';
import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OtaPage extends GetView<OtaCtrl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTA Update'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Column(
            children: [
                RHButton(
                  width: 200,
                  textKey: '获取网络固件包',
                  onTap: () {
                    controller.requestVersionUpdate();
                  },
                ),
              Obx(() {
                controller.msgFlag.value;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RHText(
                      text: "网络固件包信息",
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    RHText(
                      text: '版本：${controller.currentOta?.fullVersion}',
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    RHText(
                      text: '文件名： ${controller.currentOta?.downloadUrl.split('/').last}',
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                    RHText(
                      text: '芯片号： ${controller.currentOta?.chipNumber.toRadixString(16).toUpperCase()}',
                      fontSize: 16,
                      fontColor: RHColor.black,
                    )
                  ],
                );
              }),
              RHButton(
                width: 200,
                textKey: '下载固件包',
                onTap: () {
                  controller.startDownload();
                },
              ),
              const Gap(10),
              Obx(() {
                controller.msgFlag.value;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RHText(
                      text: "本地地址： ${controller.filePath}",
                      fontSize: 16,
                      fontColor: RHColor.black,
                    ),
                  ],
                );
              }),
              const Gap(10),
              RHButton(
                width: 200,
                textKey: '获取当前芯片版本',
                onTap: () {
                  controller.queryChipVersion();
                },
              ),
              const Gap(10),
              RHButton(
                width: 200,
                textKey: '握手信号，请求升级',
                onTap: () {
                  controller.btnHandshake();
                },
              ),
              const Gap(10),
              RHButton(
                width: 200,
                textKey: '开始升级固件包',
                onTap: () {
                  controller.startUpgrade();
                },
              ),
              const Gap(10),
              Obx(() {
                int flag = controller.updateFlag.value;
                return RHText(
                  text: "发送包： ${controller.currentPacketNum + 1} / ${controller.totalPacketCount}"
                );
              }),
              const Gap(10),
              RHButton(
                width: 200,
                textKey: '退出BOOTLOAD',
                onTap: () {
                  controller.startUpgrade();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}