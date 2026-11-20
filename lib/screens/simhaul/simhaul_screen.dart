import 'package:flutter/material.dart';
import '../../core/unit_conversions.dart';
import '../../engines/simhaul_engine.dart';
import '../../models/simhaul_models.dart';
import '../../widgets/num_field.dart';

class SimhaulScreen extends StatefulWidget {
  const SimhaulScreen({super.key});

  @override
  State<SimhaulScreen> createState() => _SimhaulScreenState();
}

class _SimhaulScreenState extends State<SimhaulScreen> {
  final _ntMinCtrl = TextEditingController(text: '1');
  final _ntMaxCtrl = TextEditingController(text: '8');
  final _loadersCtrl = TextEditingController(text: '2');
  final _shiftsCtrl = TextEditingController(text: '15');
  final _shiftHrsCtrl = TextEditingController(text: '8.0');
  final _netWtCtrl = TextEditingController(text: '110000');
  final _hpCtrl = TextEditingController(text: '1150');
  final _effCtrl = TextEditingController(text: '0.85');
  final _safetyMphCtrl = TextEditingController(text: '34.0');
  final _payloadMeanCtrl = TextEditingController(text: '110.0');
  final _loadMeanCtrl = TextEditingController(text: '105.0');
  final _dumpMeanCtrl = TextEditingController(text: '32.0');

  String _weightUnit = 'lb';
  final SimhaulConfig _config = SimhaulConfig();
  SimhaulOutput? _output;

  double _p(TextEditingController c, double fallback) =>
      double.tryParse(c.text.trim()) ?? fallback;

  void _run() {
    final rawWt = _p(_netWtCtrl, 110000.0);
    _config.ntMin = (_p(_ntMinCtrl, 1)).round();
    _config.ntMax = (_p(_ntMaxCtrl, 8)).round();
    _config.numLoaders = (_p(_loadersCtrl, 2)).round();
    _config.nShifts = (_p(_shiftsCtrl, 15)).round();
    _config.shiftHours = _p(_shiftHrsCtrl, 8.0);
    _config.truckNetLbs = UnitConversions.weightToLb(rawWt, _weightUnit);
    _config.horsepower = _p(_hpCtrl, 1150.0);
    _config.mechEff = _p(_effCtrl, 0.85);
    _config.safetyMaxMph = _p(_safetyMphCtrl, 34.0);
    _config.payloadMeanTons = _p(_payloadMeanCtrl, 110.0);
    _config.loadTimeMean = _p(_loadMeanCtrl, 105.0);
    _config.dumpTimeMean = _p(_dumpMeanCtrl, 32.0);

    setState(() {
      _output = SimhaulEngine.runSimulation(_config);
    });
  }

  @override
  void initState() {
    super.initState();
    _run();
  }

  @override
  Widget build(BuildContext context) {
    final out = _output;

    return Scaffold(
      appBar: AppBar(title: const Text('SIMHAUL Fleet Simulation')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fleet & Shift Setup', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(width: 105, child: NumField(controller: _ntMinCtrl, label: 'NT Min')),
                      SizedBox(width: 105, child: NumField(controller: _ntMaxCtrl, label: 'NT Max')),
                      SizedBox(width: 105, child: NumField(controller: _loadersCtrl, label: 'Loaders')),
                      SizedBox(width: 105, child: NumField(controller: _shiftsCtrl, label: 'Shifts')),
                      SizedBox(width: 105, child: NumField(controller: _shiftHrsCtrl, label: 'Shift Hrs')),
                      SizedBox(width: 165, child: NumField(controller: _safetyMphCtrl, label: 'Safety Cap (mph)')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: NumField(controller: _netWtCtrl, label: 'Truck Net Weight')),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _weightUnit,
                        items: const [
                          DropdownMenuItem(value: 'lb', child: Text('lb')),
                          DropdownMenuItem(value: 'kg', child: Text('kg')),
                          DropdownMenuItem(value: 't', child: Text('metric ton (t)')),
                        ],
                        onChanged: (v) => setState(() => _weightUnit = v ?? 'lb'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(width: 105, child: NumField(controller: _hpCtrl, label: 'HP')),
                      SizedBox(width: 105, child: NumField(controller: _effCtrl, label: 'Eff')),
                      SizedBox(width: 105, child: NumField(controller: _payloadMeanCtrl, label: 'Payload (t)')),
                      SizedBox(width: 105, child: NumField(controller: _loadMeanCtrl, label: 'Load (s)')),
                      SizedBox(width: 105, child: NumField(controller: _dumpMeanCtrl, label: 'Dump (s)')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _run,
            icon: const Icon(Icons.directions_car),
            label: const Text('Run Fleet Sensitivity'),
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
                      'Route: ${out.travelFt.toStringAsFixed(0)} ft in ${out.travelSec.toStringAsFixed(1)} s',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lowest Cost Fleet: NT=${out.optimalCostFleet.nt} (\$${out.optimalCostFleet.avgCost.toStringAsFixed(3)}/ton, ${out.optimalCostFleet.avgTons.toStringAsFixed(1)} t/shift)',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Peak Tonnage Fleet: NT=${out.maxTonsFleet.nt} (${out.maxTonsFleet.avgTons.toStringAsFixed(1)} t/shift, \$${out.maxTonsFleet.avgCost.toStringAsFixed(3)}/ton)',
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
                  DataColumn(label: Text('NT')),
                  DataColumn(label: Text('Avg Tons/Shift')),
                  DataColumn(label: Text('Trk Wait(s)')),
                  DataColumn(label: Text('Ldr Wait(s)')),
                  DataColumn(label: Text('Trk BD(s)')),
                  DataColumn(label: Text('$/Ton')),
                ],
                rows: out.fleetSummaries
                    .map(
                      (r) => DataRow(
                        cells: [
                          DataCell(Text('${r.nt}')),
                          DataCell(Text(r.avgTons.toStringAsFixed(1))),
                          DataCell(Text(r.avgTruckWait.toStringAsFixed(1))),
                          DataCell(Text(r.avgLoaderWait.toStringAsFixed(1))),
                          DataCell(Text(r.avgTruckBd.toStringAsFixed(1))),
                          DataCell(Text(r.avgCost.toStringAsFixed(3))),
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
