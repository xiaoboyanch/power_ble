enum BleDeviceDataMsg {
  ///Equipment information query 0x01
  deviceInfoUpdate_0x01(1),
  dataQueryUpdate_0x02(2),
  dataQueryUpdate_0x03(3),
  dataQueryUpdate_0x04(4),
  dataQueryUpdate_0x10(10),
  dateQueryUpdate_0x12(12),
  dataQueryUpdate_0x14(14),
  orderError_0x0E(14),
  deviceAck_0xD0(208);

  final int value;

  const BleDeviceDataMsg(this.value);
}