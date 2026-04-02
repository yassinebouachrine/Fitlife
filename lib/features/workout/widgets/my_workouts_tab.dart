import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/services/workout_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../screens/create_workout_screen.dart';
import '../screens/active_workout_screen.dart';

class MyWorkoutsTab extends StatefulWidget {
  const MyWorkoutsTab({super.key});
  @override
  State<MyWorkoutsTab> createState() => _MyWorkoutsTabState();
}

class _MyWorkoutsTabState extends State<MyWorkoutsTab> {
  final _workoutService = WorkoutService();
  bool _loading = true;
  String _error = '';
  List<Map<String, dynamic>> _workouts = [];

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  @override
  void initState() { super.initState(); _loadWorkouts(); }

  Future<void> _loadWorkouts() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final response = await _workoutService.getMyWorkouts();
      if (response['success'] == true) {
        setState(() { _workouts = List<Map<String, dynamic>>.from(response['data'] ?? []); _loading = false; });
      } else {
        setState(() { _error = response['message']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _createWorkout() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateWorkoutScreen()));
    if (result == true) _loadWorkouts();
  }

  void _editWorkout(Map<String, dynamic> workout) async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (_) => CreateWorkoutScreen(editWorkout: workout)));
    if (result == true) _loadWorkouts();
  }

  void _startWorkout(Map<String, dynamic> workout) async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (_) => ActiveWorkoutScreen(
        workoutName: workout['name']?.toString() ?? 'Workout',
        workoutId: _toInt(workout['id']),
      )));
    if (result == true) _loadWorkouts();
  }

  void _deleteWorkout(int id) async {
    final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Delete Workout?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete', style: TextStyle(color: c.C.rose))),
      ],
    ));
    if (confirm != true) return;

    try {
      await _workoutService.deleteWorkout(id);
      _loadWorkouts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Workout deleted'),
        backgroundColor: Colors.green.shade700, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(16)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_loading) return Center(child: CircularProgressIndicator(color: cs.primary));
    if (_error.isNotEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.cloud_off_outlined, size: 40, color: cs.onSurface.withOpacity(0.3)),
      const SizedBox(height: 12), Text(_error, style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
      const SizedBox(height: 16), ElevatedButton(onPressed: _loadWorkouts, child: const Text('Retry')),
    ]));

    if (_workouts.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: cs.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(18)),
            child: Icon(Icons.add_rounded, color: cs.primary, size: 28)),
          const SizedBox(height: 18),
          Text('No workouts yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: cs.onSurface)),
          const SizedBox(height: 6),
          Text('Create a custom workout or\ngenerate one with AI', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.4), height: 1.5)),
          const SizedBox(height: 24),
          AppButton(label: 'Create workout', onPressed: _createWorkout),
          const SizedBox(height: 10),
          AppButton(label: 'Generate with AI', icon: Icons.auto_awesome_outlined, type: Btn.outline, onPressed: () {}),
        ])));
    }

    return RefreshIndicator(onRefresh: _loadWorkouts, color: cs.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: _workouts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return Padding(padding: const EdgeInsets.only(bottom: 12),
            child: AppButton(label: 'Create new workout', icon: Icons.add_rounded, onPressed: _createWorkout));

          final w = _workouts[index - 1];
          final colorsList = [c.C.blue600, c.C.rose, c.C.emerald, c.C.cyan, c.C.violet, c.C.amber];
          final col = colorsList[(index - 1) % colorsList.length];

          return Padding(padding: const EdgeInsets.only(bottom: 10), child: AppCard(
            onTap: () => _startWorkout(w),
            child: Row(children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(11)),
                child: Icon(Icons.fitness_center_outlined, color: col, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(w['name']?.toString() ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
                const SizedBox(height: 3),
                Text('${_toInt(w['exercise_count'])} exercises  ·  ${_toInt(w['estimated_duration_min'])} min',
                  style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
              ])),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, size: 20, color: cs.onSurface.withOpacity(0.4)),
                onSelected: (val) {
                  if (val == 'start') _startWorkout(w);
                  if (val == 'edit') _editWorkout(w);
                  if (val == 'delete') _deleteWorkout(_toInt(w['id']));
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'start', child: Text('Start')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: c.C.rose))),
                ],
              ),
            ]),
          ));
        },
      ),
    );
  }
}