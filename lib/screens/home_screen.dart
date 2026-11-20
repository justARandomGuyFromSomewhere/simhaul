import 'package:flutter/material.dart';
import '../app/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      (
        title: '1. CONHAUL Calculator',
        subtitle: 'Cycle time, fleet sizing, dipper case comparison, $/ton & abbreviations',
        icon: Icons.calculate_outlined,
        route: AppRoutes.conhaul,
      ),
      (
        title: '2. SIMHAUL Simulator',
        subtitle: 'Segment road travel, truck/loader queuing, shifts & fleet cost sensitivity',
        icon: Icons.alt_route,
        route: AppRoutes.simhaul,
      ),
      (
        title: '3. Safety Velocity',
        subtitle: 'Unit conversions (mph, ft/s, km/h, m/s) & road segment speed cap check',
        icon: Icons.speed,
        route: AppRoutes.safetyVelocity,
      ),
      (
        title: '4. Rimpull, GR & RR',
        subtitle: '0–3 mph rimpull curve, power limit, grade/rolling resistance & acceleration',
        icon: Icons.trending_up,
        route: AppRoutes.rimpullGrRr,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haulage & Fleet Engineering App'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final m = modules[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                foregroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(m.icon),
              ),
              title: Text(
                m.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(m.subtitle),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, m.route),
            ),
          );
        },
      ),
    );
  }
}
