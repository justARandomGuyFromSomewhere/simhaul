class ResistanceInputs {
  final double grossWeightTons;
  final double gradePct;
  final double rrPct;
  final double horsepower;
  final double mechEff;
  final double rimpull0;
  final double rimpull1;
  final double rimpull2;
  final double rimpull3;
  final double maxAccelMphS;
  final double maxDecelMphS;

  const ResistanceInputs({
    this.grossWeightTons = 198.0,
    this.gradePct = 6.0,
    this.rrPct = 3.0,
    this.horsepower = 1150.0,
    this.mechEff = 0.85,
    this.rimpull0 = 155000.0,
    this.rimpull1 = 156000.0,
    this.rimpull2 = 159500.0,
    this.rimpull3 = 167500.0,
    this.maxAccelMphS = 3.0,
    this.maxDecelMphS = 3.2,
  });
}

class TractionEvaluationRow {
  final double speedMph;
  final double rimpullLb;
  final double grLb;
  final double grTons;
  final double rrLb;
  final double rrTons;
  final double totalResLb;
  final double totalResTons;
  final double effGradePct;
  final double netPullLb;
  final double accMphS;

  const TractionEvaluationRow({
    required this.speedMph,
    required this.rimpullLb,
    required this.grLb,
    required this.grTons,
    required this.rrLb,
    required this.rrTons,
    required this.totalResLb,
    required this.totalResTons,
    required this.effGradePct,
    required this.netPullLb,
    required this.accMphS,
  });
}
