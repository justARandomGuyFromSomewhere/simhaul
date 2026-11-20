import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/conhaul/conhaul_screen.dart';
import '../screens/simhaul/simhaul_screen.dart';
import '../screens/safety_velocity/safety_velocity_screen.dart';
import '../screens/traction/rimpull_gr_rr_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String conhaul = '/conhaul';
  static const String simhaul = '/simhaul';
  static const String safetyVelocity = '/safety-velocity';
  static const String rimpullGrRr = '/rimpull-gr-rr';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        conhaul: (context) => const ConhaulScreen(),
        simhaul: (context) => const SimhaulScreen(),
        safetyVelocity: (context) => const SafetyVelocityScreen(),
        rimpullGrRr: (context) => const RimpullGrRrScreen(),
      };
}
