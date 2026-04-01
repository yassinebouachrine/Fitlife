import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/xp_badge.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(children: [
        Row(children: [
          _s(cs, Icons.fitness_center_outlined, '142', 'Total', c.C.blue500),
          const SizedBox(width: 8),
          _s(cs, Icons.schedule_outlined, '89h', 'Time', c.C.emerald),
          const SizedBox(width: 8),
          _s(cs, Icons.bolt_outlined, '2.8k', 'XP', c.C.amber),
        ]),
        const SizedBox(height: 16),
        _h(cs, 'Upper Body Power', 'Today, 9:30 AM', '48 min', 350, Icons.fitness_center_outlined, c.C.blue500),
        const SizedBox(height: 8),
        _h(cs, 'HIIT Cardio', 'Yesterday, 7:00 AM', '30 min', 280, Icons.directions_run_outlined, c.C.rose),
        const SizedBox(height: 8),
        _h(cs, 'Leg Day', '2 days ago', '55 min', 400, Icons.sports_outlined, c.C.emerald),
        const SizedBox(height: 8),
        _h(cs, 'Core Mobility', '3 days ago', '35 min', 220, Icons.self_improvement_outlined, c.C.cyan),
        const SizedBox(height: 8),
        _h(cs, 'Push Day', '4 days ago', '50 min', 370, Icons.fitness_center_outlined, c.C.violet),
      ]),
    );
  }

  Widget _s(ColorScheme cs, IconData icon, String v, String l, Color col) => Expanded(child: AppCard(
    child: Column(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: col, size: 16),
      ),
      const SizedBox(height: 8),
      Text(v, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
      Text(l, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
    ]),
  ));

  Widget _h(ColorScheme cs, String t, String d, String dur, int xp, IconData icon, Color col) => AppCard(
    child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: col, size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 2),
        Text(d, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        XpBadge(xp: xp, small: true),
        const SizedBox(height: 4),
        Text(dur, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
      ]),
    ]),
  );
}