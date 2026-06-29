import 'package:cabina_ble/app/home/home_ctrl.dart';
import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:cabina_ble/base_views/rh_page.dart';
import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:cabina_ble/route/rh_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeCtrl> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).padding.top;
    return RHPage(
      isStack: false,
        canBack:  false,
        showBackArrow: false,
        navBarColor: RHColor.line_2,
        body: Column(
          children: [
            const Gap(20),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RHRoute.powerPage);
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(
                          child: RHText(
                            text: 'SONY TEST',
                            fontColor: RHColor.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                ),
                const Gap(10),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RHRoute.otaPage);
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(
                          child: RHText(
                            text: 'OTA TEST',
                            fontColor: RHColor.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RHRoute.table);
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Center(
                        child: RHText(
                          text: 'Table TEST',
                          fontColor: RHColor.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Get.toNamed(RHRoute.otaPage);
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            // color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(
                          child: RHText(
                            // text: 'OTA TEST',
                            fontColor: RHColor.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          ],
        )
    );
  }
}