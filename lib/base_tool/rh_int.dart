extension IntExtensions on int {
  bool updateIfChanged(int newValue, Function(int) updater) {
    if (this != newValue) {
      updater(newValue);
      return true;
    }
    return false;
  }
}