class RoadSegmentSpeedCheck {
  final int segmentId;
  final String name;
  final double maxSpeedMph;
  final double safetyMaxMph;

  const RoadSegmentSpeedCheck({
    required this.segmentId,
    required this.name,
    required this.maxSpeedMph,
    required this.safetyMaxMph,
  });

  double get effectiveCapMph => safetyMaxMph < maxSpeedMph ? safetyMaxMph : maxSpeedMph;

  String get bindingLimit {
    if (safetyMaxMph < maxSpeedMph) return 'Safety Velocity Cap';
    if (maxSpeedMph < safetyMaxMph) return 'Segment Speed Cap';
    return 'Equal Cap';
  }
}

class SafetyVelocityResult {
  final double mph;
  final double fps;
  final double kmh;
  final double mps;
  final List<RoadSegmentSpeedCheck> segmentChecks;

  const SafetyVelocityResult({
    required this.mph,
    required this.fps,
    required this.kmh,
    required this.mps,
    required this.segmentChecks,
  });
}
