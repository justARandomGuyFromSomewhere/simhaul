class HaulSegment {
  int segmentId;
  String name;
  double lengthFt;
  double gradePct;
  double rrPct;
  double maxSpeedMph;
  double endSpeedMph;
  double grossWeightTons;

  HaulSegment({
    required this.segmentId,
    required this.name,
    required this.lengthFt,
    required this.gradePct,
    required this.rrPct,
    required this.maxSpeedMph,
    required this.endSpeedMph,
    required this.grossWeightTons,
  });
}

class SimhaulConfig {
  int ntMin;
  int ntMax;
  int numLoaders;
  double loaderDipperCuyd;
  int nShifts;
  double shiftHours;
  double prepSec;
  double finishSec;
  double spotLoaderMean;
  double spotLoaderSd;
  double loadTimeMean;
  double loadTimeSd;
  double spotDumpMean;
  double spotDumpSd;
  double dumpTimeMean;
  double dumpTimeSd;
  double payloadMeanTons;
  double payloadSdTons;
  double truckNetLbs;
  double safetyMaxMph;
  double maxAccelMphS;
  double maxDecelMphS;
  double horsepower;
  double mechEff;
  double rimpull0;
  double rimpull1;
  double rimpull2;
  double rimpull3;
  double truckPurchasePrice;
  double truckTireCost;
  double truckFreightPer100lb;
  double truckLifeYrs;
  double truckOpHrsYr;
  double discountRatePct;
  double truckSalvage;
  double truckOpCostHr;
  double loaderPurchasePrice;
  double loaderWeightLbs;
  double loaderFreightPer100lb;
  double loaderLifeYrs;
  double loaderOpHrsYr;
  double loaderSalvage;
  double loaderOpCostHr;
  double truckBdMeanSec;
  double truckBdSdSec;
  double loaderBdMeanSec;
  double loaderBdSdSec;
  int seed;
  List<HaulSegment> segments;

  SimhaulConfig({
    this.ntMin = 1,
    this.ntMax = 8,
    this.numLoaders = 2,
    this.loaderDipperCuyd = 16.0,
    this.nShifts = 15,
    this.shiftHours = 8.0,
    this.prepSec = 600.0,
    this.finishSec = 600.0,
    this.spotLoaderMean = 20.0,
    this.spotLoaderSd = 4.0,
    this.loadTimeMean = 105.0,
    this.loadTimeSd = 12.0,
    this.spotDumpMean = 18.0,
    this.spotDumpSd = 4.0,
    this.dumpTimeMean = 32.0,
    this.dumpTimeSd = 5.0,
    this.payloadMeanTons = 110.0,
    this.payloadSdTons = 3.0,
    this.truckNetLbs = 110000.0,
    this.safetyMaxMph = 34.0,
    this.maxAccelMphS = 3.0,
    this.maxDecelMphS = 3.2,
    this.horsepower = 1150.0,
    this.mechEff = 0.85,
    this.rimpull0 = 132000.0,
    this.rimpull1 = 118000.0,
    this.rimpull2 = 104000.0,
    this.rimpull3 = 90000.0,
    this.truckPurchasePrice = 820000.0,
    this.truckTireCost = 50000.0,
    this.truckFreightPer100lb = 1.60,
    this.truckLifeYrs = 6.0,
    this.truckOpHrsYr = 2400.0,
    this.discountRatePct = 11.0,
    this.truckSalvage = 120000.0,
    this.truckOpCostHr = 92.0,
    this.loaderPurchasePrice = 900000.0,
    this.loaderWeightLbs = 160000.0,
    this.loaderFreightPer100lb = 1.60,
    this.loaderLifeYrs = 7.0,
    this.loaderOpHrsYr = 2400.0,
    this.loaderSalvage = 130000.0,
    this.loaderOpCostHr = 105.0,
    this.truckBdMeanSec = 2400.0,
    this.truckBdSdSec = 400.0,
    this.loaderBdMeanSec = 2100.0,
    this.loaderBdSdSec = 320.0,
    this.seed = 2026,
    List<HaulSegment>? segments,
  }) : segments = segments ??
            [
              HaulSegment(1, "Outbound - Pit Face Exit (Loaded)", 1000.0, 0.0, 3.5, 14.0, 12.0, 198.0),
              HaulSegment(2, "Outbound - Lower Ramp +6.5% (Loaded)", 6000.0, 6.5, 3.0, 18.0, 15.0, 198.0),
              HaulSegment(3, "Outbound - Upper Ramp +3.5% (Loaded)", 4500.0, 3.5, 2.5, 25.0, 12.0, 198.0),
              HaulSegment(4, "Outbound - Dump Approach (Loaded)", 900.0, 0.0, 3.5, 14.0, 0.0, 198.0),
              HaulSegment(5, "Inbound - Dump Exit (Empty)", 900.0, 0.0, 3.5, 16.0, 14.0, 88.0),
              HaulSegment(6, "Inbound - Upper Return -3.5% (Empty)", 4500.0, -3.5, 2.5, 30.0, 22.0, 88.0),
              HaulSegment(7, "Inbound - Lower Return -6.5% (Empty)", 6000.0, -6.5, 3.0, 26.0, 14.0, 88.0),
              HaulSegment(8, "Inbound - Loader Entry (Empty)", 1000.0, 0.0, 3.5, 14.0, 0.0, 88.0),
            ];
}

class SegmentLog {
  final int segmentId;
  final String direction;
  final String name;
  final double lengthFt;
  final double gradePct;
  final double rrPct;
  final double vCapMph;
  final double vPeakMph;
  final double vEndMph;
  final double avgVelMph;
  final double avgVelFps;
  final double wtTons;
  final double distFt;
  final double timeSec;

  const SegmentLog({
    required this.segmentId,
    required this.direction,
    required this.name,
    required this.lengthFt,
    required this.gradePct,
    required this.rrPct,
    required this.vCapMph,
    required this.vPeakMph,
    required this.vEndMph,
    required this.avgVelMph,
    required this.avgVelFps,
    required this.wtTons,
    required this.distFt,
    required this.timeSec,
  });
}

class FleetSummaryRow {
  final int nt;
  final double avgTons;
  final double avgCost;
  final double avgTruckWait;
  final double avgLoaderWait;
  final double avgTruckBd;
  final double avgLoaderBd;

  const FleetSummaryRow({
    required this.nt,
    required this.avgTons,
    required this.avgCost,
    required this.avgTruckWait,
    required this.avgLoaderWait,
    required this.avgTruckBd,
    required this.avgLoaderBd,
  });
}

class SimhaulOutput {
  final double travelSec;
  final double travelFt;
  final List<SegmentLog> segmentLogs;
  final List<FleetSummaryRow> fleetSummaries;
  final FleetSummaryRow optimalCostFleet;
  final FleetSummaryRow maxTonsFleet;
  final double annualTruckCost;
  final double annualLoaderCost;

  const SimhaulOutput({
    required this.travelSec,
    required this.travelFt,
    required this.segmentLogs,
    required this.fleetSummaries,
    required this.optimalCostFleet,
    required this.maxTonsFleet,
    required this.annualTruckCost,
    required this.annualLoaderCost,
  });
}
