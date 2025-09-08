import 'dart:convert';
import 'dart:typed_data';

import '../tools/crc_tools.dart';

class PowerCommands {

  static const int cmdStart = 0xF5; //开始
  static const int cmdEnd = 0xFA; //结束

  static const int cmdIndex = 3;
  static const int cmdDataIndex = 4;

  static const int subCmdIndex = 4;
  static const int subCmdDataIndex_5 = 5;
  static const int sportModeDataIndex = 11;

  static const int sportLevelIndex = 20;

  static const int cmdQueryParam_0x01 = 0x01;  //  设备参数信息查询（指令：0x01）
  static const int cmdControl_0x03 = 0x03;
  static const int cmdControl_0x05 = 0x05;
  static const int cmdQueryData_0x09 = 0x09;
  static const int cmdDeviceConf_0x0C = 0x0C;
  static const int cmdError = 0x0E;
  static const int cmdResponse_0xD0 = 0xD0;

  /*app在即将开始运行设备时，最先发送此指令给设备，通知设备即将开始，设备接收到此指令后，进行运动数据重置，同时恢复相关设置值   备注：倒计值 若设备需要倒计时提示用户，返回数据为倒计秒值，若不需要返回0*/

  static const int controlReset = 0x01; //复位
  static const int controlStop = 0x02; //停止
  static const int controlReBLE = 0x03;
  static const int controlStart = 0x04; //启动
  static const int controlReMusic = 0x06;

  static const int statusNormal = 0x00; //待机
  static const int statusStarting = 0x04; //启动中
  static const int statusStop = 0x02; //停止

  ///模式：设置恒力
  static const int hengLiMode = 0x06;

  ///模式：设置离心/向心模式
  static const int liXinLiMode = 0x08;

  ///模式：设置弹力模式
  static const int tanLiMode = 0x0A;

  ///模式：设置流体力模式
  static const int gearMode = 0x0C;

  ///模式：设置速度模式
  static const int speedMode = 0x0D;

  static const int queryDeviceCtrl_0x01 = 0x01; //设置设备配置
  static const int queryDataState_0x02 = 0x02; //获取设备状态
  // static const int queryBobaoOpen_0x03 = 0x03; //获取播报开关
  static const int queryDataSport_0x04 = 0x04; //获取运动数据
  static const int queryDataSport_0x06 = 0x06; //划船机运动数据
  static const int queryDataSport_0x08 = 0x08; //划船机运动数据
  static const int queryDataSport_0x0A = 0x0A; //划船机运动数据
  static const int getVolume_0x0B = 0x0B; //获取设备播报音量
  static const int setVolume_0x0D = 0x0D; //设置设备播报音量
  static const int queryMode = 0x06; //获取运动数据

  static const int errorUnkowCmd = 0x00; //指令不支持
  static const int errorFormat = 0x02; //格式不正确
  static const int errorCrc = 0x04; //格式不正确
  static const int errorSystemBusy = 0x06; //系统忙
  static const int errorValue = 0x08; //数值不在范围内

  static List<int> getSportData() {
    return CrcTools.encryptCmd([cmdQueryData_0x09, queryDataSport_0x04]);
  }

  static List<int> getHCJData(int num) {
    return CrcTools.encryptCmd([cmdQueryData_0x09, queryDataSport_0x06, num]);
  }
  static List<int> getMainInfo_01Data() {
    return CrcTools.encryptCmd([cmdQueryParam_0x01]);
  }

  static List<int> getDeviceState0902CMD() {
    return CrcTools.encryptCmd([cmdQueryData_0x09, queryDataState_0x02]);
  }

  // static List<List<int>> getStartBeforeCMDs() {
  //   List<List<int>> cmds = [
  //     CrcTools.encryptCmd([cmdQueryParam_0x01]),
  //   ];
  //   return cmds;
  // }

  static List<List<int>> getStarCMDs() {
    List<List<int>> cmds = [
      CrcTools.encryptCmd([cmdControl_0x05, controlReset]),
    ];
    return cmds;
  }

  static List<int> getStopCmd() {
    return CrcTools.encryptCmd([cmdControl_0x05, controlStop]);
  }

  static List<int> getOutageCMD(bool goStart) {
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      (goStart ? 04 : 02),
    ]);
  }

  static List<int> getDeviceConfig(int bobao, int handleMode, int changeInStart, bool isKG) {
    return CrcTools.encryptCmd([
      cmdControl_0x03,
      queryDeviceCtrl_0x01,
      bobao,
      handleMode,
      changeInStart,
      isKG ? 0 : 1
    ]);
  }

  static List<int> getVolumeCMDCtrl(int volume) {
    // data.bobaoVolume = volume;
    return CrcTools.encryptCmd([
      cmdDeviceConf_0x0C,
      setVolume_0x0D,
      volume
    ]);
  }

  static List<int> getVolumeCMDShow() {
    return CrcTools.encryptCmd([
      cmdDeviceConf_0x0C,
      getVolume_0x0B,
    ]);
  }

  static List<int> getReSet() {
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      01
    ]);
  }

  static List<int> getReCode(int type, int brand, int deviceCode) {
    List<int> l = CrcTools.encryptCmd([
      2,
      type~/256,
      (type % 256),
      brand~/256,
      (brand % 256),
      deviceCode ~/ 256,
      (deviceCode % 256),
    ], needSplit: false);
    return l;
  }

  static List<int> getReBootBlue() {
    return CrcTools.encryptCmd([
      cmdDeviceConf_0x0C,
      0
    ]);
  }

  static List<int> writeSNCode(String name) {
    Uint8List byte = Utf8Encoder().convert(name);
    List<int> list = [];
    if (byte.length > 16) {
      list.addAll(byte.sublist(0, 16));
    }else {
      list.addAll(byte);
      while (list.length < 16) {
        list.add(0);
      }
    }
    list.insert(0, 0x1C);
    return CrcTools.encryptCmd(list, needSplit: false);
  }

  static List<int> readSNCode() {
    return CrcTools.encryptCmd([
      0x1D,
    ]);
  }


  static List<int> getReBLEName(String name) {
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
    list.insertAll(0, [cmdDeviceConf_0x0C, controlReBLE]);
    return CrcTools.encryptCmd(list, needSplit: false);
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


  static List<int> getHengLiCMD(double weight) {
    // print('BBBBBBB  $weight  ${(weight*10)~/256} - ${((weight * 10).toInt() % 256)}');
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      hengLiMode,
      (weight*10)~/256,
      ((weight * 10).toInt() % 256),
    ]);
  }

  static List<int> getLiXinCMD(double weight) {
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      liXinLiMode,
      (weight*10)~/256,
      ((weight * 10).toInt() % 256),
    ]);
  }

  static List<int> getTanLiCMD(double weight) {
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      tanLiMode,
      (weight*10)~/256,
      ((weight * 10).toInt() % 256),
    ]);
  }

  static List<int> getSpeedCmd(double weight) {
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      speedMode,
      (weight*10)~/256,
      ((weight * 10).toInt() % 256),
    ]);
  }

  static List<int> getGearCMD(int leftLevel) {
    return CrcTools.encryptCmd([
      cmdControl_0x05,
      gearMode,
      0,
      leftLevel,
    ]);
  }
}