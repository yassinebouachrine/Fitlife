import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart' as c;
import '../../core/services/user_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/section_header.dart';
import '../workout/workout_screen.dart';
import '../workout/screens/active_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userService = UserService();
  bool _loading = true;
  String _error = '';

  String _userName = '';
  String _title = '';
  int _level = 1;
  int _xp = 0;
  int _maxXp = 500;
  int _xpToNext = 500;
  int _xpThisWeek = 0;
  int _totalWorkouts = 0;
  int _streak = 0;
  double _weight = 0;
  int _totalCalories = 0;
  List<Map<String, dynamic>> _todayPrograms = [];
  List<Map<String, dynamic>> _weekDays = [];
  Map<String, dynamic> _weekStats = {};

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final response = await _userService.getDashboard();
      if (response['success'] == true) {
        final data = response['data'];
        final user = data['user'] ?? {};
        setState(() {
          _userName = (user['full_name'] ?? 'User').toString().split(' ').first;
          _title = user['title']?.toString() ?? 'Beginner';
          _level = _toInt(user['level']);
          _xp = _toInt(user['xp']);
          _maxXp = _toInt(user['max_xp']);
          if (_maxXp == 0) _maxXp = 500;
          _xpToNext = _toInt(user['xp_to_next']);
          _xpThisWeek = _toInt(user['xp_this_week']);
          _totalWorkouts = _toInt(user['total_workouts']);
          _streak = _toInt(user['streak']);
          _weight = _toDouble(user['weight']);
          _totalCalories = _toInt(user['total_calories_burned']);
          _todayPrograms = List<Map<String, dynamic>>.from(data['today_programs'] ?? []);
          _weekDays = List<Map<String, dynamic>>.from(data['weekly_days'] ?? []);
          _weekStats = Map<String, dynamic>.from(data['weekly_stats'] ?? {});
          _loading = false;
        });
      } else {
        setState(() { _error = response['message']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  String _formatNumber(dynamic n) {
    final val = _toInt(n);
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(1)}k';
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_loading) {
      return Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(color: cs.primary),
        const SizedBox(height: 16),
        Text('Loading...', style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
      ])));
    }
    if (_error.isNotEmpty) {
      return Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.cloud_off_outlined, size: 48, color: cs.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('Connection Error', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text(_error, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.5))),
          const SizedBox(height: 24),
          ElevatedButton.icon(onPressed: _loadDashboard, icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'), style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
        ]))));
    }

    return Scaffold(body: SafeArea(child: RefreshIndicator(
      onRefresh: _loadDashboard, color: cs.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _header(cs), const SizedBox(height: 22),
          _levelCard(cs), const SizedBox(height: 22),
          _statsGrid(cs), const SizedBox(height: 22),
          _today(cs), const SizedBox(height: 22),
          _week(cs), const SizedBox(height: 22),
          _quick(cs),
        ]),
      ),
    )));
  }

  Widget _header(ColorScheme cs) => Row(children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_greeting(), style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.4))),
      const SizedBox(height: 2),
      Text(_userName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
    ])),
    IconButton(onPressed: () {},
      style: IconButton.styleFrom(backgroundColor: cs.surface, side: BorderSide(color: cs.outline.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
      icon: Badge(smallSize: 7, backgroundColor: c.C.rose,
        child: Icon(Icons.notifications_outlined, size: 20, color: cs.onSurface.withOpacity(0.5)))),
    const SizedBox(width: 6),
    XpBadge(xp: _xp),
  ]);

  Widget _levelCard(ColorScheme cs) {
    final p = _maxXp > 0 ? (_xp / _maxXp).clamp(0.0, 1.0) : 0.0;
    return AppCard(
      gradient: LinearGradient(colors: [cs.primary, c.C.blue700]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(7)),
            child: Text('LVL $_level', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
          const SizedBox(width: 8),
          Text(_title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.workspace_premium_outlined, color: Colors.white70, size: 20)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Text('$_xp', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          Text(' / $_maxXp XP', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(value: p, backgroundColor: Colors.white.withOpacity(0.15),
            valueColor: const AlwaysStoppedAnimation(Colors.white), minHeight: 5)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$_xpToNext XP to next level', style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
          Row(children: [
            Icon(Icons.trending_up_rounded, color: Colors.white.withOpacity(0.6), size: 14),
            const SizedBox(width: 3),
            Text('+$_xpThisWeek this week', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
          ]),
        ]),
      ]),
    );
  }

  // ✅ FIX: Changed childAspectRatio to avoid overflow
  Widget _statsGrid(ColorScheme cs) {
    final calP = _totalCalories > 0 ? (_totalCalories / 5000).clamp(0.0, 1.0) : 0.0;
    final wP = _totalWorkouts > 0 ? (_totalWorkouts / 200).clamp(0.0, 1.0) : 0.0;
    final sP = _streak > 0 ? (_streak / 30).clamp(0.0, 1.0) : 0.0;
    final weightP = _weight > 0 ? 0.55 : 0.0;

    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10, crossAxisSpacing: 10,
      childAspectRatio: 1.45, // ✅ Changed from 1.55 to 1.45
      children: [
        _stat(cs, Icons.fitness_center_outlined, '$_totalWorkouts', 'Workouts', c.C.blue500, wP),
        _stat(cs, Icons.local_fire_department_outlined, _formatNumber(_totalCalories), 'Calories', c.C.rose, calP),
        _stat(cs, Icons.bolt_outlined, '${_streak}d', 'Streak', c.C.amber, sP),
        _stat(cs, Icons.monitor_weight_outlined, '${_weight.toStringAsFixed(1)} kg', 'Weight', c.C.emerald, weightP),
      ],
    );
  }

  Widget _stat(ColorScheme cs, IconData icon, String val, String label, Color col, double prog) => AppCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(width: 34, height: 34, decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: col, size: 17)),
        Text('${(prog * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: col)),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
        Text(label, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.4))),
      ]),
    ]),
  );

  Widget _today(ColorScheme cs) {
    final icons = [Icons.fitness_center_outlined, Icons.self_improvement_outlined, Icons.directions_run_outlined, Icons.sports_outlined];
    final colors = [c.C.blue600, c.C.emerald, c.C.rose, c.C.amber];
    return Column(children: [
      SectionHeader(title: "Today's program", action: 'See all', onAction: () {
        // Navigate to workout tab
      }),
      const SizedBox(height: 10),
      if (_todayPrograms.isEmpty)
        AppCard(child: Center(child: Padding(padding: const EdgeInsets.all(12),
          child: Text('No programs available', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.4))))))
      else
        ..._todayPrograms.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < _todayPrograms.length - 1 ? 8 : 0),
            child: AppCard(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ActiveWorkoutScreen(
                    workoutName: p['name']?.toString() ?? 'Program',
                    programId: _toInt(p['id']),
                    exercises: const [],
                  ),
                )).then((_) => _loadDashboard());
              },
              child: Row(children: [
                Container(width: 42, height: 42,
                  decoration: BoxDecoration(color: colors[i % colors.length].withOpacity(0.08), borderRadius: BorderRadius.circular(11)),
                  child: Icon(icons[i % icons.length], color: colors[i % colors.length], size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['name']?.toString() ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
                  const SizedBox(height: 3),
                  Text('${_toInt(p['exercise_count'])} exercises  ·  ${_toInt(p['session_duration_min'])} min',
                    style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
                ])),
                XpBadge(xp: _toInt(p['xp_reward']), small: true),
              ]),
            ),
          );
        }),
    ]);
  }

  Widget _week(ColorScheme cs) {
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final Map<int, bool> activityMap = {};
    for (final day in _weekDays) {
      if (day['activity_date'] != null) {
        try {
          final date = DateTime.parse(day['activity_date'].toString());
          activityMap[date.weekday] = _toInt(day['workouts_done']) > 0;
        } catch (_) {}
      }
    }
    return Column(children: [
      const SectionHeader(title: 'This week'),
      const SizedBox(height: 10),
      AppCard(child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) => Column(children: [
            Text(dayLabels[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.35))),
            const SizedBox(height: 7),
            Container(width: 30, height: 30, decoration: BoxDecoration(
              color: activityMap[i + 1] == true ? cs.primary : cs.outline.withOpacity(0.15), shape: BoxShape.circle),
              child: activityMap[i + 1] == true ? const Icon(Icons.check_rounded, color: Colors.white, size: 15) : null),
          ]))),
        Padding(padding: const EdgeInsets.only(top: 14), child: Divider(color: cs.outline.withOpacity(0.3))),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _ws(cs, '${_toInt(_weekStats['workouts'])}', 'Workouts'),
          _ws(cs, '${_toInt(_weekStats['minutes'])}', 'Minutes'),
          _ws(cs, _formatNumber(_toInt(_weekStats['calories'])), 'Calories'),
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
      Expanded(child: AppCard(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateWorkoutScreen())).then((_) => _loadDashboard()),
        child: Column(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: c.C.blue600.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.add_rounded, color: c.C.blue600, size: 18)),
          const SizedBox(height: 8),
          Text('New workout', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface, height: 1.3)),
        ]),
      )),
      const SizedBox(width: 8),
      Expanded(child: AppCard(
        onTap: () {}, // Navigate to AI Coach tab
        child: Column(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: c.C.violet.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.auto_awesome_outlined, color: c.C.violet, size: 18)),
          const SizedBox(height: 8),
          Text('AI Coach', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface, height: 1.3)),
        ]),
      )),
      const SizedBox(width: 8),
      Expanded(child: AppCard(
        onTap: () {},
        child: Column(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: c.C.emerald.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.bar_chart_outlined, color: c.C.emerald, size: 18)),
          const SizedBox(height: 8),
          Text('Progress', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface, height: 1.3)),
        ]),
      )),
    ]),
  ]);
}

// ✅ Import placeholder - will be created below
class CreateWorkoutScreen extends StatelessWidget {
  const CreateWorkoutScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold();
}