import 'package:flutter/material.dart';
import '../../engines/safety_velocity_engine.dart';
import '../../models/safety_velocity_models.dart';
import '../../widgets/num_field.dart';

class SafetyVelocityScreen extends StatefulWidget {
  const SafetyVelocityScreen({super.key});

  @override
  State<SafetyVelocityScreen> createState() => _SafetyVelocityScreenState();
}

class _SafetyVelocityScreenState extends State<SafetyVelocityScreen> {
  final _safetyCtrl = TextEditingController(text: '34.0');
  final List<(String, TextEditingController)> _segments = [
    ('Outbound Ramp (+6.5%)', TextEditingController(text: '18.0')),
    ('Upper Ramp (+3.5%)', TextEditingController(text: '25.0')),
    ('Upper Return (-3.5%)', TextEditingController(text: '30.0')),
    ('Straight Haul Section', TextEditingController(text: '40.0')),
  ];
  SafetyVelocityResult? _result;

  void _calculate() {
    final mph = double.tryParse(_safetyCtrl.text.trim()) ?? 34.0;
    final caps = [
      for (final s in _segments) (s.$1, double.tryParse(s.$2.text.trim()) ?? 0.0),
    ];
    setState(() {
      _result = SafetyVelocityEngine.evaluate(mph, caps);
    });
  }

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Velocity Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NumField(
                    controller: _safetyCtrl,
                    label: 'Safety Maximum Speed',
                    suffix: 'mph',
                  ),
                  const SizedBox(height: 12),
                  const Text('Segment Speed Caps (mph)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._segments.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: NumField(
                        controller: s.$2,
                        label: s.$1,
                        suffix: 'mph',
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Evaluate Safety Velocity'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (r != null) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Text('mph: ${r.mph.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('ft/s: ${r.fps.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('km/h: ${r.kmh.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('m/s: ${r.mps.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Segment')),
                  DataColumn(label: Text('Seg Cap')),
                  DataColumn(label: Text('Eff Cap')),
                  DataColumn(label: Text('Controlling Limit')),
                ],
                rows: r.segmentChecks
                    .map(
                      (c) => DataRow(
                        cells: [
                          DataCell(Text('${c.segmentId}')),
                          DataCell(Text(c.name)),
                          DataCell(Text(c.maxSpeedMph.toStringAsFixed(2))),
                          DataCell(Text(c.effectiveCapMph.toStringAsFixed(2))),
                          DataCell(Text(c.bindingLimit)),
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
