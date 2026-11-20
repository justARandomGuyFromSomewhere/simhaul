import 'dart:math';
import '../models/traction_models.dart';

class TractionEngine {
  static double calculateRimpullLb(double speedMph, ResistanceInputs inp) {
    if (speedMph <= 0.0) return inp.rimpull0;
    if (speedMph < 1.0) return inp.rimpull0 + (inp.rimpull1 - inp.rimpull0) * speedMph;
    if (speedMph < 2.0) return inp.rimpull1 + (inp.rimpull2 - inp.rimpull1) * (speedMph - 1.0);
    if (speedMph < 3.0) return inp.rimpull2 + (inp.rimpull3 - inp.rimpull2) * (speedMph - 2.0);
    return (513.35 * inp.horsepower * inp.mechEff) / max(speedMph, 0.1);
  }

  static (double grLb, double grTons) calculateGradeResistance(double gradePct, double gvwTons) {
    final grLb = 20.0 * gradePct * gvwTons;
    return (grLb, grLb / 2000.0);
  }

  static (double rrLb, double rrTons) calculateRollingResistance(double rrPct, double gvwTons) {
    final rrLb = 20.0 * rrPct * gvwTons;
    return (rrLb, rrLb / 2000.0);
  }

  static TractionEvaluationRow evaluateAtSpeed(ResistanceInputs inp, double speedMph) {
    final (grLb, grTons) = calculateGradeResistance(inp.gradePct, inp.grossWeightTons);
    final (rrLb, rrTons) = calculateRollingResistance(inp.rrPct, inp.grossWeightTons);
    final totalResLb = grLb + rrLb;
    final totalResTons = grTons + rrTons;
    final effGradePct = inp.gradePct + inp.rrPct;
    final rimpLb = calculateRimpullLb(speedMph, inp);
    final netPullLb = rimpLb - totalResLb;
    final rawAcc = 21.95 * (netPullLb / max(inp.grossWeightTons * 2000.0, 1.0));
    final accMphS = max(-inp.maxDecelMphS.abs(), min(inp.maxAccelMphS.abs(), rawAcc));

    return TractionEvaluationRow(
      speedMph: speedMph,
      rimpullLb: rimpLb,
      grLb: grLb,
      grTons: grTons,
      rrLb: rrLb,
      rrTons: rrTons,
      totalResLb: totalResLb,
      totalResTons: totalResTons,
      effGradePct: effGradePct,
      netPullLb: netPullLb,
      accMphS: accMphS,
    );
  }
}
