import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageDialog {

  static void showMessageDialog(BuildContext context, PowerAdvancedData data) {

    Widget contentStr(String str) {
      return RHText(
        text: str,
        bigHeight: 30,
        bigAlignment: Alignment.centerLeft,
      );
    }

    Widget line() {
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 1,
        color: Colors.grey,
      );
    }

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      contentStr("${"device_type".tr}${data.deviceType}"),
                      contentStr("${"device_code".tr}${data.deviceCode}"),
                      contentStr("${"brand_code".tr}${data.brandCode}"),
                      contentStr("${"firmware_version".tr}${data.version} - ${data.subVersion}"),
                      line(),
                      contentStr("${"unit_system".tr}${data.unit == 0? "metric".tr : "imperial".tr}"),
                      line(),
                      contentStr("${"back_rest_min_angle".tr}${data.backMinDegree}"),
                      contentStr("${"back_rest_max_angle".tr}${data.backMaxDegree}"),
                      contentStr("${"seat_min_angle".tr}${data.seakMinDegree}"),
                      contentStr("${"seat_max_angle".tr}${data.seakMaxDegree}"),
                      contentStr("${"slider_min_distance".tr}${data.minSlider}"),
                      contentStr("${"slider_max_distance".tr}${data.maxSlider}"),
                      line(),
                      contentStr("${"motor_group_count".tr}${data.motorGroupNumber}"),
                      line(),
                      contentStr("${"motor_group_1_count".tr}${data.mainMotorCount}"),
                      contentStr("${"motor_group_1_max_weight_metric".tr} ${data.mainMaxWeightMe}"),
                      contentStr("${"motor_group_1_min_weight_metric".tr} ${data.mainMinWeightMe}"),
                      contentStr("${"motor_group_1_step_size_metric".tr} ${data.mainStepSizeMe}"),
                      contentStr("${"motor_group_1_max_weight_imperial".tr} ${data.mainMaxWeightIm}"),
                      contentStr("${"motor_group_1_min_weight_imperial".tr} ${data.mainMinWeightIm}"),
                      contentStr("${"motor_group_1_step_size_imperial".tr} ${data.mainStepSizeIm}"),
                      line(),
                      contentStr("${"motor_group_2_count".tr}${data.armMotorCount}"),
                      contentStr("${"motor_group_2_max_weight_metric".tr} ${data.armMaxWeightMe}"),
                      contentStr("${"motor_group_2_min_weight_metric".tr} ${data.armMinWeightMe}"),
                      contentStr("${"motor_group_2_step_size_metric".tr} ${data.armStepSizeMe}"),
                      contentStr("${"motor_group_2_max_weight_imperial".tr} ${data.armMaxWeightIm}"),
                      contentStr("${"motor_group_2_min_weight_imperial".tr} ${data.armMinWeightIm}"),
                      contentStr("${"motor_group_2_step_size_imperial".tr} ${data.armStepSizeIm}"),
                      line(),
                      contentStr("${"motor_group_3_count".tr}${data.legMotorCount}"),
                      contentStr("${"motor_group_3_max_weight_metric".tr} ${data.legMaxWeightMe}"),
                      contentStr("${"motor_group_3_min_weight_metric".tr} ${data.legMinWeightMe}"),
                      contentStr("${"motor_group_3_step_size_metric".tr} ${data.legStepSizeMe}"),
                      contentStr("${"motor_group_3_max_weight_imperial".tr} ${data.legMaxWeightIm}"),
                      contentStr("${"motor_group_3_min_weight_imperial".tr} ${data.legMinWeightIm}"),
                      contentStr("${"motor_group_3_step_size_imperial".tr} ${data.legStepSizeIm}"),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}