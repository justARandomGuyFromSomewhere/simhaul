class DipperCaseInput {
  double bc;
  double tc;
  double ppsh;
  double shoop;
  double showt;
  double salvsh;

  DipperCaseInput({
    required this.bc,
    required this.tc,
    this.ppsh = 0.0,
    this.shoop = 0.0,
    this.showt = 0.0,
    this.salvsh = 0.0,
  });

  DipperCaseInput copy() => DipperCaseInput(
        bc: bc,
        tc: tc,
        ppsh: ppsh,
        shoop: shoop,
        showt: showt,
        salvsh: salvsh,
      );
}

class ConhaulInput {
  double prod;
  double shdu;
  double pload;
  double pnvw;
  double hp;
  double eff;
  double vhp;
  double hl1;
  double hl2;
  double rl;
  double rl1;
  double vpit;
  double vcr;
  double gr;
  double rr;
  String grd1;
  String grd2;
  double t1;
  double t2;
  double t3;
  double dm;
  double opefs;
  double opeft;
  List<DipperCaseInput> dipperCases;
  double ppt;
  double tireco;
  double frate;
  double serlif;
  double ophrs;
  double dinter;
  double salval;
  double opcotr;
  double fratsh;
  double slife;
  double ophs;
  double maxvel;
  double? velreOverride;
  double? sfrOverride;
  double? sfmOverride;
  double? sfrtOverride;
  double? sfmtOverride;

  ConhaulInput({
    this.prod = 5000.0,
    this.shdu = 8.0,
    this.pload = 57.7,
    this.pnvw = 44.3,
    this.hp = 682.0,
    this.eff = 0.85,
    this.vhp = 45.0,
    this.hl1 = 1500.0,
    this.hl2 = 4500.0,
    this.rl = 4500.0,
    this.rl1 = 1200.0,
    this.vpit = 14.0,
    this.vcr = 15.0,
    this.gr = 5.0,
    this.rr = 3.0,
    this.grd1 = 'U',
    this.grd2 = 'D',
    this.t1 = 0.35,
    this.t2 = 0.30,
    this.t3 = 0.50,
    this.dm = 2800.0,
    this.opefs = 0.83,
    this.opeft = 0.85,
    List<DipperCaseInput>? dipperCases,
    this.ppt = 450000.0,
    this.tireco = 28000.0,
    this.frate = 1.50,
    this.serlif = 6.0,
    this.ophrs = 2400.0,
    this.dinter = 10.0,
    this.salval = 65000.0,
    this.opcotr = 65.0,
    this.fratsh = 1.50,
    this.slife = 7.0,
    this.ophs = 2400.0,
    this.maxvel = 30.0,
    this.velreOverride,
    this.sfrOverride,
    this.sfmOverride,
    this.sfrtOverride,
    this.sfmtOverride,
  }) : dipperCases = dipperCases ??
            [
              DipperCaseInput(
                bc: 8.5,
                tc: 28.0,
                ppsh: 650000.0,
                shoop: 80.0,
                showt: 120000.0,
                salvsh: 90000.0,
              ),
              DipperCaseInput(
                bc: 11.0,
                tc: 32.0,
                ppsh: 820000.0,
                shoop: 95.0,
                showt: 145000.0,
                salvsh: 115000.0,
              ),
            ];
}

class FleetCaseResult {
  final int caseNo;
  final double dipperCuyd;
  final double tcSec;
  final int passes;
  final double loadTimeMin;
  final double ttMin;
  final double htMin;
  final double thtMin;
  final double ttrMin;
  final double rtMin;
  final double tretMin;
  final double tftMin;
  final double cycleTimeMin;
  final double truckProdTShift;
  final double tripsShift;
  final double tonsTrip;
  final int reqTrucks;
  final double arrivalTHr;
  final double loadTHr;
  final int reqLoaders;
  final double fleetCapTShift;
  final double loaderCapTShift;
  final double tonsMovedTShift;
  final double truckCostPerTon;
  final double loaderCostPerTon;
  final double totalCostPerTon;

  const FleetCaseResult({
    required this.caseNo,
    required this.dipperCuyd,
    required this.tcSec,
    required this.passes,
    required this.loadTimeMin,
    required this.ttMin,
    required this.htMin,
    required this.thtMin,
    required this.ttrMin,
    required this.rtMin,
    required this.tretMin,
    required this.tftMin,
    required this.cycleTimeMin,
    required this.truckProdTShift,
    required this.tripsShift,
    required this.tonsTrip,
    required this.reqTrucks,
    required this.arrivalTHr,
    required this.loadTHr,
    required this.reqLoaders,
    required this.fleetCapTShift,
    required this.loaderCapTShift,
    required this.tonsMovedTShift,
    required this.truckCostPerTon,
    required this.loaderCostPerTon,
    required this.totalCostPerTon,
  });
}

class ConhaulOutput {
  final Map<String, double> summary;
  final List<FleetCaseResult> results;

  const ConhaulOutput({required this.summary, required this.results});
}

const List<(String, String)> conhaulAbbreviations = [
  ("PROD", "Desired production rate (tons/shift) - တစ်ဆိုင်းလျှင် ထုတ်လုပ်လိုသော ပမာဏ"),
  ("SHDU", "Shift duration (hours) - အလုပ်ချိန် တစ်ဆိုင်းကြာချိန်"),
  ("PLOAD", "Truck payload capacity (short tons) - ထရပ်ကား တင်ဆောင်နိုင်သော အလေးချိန်"),
  ("PNVW", "Truck net vehicle weight (short tons) - ထရပ်ကား ဗလာအလေးချိန်"),
  ("GVW", "Gross vehicle weight (PLOAD + PNVW, short tons) - ကုန်တင်ပြီး စုစုပေါင်းအလေးချိန်"),
  ("HP", "Truck horsepower (HP) - ထရပ်ကား အင်ဂျင်ပါဝါ"),
  ("EFF", "Engine transmission efficiency (0-1) - အင်ဂျင် စွမ်းအင်ပို့လွှတ်မှု ထိရောက်မှုနှုန်း"),
  ("VHP", "Truck heaped volume (cu. yd.) - ထရပ်ကား ကုန်တင်နိုင်သော ထုထည်"),
  ("HL1", "Pit to main haul distance (ft) - ကျင်းထဲမှ ပင်မလမ်းမကြီးအထိ အကွာအဝေး"),
  ("HL2", "Main haul road length (ft) - ပင်မသယ်ယူပို့ဆောင်ရေးလမ်း အရှည်"),
  ("RL", "Return main haul length (ft) - အပြန် ပင်မလမ်း အရှည်"),
  ("RL1", "Dump to main haul length (ft) - ကုန်သွန်နေရာမှ ပင်မလမ်းမကြီးအထိ အကွာအဝေး"),
  ("GR", "Average grade of haul road (%) - လမ်းအတက်အဆင်း လျှောစောက်ရာခိုင်နှုန်း"),
  ("RR", "Rolling resistance (%) - ဘီးလှိမ့်ခုခံအား ရာခိုင်နှုန်း"),
  ("GRD1 / GRD2", "Loaded / Return grade direction (U=Uphill, D=Downhill) - အသွား/အပြန် အတက်အဆင်း လားရာ"),
  ("EFFGR / EFFGRD", "Effective grade loaded / return (%) - အသွား/အပြန် အသားတင် လျှောစောက်ခုခံအား"),
  ("RIMPUL / RIMP", "Required rimpull loaded / return (lbs) - ဘီးဆွဲအား လိုအပ်ချက်"),
  ("VPIT / VCR", "Max speed in pit / at crusher-dump (MPH) - ကျင်းထဲ / ကုန်သွန်နေရာ အမြင့်ဆုံးအမြန်နှုန်း"),
  ("VELM / VELRE", "Max loaded / return speed on main haul (MPH) - ပင်မလမ်း အသွား/အပြန် အမြင့်ဆုံးအမြန်နှုန်း"),
  ("SFR / SFM", "Speed factor from rest / main haul (loaded) - အသွား အမြန်နှုန်းမြှင့်ကိန်း"),
  ("SFRT / SFMT", "Speed factor from rest / main haul (return) - အပြန် အမြန်နှုန်းမြှင့်ကိန်း"),
  ("TT", "Travel time in pit (min) - ကျင်းထဲမှ ပင်မလမ်းသို့ မောင်းချိန်"),
  ("HT", "Travel time on main haul road (min) - ပင်မလမ်းမကြီးပေါ် ကုန်တင်မောင်းချိန်"),
  ("TTR", "Return travel time at crusher/dump area (min) - ကုန်သွန်နေရာမှ ပင်မလမ်းသို့ အပြန်မောင်းချိန်"),
  ("RT", "Return travel time on main haul road (min) - ပင်မလမ်းမကြီးပေါ် ဗလာအပြန်မောင်းချိန်"),
  ("THT", "Total effective loaded haul time ((TT+HT)/OPEFT, min) - စုစုပေါင်း ကုန်တင်မောင်းချိန်"),
  ("TRET", "Total effective return time ((TTR+RT)/OPEFT, min) - စုစုပေါင်း ဗလာအပြန်မောင်းချိန်"),
  ("T1 / T2 / T3", "Spot at loader / Spot at dump / Dump time (min) - နေရာယူချိန်များနှင့် ကုန်သွန်ချိန်"),
  ("TFT", "Total fixed time (T1 + T2 + T3, min) - စုစုပေါင်း ပုံသေကြာချိန်"),
  ("DM", "Material density (lbs/cu.yd.) - မြေ/ကျောက် သိပ်သည်းဆ"),
  ("OPEFS / OPEFT", "Loader / Truck operating efficiency (0-1) - Loader နှင့် Truck လုပ်ငန်းလည်ပတ်မှု ထိရောက်မှု"),
  ("BC", "Dipper / bucket capacity (cu.yd.) - Loader ခွက်အရွယ်အစား"),
  ("TC", "Loader cycle time (sec) - Loader တစ်ခါခပ်/တင် ကြာချိန်"),
  ("NUM", "Number of loader passes per truck - ကားတစ်စီးပြည့်ရန် ခပ်ရမည့်အကြိမ်ရေ"),
  ("TL", "Truck loading time (min) - ကားတစ်စီး ကုန်တင်ချိန်"),
  ("TCT", "Total truck cycle time (TFT + TL + THT + TRET, min) - ကားတစ်ခေါက် စုစုပေါင်းကြာချိန်"),
  ("QTH / QTHS", "Truck production per hour / per shift (tons) - ကားတစ်စီး၏ တစ်နာရီ / တစ်ဆိုင်း သယ်ယူနိုင်မှု"),
  ("TRPH / TRPSH", "Trips per hour / per shift - တစ်နာရီ / တစ်ဆိုင်း အခေါက်ရေ"),
  ("TPT", "Tons per trip - တစ်ခေါက်လျှင် သယ်ယူသော တန်ချိန်"),
  ("NTR1 (ReqTrucks)", "Required number of trucks - လိုအပ်သော ထရပ်ကား အရေအတွက်"),
  ("XLAM / XMU", "Truck arrival rate / Loader service rate (trucks/hr) - ကားရောက်ရှိနှုန်း / Loader ဝန်ဆောင်မှုနှုန်း"),
  ("NSHOV1 (ReqLoaders)", "Required number of loaders - လိုအပ်သော Loader အရေအတွက်"),
  ("FPSH / SHOCAP", "Fleet capacity / Loader capacity (tons/shift) - ကားအုပ်စု / Loader စွမ်းဆောင်ရည်"),
  ("TONMOV", "Actual tons moved per shift (min of FPSH, SHOCAP) - အမှန်တကယ် သယ်ယူနိုင်သော တန်ချိန်"),
  ("PPT / TIRECO", "Truck purchase price / Tire cost ($) - ထရပ်ကား ဝယ်ဈေး / တာယာဖိုး"),
  ("FRATE / FRATSH", "Truck / Loader freight rate ($/100 lbs) - သယ်ယူပို့ဆောင်ခ နှုန်းထား"),
  ("SERLIF / SLIFE", "Truck / Loader service life (years) - စက်သက်တမ်း"),
  ("OPHRS / OPHS", "Truck / Loader operating hours per year - တစ်နှစ်လျှင် အလုပ်လုပ်ချိန် နာရီ"),
  ("DINTER / CRF", "Annual interest rate (%) / Capital recovery factor - နှစ်စဉ်အတိုးနှုန်း / အရင်းပြန်ဆပ်ကိန်း"),
  ("SALVAL / SALVSH", "Truck / Loader salvage value ($) - သက်တမ်းကုန် ပြန်ရောင်းတန်ဖိုး"),
  ("OPCOTR / SHOOP", "Truck / Loader operating cost per hour ($/hr) - တစ်နာရီ လည်ပတ်စရိတ်"),
  ("PPSH / SHOWT", "Loader purchase price ($) / Loader weight (lbs) - Loader ဝယ်ဈေး / အလေးချိန်"),
  ("COPTON / SHOCOS", "Truck / Loader cost per ton ($/ton) - တစ်တန်လျှင် Truck / Loader ကုန်ကျစရိတ်"),
  ("TOTCOS", "Total haulage & loading cost per ton ($/ton) - တစ်တန်လျှင် စုစုပေါင်းကုန်ကျစရိတ်"),
];
