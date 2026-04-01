import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';

class MyWorkoutsTab extends StatelessWidget {
  const MyWorkoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(color: cs.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(18)),
          child: Icon(Icons.add_rounded, color: cs.primary, size: 28),
        ),
        const SizedBox(height: 18),
        Text('No workouts yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 6),
        Text('Create a custom workout or\ngenerate one with AI', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.4), height: 1.5)),
        const SizedBox(height: 24),
        AppButton(label: 'Create workout', onPressed: () {}),
        const SizedBox(height: 10),
        AppButton(label: 'Generate with AI', icon: Icons.auto_awesome_outlined, type: Btn.outline, onPressed: () {}),
      ],
    )));
  }
}