import 'package:cabina_ble/base_tool/rh_null.dart';

enum PowerMode {
  standard(0),
  eccentric(1),
  elastic(2),
  isokinetic(3),
  isometric(4);

  final int value;

  const PowerMode(this.value);

  static fromInt(dynamic value) {
    int num = RHNull.getInt(value);
    switch (num) {
      case 0:
        return standard;
      case 1:
        return eccentric;
      case 2:
        return elastic;
      case 3:
        return isokinetic;
      case 4:
        return isometric;
      default:
        return standard;
    }
  }
}