import 'dart:convert';
import 'dart:typed_data';

import 'package:cabina_ble/blue/tools/crc_tools.dart';

class OtaCommands {
  static const int cmdStart = 0xF5; //START
  static const int cmdEnd = 0xFA; //END

  static const int cmdIndex = 3;
  static const int cmdDataIndex = 4;

  static const int subCmdIndex = 4;
  static const int subCmdDataIndex_5 = 5;
  static const int sportModeDataIndex = 11;

  static const int cmdQueryData_0xD0 = 0xD0;
  static const int cmdQueryData_0xD1 = 0xD1;
  static const int cmdQueryData_0xD3 = 0xD3;
  static const int cmdQueryData_0xD5 = 0xD5;
  static const int cmdQueryData_0xD7 = 0xD7;
  static const int cmdQueryData_0xDD = 0xDD;
  static const int cmdQueryData_0xDE = 0xDE;
  static const int cmdQueryData_0xDF = 0xDF;
  static const int cmdQueryData_0xE0 = 0xE0;

  static const int controlReMusic = 0x06;
  static const int cmdDeviceConf_0x0C = 0x0C;

  /// 握手信号 D1
  static List<int> handshake(int chipNumber, int mode, int packetCount, int fileLength, int versionHigh, int versionLow, {int address = 0x00}) {
    List<int> list = [];
    list.addAll([
      cmdQueryData_0xD1,
      chipNumber,
      mode,
      packetCount ~/ 256,
      packetCount % 256,
      fileLength ~/ 256,
      fileLength % 256,
      versionHigh,
      versionLow,
      0x00,
      0x00,
    ]);
    return CrcTools.encryptCmd(list, address: address);
  }
  /// IAP写入操作 D3
  static List<int> IAPWrite(int chipNumber, int packageNum, int length, List<int> data, {int address = 0x00}) {
    List<int> list = [];
    list.addAll([
      cmdQueryData_0xD3,
      chipNumber,
      packageNum ~/ 256,
      packageNum % 256,
      length,
      ...data,
    ]);
    return CrcTools.encryptCmd(list, address: address);
  }
  /// 退出BOOTLOADER操作 D5
  static List<int> exitBootloader(int chipNumber) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xD5,
      chipNumber,
      0x00,
    ]);
  }

  static List<int> exitBootloaderCheck(int chipNumber, int checkSum, {int address = 0x00}) {
    List<int> list = [];
    list.addAll([
      cmdQueryData_0xD5,
      chipNumber,
      checkSum ~/ 256,
      checkSum % 256,
    ]);
    return CrcTools.encryptCmd(list, address: address);
  }
  /// 查询芯片版本号 D7
  static List<int> queryChipVersion(int chipNumber, {int address = 0x00}) {
    List<int> list = [];
    list.addAll([
      cmdQueryData_0xD7,
      chipNumber,
    ]);
    return CrcTools.encryptCmd(list, address: address);
  }

  ///读ROM
  static List<int> readRom(int chipNumber, int addressHigh, int addressLow, int length) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xDD,
      chipNumber,
      addressHigh,
      addressLow,
      length,
    ]);
  }

  /// 写ROM
  static List<int> writeRom(int chipNumber, int addressHigh, int addressLow, int length, List<int> data) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xDE,
      chipNumber,
      addressHigh,
      addressLow,
      length,
      ...data,
    ]);
  }

  /// 擦除ROM
  static List<int> eraseRom(int chipNumber, int addressHigh, int addressLow) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xDF,
      chipNumber,
      addressHigh,
      addressLow,
    ]);
  }

  static List<int> getReBootBlue() {
    return CrcTools.encryptCmd([
      cmdDeviceConf_0x0C,
      0
    ]);
  }

  static List<int> getReMusicName(String name) {
    Uint8List byte = Utf8Encoder().convert(name);
    List<int> list = [];
    if (byte.length > 12) {
      list.addAll(byte.sublist(0, 12));
    }else {
      list.addAll(byte);
      while (list.length < 12) {
        list.add(0);
      }
    }
    list.insertAll(0, [cmdDeviceConf_0x0C, controlReMusic]);
    return CrcTools.encryptCmd(list, needSplit: false);
  }
}

