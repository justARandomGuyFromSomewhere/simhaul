import '../core/unit_conversions.dart';
import '../models/safety_velocity_models.dart';

class SafetyVelocityEngine {
  static SafetyVelocityResult evaluate(
    double safetyMaxMph,
    List<(String, double)> segmentCapsMph,
  ) {
    final mph = safetyMaxMph < 0 ? 0.0 : safetyMaxMph;
    final fps = mph * UnitConversions.fpsPerMph;
    final kmh = mph * UnitConversions.kmhPerMph;
    final mps = fps * UnitConversions.mpsPerFps;

    final checks = <RoadSegmentSpeedCheck>[];
    for (int i = 0; i < segmentCapsMph.length; i++) {
      checks.add(
        RoadSegmentSpeedCheck(
          segmentId: i + 1,
          name: segmentCapsMph[i].$1,
          maxSpeedMph: segmentCapsMph[i].$2,
          safetyMaxMph: mph,
        ),
      );
    }

    return SafetyVelocityResult(
      mph: mph,
      fps: fps,
      kmh: kmh,
      mps: mps,
      segmentChecks: checks,
    );
  }
}
