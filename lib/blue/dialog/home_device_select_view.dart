import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../base_tool/rh_null.dart';
import '../../base_views/rh_colors.dart';
import '../../base_views/rh_text.dart';
import '../../dto/device_dto.dart';
import '../entity/rh_blue_scan_result.dart';

typedef DeviceCallback = void Function(RHBlueScanResult blueDevice);

class HomeDeviceSelectView extends StatefulWidget {
  List<DeviceDto> deviceList = [];
  List<RHBlueScanResult> blueList = [];
  DeviceCallback itemClick;
  var flag = 0.obs;

  void addDevice() {}
  bool _isBottomSheetShowing = false;

  HomeDeviceSelectView({super.key, required this.itemClick});

  void show(List<RHBlueScanResult> resultList, BuildContext context) {
    deviceList.clear();
    blueList.clear();
    blueList.addAll(resultList);
    for (int i=0; i<blueList.length; i++) {
      RHBlueScanResult result = blueList[i];
      deviceList.add(DeviceDto.fromJson(result.toRHDeviceJson()));
    }
    if (!_isBottomSheetShowing) {
      _isBottomSheetShowing = true;
      showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: RHColor.pageBack,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          context: context,
          builder: (context) {
            return this;
          }).then((value) {
            _isBottomSheetShowing = false;
      });
    }else {
      flag.value++;
    }

  }

  @override
  State<StatefulWidget> createState() => _HomeDeviceSelectViewState();
}

class _HomeDeviceSelectViewState extends State<HomeDeviceSelectView> {
  @override
  Widget build(BuildContext context) {
    double maxLength = 25 + 98 * widget.blueList.length + 40;
    if (maxLength > 600) {
      maxLength = 600;
    }
    return Container(
      width: double.infinity,
      height: maxLength,
      decoration: BoxDecoration(
          color: RHColor.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: Column(
        children: [
          const Gap(18),
          RHText(
            fontSize: 18,
            fontColor: RHColor.font3333,
            textKey: 'bluetooth_selectDevice',
          ),
          const Gap(18),
          Expanded(
            child: Obx(() {
              int num = widget.flag.value;
              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    DeviceDto deviceDto = widget.deviceList[index];

                    String subTitle = RHNull.getStr(deviceDto.deviceName);
                    // if (subTitle.isEmpty) {
                    // }
                    // subTitle += deviceDto.bluetooth;
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.itemClick(widget.blueList[index]);
                      },
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.only(left: 18, right: 18),
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        decoration: BoxDecoration(
                          color: RHColor.fontF5F5,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // RHImage(
                            //   width: 75,
                            //   height: 75,
                            //   imageName: deviceDto.typeEnum.deviceIcon,
                            // ),
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 8, // 总共需要20， 这边距离是10，因为已经设置了10的内间距
                                    ),
                                    RHText(
                                      fontSize: 16,
                                      textKey: deviceDto.typeEnum.tagName,
                                      maxLine: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RHText(
                                        maxLine: 3,
                                        fontSize: 14,
                                        fontColor: RHColor.font3333,
                                        text: subTitle
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 18,
                      width: 18,
                    );
                  },
                  itemCount: widget.blueList.length);
            }),
          )
        ],
      ),
    );
  }
}
