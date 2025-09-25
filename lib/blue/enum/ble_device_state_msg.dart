enum BleDeviceStateMsg {
  ///Feedback after checking that the Bluetooth communication of the device is normal
  deviceCheckSuccess,
  ///Feedback after the device's Bluetooth checks for abnormal communication
  deviceCheckError,
  ///After the device's Bluetooth is connected, start checking whether the communication is normal
  deviceChecking,
  ///Open the Character
  deviceOpenCharacter,
  ///Failed to open the channel
  deviceOpenCharacterError,
  ///The device's Bluetooth starts to connect
  bleStartConnect,
  ///The device's Bluetooth connection was successful
  bleConnect,
  ///The Bluetooth connection of the device failed
  bleConnectError,
  ///The Bluetooth connection of the device is disconnected
  bleDisconnect,
  ///The Bluetooth switch of the device is turned off
  bleDisconnectBySwitch,
  ///The device failed to send the message
  bleCharacteristicError,
  ///The equipment is powered off.
  bleDisconnectByPowerOff,
  ///Reconnect after the Bluetooth is disconnected
  bleBleReConnect,
  ///Bluetooth list data
  deviceScanResult,
  ///Metric and imperial system status
  deviceUnitState,
}

