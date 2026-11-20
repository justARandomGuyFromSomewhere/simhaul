import 'package:flutter/material.dart';
import '../../engines/traction_engine.dart';
import '../../models/traction_models.dart';
import '../../widgets/num_field.dart';

class RimpullGrRrScreen extends StatefulWidget {
  const RimpullGrRrScreen({super.key});

  @override
  State<RimpullGrRrScreen> createState() => _RimpullGrRrScreenState();
}

class _RimpullGrRrScreenState extends State<RimpullGrRrScreen> {
  final _gvwCtrl = TextEditingController(text: '198.0');
  final _grCtrl = TextEditingController(text: '6.0');
  final _rrCtrl = TextEditingController(text: '3.0');
  final _hpCtrl = TextEditingController(text: '1150.0');
  final _effCtrl = TextEditingController(text: '0.85');
  final _r0Ctrl = TextEditingController(text: '155000');
  final _r1Ctrl = TextEditingController(text: '156000');
  final _r2Ctrl = TextEditingController(text: '159500');
  final _r3Ctrl = TextEditingController(text: '167500');
  final _spCtrl = TextEditingController(text: '12.0');

  List<TractionEvaluationRow> _rows = [];

  double _p(TextEditingController c, double fallback) =>
      double.tryParse(c.text.trim()) ?? fallback;

  void _calculate() {
    final sp = _p(_spCtrl, 12.0);
    final inp = ResistanceInputs(
      grossWeightTons: _p(_gvwCtrl, 198.0),
      gradePct: _p(_grCtrl, 6.0),
      rrPct: _p(_rrCtrl, 3.0),
      horsepower: _p(_hpCtrl, 1150.0),
      mechEff: _p(_effCtrl, 0.85),
      rimpull0: _p(_r0Ctrl, 155000),
      rimpull1: _p(_r1Ctrl, 156000),
      rimpull2: _p(_r2Ctrl, 159500),
      rimpull3: _p(_r3Ctrl, 167500),
    );
    final speeds = [0.0, 1.0, 2.0, 3.0, sp, 20.0];
    setState(() {
      _rows = [for (final s in speeds) TractionEngine.evaluateAtSpeed(inp, s)];
    });
  }

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    final base = _rows.isNotEmpty ? _rows[4] : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Rimpull, GR & RR Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(width: 165, child: NumField(controller: _gvwCtrl, label: 'GVW (tons)')),
                  SizedBox(width: 165, child: NumField(controller: _grCtrl, label: 'Grade GR (%)')),
                  SizedBox(width: 165, child: NumField(controller: _rrCtrl, label: 'Rolling RR (%)')),
                  SizedBox(width: 165, child: NumField(controller: _hpCtrl, label: 'HP')),
                  SizedBox(width: 165, child: NumField(controller: _effCtrl, label: 'Mech Eff')),
                  SizedBox(width: 165, child: NumField(controller: _spCtrl, label: 'Eval Speed (mph)')),
                  SizedBox(width: 165, child: NumField(controller: _r0Ctrl, label: 'Rimpull @ 0 mph')),
                  SizedBox(width: 165, child: NumField(controller: _r1Ctrl, label: 'Rimpull @ 1 mph')),
                  SizedBox(width: 165, child: NumField(controller: _r2Ctrl, label: 'Rimpull @ 2 mph')),
                  SizedBox(width: 165, child: NumField(controller: _r3Ctrl, label: 'Rimpull @ 3 mph')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate),
            label: const Text('Calculate Rimpull, GR & RR'),
          ),
          if (base != null) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GR: ${base.grLb.toStringAsFixed(1)} lb (${base.grTons.toStringAsFixed(2)} t) | '
                      'RR: ${base.rrLb.toStringAsFixed(1)} lb (${base.rrTons.toStringAsFixed(2)} t)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Effective Grade: ${base.effGradePct.toStringAsFixed(2)}% | '
                      'Total Res: ${base.totalResLb.toStringAsFixed(1)} lb (${base.totalResTons.toStringAsFixed(2)} t)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Speed(mph)')),
                  DataColumn(label: Text('Rimpull(lb)')),
                  DataColumn(label: Text('Total Res(lb)')),
                  DataColumn(label: Text('Net Pull(lb)')),
                  DataColumn(label: Text('Accel(mph/s)')),
                ],
                rows: _rows
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(Text(r.speedMph.toStringAsFixed(2))),
                          DataCell(Text(r.rimpullLb.toStringAsFixed(1))),
                          DataCell(Text(r.totalResLb.toStringAsFixed(1))),
                          DataCell(Text(r.netPullLb.toStringAsFixed(1))),
                          DataCell(Text(r.accMphS.toStringAsFixed(3))),
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
