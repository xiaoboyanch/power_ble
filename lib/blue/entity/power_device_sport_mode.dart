enum PowerDeviceMode {
  none,
  factoryConfig,  ///  工厂配置
  snCode,  ///  木卫六SN 码

  goStart, /// 启动停止

  bobao, /// 播报开关
  bobaoVolume, /// 音量调节

  deviceConfig, /// 手柄模式 /// 启动后档位可调

  // changeInStart,

  ///模式：设置恒力
  hengLi,

  ///模式：设置离心/向心模式
  liXin,

  ///模式：设置弹力模式
  tanLi,

  ///模式：设置弹力模式
  speed,

  ///模式：设置流体力模式
  fluidForce
}
