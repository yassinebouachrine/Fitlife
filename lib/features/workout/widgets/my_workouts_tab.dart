import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';

class MyWorkoutsTab extends StatelessWidget {
  const MyWorkoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.add_rounded,
                color: theme.colorScheme.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create Custom Workout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Build your own workout or let the AI\ncreate one for you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.45),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'Create Workout',
              icon: Icons.add_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Generate with AI',
              icon: Icons.auto_awesome_rounded,
              type: ButtonType.outline,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}