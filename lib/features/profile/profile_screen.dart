import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart' as c;
import '../../core/theme/theme_provider.dart';
import '../../core/services/user_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/app_card.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  final _authService = AuthService();
  bool _loading = true;
  String _error = '';
  String _fullName = '';
  int _level = 1;
  String _title = 'Beginner';
  int _xp = 0;
  int _totalWorkouts = 0;
  int _streak = 0;
  double _weight = 0;
  double _height = 0;
  String _goal = '';
  String _fitnessLevel = '';
  List<Map<String, dynamic>> _achievements = [];

  int _toInt(dynamic v) { if (v == null) return 0; if (v is int) return v; if (v is double) return v.toInt(); if (v is String) return int.tryParse(v) ?? 0; return 0; }
  double _toDouble(dynamic v) { if (v == null) return 0.0; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? 0.0; return 0.0; }

  @override
  void initState() { super.initState(); _loadProfile(); }

  Future<void> _loadProfile() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final response = await _userService.getProfile();
      if (response['success'] == true) {
        final user = response['data']['user'] ?? {};
        setState(() {
          _fullName = user['full_name']?.toString() ?? '';
          _level = _toInt(user['level']); _title = user['title']?.toString() ?? 'Beginner';
          _xp = _toInt(user['xp']); _totalWorkouts = _toInt(user['total_workouts']);
          _streak = _toInt(user['streak']); _weight = _toDouble(user['weight']);
          _height = _toDouble(user['height']); _goal = user['goal']?.toString() ?? '';
          _fitnessLevel = user['fitness_level']?.toString() ?? '';
          _achievements = List<Map<String, dynamic>>.from(response['data']['achievements'] ?? []);
          _loading = false;
        });
      } else { setState(() { _error = response['message']?.toString() ?? 'Failed'; _loading = false; }); }
    } catch (e) { setState(() { _error = e.toString(); _loading = false; }); }
  }

  void _editProfile() async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (_) => EditProfileScreen(fullName: _fullName, weight: _weight, height: _height, goal: _goal, fitnessLevel: _fitnessLevel)));
    if (result == true) _loadProfile();
  }

  void _logout() async {
    final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Sign Out?'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Sign Out', style: TextStyle(color: c.C.rose))),
      ],
    ));
    if (confirm != true) return;
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = ThemeProvider.I.isDark;

    if (_loading) return Scaffold(body: Center(child: CircularProgressIndicator(color: cs.primary)));
    if (_error.isNotEmpty) return Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.cloud_off_outlined, size: 48, color: cs.onSurface.withOpacity(0.3)),
      const SizedBox(height: 16), Text(_error, textAlign: TextAlign.center, style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
      const SizedBox(height: 16), ElevatedButton.icon(onPressed: _loadProfile, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Retry'),
        style: ElevatedButton.styleFrom(backgroundColor: cs.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
    ])));

    return Scaffold(body: SafeArea(child: RefreshIndicator(onRefresh: _loadProfile, color: cs.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
        child: Column(children: [
          Row(children: [
            Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
            const Spacer(),
            IconButton(onPressed: () {},
              style: IconButton.styleFrom(backgroundColor: cs.surface, side: BorderSide(color: cs.outline.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
              icon: Icon(Icons.settings_outlined, size: 20, color: cs.onSurface.withOpacity(0.45))),
          ]),
          const SizedBox(height: 24),
          Container(width: 84, height: 84, decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            child: Center(child: Text(_fullName.isNotEmpty ? _fullName[0].toUpperCase() : 'U',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)))),
          const SizedBox(height: 14),
          Text(_fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: cs.onSurface)),
          const SizedBox(height: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: cs.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Text('Level $_level · $_title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary))),
          const SizedBox(height: 22),
          Row(children: [
            _st(cs, Icons.fitness_center_outlined, '$_totalWorkouts', 'Workouts', c.C.blue500),
            const SizedBox(width: 8), _st(cs, Icons.local_fire_department_outlined, '${_streak}d', 'Streak', c.C.amber),
            const SizedBox(width: 8), _st(cs, Icons.bolt_outlined, '$_xp', 'XP', c.C.violet),
          ]),
          const SizedBox(height: 22),
          _titleW(cs, 'Achievements'), const SizedBox(height: 10),
          if (_achievements.isEmpty)
            AppCard(child: Center(child: Padding(padding: const EdgeInsets.all(8),
              child: Text('No achievements yet. Keep working out!', style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.4))))))
          else SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: Row(children: _achievements.map((a) => Padding(padding: const EdgeInsets.only(right: 16),
              child: _badge(cs, Icons.emoji_events_outlined, a['name']?.toString() ?? '', c.C.amber))).toList())),
          const SizedBox(height: 22),
          Row(children: [_titleW(cs, 'Fitness profile'), const Spacer(),
            TextButton(onPressed: _editProfile, style: TextButton.styleFrom(foregroundColor: cs.primary,
              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter')), child: const Text('Edit'))]),
          const SizedBox(height: 6),
          AppCard(padding: EdgeInsets.zero, child: Column(children: [
            _info(cs, Icons.gps_fixed_outlined, 'Goal', _goal.isNotEmpty ? _goal : '-', c.C.rose),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _info(cs, Icons.bar_chart_outlined, 'Level', _fitnessLevel.isNotEmpty ? _fitnessLevel : '-', c.C.blue500),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _info(cs, Icons.monitor_weight_outlined, 'Weight', _weight > 0 ? '${_weight.toStringAsFixed(1)} kg' : '-', c.C.emerald),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _info(cs, Icons.straighten_outlined, 'Height', _height > 0 ? '${_height.toStringAsFixed(0)} cm' : '-', c.C.cyan),
          ])),
          const SizedBox(height: 22),
          _titleW(cs, 'Preferences'), const SizedBox(height: 10),
          AppCard(padding: EdgeInsets.zero, child: Column(children: [
            _tog(cs, Icons.dark_mode_outlined, 'Dark mode', dark, (_) { ThemeProvider.I.toggle(); setState(() {}); }),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _row(cs, Icons.notifications_outlined, 'Notifications', () {}),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _row(cs, Icons.language_outlined, 'Language', () {}),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _row(cs, Icons.lock_outline_rounded, 'Privacy', () {}),
            Divider(height: 1, indent: 14, endIndent: 14, color: cs.outline.withOpacity(0.2)),
            _row(cs, Icons.help_outline_rounded, 'Help', () {}),
          ])),
          const SizedBox(height: 22),
          SizedBox(width: double.infinity, height: 48, child: OutlinedButton.icon(
            onPressed: _logout, icon: const Icon(Icons.logout_rounded, size: 18), label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(foregroundColor: c.C.rose, side: BorderSide(color: c.C.rose.withOpacity(0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter')))),
        ]),
      ),
    )));
  }

  Widget _st(ColorScheme cs, IconData icon, String v, String l, Color col) => Expanded(child: AppCard(child: Column(children: [
    Container(width: 34, height: 34, decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: col, size: 17)),
    const SizedBox(height: 8), Text(v, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
    Text(l, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
  ])));
  Widget _titleW(ColorScheme cs, String t) => Align(alignment: Alignment.centerLeft,
    child: Text(t, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.2)));
  Widget _badge(ColorScheme cs, IconData icon, String l, Color col) => Column(children: [
    Container(width: 44, height: 44, decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: col, size: 20)),
    const SizedBox(height: 5), Text(l, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.4))),
  ]);
  Widget _info(ColorScheme cs, IconData icon, String l, String v, Color col) => Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(children: [
      Container(width: 30, height: 30, decoration: BoxDecoration(color: col.withOpacity(0.06), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: col, size: 15)),
      const SizedBox(width: 12), Text(l, style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.5))),
      const Spacer(), Text(v, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
    ]));
  Widget _row(ColorScheme cs, IconData icon, String l, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(children: [
      Container(width: 30, height: 30, decoration: BoxDecoration(color: cs.onSurface.withOpacity(0.04), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 15, color: cs.onSurface.withOpacity(0.4))),
      const SizedBox(width: 12), Expanded(child: Text(l, style: TextStyle(fontSize: 14, color: cs.onSurface))),
      Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurface.withOpacity(0.2)),
    ])));
  Widget _tog(ColorScheme cs, IconData icon, String l, bool v, ValueChanged<bool> f) => Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    child: Row(children: [
      Container(width: 30, height: 30, decoration: BoxDecoration(color: cs.onSurface.withOpacity(0.04), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 15, color: cs.onSurface.withOpacity(0.4))),
      const SizedBox(width: 12), Expanded(child: Text(l, style: TextStyle(fontSize: 14, color: cs.onSurface))),
      Switch(value: v, onChanged: f),
    ]));
}