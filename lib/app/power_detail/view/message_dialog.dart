import 'package:cabina_ble/base_views/rh_text.dart';
import 'package:cabina_ble/blue/entity/power_advanced_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base_tool/log_utils.dart';

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
          LogUtils.d("01指令： ${data.mainMinWeightMe} : ${data.mainMaxWeightMe} : ${data.mainStepSizeMe}");
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
                      line(),
                      contentStr("${"motor_group_count".tr}${data.motorGroupNumber}"),
                      line(),
                      contentStr("${"motor_group_1_count".tr}${data.mainMotorCount}"),
                      contentStr("${"motor_group_1_max_weight_metric".tr} ${(data.mainMaxWeightMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_1_min_weight_metric".tr} ${(data.mainMinWeightMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_1_step_size_metric".tr} ${(data.mainStepSizeMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_1_max_weight_imperial".tr} ${(data.mainMaxWeightIm/ 10).toStringAsFixed(1)}LB"),
                      contentStr("${"motor_group_1_min_weight_imperial".tr} ${(data.mainMinWeightIm/ 10).toStringAsFixed(1)}LB"),
                      contentStr("${"motor_group_1_step_size_imperial".tr} ${(data.mainStepSizeIm/ 10).toStringAsFixed(1)}LB"),
                      line(),
                      contentStr("${"motor_group_2_count".tr}${data.armMotorCount}"),
                      contentStr("${"motor_group_2_max_weight_metric".tr} ${(data.armMaxWeightMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_2_min_weight_metric".tr} ${(data.armMinWeightMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_2_step_size_metric".tr} ${(data.armStepSizeMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_2_max_weight_imperial".tr} ${(data.armMaxWeightIm/ 10).toStringAsFixed(1)}LB"),
                      contentStr("${"motor_group_2_min_weight_imperial".tr} ${(data.armMinWeightIm/ 10).toStringAsFixed(1)}LB"),
                      contentStr("${"motor_group_2_step_size_imperial".tr} ${(data.armStepSizeIm/ 10).toStringAsFixed(1)}LB"),
                      line(),
                      contentStr("${"motor_group_3_count".tr}${data.legMotorCount}"),
                      contentStr("${"motor_group_3_max_weight_metric".tr} ${(data.legMaxWeightMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_3_min_weight_metric".tr} ${(data.legMinWeightMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_3_step_size_metric".tr} ${(data.legStepSizeMe/ 10).toStringAsFixed(1)}KG"),
                      contentStr("${"motor_group_3_max_weight_imperial".tr} ${(data.legMaxWeightIm/ 10).toStringAsFixed(1)}LB"),
                      contentStr("${"motor_group_3_min_weight_imperial".tr} ${(data.legMinWeightIm/ 10).toStringAsFixed(1)}LB"),
                      contentStr("${"motor_group_3_step_size_imperial".tr} ${(data.legStepSizeIm/ 10).toStringAsFixed(1)}LB"),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}