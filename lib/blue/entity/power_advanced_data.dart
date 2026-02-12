import 'package:cabina_ble/blue/base/base_device_data.dart';
import 'package:cabina_ble/blue/enum/power_mode.dart';

class PowerAdvancedData extends BaseDeviceData {
  int brandCode = 0;
  int deviceCode = 10000;
  int deviceType = 34;

  int version = 4;
  int subVersion = 0;
  /// 0:KG 1:LB
  int unit = 0;
  int errorCode = 0;
  /// Number of motor groups
  int motorGroupNumber = 3;

  ///The current group number displayed on the device's knob header.
  int curKnobNumber = 0;

  int emergencyStop = 0;

  /// Basic maximum and minimum weight parameters for Motor Group 1
  int mainMotorCount = 2;
  int mainMaxWeightMe = 300;
  int mainMinWeightMe = 30;
  int mainStepSizeMe = 1;
  int mainMaxWeightIm = 300;
  int mainMinWeightIm = 30;
  int mainStepSizeIm = 1;


  /// Basic maximum and minimum weight parameters for Motor Group 2
  int armMotorCount = 2;
  int armMaxWeightMe = 300;
  int armMinWeightMe = 30;
  int armStepSizeMe = 1;
  int armMaxWeightIm = 300;
  int armMinWeightIm = 30;
  int armStepSizeIm = 1;

  /// Basic maximum and minimum weight parameters for Motor Group 3
  int legMotorCount = 1;
  int legMaxWeightMe = 300;
  int legMinWeightMe = 30;
  int legStepSizeMe = 1;
  int legMaxWeightIm = 300;
  int legMinWeightIm = 30;
  int legStepSizeIm = 1;

  ///Seat, Back, Slider parameters
  int backMinDegree = 0;
  int backMaxDegree = 180;
  int seatMinDegree = 0;
  int seatMaxDegree = 180;

  /// Current backrest, seat, and left/right slider data
  int curBackDegree = 0;
  int curSeatDegree = 0;
  int curLeftArmSwing = 0;
  int curRightArmSwing = 0;
  ///Mode parameters
  ///
  ///
  ///The current status and mode of the three motor sets
  int mainStatus = 0;
  int mainMode = 0;
  int armStatus = 0;
  int armMode = 0;
  int legStatus = 0;
  int legMode = 0;
  /// current number of active motor groups
  bool isStart = false;
  int curMotorGroup = 0;

  ///Current mode
  PowerMode curMode = PowerMode.standard;

  ///Mode parameters
  /// standard parameters
  int modeStandardWeight = 0;
  /// eccentric parameters
  int modeEccentricForce = 0;
  int modeConcentricForce = 0;
  /// elastic parameters
  int modeInitialForce = 0;
  int modeMaximumForce = 0;
  int modeSpringLength = 0;
  /// strength measurement  parameters
  int modeLinearVelocity = 0;
  /// isometric parameters
  int modeCableLength = 0;
  ///引体向上
  int assistValue = 0;
  int raiseHeight = 0;

  ///Real-time weight on the left
  int curLeftWeight = 0;
  ///Real-time weight on the right
  int curRightWeight = 0;
  int curLeftCount = 0;
  int curRightCount = 0;
  int curLeftCableLength = 0;
  int curRightCableLength = 0;
  int curRightLinearVelocity = 0;
  int curLeftLinearVelocity = 0;
  int curLeftRPM = 0;
  int curRightRPM = 0;

  int legWeight = 0;
  int legCounts = 0;
  int legCableLength = 0;
  int legLinearVelocity = 0;
  int legRPM = 0;

  int pressureSensor = 0;

  ///handle button press
  int handlePress = 0;

  updateMotorStatus() {
    if (mainStatus == 1) {
      isStart = true;
      curMotorGroup = 0;
      curMode = PowerMode.fromInt(mainMode);
    } else if (armStatus == 1) {
      isStart = true;
      curMotorGroup = 1;
      curMode = PowerMode.fromInt(armMode);
    } else if (legStatus == 1) {
      isStart = true;
      curMotorGroup = 2;
      curMode = PowerMode.fromInt(legMode);
    } else {
      isStart = false;
      // If no motor is in the start state, the default value is 0
      curMotorGroup = 0;
    }
  }

  unitStr() {
    return unit == 0 ? "KG" : "LB";
  }

}