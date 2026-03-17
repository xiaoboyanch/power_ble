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
  static const int cmdQueryData_0xE0 = 0xE0;

  /// 握手信号 D1
  static List<int> handshake(int mode, int chipNumber, int packetCount, int fileLength, int versionHigh, int versionLow) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xD1,
      mode,
      chipNumber,
      packetCount ~/ 256,
      packetCount % 256,
      fileLength ~/ 256,
      fileLength % 256,
      versionHigh,
      versionLow,
      0x00,
      0x00,
    ]);
  }
  /// IAP写入操作 D3
  static List<int> IAPWrite(int packageNum, List<int> data) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xD3,
      packageNum ~/ 256,
      packageNum % 256,
      ...data,
    ]);
  }
  /// 退出BOOTLOADER操作 D5
  static List<int> exitBootloader() {
    return CrcTools.encryptCmd([
      cmdQueryData_0xD5,
      cmdQueryData_0xD5,
      0x00,
    ]);
  }
  /// 查询芯片版本号 D7
  static List<int> queryChipVersion(int chipNumber) {
    return CrcTools.encryptCmd([
      cmdQueryData_0xD7,
      chipNumber,
    ]);
  }

}

