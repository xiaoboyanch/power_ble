enum RHDeviceCode {

  walkF1(10100),
  walkL400(10101),
  walkL400B(10102),
  walkP1(10000),
  walkP2Manual(10001),
  walkP2Auto(10002),
  walkP2Move(10003),
  walkP3Manual(10200),
  walkP3Auto(10201),
  walkP3Simple(10202),
  walkP5(10203);

  final int value;

  const RHDeviceCode(this.value);

  static RHDeviceCode fromInt(int value) {
    switch (value) {
      case 10100:
        return walkF1;
      case 10101:
        return walkL400;
      case 10102:
        return walkL400B;
      case 10000:
        return walkP1;
      case 10001:
        return walkP2Manual;
      case 10002:
        return walkP2Auto;
      case 10200:
        return walkP3Manual;
      case 10201:
        return walkP3Auto;
      case 10202:
        return walkP3Simple;
      case 10203:
        return walkP5;
      default:
        return walkP1;
    }
  }

  static bool checkIncline(int value){
    switch (value) {
      case 10001:
      case 10002:
      case 10003:
      case 10200:
      case 10201:
      case 10203:
        return true;
      default:
        return false;
    }
  }

  static bool checkInclineFunction(int value) {
    switch (value) {
      case 10002:
      case 10003:
      case 10201:
      case 10203:
        return true;
      default:
        return false;
    }
  }

  static bool checkWalk(int value) {
    switch (value) {
      case 10000:
      case 10001:
      case 10002:
        return true;
      default:
        return false;
    }
  }

  static bool checkWalkCalc(int value) {
    switch (value) {
      case 10000:
      case 10001:
        return true;
      default:
        return false;
    }
  }

  static bool checkP2(int value) {
    switch (value) {
      case 10001:
      case 10002:
        return true;
      default:
        return false;
    }
  }

  static bool isTreadmill(int value) {
    switch (value) {
      case 10200:
      case 10201:
      case 10203:
        return true;
      default:
        return false;
    }
  }
}