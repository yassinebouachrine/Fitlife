import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/services/history_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_button.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final String workoutName;
  final int? programId;
  final int? workoutId;
  final List<Map<String, dynamic>> exercises;

  const ActiveWorkoutScreen({
    super.key,
    required this.workoutName,
    this.programId,
    this.workoutId,
    this.exercises = const [],
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final _historyService = HistoryService();

  Timer? _timer;
  int _seconds = 0;
  bool _running = true;
  bool _finishing = false;
  int _completedExercises = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_running) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int secs) {
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    final s = secs % 60;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _togglePause() {
    setState(() => _running = !_running);
  }

  void _finishWorkout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finish Workout?'),
        content: Text('Duration: ${_formatTime(_seconds)}\nCompleted exercises: $_completedExercises'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
            child: const Text('Finish'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _finishing = true);
    _timer?.cancel();

    try {
      final durationMin = (_seconds / 60).ceil();
      final response = await _historyService.logWorkout(
        workoutName: widget.workoutName,
        durationMin: durationMin < 1 ? 1 : durationMin,
        workoutType: widget.programId != null ? 'program' : 'custom',
        programId: widget.programId,
        workoutId: widget.workoutId,
        exercisesCompleted: _completedExercises,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        final data = response['data'] ?? {};
        _showResult(data);
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      Navigator.pop(context, true);
    }
  }

  void _showResult(Map<String, dynamic> data) {
    final cs = Theme.of(context).colorScheme;
    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Icon(Icons.emoji_events_rounded, color: c.C.amber, size: 28),
          const SizedBox(width: 10),
          const Text('Workout Complete!'),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _resultRow('XP Earned', '+${_toInt(data['xp_earned'])} XP', c.C.amber),
          _resultRow('Calories', '${_toInt(data['calories_burned'])} cal', c.C.rose),
          _resultRow('Duration', '${_formatTime(_seconds)}', c.C.blue500),
          _resultRow('Streak', '${_toInt(data['streak'])} days', c.C.emerald),
          if (_toInt(data['new_level']) > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: cs.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Icon(Icons.arrow_upward_rounded, color: cs.primary),
                  const SizedBox(width: 8),
                  Text('Level ${_toInt(data['new_level'])} - ${data['new_title'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.w700, color: cs.primary)),
                ]),
              ),
            ),
        ]),
        actions: [
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { Navigator.pop(ctx); Navigator.pop(context, true); },
            style: ElevatedButton.styleFrom(backgroundColor: cs.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Done'),
          )),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value, Color col) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: col)),
    ]),
  );

  void _cancelWorkout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Workout?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep going')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Cancel', style: TextStyle(color: c.C.rose)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: _cancelWorkout),
        title: Text(widget.workoutName),
        centerTitle: true,
      ),
      body: Column(children: [
        // Timer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          color: cs.primary.withOpacity(0.04),
          child: Column(children: [
            Text(_formatTime(_seconds), style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: cs.onSurface, fontFamily: 'monospace')),
            const SizedBox(height: 8),
            Text(_running ? 'In progress' : 'Paused', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.5))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton.icon(
                onPressed: _togglePause,
                icon: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 20),
                label: Text(_running ? 'Pause' : 'Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _running ? cs.outline.withOpacity(0.2) : cs.primary,
                  foregroundColor: _running ? cs.onSurface : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _finishing ? null : _finishWorkout,
                icon: _finishing
                    ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded, size: 20),
                label: const Text('Finish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.C.emerald, foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ]),
          ]),
        ),

        // Exercise counter
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Text('Exercises completed', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const Spacer(),
            IconButton(
              onPressed: _completedExercises > 0 ? () => setState(() => _completedExercises--) : null,
              icon: const Icon(Icons.remove_circle_outline, size: 28),
              color: cs.onSurface.withOpacity(0.4),
            ),
            Text('$_completedExercises', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: cs.primary)),
            IconButton(
              onPressed: () => setState(() => _completedExercises++),
              icon: const Icon(Icons.add_circle_outline, size: 28),
              color: cs.primary,
            ),
          ]),
        ),

        // Quick stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Expanded(child: AppCard(child: Column(children: [
              Icon(Icons.schedule_outlined, size: 20, color: c.C.blue500),
              const SizedBox(height: 4),
              Text('${(_seconds / 60).floor()} min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
              Text('Duration', style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.4))),
            ]))),
            const SizedBox(width: 10),
            Expanded(child: AppCard(child: Column(children: [
              Icon(Icons.fitness_center_outlined, size: 20, color: c.C.emerald),
              const SizedBox(height: 4),
              Text('$_completedExercises', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
              Text('Exercises', style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.4))),
            ]))),
          ]),
        ),
      ]),
    );
  }
}