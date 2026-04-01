import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/xp_badge.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Summary
          Row(
            children: [
              _summaryCard(theme, Icons.fitness_center_rounded, '142',
                  'Total', AppColors.primary),
              const SizedBox(width: 10),
              _summaryCard(theme, Icons.schedule_rounded, '89h', 'Time',
                  AppColors.secondary),
              const SizedBox(width: 10),
              _summaryCard(
                  theme, Icons.bolt_rounded, '2.8k', 'XP', AppColors.accent),
            ],
          ),
          const SizedBox(height: 20),
          _historyItem(theme, 'Upper Body Power', 'Today, 9:30 AM', '48 min',
              350, Icons.fitness_center_rounded, AppColors.primary),
          const SizedBox(height: 10),
          _historyItem(theme, 'HIIT Cardio Blast', 'Yesterday, 7:00 AM',
              '30 min', 280, Icons.directions_run_rounded, AppColors.error),
          const SizedBox(height: 10),
          _historyItem(theme, 'Leg Day', '2 days ago', '55 min', 400,
              Icons.sports_martial_arts_rounded, AppColors.secondary),
          const SizedBox(height: 10),
          _historyItem(theme, 'Core & Mobility', '3 days ago', '35 min', 220,
              Icons.self_improvement_rounded, AppColors.info),
          const SizedBox(height: 10),
          _historyItem(theme, 'Push Day', '4 days ago', '50 min', 370,
              Icons.fitness_center_rounded, AppColors.primaryLight),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _summaryCard(
      ThemeData theme, IconData icon, String val, String label, Color color) {
    return Expanded(
      child: AppCard(
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(val,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                )),
            Text(label,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                )),
          ],
        ),
      ),
    );
  }

  Widget _historyItem(ThemeData theme, String title, String date, String dur,
      int xp, IconData icon, Color color) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    )),
                const SizedBox(height: 2),
                Text(date,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              XpBadge(xp: xp, compact: true),
              const SizedBox(height: 4),
              Text(dur,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}