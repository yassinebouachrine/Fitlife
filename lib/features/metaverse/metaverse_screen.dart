import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart' as c;
import '../../core/widgets/app_card.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/section_header.dart';

class MetaverseScreen extends StatelessWidget {
  const MetaverseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(body: SafeArea(child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Metaverse', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
          const Spacer(),
          const XpBadge(xp: 2840),
        ]),
        const SizedBox(height: 22),

        // Portal
        AppCard(gradient: LinearGradient(colors: [cs.primary, c.C.blue700]),
          child: Column(children: [
            Container(width: 56, height: 56,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.explore_outlined, color: Colors.white, size: 26)),
            const SizedBox(height: 14),
            const Text('Virtual Gym', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('128 athletes online', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 44, child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text('Enter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18), foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              ),
            )),
          ]),
        ),
        const SizedBox(height: 22),

        // Avatar
        AppCard(child: Row(children: [
          Container(width: 48, height: 48,
            decoration: BoxDecoration(color: cs.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(13)),
            child: Icon(Icons.person_outline_rounded, color: cs.primary, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Alex Prime', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
            Text('Level 12 · Elite Warrior', style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
            const SizedBox(height: 5),
            Row(children: [
              _avs(cs, '2,840', 'XP'), const SizedBox(width: 14),
              _avs(cs, '#24', 'Rank'), const SizedBox(width: 14),
              _avs(cs, '7', 'Trophies'),
            ]),
          ])),
        ])),
        const SizedBox(height: 22),

        const SectionHeader(title: 'Live classes'),
        const SizedBox(height: 10),
        SizedBox(height: 120, child: ListView(scrollDirection: Axis.horizontal, children: [
          _live(cs, 'HIIT Inferno', '45 min', 24, true),
          const SizedBox(width: 10),
          _live(cs, 'Power Lifting', '60 min', 12, true),
          const SizedBox(width: 10),
          _live(cs, 'Yoga Flow', '30 min', 18, false),
        ])),
        const SizedBox(height: 22),

        const SectionHeader(title: 'Challenges'),
        const SizedBox(height: 10),
        _ch(cs, '7-Day Warrior', 'Complete 7 workouts in a row', 0.71, 2, 500, c.C.amber),
        const SizedBox(height: 8),
        _ch(cs, 'Iron Body', 'Lift 10,000 kg total', 0.45, 5, 750, c.C.blue500),
        const SizedBox(height: 22),

        const SectionHeader(title: 'Leaderboard'),
        const SizedBox(height: 10),
        _ld(cs, 1, 'ZephyrX99', 'Fire Dragon', 8420),
        const SizedBox(height: 6),
        _ld(cs, 2, 'IronMaiden', 'Steel Titan', 7850),
        const SizedBox(height: 6),
        _ld(cs, 3, 'BeastMode', 'War Chief', 6300),
      ]),
    )));
  }

  Widget _avs(ColorScheme cs, String v, String l) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(v, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
    Text(l, style: TextStyle(fontSize: 10, color: cs.onSurface.withOpacity(0.35))),
  ]);

  Widget _live(ColorScheme cs, String t, String d, int j, bool live) => Container(
    width: 160, padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: cs.outline.withOpacity(0.5))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(
          color: live ? c.C.rose : c.C.emerald, shape: BoxShape.circle)),
        const Spacer(),
        if (live) Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c.C.rose)),
      ]),
      const Spacer(),
      Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
      const SizedBox(height: 3),
      Text('$d · $j joined', style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
    ]),
  );

  Widget _ch(ColorScheme cs, String t, String d, double p, int days, int r, Color col) => AppCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 34, height: 34,
          decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(9)),
          child: Icon(Icons.flag_outlined, color: col, size: 17)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
          Text(d, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
        ])),
        XpBadge(xp: r, small: true),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: p, backgroundColor: col.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation(col), minHeight: 5))),
        const SizedBox(width: 10),
        Text('${(p * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: col)),
      ]),
      const SizedBox(height: 5),
      Text('$days days left', style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.35))),
    ]),
  );

  Widget _ld(ColorScheme cs, int r, String n, String t, int xp) => AppCard(
    child: Row(children: [
      Container(width: 30, height: 30,
        decoration: BoxDecoration(
          color: r == 1 ? c.C.amber.withOpacity(0.08) : r == 2 ? c.C.slate300.withOpacity(0.15) : c.C.orange.withOpacity(0.08),
          shape: BoxShape.circle),
        child: Center(child: Text('#$r', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
          color: r == 1 ? c.C.amber : r == 2 ? c.C.slate400 : c.C.orange)))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(n, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
        Text(t, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.35))),
      ])),
      XpBadge(xp: xp, small: true),
    ]),
  );
}