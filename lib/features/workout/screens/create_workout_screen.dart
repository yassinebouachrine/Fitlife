import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/services/workout_service.dart';
import '../../../core/services/program_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_card.dart';
import 'select_exercises_screen.dart';

class CreateWorkoutScreen extends StatefulWidget {
  final Map<String, dynamic>? editWorkout;
  const CreateWorkoutScreen({super.key, this.editWorkout});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _workoutService = WorkoutService();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '30');

  bool _saving = false;
  List<Map<String, dynamic>> _selectedExercises = [];

  bool get _isEdit => widget.editWorkout != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameCtrl.text = widget.editWorkout!['name']?.toString() ?? '';
      _descCtrl.text = widget.editWorkout!['description']?.toString() ?? '';
      _durationCtrl.text = (widget.editWorkout!['estimated_duration_min'] ?? 30).toString();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  void _addExercises() async {
    final result = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(builder: (_) => SelectExercisesScreen(selected: _selectedExercises)),
    );
    if (result != null) {
      setState(() => _selectedExercises = result);
    }
  }

  void _removeExercise(int index) {
    setState(() => _selectedExercises.removeAt(index));
  }

  void _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showError('Please enter a workout name');
      return;
    }

    setState(() => _saving = true);

    try {
      final exercises = _selectedExercises.map((e) => {
        'exercise_id': e['id'],
        'sets': e['sets'] ?? 3,
        'reps': e['reps'] ?? '10',
        'weight_kg': e['weight_kg'],
        'rest_seconds': e['rest_seconds'] ?? 60,
      }).toList();

      if (_isEdit) {
        await _workoutService.updateWorkout(
          id: widget.editWorkout!['id'],
          name: name,
          description: _descCtrl.text.trim(),
          estimatedDurationMin: int.tryParse(_durationCtrl.text) ?? 30,
          exercises: exercises,
        );
      } else {
        await _workoutService.createWorkout(
          name: name,
          description: _descCtrl.text.trim(),
          estimatedDurationMin: int.tryParse(_durationCtrl.text) ?? 30,
          exercises: exercises,
        );
      }

      if (!mounted) return;
      _showSuccess(_isEdit ? 'Workout updated!' : 'Workout created!');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Workout' : 'Create Workout'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary))
                : Text('Save', style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppTextField(label: 'Workout Name', hint: 'e.g. Upper Body Power', controller: _nameCtrl, prefix: Icons.fitness_center_outlined),
          const SizedBox(height: 16),
          AppTextField(label: 'Description (optional)', hint: 'Describe your workout', controller: _descCtrl, prefix: Icons.description_outlined),
          const SizedBox(height: 16),
          AppTextField(label: 'Duration (minutes)', hint: '30', controller: _durationCtrl, prefix: Icons.schedule_outlined, keyboard: TextInputType.number),
          const SizedBox(height: 24),

          // Exercises section
          Row(children: [
            Text('Exercises', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
            const Spacer(),
            TextButton.icon(
              onPressed: _addExercises,
              icon: Icon(Icons.add_rounded, size: 18, color: cs.primary),
              label: Text('Add', style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),

          if (_selectedExercises.isEmpty)
            AppCard(
              onTap: _addExercises,
              child: Center(child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Icon(Icons.add_circle_outline, size: 36, color: cs.primary.withOpacity(0.5)),
                  const SizedBox(height: 8),
                  Text('Tap to add exercises', style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.5))),
                ]),
              )),
            )
          else
            ...List.generate(_selectedExercises.length, (i) {
              final ex = _selectedExercises[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  child: Row(children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: cs.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w700, color: cs.primary, fontSize: 14))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(ex['name']?.toString() ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
                      Text('${ex['sets'] ?? 3} sets · ${ex['reps'] ?? '10'} reps · ${ex['rest_seconds'] ?? 60}s rest',
                        style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.4))),
                    ])),
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 18, color: cs.onSurface.withOpacity(0.3)),
                      onPressed: () => _removeExercise(i),
                    ),
                  ]),
                ),
              );
            }),

          const SizedBox(height: 24),
          AppButton(label: _isEdit ? 'Update Workout' : 'Create Workout', loading: _saving, onPressed: _save),
        ]),
      ),
    );
  }
}