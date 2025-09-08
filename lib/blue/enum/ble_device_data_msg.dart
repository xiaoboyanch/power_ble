enum BleDeviceDataMsg {
  ///设备信息更新 0x01
  deviceInfoUpdate_0x01(1),
  /// 0x02
  statusUpdate_0x02(2),
  ///查询数据更新 0x04
  dataQueryUpdate_0x04(4),
  /// 错误报告
  orderError_0x0E(14),
  /// SNCode
  snCode_0x1D(29),
  ///含有特殊性质的数据
  ///收到操作回调
  deviceAck_0xD0(208),
  ///适配拖基其他跑步机重新下发速度
  resetSpeed_0xD1(209),
  ///展智带扶手的走步机 判断扶手状态
  checkHandle_0xD2(210),

  ///走步机步数
  updateStep(11),
  ///走步机更新抖抖鸡
  updateShake(12);

  final int value;

  const BleDeviceDataMsg(this.value);
}