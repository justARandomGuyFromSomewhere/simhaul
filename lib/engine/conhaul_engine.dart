import 'dart:math';
import '../models/conhaul_models.dart';

class ConhaulEngine {
  static int ceilPos(double val) {
    return val > 0.0 ? (val - 1e-12).ceil() : 0;
  }

  static double calcCrf(double ratePct, double years) {
    if (years <= 0.0) return 0.0;
    final r = ratePct / 100.0;
    if (r.abs() < 1e-12) return 1.0 / years;
    final factor = pow(1.0 + r, years).toDouble();
    return (r * factor) / (factor - 1.0);
  }

  static ConhaulOutput compute(ConhaulInput d) {
    final gvw = d.pload + d.pnvw;
    final effgr = d.grd1.trim().toUpperCase() == 'U' ? (d.rr + d.gr) : (d.rr - d.gr);
    final rimpul = effgr * 20.0 * gvw;
    final velm = (effgr <= 0.0 || rimpul <= 0.0)
        ? d.maxvel
        : min(d.maxvel, (d.hp * 513.35 * d.eff) / rimpul);

    final sfr = d.sfrOverride ?? max(0.05, 0.90 - (720.0 / (d.hl1 + 1200.0)));
    final sfm = d.sfmOverride ?? max(0.05, 0.95 - (460.0 / (d.hl2 + 1200.0)));
    final tt = d.hl1 / (sfr * 88.0 * d.vpit);
    final ht = d.hl2 / (sfm * 88.0 * velm);

    final sfrt = d.sfrtOverride ?? max(0.05, 0.90 - (720.0 / (d.rl1 + 1200.0)));
    final sfmt = d.sfmtOverride ?? max(0.05, 0.95 - (460.0 / (d.rl + 1200.0)));
    final effgrd = d.grd2.trim().toUpperCase() == 'D' ? (d.rr - d.gr) : (d.rr + d.gr);

    double rimp = 0.0;
    double velre;
    if (effgrd <= 0.0) {
      rimp = 0.0;
      velre = d.velreOverride == null ? d.maxvel : min(d.maxvel, d.velreOverride!);
    } else {
      rimp = effgrd * 20.0 * d.pnvw;
      velre = rimp <= 0.0 ? d.maxvel : min(d.maxvel, (d.hp * 513.35 * d.eff) / rimp);
    }

    final ttr = d.rl1 / (sfrt * 88.0 * d.vcr);
    final rt = d.rl / (sfmt * 88.0 * velre);

    final tft = d.t1 + d.t2 + d.t3;
    final tht = (tt + ht) / d.opeft;
    final tret = (ttr + rt) / d.opeft;

    final ppnet = d.ppt - d.tireco;
    final frcost = (d.pnvw * 2000.0 * d.frate) / 100.0;
    final totdel = ppnet + frcost;
    final opcoyr = d.opcotr * d.ophrs;
    final crf = calcCrf(d.dinter, d.serlif);
    final anncos = ((totdel - d.salval) * crf) + (d.salval * (d.dinter / 100.0)) + opcoyr;
    final crfsh = calcCrf(d.dinter, d.slife);

    final List<FleetCaseResult> results = [];
    for (int i = 0; i < d.dipperCases.length; i++) {
      final c = d.dipperCases[i];
      final bc = c.bc;
      final tc = c.tc;
      final numPasses = max(1, (d.vhp / bc).round());
      final tl = (numPasses * tc) / (60.0 * d.opefs);
      final tct = tft + tl + tht + tret;

      final qth = (60.0 * numPasses * bc * d.dm) / (tct * 2000.0);
      final qths = qth * d.shdu;
      final trph = 60.0 / tct;
      final trpsh = trph * d.shdu;
      final tpt = qths / trpsh;
      final ntr1 = max(1, ceilPos(d.prod / qths));

      final arrt = tct / ntr1.toDouble();
      final xlam = (1.0 / arrt) * 60.0;
      final xmu = (1.0 / tl) * 60.0;
      final nshov1 = max(1, ceilPos(xlam / xmu));

      final fpsh = qths * ntr1.toDouble();
      final shocap = xmu * d.shdu * tpt * nshov1.toDouble();
      final tonmov = min(fpsh, shocap);

      final unload = 0.02 * c.ppsh;
      final opcosh = c.shoop * d.ophs;
      final frcosh = (c.showt * d.fratsh) / 100.0;
      final totpr = c.ppsh + frcosh + unload;
      final ancosh = ((totpr - c.salvsh) * crfsh) + opcosh;

      final flcost = anncos * ntr1.toDouble();
      final hourco = flcost / d.ophrs;
      final copton = hourco / (tonmov / d.shdu);

      final flcosh = ancosh * nshov1.toDouble();
      final hrcosh = flcosh / d.ophs;
      final shocos = hrcosh / (tonmov / d.shdu);

      final totcos = copton + shocos;

      results.add(
        FleetCaseResult(
          caseNo: i + 1,
          dipperCuyd: bc,
          tcSec: tc,
          passes: numPasses,
          loadTimeMin: tl,
          ttMin: tt,
          htMin: ht,
          thtMin: tht,
          ttrMin: ttr,
          rtMin: rt,
          tretMin: tret,
          tftMin: tft,
          cycleTimeMin: tct,
          truckProdTShift: qths,
          tripsShift: trpsh,
          tonsTrip: tpt,
          reqTrucks: ntr1,
          arrivalTHr: xlam,
          loadTHr: xmu,
          reqLoaders: nshov1,
          fleetCapTShift: fpsh,
          loaderCapTShift: shocap,
          tonsMovedTShift: tonmov,
          truckCostPerTon: copton,
          loaderCostPerTon: shocos,
          totalCostPerTon: totcos,
        ),
      );
    }

    final summary = {
      'gvw': gvw,
      'effgr': effgr,
      'rimpul': rimpul,
      'velm': velm,
      'tt': tt,
      'ht': ht,
      'effgrd': effgrd,
      'rimp': rimp,
      'velre': velre,
      'ttr': ttr,
      'rt': rt,
      'tht': tht,
      'tret': tret,
      'tft': tft,
    };

    return ConhaulOutput(summary: summary, results: results);
  }
}
