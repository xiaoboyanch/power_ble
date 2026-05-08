import 'package:cabina_ble/app/ota/ota_ctrl.dart';
import 'package:cabina_ble/base_views/rh_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../base_views/rh_colors.dart';
import '../../base_views/rh_text.dart';
import '../../blue/entity/rh_blue_scan_result.dart';

class OtaPage extends GetView<OtaCtrl> {
  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).padding.bottom;
    return RHPage(
      isStack: false,
      canBack:  false,
      showBackArrow: true,
      navBarColor: RHColor.line_2,
      body: Stack(
        children: [
          Obx(() {
            controller.flag.value;
            return ListView.separated(
                itemBuilder: (_, index) {
                  RHBlueScanResult rhBlueScanResult = controller.bleResultList[index];
                  // ScanResult scanResult = rhBlueScanResult.scanResult;
                  // var adv = scanResult.advertisementData;
                  return GestureDetector(
                    onTap: () {
                      controller.connectDevice(rhBlueScanResult);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: RHColor.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(12),
                          RHText(
                            text: rhBlueScanResult.bluetoothDevice.advName,
                            // text: scanResult.device.platformName.isNotEmpty ? scanResult.device.platformName : scanResult.device.remoteId.str,
                            fontSize: 20,
                            fontColor: RHColor.black,
                          ),
                          const Gap(8),
                          RHText(
                            // text: scanResult.device.remoteId.str,
                            fontSize: 14,
                            fontColor: RHColor.black,
                          ),
                          // if (scanResult.device.platformName.isNotEmpty)
                          //   Column(
                          //     children: <Widget>[
                          //       if (adv.msd.isNotEmpty) _buildAdvRow(context, 'Manufacturer Data', getNiceManufacturerData(adv.msd)),
                          //       if (adv.serviceUuids.isNotEmpty) _buildAdvRow(context, 'Service UUIDs', getNiceServiceUuids(adv.serviceUuids)),
                          //       if (adv.serviceData.isNotEmpty) _buildAdvRow(context, 'Service Data', getNiceServiceData(adv.serviceData)),
                          //     ],
                          //   )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) => const Gap(2),
                padding: EdgeInsets.only(bottom: bottom + 64),
                itemCount: controller.bleResultList.length);
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() {
              bool scanning = controller.scanningFlag.value;
              return Padding(
                padding: EdgeInsets.only(bottom: bottom + 20),
                child: GestureDetector(
                  onTap: () {
                    controller.btnStartScan();
                    // Get.toNamed(RHRoute.powerDetailPage);
                  },
                  child: Container(
                    width: 216,
                    height: 46,
                    decoration: BoxDecoration(
                      color: RHColor.defaultRed,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Center(
                      child: RHText(
                        fontSize: 16,
                        fontColor: RHColor.white,
                        textKey: scanning ? 'stop_scanning':'start_scanning',
                      ),
                    ),
                  ),
                ),
              );
            }),

          )
        ],
      ),
    );
  }

}