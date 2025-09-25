class BaseDeviceData {
  int times = 0;
  int distance = 0;
  int originalCalories = 0;

  double get kcal => originalCalories / 10;
  int originalSpeed = 0;

  double get speed => originalSpeed / 10;

  int slope = 0;
  int resistance = 1;

  int sendSpeed = 0;
  int sendSlope = 0;
  int sendResistance = 0;

  double get controlSpeed => sendSpeed / 10;

  int get controlSlope => sendSlope;

  int get controlResistance => sendResistance;

  int prevStateCode = 0;
  int heartRare = 0;

  int paragraph = 0;
  bool hasBracelet = false;
  int braceletHeartRare = 0;

  int isSupportPause = -1;
  int countdown = 0;
  int imperial = -1; //-1没有传 0公里 1英里

  int power = 0;
  int minSlope = 0;
  int minSpeed = 0;
  int minResistance = 0;

  int maxSlope = 0;
  int maxSpeed = 0;
  int maxResistance = 0;

  bool get canControlSpeed => maxSpeed > 0;

  bool get canControlSlope => maxSlope > 0;

  bool get canControlResistance => maxResistance > 0;
}

