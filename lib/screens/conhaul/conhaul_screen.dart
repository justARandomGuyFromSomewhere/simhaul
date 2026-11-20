import 'package:flutter/material.dart';
import '../../engines/conhaul_engine.dart';
import '../../models/conhaul_models.dart';
import '../../widgets/num_field.dart';

class ConhaulScreen extends StatefulWidget {
  const ConhaulScreen({super.key});

  @override
  State<ConhaulScreen> createState() => _ConhaulScreenState();
}

class _ConhaulScreenState extends State<ConhaulScreen> {
  final _prodCtrl = TextEditingController(text: '5000');
  final _shduCtrl = TextEditingController(text: '8');
  final _ploadCtrl = TextEditingController(text: '57.7');
  final _pnvwCtrl = TextEditingController(text: '44.3');
  final _hpCtrl = TextEditingController(text: '682');
  final _effCtrl = TextEditingController(text: '0.85');
  final _vhpCtrl = TextEditingController(text: '45');
  final _hl1Ctrl = TextEditingController(text: '1500');
  final _hl2Ctrl = TextEditingController(text: '4500');
  final _rlCtrl = TextEditingController(text: '4500');
  final _rl1Ctrl = TextEditingController(text: '1200');
  final _grCtrl = TextEditingController(text: '5.0');
  final _rrCtrl = TextEditingController(text: '3.0');
  final _vpitCtrl = TextEditingController(text: '14.0');
  final _vcrCtrl = TextEditingController(text: '15.0');
  final _t1Ctrl = TextEditingController(text: '0.35');
  final _t2Ctrl = TextEditingController(text: '0.30');
  final _t3Ctrl = TextEditingController(text: '0.50');
  final _dmCtrl = TextEditingController(text: '2800');
  final _opefsCtrl = TextEditingController(text: '0.83');
  final _opeftCtrl = TextEditingController(text: '0.85');
  final _pptCtrl = TextEditingController(text: '450000');
  final _tirecoCtrl = TextEditingController(text: '28000');
  final _frateCtrl = TextEditingController(text: '1.50');
  final _serlifCtrl = TextEditingController(text: '6');
  final _ophrsCtrl = TextEditingController(text: '2400');
  final _dinterCtrl = TextEditingController(text: '10');
  final _salvalCtrl = TextEditingController(text: '65000');
  final _opcotrCtrl = TextEditingController(text: '65');
  final _fratshCtrl = TextEditingController(text: '1.50');
  final _slifeCtrl = TextEditingController(text: '7');
  final _ophsCtrl = TextEditingController(text: '2400');

  String _grd1 = 'U';
  String _grd2 = 'D';
  final List<DipperCaseInput> _cases = [
    DipperCaseInput(bc: 8.5, tc: 28.0, ppsh: 650000, shoop: 80, showt: 120000, salvsh: 90000),
    DipperCaseInput(bc: 11.0, tc: 32.0, ppsh: 820000, shoop: 95, showt: 145000, salvsh: 115000),
  ];
  ConhaulOutput? _output;

  double _p(TextEditingController c, double fallback) =>
      double.tryParse(c.text.trim()) ?? fallback;

  void _calculate() {
    final inp = ConhaulInput(
      prod: _p(_prodCtrl, 5000),
      shdu: _p(_shduCtrl, 8),
      pload: _p(_ploadCtrl, 57.7),
      pnvw: _p(_pnvwCtrl, 44.3),
      hp: _p(_hpCtrl, 682),
      eff: _p(_effCtrl, 0.85),
      vhp: _p(_vhpCtrl, 45),
      hl1: _p(_hl1Ctrl, 1500),
      hl2: _p(_hl2Ctrl, 4500),
      rl: _p(_rlCtrl, 4500),
      rl1: _p(_rl1Ctrl, 1200),
      gr: _p(_grCtrl, 5.0),
      rr: _p(_rrCtrl, 3.0),
      grd1: _grd1,
      grd2: _grd2,
      vpit: _p(_vpitCtrl, 14.0),
      vcr: _p(_vcrCtrl, 15.0),
      t1: _p(_t1Ctrl, 0.35),
      t2: _p(_t2Ctrl, 0.30),
      t3: _p(_t3Ctrl, 0.50),
      dm: _p(_dmCtrl, 2800),
      opefs: _p(_opefsCtrl, 0.83),
      opeft: _p(_opeftCtrl, 0.85),
      dipperCases: [for (final c in _cases) c.copy()],
      ppt: _p(_pptCtrl, 450000),
      tireco: _p(_tirecoCtrl, 28000),
      frate: _p(_frateCtrl, 1.50),
      serlif: _p(_serlifCtrl, 6),
      ophrs: _p(_ophrsCtrl, 2400),
      dinter: _p(_dinterCtrl, 10),
      salval: _p(_salvalCtrl, 65000),
      opcotr: _p(_opcotrCtrl, 65),
      fratsh: _p(_fratshCtrl, 1.50),
      slife: _p(_slifeCtrl, 7),
      ophs: _p(_ophsCtrl, 2400),
    );
    setState(() {
      _output = ConhaulEngine.compute(inp);
    });
  }

  void _addCase() {
    if (_cases.length >= 10) return;
    setState(() {
      _cases.add(DipperCaseInput(bc: 14.0, tc: 35.0, ppsh: 950000, shoop: 110, showt: 170000, salvsh: 135000));
    });
  }

  void _showAbbreviations() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        builder: (context, controller) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'CONHAUL Abbreviations & Definitions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: conhaulAbbreviations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final item = conhaulAbbreviations[idx];
                  return ListTile(
                    dense: true,
                    title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.$2),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    final out = _output;
    FleetCaseResult? best;
    if (out != null && out.results.isNotEmpty) {
      best = out.results.reduce((a, b) => a.totalCostPerTon < b.totalCostPerTon ? a : b);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CONHAUL Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Abbreviations',
            onPressed: _showAbbreviations,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Production & Truck Specs', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(width: 165, child: NumField(controller: _prodCtrl, label: 'PROD (t/shift)')),
                      SizedBox(width: 165, child: NumField(controller: _shduCtrl, label: 'SHDU (hrs)')),
                      SizedBox(width: 165, child: NumField(controller: _ploadCtrl, label: 'PLOAD (t)')),
                      SizedBox(width: 165, child: NumField(controller: _pnvwCtrl, label: 'PNVW (t)')),
                      SizedBox(width: 165, child: NumField(controller: _hpCtrl, label: 'HP')),
                      SizedBox(width: 165, child: NumField(controller: _effCtrl, label: 'EFF (0-1)')),
                      SizedBox(width: 165, child: NumField(controller: _vhpCtrl, label: 'VHP (cu.yd)')),
                      SizedBox(width: 165, child: NumField(controller: _dmCtrl, label: 'DM (lb/cu.yd)')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Haul Road, Grade & Times', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(width: 165, child: NumField(controller: _hl1Ctrl, label: 'HL1 (ft)')),
                      SizedBox(width: 165, child: NumField(controller: _hl2Ctrl, label: 'HL2 (ft)')),
                      SizedBox(width: 165, child: NumField(controller: _rlCtrl, label: 'RL (ft)')),
                      SizedBox(width: 165, child: NumField(controller: _rl1Ctrl, label: 'RL1 (ft)')),
                      SizedBox(width: 165, child: NumField(controller: _grCtrl, label: 'GR (%)')),
                      SizedBox(width: 165, child: NumField(controller: _rrCtrl, label: 'RR (%)')),
                      SizedBox(width: 165, child: NumField(controller: _vpitCtrl, label: 'VPIT (MPH)')),
                      SizedBox(width: 165, child: NumField(controller: _vcrCtrl, label: 'VCR (MPH)')),
                      SizedBox(width: 105, child: NumField(controller: _t1Ctrl, label: 'T1 (min)')),
                      SizedBox(width: 105, child: NumField(controller: _t2Ctrl, label: 'T2 (min)')),
                      SizedBox(width: 105, child: NumField(controller: _t3Ctrl, label: 'T3 (min)')),
                      SizedBox(width: 165, child: NumField(controller: _opefsCtrl, label: 'OPEFS')),
                      SizedBox(width: 165, child: NumField(controller: _opeftCtrl, label: 'OPEFT')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('GRD1: '),
                      DropdownButton<String>(
                        value: _grd1,
                        items: const [
                          DropdownMenuItem(value: 'U', child: Text('U (Uphill)')),
                          DropdownMenuItem(value: 'D', child: Text('D (Downhill)')),
                        ],
                        onChanged: (v) => setState(() => _grd1 = v ?? 'U'),
                      ),
                      const SizedBox(width: 20),
                      const Text('GRD2: '),
                      DropdownButton<String>(
                        value: _grd2,
                        items: const [
                          DropdownMenuItem(value: 'D', child: Text('D (Downhill)')),
                          DropdownMenuItem(value: 'U', child: Text('U (Uphill)')),
                        ],
                        onChanged: (v) => setState(() => _grd2 = v ?? 'D'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cost Parameters', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(width: 165, child: NumField(controller: _pptCtrl, label: 'PPT (\$)')),
                      SizedBox(width: 165, child: NumField(controller: _tirecoCtrl, label: 'TIRECO (\$)')),
                      SizedBox(width: 165, child: NumField(controller: _frateCtrl, label: 'FRATE (\$/100lb)')),
                      SizedBox(width: 165, child: NumField(controller: _serlifCtrl, label: 'SERLIF (yr)')),
                      SizedBox(width: 165, child: NumField(controller: _ophrsCtrl, label: 'OPHRS/yr')),
                      SizedBox(width: 165, child: NumField(controller: _dinterCtrl, label: 'DINTER (%)')),
                      SizedBox(width: 165, child: NumField(controller: _salvalCtrl, label: 'SALVAL (\$)')),
                      SizedBox(width: 165, child: NumField(controller: _opcotrCtrl, label: 'OPCOTR (\$/hr)')),
                      SizedBox(width: 165, child: NumField(controller: _fratshCtrl, label: 'FRATSH (\$/100lb)')),
                      SizedBox(width: 165, child: NumField(controller: _slifeCtrl, label: 'SLIFE (yr)')),
                      SizedBox(width: 165, child: NumField(controller: _ophsCtrl, label: 'OPHS/yr')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dipper Cases (${_cases.length}/10)', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: _cases.length < 10 ? _addCase : null,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Case'),
                      ),
                    ],
                  ),
                  ...List.generate(_cases.length, (i) {
                    final c = _cases[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text('C${i + 1}: '),
                          Expanded(
                            child: TextFormField(
                              initialValue: c.bc.toString(),
                              decoration: const InputDecoration(labelText: 'BC (cu.yd)'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => c.bc = double.tryParse(v) ?? c.bc,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: c.tc.toString(),
                              decoration: const InputDecoration(labelText: 'TC (sec)'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => c.tc = double.tryParse(v) ?? c.tc,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: c.ppsh.toString(),
                              decoration: const InputDecoration(labelText: 'PPSH (\$)'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => c.ppsh = double.tryParse(v) ?? c.ppsh,
                            ),
                          ),
                          if (_cases.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => setState(() => _cases.removeAt(i)),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Calculate CONHAUL'),
          ),
          if (out != null) ...[
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GVW: ${out.summary['gvw']!.toStringAsFixed(1)} t | '
                      'VELM: ${out.summary['velm']!.toStringAsFixed(2)} mph | '
                      'VELRE: ${out.summary['velre']!.toStringAsFixed(2)} mph',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TT: ${out.summary['tt']!.toStringAsFixed(2)}m | '
                      'HT: ${out.summary['ht']!.toStringAsFixed(2)}m | '
                      'THT: ${out.summary['tht']!.toStringAsFixed(2)}m | '
                      'TRET: ${out.summary['tret']!.toStringAsFixed(2)}m | '
                      'TFT: ${out.summary['tft']!.toStringAsFixed(2)}m',
                    ),
                    if (best != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Best Option: Case ${best.caseNo} (${best.dipperCuyd.toStringAsFixed(1)} cu.yd) -> \$${best.totalCostPerTon.toStringAsFixed(3)}/ton',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Case')),
                  DataColumn(label: Text('BC')),
                  DataColumn(label: Text('Passes')),
                  DataColumn(label: Text('Cycle')),
                  DataColumn(label: Text('Trucks')),
                  DataColumn(label: Text('Loaders')),
                  DataColumn(label: Text('Moved(t/sh)')),
                  DataColumn(label: Text('$/ton')),
                ],
                rows: out.results
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(Text('${r.caseNo}')),
                          DataCell(Text(r.dipperCuyd.toStringAsFixed(1))),
                          DataCell(Text('${r.passes}')),
                          DataCell(Text(r.cycleTimeMin.toStringAsFixed(2))),
                          DataCell(Text('${r.reqTrucks}')),
                          DataCell(Text('${r.reqLoaders}')),
                          DataCell(Text(r.tonsMovedTShift.toStringAsFixed(1))),
                          DataCell(Text(r.totalCostPerTon.toStringAsFixed(3))),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
