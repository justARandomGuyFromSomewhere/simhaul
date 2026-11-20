import 'dart:math';
import '../models/simhaul_models.dart';

class SimhaulEngine {
  static double rimpullAtSpeed(double speedMph, SimhaulConfig cfg) {
    if (speedMph <= 0.0) return cfg.rimpull0;
    if (speedMph < 1.0) return cfg.rimpull0 + (cfg.rimpull1 - cfg.rimpull0) * speedMph;
    if (speedMph < 2.0) return cfg.rimpull1 + (cfg.rimpull2 - cfg.rimpull1) * (speedMph - 1.0);
    if (speedMph < 3.0) return cfg.rimpull2 + (cfg.rimpull3 - cfg.rimpull2) * (speedMph - 2.0);
    return (513.35 * cfg.horsepower * cfg.mechEff) / max(speedMph, 0.1);
  }

  static double crfFactor(double ratePct, double years) {
    if (years <= 0.0) return 0.0;
    final r = ratePct / 100.0;
    if (r.abs() < 1e-12) return 1.0 / years;
    final comp = pow(1.0 + r, years).toDouble();
    return (r * comp) / (comp - 1.0);
  }

  static double sampleNormal(double mean, double sd, Random rng, double minVal) {
    double sum = 0.0;
    for (int i = 0; i < 12; i++) {
      sum += rng.nextDouble();
    }
    final z = sum - 6.0;
    return max(minVal, mean + sd * z);
  }

  static double sampleExp(double mean, double sd, Random rng, double minVal) {
    final u = max(1e-9, min(1.0 - 1e-9, rng.nextDouble()));
    return max(minVal, mean - sd * (1.0 + log(1.0 - u)));
  }

  static (double, double) computeAnnualCosts(SimhaulConfig cfg) {
    final crfT = crfFactor(cfg.discountRatePct, cfg.truckLifeYrs);
    final capT = (cfg.truckPurchasePrice - cfg.truckTireCost) +
        (cfg.truckNetLbs * cfg.truckFreightPer100lb) / 100.0;
    final annTruck = (capT - cfg.truckSalvage) * crfT + (cfg.truckOpCostHr * cfg.truckOpHrsYr);

    final crfL = crfFactor(cfg.discountRatePct, cfg.loaderLifeYrs);
    final capL = cfg.loaderPurchasePrice +
        (cfg.loaderWeightLbs * cfg.loaderFreightPer100lb) / 100.0 +
        0.02 * cfg.loaderPurchasePrice;
    final annLoader = (capL - cfg.loaderSalvage) * crfL + (cfg.loaderOpCostHr * cfg.loaderOpHrsYr);

    return (annTruck, annLoader);
  }

  static (double, double, List<SegmentLog>) simulateHaulTravel(SimhaulConfig cfg) {
    const fps = 1.466;
    double totalTimeSec = 0.0;
    double totalDistFt = 0.0;
    final List<SegmentLog> logs = [];

    for (final seg in cfg.segments) {
      final effGrade = seg.gradePct + seg.rrPct;
      double vPot;
      if (effGrade > 0.0) {
        final resTons = (20.0 * effGrade * seg.grossWeightTons) / 2000.0;
        vPot = min(cfg.safetyMaxMph, (513.35 * cfg.horsepower * cfg.mechEff) / max(resTons, 0.1));
      } else {
        vPot = cfg.safetyMaxMph;
      }

      final vCap = min(vPot, seg.maxSpeedMph);
      final vEnd = seg.endSpeedMph > 0.0 ? min(seg.endSpeedMph, vCap) : 0.0;

      double v = vCap >= 1.0 ? 1.0 : vCap;
      double vPeak = v;
      double tSeg = 0.0;
      double sSeg = 0.0;
      int guard = 0;

      while (sSeg < seg.lengthFt && guard < 400) {
        guard++;
        vPeak = max(vPeak, v);
        final rimp = rimpullAtSpeed(v, cfg);
        final netPull = rimp - (20.0 * effGrade * seg.grossWeightTons);
        double acc = 21.95 * (netPull / max(seg.grossWeightTons, 0.1));
        if (seg.gradePct < 0.0 && v > vCap) {
          acc = -cfg.maxDecelMphS.abs();
        }
        acc = max(-cfg.maxDecelMphS.abs(), min(cfg.maxAccelMphS, acc));

        final dt = v < vCap ? (1.0 / max(acc.abs(), 0.1)) : 0.0;
        final ds = dt > 0.0
            ? (fps * max(v - 0.5, 0.5) * dt + 0.5 * acc * fps * pow(dt, 2))
            : 0.0;
        final decDist = v > vEnd
            ? (pow(v, 2) - pow(vEnd, 2)) / max(2.0 * cfg.maxDecelMphS.abs() * fps, 0.1)
            : 0.0;

        if (sSeg + ds + decDist >= seg.lengthFt) {
          final constFt = max(0.0, seg.lengthFt - sSeg - ds - max(0.0, decDist));
          if (constFt > 0.0) {
            if (dt > 0.0) {
              tSeg += dt;
              sSeg += ds;
            }
            tSeg += constFt / max(max(v, 1.0) * fps, 0.1);
            sSeg += constFt;
          }
          if (vEnd > 0.0 && v > vEnd) {
            tSeg += (v - vEnd).abs() / max(cfg.maxDecelMphS, 0.1);
          }
          sSeg = seg.lengthFt;
          break;
        }

        if (dt > 0.0) {
          tSeg += dt;
          sSeg += ds;
        }

        if (v < vCap) {
          v = min(vCap, v + 1.0);
          vPeak = max(vPeak, v);
        } else {
          final remFt = max(0.0, seg.lengthFt - sSeg - max(0.0, decDist));
          tSeg += remFt / max(max(vCap, 1.0) * fps, 0.1);
          sSeg += remFt;
          if (vEnd > 0.0 && vCap > vEnd) {
            tSeg += (vCap - vEnd).abs() / max(cfg.maxDecelMphS, 0.1);
          }
          sSeg = seg.lengthFt;
          break;
        }
      }

      final avgVelFps = sSeg / max(tSeg, 0.1);
      final avgVelMph = avgVelFps / fps;
      final lowerName = seg.name.toLowerCase();
      final isInbound = lowerName.contains('inbound') ||
          lowerName.contains('return') ||
          lowerName.contains('empty') ||
          (seg.gradePct < 0.0 && !lowerName.contains('outbound'));
      final direction = isInbound ? 'Inbound (Return)' : 'Outbound (Haul)';

      totalTimeSec += tSeg;
      totalDistFt += sSeg;

      logs.add(
        SegmentLog(
          segmentId: seg.segmentId,
          direction: direction,
          name: seg.name,
          lengthFt: seg.lengthFt,
          gradePct: seg.gradePct,
          rrPct: seg.rrPct,
          vCapMph: vCap,
          vPeakMph: vPeak,
          vEndMph: vEnd,
          avgVelMph: avgVelMph,
          avgVelFps: avgVelFps,
          wtTons: seg.grossWeightTons,
          distFt: sSeg,
          timeSec: tSeg,
        ),
      );
    }

    return (totalTimeSec, totalDistFt, logs);
  }

  static SimhaulOutput runSimulation(SimhaulConfig cfg) {
    final (travelSec, travelFt, segLogs) = simulateHaulTravel(cfg);
    final rng = Random(cfg.seed);
    final (annTruck, annLoader) = computeAnnualCosts(cfg);
    final activeShiftSec = max(60.0, cfg.shiftHours * 3600.0 - cfg.finishSec);
    final shiftHrs = max(cfg.shiftHours, 0.1);
    final nLoaders = max(1, cfg.numLoaders);

    final List<FleetSummaryRow> summaries = [];
    final int startNt = max(1, cfg.ntMin);
    final int endNt = max(startNt, cfg.ntMax);

    for (int nt = startNt; nt <= endNt; nt++) {
      double totTonsAll = 0.0;
      double totCostAll = 0.0;
      double totTWaitAll = 0.0;
      double totLWaitAll = 0.0;
      double totTBdAll = 0.0;
      double totLBdAll = 0.0;

      for (int sh = 1; sh <= cfg.nShifts; sh++) {
        List<double> elt = List.filled(nt, cfg.prepSec);
        List<int> state = List.filled(nt, 2);
        List<double> loaderClocks = List.filled(nLoaders, cfg.prepSec);

        double shiftTons = 0.0;
        double truckWait = 0.0;
        double loaderWait = 0.0;
        double truckBd = 0.0;
        double loaderBd = 0.0;
        int loads = 0;

        final breaks = [
          [7200.0, 600.0, 0.0],
          [14400.0, 1200.0, 0.0],
          [21600.0, 600.0, 0.0],
        ];
        final trkBdTrigger = max(1, (rng.nextDouble() * 35.0).floor());
        final ldrBdTrigger = max(1, (rng.nextDouble() * 45.0).floor());

        for (int step = 0; step < 4000; step++) {
          final order = List.generate(nt, (i) => i)
            ..sort((a, b) => elt[a].compareTo(elt[b]));
          elt = [for (final i in order) elt[i]];
          state = [for (final i in order) state[i]];

          if (elt[0] > (activeShiftSec - travelSec)) break;

          if (state[0] == 1) {
            elt[0] += travelSec;
            state[0] = 3;
          } else if (state[0] == 3) {
            final spD = sampleNormal(cfg.spotDumpMean, cfg.spotDumpSd, rng, 1.0);
            final dmpT = sampleExp(cfg.dumpTimeMean, cfg.dumpTimeSd, rng, 1.0);
            loads++;
            elt[0] += spD + dmpT;
            state[0] = 2;
          } else {
            int lIdx = 0;
            for (int idx = 1; idx < nLoaders; idx++) {
              if (loaderClocks[idx] < loaderClocks[lIdx]) {
                lIdx = idx;
              }
            }

            for (int bIdx = 0; bIdx < breaks.length; bIdx++) {
              final bTime = breaks[bIdx][0];
              final bDur = breaks[bIdx][1];
              final bUsed = breaks[bIdx][2] > 0.5;
              if (!bUsed && (elt[0] >= bTime || loaderClocks[lIdx] >= bTime)) {
                for (int k = 0; k < nt; k++) {
                  elt[k] += bDur;
                }
                for (int j = 0; j < nLoaders; j++) {
                  loaderClocks[j] += bDur;
                }
                breaks[bIdx][2] = 1.0;
              }
            }

            if (loads == trkBdTrigger && nt >= 2) {
              final bdDur = sampleNormal(cfg.truckBdMeanSec, cfg.truckBdSdSec, rng, 60.0);
              elt[0] += bdDur;
              truckBd += bdDur;
            }

            if (loads == ldrBdTrigger && sh % 5 == 0) {
              final repDur = sampleNormal(cfg.loaderBdMeanSec, cfg.loaderBdSdSec, rng, 60.0);
              loaderClocks[lIdx] += repDur;
              loaderBd += repDur;
            }

            if (loaderClocks[lIdx] < elt[0]) {
              loaderWait += (elt[0] - loaderClocks[lIdx]);
              loaderClocks[lIdx] = elt[0];
            } else {
              final wDur = loaderClocks[lIdx] - elt[0];
              truckWait += wDur;
              elt[0] += wDur;
            }

            final spL = sampleNormal(cfg.spotLoaderMean, cfg.spotLoaderSd, rng, 1.0);
            final ldT = sampleNormal(cfg.loadTimeMean, cfg.loadTimeSd, rng, 2.0);
            final tons = sampleNormal(cfg.payloadMeanTons, cfg.payloadSdTons, rng, 1.0);

            loaderClocks[lIdx] += spL + ld_t_clamp(ldT);
            elt[0] += spL + ldT;
            shiftTons += tons;
            state[0] = 1;
          }
        }

        final tonsPerHr = max(shiftTons / shiftHrs, 1e-3);
        final trkCostTon = ((annTruck * nt) / max(cfg.truckOpHrsYr, 1.0)) / tonsPerHr;
        final ldrCostTon = ((annLoader * nLoaders) / max(cfg.loaderOpHrsYr, 1.0)) / tonsPerHr;
        final costPerTon = trkCostTon + ldrCostTon;

        totTonsAll += shiftTons;
        totCostAll += costPerTon;
        totTWaitAll += truckWait;
        totLWaitAll += loaderWait;
        totTBdAll += truckBd;
        totLBdAll += loaderBd;
      }

      final nSh = max(cfg.nShifts, 1).toDouble();
      summaries.add(
        FleetSummaryRow(
          nt: nt,
          avgTons: totTonsAll / nSh,
          avgCost: totCostAll / nSh,
          avgTruckWait: totTWaitAll / nSh,
          avgLoaderWait: totLWaitAll / nSh,
          avgTruckBd: totTBdAll / nSh,
          avgLoaderBd: totLBdAll / nSh,
        ),
      );
    }

    FleetSummaryRow optCost = summaries.first;
    FleetSummaryRow maxTons = summaries.first;
    for (final row in summaries) {
      if (row.avgCost < optCost.avgCost) optCost = row;
      if (row.avgTons > maxTons.avgTons) maxTons = row;
    }

    return SimhaulOutput(
      travelSec: travelSec,
      travelFt: travelFt,
      segmentLogs: segLogs,
      fleetSummaries: summaries,
      optimalCostFleet: optCost,
      maxTonsFleet: maxTons,
      annualTruckCost: annTruck,
      annualLoaderCost: annLoader,
    );
  }

  static double ld_t_clamp(double val) => val < 0.0 ? 0.0 : val;
}
