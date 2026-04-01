import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart' as c;
import '../../core/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = ThemeProvider.I.isDark;

    return Scaffold(body: SafeArea(child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: Column(children: [
        // Top bar
        Row(children: [
          Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
          const Spacer(),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: cs.surface,
              side: BorderSide(color: cs.outline.withOpacity(0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            ),
            icon: Icon(Icons.settings_outlined, size: 20, color: cs.onSurface.withOpacity(0.45)),
          ),
        ]),
        const SizedBox(height: 24),

        // Avatar
        Container(
          width: 84, height: 84,
          decoration: BoxDecoration(
            color: cs.primary, shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_outlined, color: Colors.white, size: 38),
        ),
        const SizedBox(height: 14),
        Text(K.fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: cs.onSurface)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(color: cs.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
          child: Text('Level ${K.level} · ${K.title}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary)),
        ),
        const SizedBox(height: 22),

        // Stats
        Row(children: [
          _st(cs, Icons.fitness_center_outlined, '${K.workouts}', 'Workouts', c.C.blue500),
          const SizedBox(width: 8),
          _st(cs, Icons.local_fire_department_outlined, '${K.streak}d', 'Streak', c.C.amber),
          const SizedBox(width: 8),
          _st(cs, Icons.bolt_outlined, '${K.xp}', 'XP', c.C.violet),
        ]),
        const SizedBox(height: 22),

        // Achievements
        _title(cs, 'Achievements'),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _badge(cs, Icons.local_fire_department_outlined, 'Streak', c.C.amber),
          _badge(cs, Icons.fitness_center_outlined, 'Iron Will', c.C.blue500),
          _badge(cs, Icons.workspace_premium_outlined, 'Champion', c.C.violet),
          _badge(cs, Icons.bolt_outlined, 'Speed', c.C.emerald),
          _badge(cs, Icons.gps_fixed_outlined, 'Focused', c.C.rose),
        ]),
        const SizedBox(height: 22),

        // Fitness profile
        Row(children: [
          _title(cs, 'Fitness profile'),
          const Spacer(),
          TextButton(onPressed: () {}, style: TextButton.styleFrom(
            foregroundColor: cs.primary,
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
          ), child: const Text('Edit')),
        ]),
        const SizedBox(height: 6),
        AppCard(padding: EdgeInsets.zero, child: Column(children: [
          _info(cs, Icons.gps_fixed_outlined, 'Goal', 'Build Muscle', c.C.rose),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _info(cs, Icons.bar_chart_outlined, 'Level', 'Intermediate', c.C.blue500),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _info(cs, Icons.monitor_weight_outlined, 'Weight', '${K.weight} kg', c.C.emerald),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _info(cs, Icons.straighten_outlined, 'Height', '${K.height} cm', c.C.cyan),
        ])),
        const SizedBox(height: 22),

        // Preferences
        _title(cs, 'Preferences'),
        const SizedBox(height: 10),
        AppCard(padding: EdgeInsets.zero, child: Column(children: [
          _tog(cs, Icons.dark_mode_outlined, 'Dark mode', dark, (_) { ThemeProvider.I.toggle(); setState(() {}); }),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _row(cs, Icons.notifications_outlined, 'Notifications'),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _row(cs, Icons.language_outlined, 'Language'),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _row(cs, Icons.lock_outline_rounded, 'Privacy'),
          Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
          _row(cs, Icons.help_outline_rounded, 'Help'),
        ])),
        const SizedBox(height: 22),

        // Logout
        SizedBox(width: double.infinity, height: 48, child: OutlinedButton.icon(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Sign out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: c.C.rose,
            side: BorderSide(color: c.C.rose.withOpacity(0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
        )),
      ]),
    )));
  }

  Widget _st(ColorScheme cs, IconData icon, String v, String l, Color col) => Expanded(child: AppCard(
    child: Column(children: [
      Container(width: 34, height: 34,
        decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, color: col, size: 17)),
      const SizedBox(height: 8),
      Text(v, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
      Text(l, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
    ]),
  ));

  Widget _title(ColorScheme cs, String t) => Align(alignment: Alignment.centerLeft,
    child: Text(t, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.2)));

  Widget _badge(ColorScheme cs, IconData icon, String l, Color col) => Column(children: [
    Container(width: 44, height: 44,
      decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: col, size: 20)),
    const SizedBox(height: 5),
    Text(l, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.4))),
  ]);

  Widget _info(ColorScheme cs, IconData icon, String l, String v, Color col) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(children: [
      Container(width: 30, height: 30,
        decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: col, size: 15)),
      const SizedBox(width: 12),
      Text(l, style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.5))),
      const Spacer(),
      Text(v, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
    ]),
  );

  Widget _row(ColorScheme cs, IconData icon, String l) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(children: [
      Container(width: 30, height: 30,
        decoration: BoxDecoration(color: cs.onSurface.withOpacity(0.04), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 15, color: cs.onSurface.withOpacity(0.4))),
      const SizedBox(width: 12),
      Expanded(child: Text(l, style: TextStyle(fontSize: 14, color: cs.onSurface))),
      Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurface.withOpacity(0.2)),
    ]),
  );

  Widget _tog(ColorScheme cs, IconData icon, String l, bool v, ValueChanged<bool> f) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    child: Row(children: [
      Container(width: 30, height: 30,
        decoration: BoxDecoration(color: cs.onSurface.withOpacity(0.04), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 15, color: cs.onSurface.withOpacity(0.4))),
      const SizedBox(width: 12),
      Expanded(child: Text(l, style: TextStyle(fontSize: 14, color: cs.onSurface))),
      Switch(value: v, onChanged: f),
    ]),
  );
}