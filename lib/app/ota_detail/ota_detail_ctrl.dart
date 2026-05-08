import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cabina_ble/api/rh_http.dart';
import 'package:cabina_ble/base_tool/rh_null.dart';
import 'package:cabina_ble/base_views/rh_toast.dart';
import 'package:cabina_ble/blue/commands/ota_commands.dart';
import 'package:cabina_ble/blue/model/ota_model.dart';
import 'package:cabina_ble/blue/tools/tools.dart';
import 'package:cabina_ble/dto/ota_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/rh_urls.dart';
import '../../base_tool/download.dart';
import '../../base_tool/log_utils.dart';
import '../../blue/enum/device_type.dart';
import '../../blue/factory/ble_factory.dart';
import '../../blue/model/power_adv_model.dart';

class OtaDetailCtrl extends GetxController {

  late OtaModel otaModel;

  static const int cmdIndex = 3;
  static const int cmdDataIndex = 4;

  static const int subCmdIndex = 4;
  static const int subCmdDataIndex_5 = 5;

  RxInt msgFlag = 0.obs;
  RxInt chipFlag = 0.obs;
  RxInt updateFlag = 0.obs;
  RxInt romFlag = 0.obs;

  List<OtaDto> otaList = [];
  OtaDto? currentOta;

  double apkProgress = 0.0;

  String filePath = '';

  int chipNumber = 1;

  int newOtaHighVer = 0;
  int newOtaLowVer = 0;
  int otaHighVer = 0;
  int otaLowVer = 0;

  // int otaUpdateType = 0;

  int packetSize = 64; // 每个包 64 字节
  ///需要更新的 固件包文件
  File? otaFile;
  int totalFileLength = 0;
  int totalPacketCount = 0;
  int currentPacketNum = 0;  // 当前发送的包序号
  bool isOtaUpgrading = false;  // 是否正在 OTA 升级中

  int errIndex = 0;


  int deviceChip = 0;
  int deviceHigh = 0;
  int deviceLow = 0;

  TextEditingController adsHCtrl = TextEditingController();
  TextEditingController adsLCtrl = TextEditingController();
  TextEditingController lengthCtrl = TextEditingController();
  String readStr = '';

  // TextEditingController adsHWCtrl = TextEditingController();
  // TextEditingController adsLWCtrl = TextEditingController();
  TextEditingController dataWCtrl = TextEditingController();
  TextEditingController chipCtrl = TextEditingController();

  int startAddress = 4096;

  List<int> currentPacket = [];

  Timer? handshakeTimer;

   @override
  void onInit() {
    super.onInit();
    otaModel = BleFactory.createModel(RHDeviceType.ota) as OtaModel;
    otaModel.onOtaDataReceived = (value) {
      LogUtils.d("返回数据： ${Tools.getNiceHexArray(value)}");

      switch (value[cmdIndex]) {
        case OtaCommands.cmdQueryData_0xD0: {
          int requestType = value[cmdDataIndex + 1];
          // int state = value[cmdDataIndex + 1];
          int chip = value[cmdDataIndex];
          switch (requestType) {
            case OtaCommands.cmdQueryData_0xD1: {
              // if (state == 0) {
                // if (chip == chipNumber) {
              if (isOtaUpgrading) {
                return;
              }
                  LogUtils.d("握手申请成功，开始上传固件包, 芯片号： $chip");
                  ///开始下载
                  Future.delayed(Duration(milliseconds: 500), () {
                    RHToast.showToast(msg: "开始下载");
                    handshakeTimer?.cancel();
                    handshakeTimer = null;
                    startUpgrade();
                  });

                // }else {
                //   LogUtils.d("握手申请成功，但芯片号不一致，状态： $state : $chip  :$chipNumber");
                // }
              // }else {
              //   LogUtils.d("握手申请失败，1秒后自动重试，状态： $state : $chip");
              //   Future.delayed(const Duration(milliseconds: 200), (){
              //     handshake(chipNumber, 1, totalPacketCount, totalFileLength, newOtaHighVer, newOtaLowVer);
              //   });
              // }
            }
            case OtaCommands.cmdQueryData_0xD3: {
              /// 返回成功后继续发送固件包
              // if (state == 0) {
                // 成功，继续发送下一个包
                if (currentPacketNum + 1 >= totalPacketCount) {
                  // exitBootloader();
                  LogUtils.d("更新完成");
                  RHToast.showToast(msg: "更新完成");
                }else {
                  // if (currentPacket.isNotEmpty) {
                  //   String text = '40';
                  //   int length = int.parse(text, radix: 16);
                  //   otaModel.readRom(chip, startAddress~/ 256, startAddress% 256, length);
                  //   startAddress += 64;
                  // }
                  Future.delayed(const Duration(milliseconds: 1), (){
                    currentPacketNum++;
                    _sendNextPacket();
                    updateFlag.value++;
                  });
                }
              // } else {
              //   // 失败，停止更新并提示
              //   isOtaUpgrading = false;
              //   RHToast.showToast(msg: "固件包 ${currentPacketNum} 写入失败，状态：$state");
              // }
            }
            case OtaCommands.cmdQueryData_0xD5: {
              RHToast.showToast(msg: "推出BOOTLOAD操作, 进入APP");
            }
          }
        }
        case OtaCommands.cmdQueryData_0xD7: {
          deviceChip = value[subCmdIndex];
          deviceHigh = value[subCmdIndex + 1];
          deviceLow = value[subCmdIndex + 2];
          msgFlag.value++;
        }
        case OtaCommands.cmdQueryData_0xE0: {
          int chip = value[cmdDataIndex];
          int state = value[cmdDataIndex + 1];
          int error = value[cmdDataIndex + 2];
          int msgHigh = value[cmdDataIndex + 3];
          int msgLow = value[cmdDataIndex + 4];

          if (isOtaUpgrading) {
            LogUtils.d("当前正下载失败： $state : $chip : $error : $msgHigh : $msgLow");
            // _sendNextPacket();
          }else {
            LogUtils.d("报错：$state : $chip : $error : $msgHigh : $msgLow ");
          }
          // switch (requestType) {
          //   case OtaCommands.cmdQueryData_0xD1: {
          //
          //   }
          //   case OtaCommands.cmdQueryData_0xD3: {
          //     isOtaUpgrading = false;
          //     RHToast.showToast(msg: "固件包 ${currentPacketNum} 写入失败，状态：$state : err: $error");
          //   }
          //   case OtaCommands.cmdQueryData_0xD5: {
          //
          //   }
          // }
        }
        case OtaCommands.cmdQueryData_0xDD: {
          readStr = Tools.getNiceHexArray(value);
          // int length = value[7];
          // List<int> data = value.sublist(8, 8 + length);
          // // currentPacket
          // bool areEqual = data.length == currentPacket.length &&
          //     data.asMap().entries.every(
          //           (e) => e.value == currentPacket[e.key],
          //     );
          // LogUtils.d("是否相等： ${Tools.getNiceHexArray(data)} :  ${Tools.getNiceHexArray(currentPacket)}");
          // currentPacket.clear();
          // if (areEqual) {
          //   Future.delayed(const Duration(milliseconds: 1), (){
          //     currentPacketNum++;
          //     _sendNextPacket();
          //     updateFlag.value++;
          //   });
          // }
          romFlag.value++;
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
             newOtaHighVer = currentOta!.majorVersion;
             newOtaLowVer = currentOta!.minorVersion;
             chipNumber = currentOta!.chipNumber;
             chipCtrl.text = chipNumber.toRadixString(16).toUpperCase();
             startDownload();
           }
           romFlag.value++;
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
    // totalFileLength = totalFileLength - 4096;
    // totalFileLength = 20880;
    // 计算总包数 (向上取整)
    totalPacketCount = (totalFileLength / packetSize).ceil();

    LogUtils.d('文件大小：$totalFileLength 字节');
    LogUtils.d('分包大小：$packetSize 字节');
    LogUtils.d('总包数：$totalPacketCount 包');
    LogUtils.d("固件包路径： $filePath");
    handshakeTimer?.cancel();
    handshakeTimer = null;
    handshakeTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!isOtaUpgrading) {
        handshake(chipNumber, 1, totalPacketCount, totalFileLength, newOtaHighVer, newOtaLowVer);
      }
    });
    // handshake(chipNumber, 1, totalPacketCount, totalFileLength, newOtaHighVer, newOtaLowVer);
    // startUpgrade();
  }

  startUpgrade() {
     currentPacketNum = 0;
     isOtaUpgrading = true;
     _sendNextPacket();
     updateFlag.value++;
     ///test
    //  timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
    //   text();
    // });
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

      IAPWrite(chipNumber, currentPacketNum, packetData.length, packetData);
      currentPacket.addAll(packetData);
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

    // int offset = 4096 + (packetNum * packetSize); // 从 4096 字节后开始读取
    // int remainingBytes = totalFileLength - (packetNum * packetSize);

    // 如果剩余数据不足 64 字节，有多少发多少，不补 0
    int readLength = remainingBytes < packetSize ? remainingBytes : packetSize;

    RandomAccessFile file = otaFile!.openSync(mode: FileMode.read);
    try {
      file.setPositionSync(offset);
      Uint8List buffer = Uint8List(readLength);
      file.readIntoSync(buffer);
      // return buffer.toList();
      List<int> result = buffer.toList();
      // 如果是最后一个包，确保长度是4的倍数
      bool isLastPacket = (packetNum == totalPacketCount - 1);
      if (isLastPacket && result.length % 4 != 0) {
        int padding = 4 - (result.length % 4);
        for (int i = 0; i < padding; i++) {
          result.add(0);
        }
        LogUtils.d('最后一个包补零：原长度 ${buffer.length}, 补零后长度 ${result.length}');
      }
      return result;
    } finally {
      file.closeSync();
    }
  }

  queryChipVersion() {
     otaModel.queryChipVersion(chipNumber);
  }

  handshake(int chipNumber, int mode, int packetCount, int fileLength, int versionHigh, int versionLow) {
    otaModel.handshake(chipNumber, mode, packetCount, fileLength, versionHigh, versionLow);
  }

  IAPWrite(int chipNumber, int packageNum, int length, List<int> data) {
    otaModel.IAPWrite(chipNumber, packageNum, length, data);
  }

  exitBootloader() {
    otaModel.exitBootloader(chipNumber);
  }

  readRom() {
     int adsH = int.parse(adsHCtrl.text, radix: 16);
     int adsL = int.parse(adsLCtrl.text, radix: 16);
     int chip = int.parse(chipCtrl.text, radix: 16);
     int length = int.parse(lengthCtrl.text, radix: 16);
     otaModel.readRom(chip, adsH, adsL, length);
  }

  eraseRom() {
    int adsH = int.parse(adsHCtrl.text, radix: 16);
    int adsL = int.parse(adsLCtrl.text, radix: 16);
    int chip = int.parse(chipCtrl.text, radix: 16);
    otaModel.eraseRom(chip, adsH, adsL);
  }

  writeRom() {
    try {
      int adsH = int.parse(adsHCtrl.text, radix: 16);
      int adsL = int.parse(adsLCtrl.text, radix: 16);
      int chip = int.parse(chipCtrl.text, radix: 16);

      String hexStr = dataWCtrl.text.trim();
      if (hexStr.isEmpty) {
        RHToast.showToast(msg: '请输入十六进制数据');
        return;
      }

      List<int> data = [];
      List<String> hexValues = hexStr.split(RegExp(r'\s+'));
      for (String hex in hexValues) {
        if (hex.isNotEmpty) {
          data.add(int.parse(hex, radix: 16));
        }
      }

      if (data.isEmpty) {
        RHToast.showToast(msg: '无效的十六进制数据');
        return;
      }

      int length = data.length;

      otaModel.writeRom(chip, adsH, adsL, length, data);
      // RHToast.showToast(msg: '开始写入 ROM，长度：$length');
    } catch (e) {
      RHToast.showToast(msg: '数据解析失败：$e');
    }
  }

  String formatHexInput(String input) {
    // 移除所有现有空格
    String cleaned = input.replaceAll(' ', '');

    // 每两个字符添加一个空格
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 2 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleaned[i]);
    }

    return buffer.toString();
  }

  @override
  void onClose() {
    super.onClose();
    otaModel.stopConnect();
    handshakeTimer?.cancel();
    handshakeTimer = null;
  }

  Timer? timer;
  text() {
    int state = 0;
    if (state == 0) {
      // 成功，继续发送下一个包
      if (currentPacketNum + 1 >= totalPacketCount) {
        // exitBootloader();
        timer?.cancel();
        timer = null;
        RHToast.showToast(msg: "更新完成");
      }else {
        Future.delayed(const Duration(milliseconds: 100), (){
          currentPacketNum++;
          _sendNextPacket();
          updateFlag.value++;
        });
      }
    } else {
      // 失败，停止更新并提示
      isOtaUpgrading = false;
      RHToast.showToast(msg: "固件包 ${currentPacketNum} 写入失败，状态：$state");
    }
  }

}