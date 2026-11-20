class UnitConversions {
  static const double kgToLb = 2.20462262185;
  static const double metricTonToLb = 2204.62262185;
  static const double fpsPerMph = 1.466;
  static const double kmhPerMph = 1.609344;
  static const double mpsPerFps = 0.3048;

  static double weightToLb(double value, String unit) {
    switch (unit.trim().toLowerCase()) {
      case 'lb':
      case 'lbs':
        return value;
      case 'kg':
      case 'kgs':
        return value * kgToLb;
      case 't':
      case 'ton':
      case 'tons':
      case 'mt':
        return value * metricTonToLb;
      default:
        return value;
    }
  }
}
