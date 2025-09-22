// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:get/get.dart';
// import '../../base_tool/log_utils.dart';
// import '../../base_views/rh_toast.dart';
// import '../ble_manager.dart';
// import '../commands/power_commands.dart';
// import '../entity/power_device_data.dart';
// import '../entity/power_device_sport_mode.dart';
// import '../entity/power_equipment_control.dart';
// import '../entity/rh_blue_scan_result.dart';
// import '../enum/ble_device_data_msg.dart';
// import '../enum/ble_device_state_msg.dart';
// import '../enum/device_type.dart';
// import '../enum/llz_power_mode.dart';
// import '../repository/power_repository.dart';
// import '../tools/crc_tools.dart';
// import '../tools/tools.dart';
// import '../uuid/ble_uuid.dart';
//
// import '../base/ble_model.dart';
//
// class PowerModel extends BleModel {
//
//   late PowerRepository _repository;
//   final PowerDeviceData mPowerData = PowerDeviceData();
//   List<RHBlueScanResult> bleResultList = [];
//   StreamController<BleDeviceDataMsg> get bleDeviceDataController => _repository.bleDeviceDataController;
//   StreamSubscription? _deviceStateSubscription;
//   PowerModel() {
//     setDeviceType(RHDeviceType.powerBoard);
//     _repository = PowerRepository(bleDeviceStateController);
//     mQueryCmdData = PowerCommands.getSportData();
//     _deviceStateSubscription = bleDeviceStateController.stream.listen( (msg) {
//       LogUtils.d("蓝牙状态变化： $msg");
//         switch (msg) {
//           //一切都准备好了
//           case BleDeviceStateMsg.deviceCheckSuccess: {
//             RHToast.dismiss();
//             cleanParamsTimer();
//             startCheckDeviceState();
//           }
//           case BleDeviceStateMsg.bleDisconnect:{
//
//           }
//           case BleDeviceStateMsg.bleBleReConnect:{
//
//           }
//           default:
//             break;
//         }
//     });
//     // _repository.bleDeviceDataController.stream.listen( (msg) {
//     // });
//   }
//
//   @override
//   void startScan() async{
//     if (await checkPermission()) {
//       super.startScan();
//       int _flag = 0;
//       BleManager.instance.startScan([Guid(BlueUUID.FS_UUID), Guid(BlueUUID.FTMS_UUID)], [], [RHDeviceType.powerBoard, RHDeviceType.softPower], (result) {
//         int newFlag = ++_flag;
//         Future.delayed(const Duration(milliseconds: 300), () {
//           if (newFlag == _flag) {
//             // if (type == RHDeviceType.powerBoard) {
//               sortScanResult(result);
//             // }
//           }
//         });
//
//       });
//     }
//   }
//
//   @override
//   sortScanResult(List<ScanResult> result) async {
//      List<RHBlueScanResult> resultList = await _repository.sortScanResult(result, [RHDeviceType.powerBoard, RHDeviceType.softPower]);
//      LogUtils.d("ajdajdajdjahdsa : ${resultList.length}");
//      if (resultList.isNotEmpty){
//        scanSize = resultList.length;
//        BleManager.instance.stopScan();
//        bleResultList.clear();
//        if (resultList.isNotEmpty) {
//          bleResultList.addAll(resultList);
//        }
//        bleDeviceStateController.add(BleDeviceStateMsg.deviceScanResult);
//
//        // if (resultList.length == 1) {
//        //   selectDevice(resultList[0]);
//        //   connectDevice();
//        // }else{
//        //   RHToast.dismiss();
//        //   showSelectDeviceDialog(resultList, (value) {
//        //     Navigator.pop(Get.context!);
//        //     selectDevice(value);
//        //     connectDevice();
//        //   });
//        // }
//      }
//   }
//
//   @override
//   void selectDevice(RHBlueScanResult scanResult) {
//     super.selectDevice(scanResult);
//     connectDevice();
//   }
//
//   @override
//   void connectDevice() async {
//     if (mDevice == null) return;
//     bleDeviceStateController.add(BleDeviceStateMsg.bleStartConnect);
//     BleManager.instance.registerDeviceStreamSubscription(mDevice!);
//     BleManager.instance.stopScan();
//     super.connectDevice();
//   }
//
//   ///蓝牙连接成功后开始检查设备连接状态
//   @override
//   void deviceConnected() {
//     if (mDevice == null) return;
//     if (!bleDeviceStateController.isClosed) {
//       bleDeviceStateController.add(BleDeviceStateMsg.bleConnect);
//       deviceDiscovery(BlueUUID.FS_UUID, BlueUUID.POWER_NOTIFY, write: BlueUUID.POWER_WRITE);
//     }
//   }
//
//   @override
//   void deviceDisconnected() {
//   }
//
//   int _sendCount = 0;
//   @override
//   notifyCharacteristicValue(List<int> event) {
//     if (event.length > 5) {
//       List<int> value = CrcTools.receiveDecodeCmd(event);
//       if (value[3] == 9 && value[4] == 4) {
//
//       }else {
//         LogUtils.d("notifyCharacteristicValue111 ${Tools.getNiceHexArray(event)}");
//       }
//       if (CrcTools.checkCRC(value)) {
//         int code = _repository.handleCharacteristic(value, mPowerData, mDeviceInfo!);
//         if (code == PowerRepository.CODE_KG_CHANGE) {
//           _reGetDeviceInfo(true);
//           _sendCount = 0;
//         }else if (_sendCount++ % 50 == 49) {
//           _reGetDeviceInfo(false);
//         }
//
//       }else {
//         if (value.length == 14) { /// 有一个版本,拿到的0902没有CRC数据,结尾也不对.特地兼容
//           const List<int> targetList = [245, 14, 0, 9, 2, 0, 0, 0];
//           int i=0;
//           bool gogogo = true;
//           while (i < targetList.length) {
//             int targetInt = targetList[i];
//             int valueInt = value[i];
//             if (targetInt != valueInt) {
//               gogogo = false;
//             }
//             i++;
//           }
//           if (gogogo) {
//             _repository.handleCharacteristic(value, mPowerData, mDeviceInfo!);
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   void sendMessage(BleDeviceStateMsg msg) {
//     bleDeviceStateController.add(msg);
//     switch (msg) {
//     ///通知设备通道打开后开始初始化
//       case BleDeviceStateMsg.deviceOpenCharacter: {
//         ///打开通道后发送0x01指令
//         bleDeviceStateController.add(BleDeviceStateMsg.deviceChecking);
//         startCheckDeviceInfo();
//       }
//       case BleDeviceStateMsg.deviceOpenCharacterError: {
//
//       }
//       default:
//         break;
//     }
//     print('AAAAAA  sendMessage $msg');
//     bleDeviceStateController.add(msg);
//   }
//
//   sendCmd(List<int> value) {
//     checkDeviceInfo(value);
//   }
//
//   void _reGetDeviceInfo(bool hasMain) {
//     /// 判断code值,发现重量单位切换了,重新获取数据
//     if (hasMain) {
//       mCmdData.add(PowerCommands.getMainInfo_01Data());
//     }
//     mCmdData.add(PowerCommands.getDeviceState0902CMD());
//   }
//
//   /// 健身站模式调节
//   /// 标准:  3~30   D=6
//   /// 离心:  6~ 30  D=10
//   /// 弹力:  10~30 D=15
//   /// 速度:  10~30 D=20
//   /// 这些切换后的初始数据是定好的,不要乱改
//   void onLLZOutageDevice({bool goStart=false}) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setOutageCmd(goStart);
//     sendPowerControl(control);
//   }
//   void onWeightChange(LLZPowerMode mode, double weight) {
//     switch (mode) {
//       case LLZPowerMode.hengLi:
//         onLLZHengLiBtnClick(weight: weight);
//         break;
//       case LLZPowerMode.liXin:
//         onLLZLiXinBtnClick(weight: weight);
//         break;
//       case LLZPowerMode.tanLi:
//         onLLZTanLiBtnClick(weight: weight);
//         break;
//       case LLZPowerMode.speed:
//         onLLZSpeedBtnClick(weight: weight);
//         break;
//       case LLZPowerMode.gear:
//         onLLZHengLiBtnClick(weight: weight);
//         break;
//       default:
//         break;
//     }
//   }
//   void onLLZHengLiBtnClick({double weight = 6}) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setHengLiCMD(weight);
//     sendPowerControl(control);
//   }
//   void onLLZLiXinBtnClick({double weight = 10}) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setLiXinCMD(weight);
//     sendPowerControl(control);
//   }
//   void onLLZTanLiBtnClick({double weight = 15}) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setTanLiCMD(weight);
//     sendPowerControl(control);
//   }
//   void onLLZSpeedBtnClick({double weight = 20}) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setSpeedCMD(weight);
//     sendPowerControl(control);
//   }
//
//   //  改蓝牙名
//   void onChangeBLEName(String bleName) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setBLEName(name: bleName);
//     sendPowerControl(control);
//   }
//
//   //  改音乐名
//   void onChangeMusicName(String musicName) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setMusicName(name: musicName);
//     sendPowerControl(control);
//   }
//
//   //重启蓝牙
//   void onRebootBlue() {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.rebootBlue();
//     sendPowerControl(control);
//   }
//
//   void onResetParams() {
//     PowerDeviceControl control1 = PowerDeviceControl();
//     control1.setResetDevice();
//     sendPowerControl(control1);
//     sendPowerControl(control1);
//   }
//   //  改型号
//   void onChangeDeviceCode({int dt=31, int brand=168, int deviceCode=24010}) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setDeviceCode(
//         type: dt,
//         brand: brand,
//         deviceCode: deviceCode
//     );
//     sendPowerControl(control);
//   }
//
//   void onSetUserCustomConfig() {
//     // PowerDeviceControl control = PowerDeviceControl();
//     // AppModel apmd = AppModel.getMgr();
//     // control.setLLZDeviceConfig(
//     //     apmd.llzBobao==1 ? 1 : 0,
//     //     apmd.llzHandleMode,
//     //     apmd.llzChangeInStart,
//     //     apmd.llzIsKG
//     // );
//     // sendPowerControl(control);
//   }
//   void onSetCurrentDeviceConfig(bool isKG) {
//     PowerDeviceControl control = PowerDeviceControl();
//     // AppModel apmd = AppModel.getMgr();
//     // control.setLLZDeviceConfig(
//     //     apmd.llzBobao==1 ? 1 : 0,
//     //     apmd.llzHandleMode,
//     //     apmd.llzChangeInStart,
//     //     isKG
//     // );
//     sendPowerControl(control);
//   }
//
//   void onLLZSetup() {
//     // AppModel apmd = AppModel.getMgr();
//     // //  音量设置
//     // onLLZVolumeChange(apmd.llzBobaoVolume);
//     // //  播报开关
//     // onSetUserCustomConfig();
//     // //  这个要延时获取,不然按钮耗时太长,影响了其他操作
//     // Future.delayed(const Duration(seconds: 1), () {
//     //   onLLZGetVolume();
//     //   // checkDeviceInfo(PowerCommands.getDeviceState0902CMD());
//     // });
//     //  屏幕常亮
//     // if (apmd.screenLight) {
//     //   WakelockPlus.enable();
//     // }
//   }
//
//   //  获取健身站音量
//   void onLLZGetVolume(){
//     PowerDeviceControl control1 = PowerDeviceControl();
//     control1.getVolumeValue();
//     sendPowerControl(control1);
//   }
//   //  设置健身站音量
//   void onLLZVolumeChange(int value) {
//     PowerDeviceControl control = PowerDeviceControl();
//     control.setVolumeControl(value);
//     // AppModel.getMgr().llzBobaoVolume = value;
//     sendPowerControl(control);
//   }
//
//   void sendPowerControl(PowerDeviceControl value) {
//     List<int>? cmd;
//     switch (value.deviceMode) {
//       case PowerDeviceMode.hengLi:
//         {
//           cmd = PowerCommands.getHengLiCMD(value.leftWeight);
//           break;
//         }
//       case PowerDeviceMode.liXin:
//         {
//           cmd = PowerCommands.getLiXinCMD(value.leftWeight,
//           );
//           break;
//         }
//       case PowerDeviceMode.tanLi:
//         {
//           cmd = PowerCommands.getTanLiCMD(value.leftWeight,
//           );
//           break;
//         }
//       case PowerDeviceMode.speed:
//         {
//           cmd = PowerCommands.getSpeedCmd(value.leftWeight,
//           );
//           break;
//         }
//       case PowerDeviceMode.fluidForce:
//         {
//           cmd = PowerCommands.getGearCMD(value.leftLevel);
//           break;
//         }
//       case PowerDeviceMode.deviceConfig:
//         {
//           cmd = PowerCommands.getDeviceConfig(
//             value.isKG,
//           );
//           break;
//         }
//       case PowerDeviceMode.goStart:
//         {
//           cmd = PowerCommands.getOutageCMD(value.goStart);
//           break;
//         }
//       case PowerDeviceMode.bobao:
//         {
//           cmd = PowerCommands.getVolumeCMDCtrl(value.leftLevel);
//           break;
//         }
//       case PowerDeviceMode.bobaoVolume:
//         {
//           cmd = PowerCommands.getVolumeCMDShow();
//           break;
//         }
//       case PowerDeviceMode.factoryConfig:
//         {
//           switch (value.type) {
//             case PowerDeviceControl.TYPE_ReCode: {
//               cmd = PowerCommands.getReCode(value.dt, value.brand, value.deviceCode);
//             }
//             case PowerDeviceControl.TYPE_ReBLE: {
//               cmd = PowerCommands.getReBLEName(value.BLEName);
//             }
//             case PowerDeviceControl.TYPE_ReMusicName: {
//               cmd = PowerCommands.getReMusicName(value.BLEName);
//             }
//             case PowerDeviceControl.TYPE_ReBoot: {
//               cmd = PowerCommands.getReBootBlue();
//             }
//             case PowerDeviceControl.TYPE_PlayAudio: {
//               // cmd = PowerCommands.getPlayAudio(value.leftLevel);
//             }
//             default:{
//
//             }
//           }
//         }
//       default:
//         if (value.isReset) {
//           cmd = PowerCommands.getReSet();
//         }
//         break;
//     }
//
//     if (cmd != null) {
//       // mCmdData.add(cmd);
//       LogUtils.d('蓝牙通知-发送力量控制的命令 $cmd');
//       // checkDeviceInfo(cmd);
//       mCmdData.add(cmd);
//     }
//   }
//
//   @override
//   void clean() {
//     _deviceStateSubscription?.cancel();
//     _deviceStateSubscription = null;
//     _repository.dispose();
//   }
//
//   stopConnect() {
//     disconnectDevice(clean:  true);
//     disposeConnect();
//   }
//
// }