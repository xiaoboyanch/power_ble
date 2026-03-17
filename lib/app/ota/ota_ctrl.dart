import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cabina_ble/api/rh_http.dart';
import 'package:cabina_ble/base_tool/rh_null.dart';
import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:cabina_ble/blue/commands/ota_commands.dart';
import 'package:cabina_ble/dto/ota_dto.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/rh_urls.dart';
import '../../base_tool/download.dart';
import '../../base_tool/log_utils.dart';
import '../../blue/enum/device_type.dart';
import '../../blue/factory/ble_factory.dart';
import '../../blue/model/power_adv_model.dart';

class OtaCtrl extends GetxController {

  late PowerAdvancedModel powerModel;

  static const int cmdIndex = 3;
  static const int cmdDataIndex = 4;

  static const int subCmdIndex = 4;
  static const int subCmdDataIndex_5 = 5;

  RxInt msgFlag = 0.obs;
  RxInt chipFlag = 0.obs;
  RxInt updateFlag = 0.obs;

  List<OtaDto> otaList = [];
  OtaDto? currentOta;

  double apkProgress = 0.0;

  String filePath = '';

  int chipNumber = 0;

  int newOtaHighVer = 0;
  int newOtaLowVer = 0;
  int otaHighVer = 0;
  int otaLowVer = 0;

  int otaUpdateType = 0;

  int packetSize = 64; // 每个包 64 字节
  ///需要更新的 固件包文件
  File? otaFile;
  int totalFileLength = 0;
  int totalPacketCount = 0;
  int currentPacketNum = 0;  // 当前发送的包序号
  bool isOtaUpgrading = false;  // 是否正在 OTA 升级中

  int errIndex = 0;

   @override
  void onInit() {
    super.onInit();
    powerModel = BleFactory.createModel(RHDeviceType.powerAdvanced) as PowerAdvancedModel;
    powerModel.otaState = true;
    powerModel.onOtaDataReceived = (value) {
      switch (value[cmdIndex]) {
        case OtaCommands.cmdQueryData_0xD0: {
          int state = value[cmdDataIndex];
          int chip = value[cmdDataIndex + 1];
          switch (otaUpdateType) {
            case OtaCommands.cmdQueryData_0xD1: {
              if (state == 0) {
                otaUpdateType = 0;
                RHToast.showToast(msg: "握手申请成功，可以上传固件包, 芯片号： $chip");
              }else {
                RHToast.showToast(msg: "握手申请失败，1秒后自动重试，状态： $state : $chip");
                Future.delayed(const Duration(seconds: 1), (){
                  handshake(1, chipNumber, totalPacketCount, totalFileLength, newOtaHighVer, newOtaLowVer);
                });
              }
            }
            case OtaCommands.cmdQueryData_0xD3: {
              /// 返回成功后继续发送固件包
              if (state == 0) {
                // 成功，继续发送下一个包
                if (currentPacketNum + 1 >= totalPacketCount) {
                  exitBootloader();
                  RHToast.showToast(msg: "更新完成");
                }else {
                  currentPacketNum++;
                  updateFlag.value++;
                  _sendNextPacket();
                }
              } else {
                // 失败，停止更新并提示
                isOtaUpgrading = false;
                RHToast.showToast(msg: "固件包 ${currentPacketNum} 写入失败，状态：$state");
              }
            }
            case OtaCommands.cmdQueryData_0xD5: {

            }
          }
        }
        case OtaCommands.cmdQueryData_0xD7: {
            int chip = value[subCmdIndex];
            int highVer = value[subCmdIndex + 1];
            int lowVer = value[subCmdIndex + 2];
        }
        case OtaCommands.cmdQueryData_0xE0: {
          int state = value[cmdDataIndex];
          int chip = value[cmdDataIndex + 1];
          int error = value[cmdDataIndex + 2];
          switch (otaUpdateType) {
            case OtaCommands.cmdQueryData_0xD1: {

            }
            case OtaCommands.cmdQueryData_0xD3: {
              isOtaUpgrading = false;
              RHToast.showToast(msg: "固件包 ${currentPacketNum} 写入失败，状态：$state : err: $error");
            }
            case OtaCommands.cmdQueryData_0xD5: {

            }
          }
        }
      }
    };
  }

  requestVersionUpdate() {
     RHToast.showToast(msg: '正在获取固件版本');
     RHHttp.queryData(
         mtd: RHHttp.methodGet,
         params: {//系统：1-安卓 2-IOS 3-彩屏
           'deviceType': 35,
         },
         url: RHUrls.otaUpdate,
         callback: (a,b,data) {
           if (!a) {
             RHToast.showToast(msg: '获取固件版本失败');
           }
           LogUtils.d('versionCheck : ${data}');
           List lt = RHNull.getList(data);
           otaList = lt.map((e) {
             OtaDto dto = OtaDto.fromJson(e);
             return dto;
           }).toList();
           if (otaList.isNotEmpty) {
             currentOta = otaList.last;
           }
           msgFlag.value++;
         });
  }

  startDownload() {
     if (currentOta != null) {
       ApkDownloader.downloadAndInstall(url: currentOta!.downloadUrl, onProgress: (progress, filePath) {
         apkProgress = progress;
         LogUtils.d("下载升级中： $progress");
         if (apkProgress == 1.0) {
           RHToast.showToast(msg: "下载完成");
           this.filePath = filePath;
           msgFlag.value++;
         }
       });
     }

  }

  btnHandshake() async{
    if (Platform.isAndroid) {
      final status = await Permission.requestInstallPackages.status;
      if (!status.isGranted) {
        await Permission.requestInstallPackages.request();
      }
    }
    otaFile = File(filePath);
    if (otaFile == null) {
      RHToast.showToast(msg: '请选择固件文件');
      return;
    }
    if (!otaFile!.existsSync()) {
      RHToast.showToast(msg: '固件文件不存在');
      return;
    }
    totalFileLength = otaFile!.lengthSync();
    // 计算总包数 (向上取整)
    totalPacketCount = (totalFileLength / packetSize).ceil();

    LogUtils.d('文件大小：$totalFileLength 字节');
    LogUtils.d('分包大小：$packetSize 字节');
    LogUtils.d('总包数：$totalPacketCount 包');
    handshake(1, chipNumber, totalPacketCount, totalFileLength, newOtaHighVer, newOtaLowVer);
  }

  startUpgrade() {
     otaUpdateType = OtaCommands.cmdQueryData_0xD3;
     currentPacketNum = 0;
     isOtaUpgrading = true;
     _sendNextPacket();
     updateFlag.value++;
     ///test
     timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      text();
    });
  }



  /// 发送下一个数据包
  void _sendNextPacket() {
    if (!isOtaUpgrading || currentPacketNum >= totalPacketCount) {
      isOtaUpgrading = false;
      RHToast.showToast(msg: "固件更新完成");
      return;
    }

    try {
      // 读取当前包的数据
      List<int> packetData = _readPacket(currentPacketNum);

      LogUtils.d('发送包 ${currentPacketNum + 1}/$totalPacketCount, 数据长度：${packetData.length}');

      IAPWrite(currentPacketNum, packetData);
    } catch (e) {
      LogUtils.e('读取固件包失败：$e');
      isOtaUpgrading = false;
      RHToast.showToast(msg: "读取固件文件失败");
    }
  }

  /// 读取指定包的数据
  List<int> _readPacket(int packetNum) {
    int offset = packetNum * packetSize;
    int remainingBytes = totalFileLength - offset;

    // 如果剩余数据不足 64 字节，有多少发多少，不补 0
    int readLength = remainingBytes < packetSize ? remainingBytes : packetSize;

    RandomAccessFile file = otaFile!.openSync(mode: FileMode.read);
    try {
      file.setPositionSync(offset);
      Uint8List buffer = Uint8List(readLength);
      file.readIntoSync(buffer);
      return buffer.toList();
    } finally {
      file.closeSync();
    }
  }

  queryChipVersion() {
     powerModel.queryChipVersion(chipNumber);
  }

  handshake(int mode, int chipNumber, int packetCount, int fileLength, int versionHigh, int versionLow) {
     otaUpdateType = OtaCommands.cmdQueryData_0xD1;
    powerModel.handshake(mode, chipNumber, packetCount, fileLength, versionHigh, versionLow);
  }

  IAPWrite(int packageNum, List<int> data) {
    powerModel.IAPWrite( packageNum, data);
  }

  exitBootloader() {
    otaUpdateType = OtaCommands.cmdQueryData_0xD5;
    powerModel.exitBootloader();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    powerModel.otaState = false;
  }

  Timer? timer;
  text() {
    int state = 0;
    if (state == 0) {
      // 成功，继续发送下一个包
      if (currentPacketNum + 1 >= totalPacketCount) {
        exitBootloader();
        timer?.cancel();
        timer = null;
        RHToast.showToast(msg: "更新完成");
      }else {
        currentPacketNum++;
        _sendNextPacket();
      }
    } else {
      // 失败，停止更新并提示
      isOtaUpgrading = false;
      RHToast.showToast(msg: "固件包 ${currentPacketNum} 写入失败，状态：$state");
    }
  }

}