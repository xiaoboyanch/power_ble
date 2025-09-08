enum BlueAckEnum {
  changeCode(2),
  forceLoading(54),
  modeAndWeight(56),
  blueName(123),
  musicName(126),
  bobaoVolume(1213),
  bobao_KG(301);

  final int value;

  const BlueAckEnum(this.value);

  String enumToString() {
    switch (this) {
      case BlueAckEnum.changeCode:
        return '机型吗, 型号, 品牌码';
      case BlueAckEnum.blueName:
        return '蓝牙名称';
      case BlueAckEnum.musicName:
        return '音乐名称';
      case BlueAckEnum.bobaoVolume:
        return '播报音量';
      case BlueAckEnum.bobao_KG:
        return '播报开关, 重量单位';
      default:
        return '';
    }
  }
}