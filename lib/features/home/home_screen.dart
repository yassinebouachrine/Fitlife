import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart' as c;
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _header(cs),
            const SizedBox(height: 22),
            _level(cs),
            const SizedBox(height: 22),
            _stats(cs),
            const SizedBox(height: 22),
            _today(cs),
            const SizedBox(height: 22),
            _week(cs),
            const SizedBox(height: 22),
            _quick(cs),
          ]),
        ),
      ),
    );
  }

  Widget _header(ColorScheme cs) => Row(children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Good evening,', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.4))),
      const SizedBox(height: 2),
      Text(K.user, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
    ])),
    IconButton(
      onPressed: () {},
      style: IconButton.styleFrom(
        backgroundColor: cs.surface,
        side: BorderSide(color: cs.outline.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      ),
      icon: Badge(
        smallSize: 7,
        backgroundColor: c.C.rose,
        child: Icon(Icons.notifications_outlined, size: 20, color: cs.onSurface.withOpacity(0.5)),
      ),
    ),
    const SizedBox(width: 6),
    const XpBadge(xp: K.xp),
  ]);

  Widget _level(ColorScheme cs) {
    const p = K.xp / K.maxXp;
    return AppCard(
      gradient: LinearGradient(colors: [cs.primary, c.C.blue700]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(7)),
            child: Text('LVL ${K.level}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          const Text(K.title, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.workspace_premium_outlined, color: Colors.white70, size: 20),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Text('${K.xp}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          Text(' / ${K.maxXp} XP', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: p, backgroundColor: Colors.white.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation(Colors.white), minHeight: 5),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${K.maxXp - K.xp} XP to next level', style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
          Row(children: [
            Icon(Icons.trending_up_rounded, color: Colors.white.withOpacity(0.6), size: 14),
            const SizedBox(width: 3),
            Text('+320 this week', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
          ]),
        ]),
      ]),
    );
  }

  Widget _stats(ColorScheme cs) => GridView.count(
    crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.55,
    children: [
      _stat(cs, Icons.fitness_center_outlined, '${K.workouts}', 'Workouts', c.C.blue500, 0.71),
      _stat(cs, Icons.local_fire_department_outlined, '${K.calories}', 'Calories', c.C.rose, 0.84),
      _stat(cs, Icons.bolt_outlined, '${K.streak}d', 'Streak', c.C.amber, 0.60),
      _stat(cs, Icons.monitor_weight_outlined, '${K.weight} kg', 'Weight', c.C.emerald, 0.55),
    ],
  );

  Widget _stat(ColorScheme cs, IconData icon, String val, String label, Color col, double prog) => AppCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: col, size: 17),
        ),
        Text('${(prog * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: col)),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
        Text(label, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.4))),
      ]),
    ]),
  );

  Widget _today(ColorScheme cs) => Column(children: [
    SectionHeader(title: "Today's program", action: 'See all', onAction: () {}),
    const SizedBox(height: 10),
    _prog(cs, 'Upper Body Power', 6, 45, 350, Icons.fitness_center_outlined, c.C.blue600),
    const SizedBox(height: 8),
    _prog(cs, 'Core Stability', 8, 30, 200, Icons.self_improvement_outlined, c.C.emerald),
  ]);

  Widget _prog(ColorScheme cs, String t, int ex, int min, int xp, IconData icon, Color col) => AppCard(
    child: Row(children: [
      Container(
        width: 42, height: 42,
        decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(11)),
        child: Icon(icon, color: col, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 3),
        Text('$ex exercises  ·  $min min', style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
      ])),
      XpBadge(xp: xp, small: true),
    ]),
  );

  Widget _week(ColorScheme cs) {
    final d = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final a = [true, true, true, false, true, true, false];
    return Column(children: [
      const SectionHeader(title: 'This week'),
      const SizedBox(height: 10),
      AppCard(child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(7, (i) => Column(children: [
          Text(d[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.35))),
          const SizedBox(height: 7),
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: a[i] ? cs.primary : cs.outline.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: a[i] ? const Icon(Icons.check_rounded, color: Colors.white, size: 15) : null,
          ),
        ]))),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Divider(color: cs.outline.withOpacity(0.3)),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _ws(cs, '5', 'Workouts'), _ws(cs, '245', 'Minutes'), _ws(cs, '1.8k', 'Calories'),
        ]),
      ])),
    ]);
  }

  Widget _ws(ColorScheme cs, String v, String l) => Column(children: [
    Text(v, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
    Text(l, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
  ]);

  Widget _quick(ColorScheme cs) => Column(children: [
    const SectionHeader(title: 'Quick actions'),
    const SizedBox(height: 10),
    Row(children: [
      Expanded(child: _qa(cs, Icons.add_rounded, 'New workout', c.C.blue600)),
      const SizedBox(width: 8),
      Expanded(child: _qa(cs, Icons.auto_awesome_outlined, 'AI Coach', c.C.violet)),
      const SizedBox(width: 8),
      Expanded(child: _qa(cs, Icons.bar_chart_outlined, 'Progress', c.C.emerald)),
    ]),
  ]);

  Widget _qa(ColorScheme cs, IconData icon, String l, Color col) => AppCard(
    child: Column(children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: col, size: 18),
      ),
      const SizedBox(height: 8),
      Text(l, textAlign: TextAlign.center, style: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface, height: 1.3,
      )),
    ]),
  );
}