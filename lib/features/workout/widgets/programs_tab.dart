import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/xp_badge.dart';

class ProgramsTab extends StatefulWidget {
  const ProgramsTab({super.key});
  @override
  State<ProgramsTab> createState() => _ProgramsTabState();
}

class _ProgramsTabState extends State<ProgramsTab> {
  int _f = 0;
  final _tags = ['All', 'Upper', 'Lower', 'Core', 'Cardio'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(children: [
        // AI
        SizedBox(width: double.infinity, height: 48,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.auto_awesome_outlined, size: 18),
            label: const Text('Generate AI Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary, foregroundColor: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Filters
        SizedBox(height: 34, child: ListView.separated(
          scrollDirection: Axis.horizontal, itemCount: _tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, i) {
            final sel = _f == i;
            return GestureDetector(
              onTap: () => setState(() => _f = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: sel ? cs.primary.withOpacity(0.06) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: sel ? cs.primary : cs.outline.withOpacity(0.5)),
                ),
                child: Center(child: Text(_tags[i], style: TextStyle(
                  fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? cs.primary : cs.onSurface.withOpacity(0.45),
                ))),
              ),
            );
          },
        )),
        const SizedBox(height: 14),

        _card(cs, 'Power Hypertrophy', 'Build size and strength', '60 min', '12 wk', 'Advanced', 500, Icons.fitness_center_outlined, c.C.blue600),
        const SizedBox(height: 10),
        _card(cs, 'Shred Protocol', 'Fat burning program', '45 min', '8 wk', 'Intermediate', 380, Icons.local_fire_department_outlined, c.C.rose),
        const SizedBox(height: 10),
        _card(cs, 'Athletic Performance', 'Speed and power', '50 min', '10 wk', 'Advanced', 450, Icons.directions_run_outlined, c.C.emerald),
        const SizedBox(height: 10),
        _card(cs, 'Flexibility Flow', 'Mobility and recovery', '30 min', '6 wk', 'Beginner', 200, Icons.self_improvement_outlined, c.C.cyan),
      ]),
    );
  }

  Widget _card(ColorScheme cs, String title, String sub, String dur, String wk, String lvl, int xp, IconData icon, Color col) => AppCard(
    padding: EdgeInsets.zero,
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: col, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
          ])),
          XpBadge(xp: xp, small: true),
        ]),
      ),
      Divider(height: 1, color: cs.outline.withOpacity(0.3)),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Row(children: [
          _tag(cs, Icons.schedule_outlined, dur),
          const SizedBox(width: 12),
          _tag(cs, Icons.date_range_outlined, wk),
          const SizedBox(width: 12),
          _tag(cs, Icons.bar_chart_outlined, lvl),
          const Spacer(),
          SizedBox(height: 32, child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: col, foregroundColor: Colors.white, elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
            ),
            child: const Text('Start'),
          )),
        ]),
      ),
    ]),
  );

  Widget _tag(ColorScheme cs, IconData icon, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 13, color: cs.onSurface.withOpacity(0.3)),
    const SizedBox(width: 3),
    Text(t, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.4))),
  ]);
}