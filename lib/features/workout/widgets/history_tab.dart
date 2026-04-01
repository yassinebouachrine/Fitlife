import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/xp_badge.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildSummaryCards(),
          const SizedBox(height: AppSpacing.xl),
          ..._buildHistoryItems(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.fitness_center_rounded,
            value: '142',
            label: 'Total',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _SummaryCard(
            icon: Icons.schedule_rounded,
            value: '89h',
            label: 'Time',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _SummaryCard(
            icon: Icons.bolt_rounded,
            value: '2.8k',
            label: 'XP',
            color: AppColors.xpGold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildHistoryItems() {
    final history = [
      {
        'title': 'Upper Body Power',
        'date': 'Today, 9:30 AM',
        'duration': '48 min',
        'xp': 350,
        'icon': Icons.fitness_center_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'HIIT Cardio Blast',
        'date': 'Yesterday, 7:00 AM',
        'duration': '30 min',
        'xp': 280,
        'icon': Icons.directions_run_rounded,
        'color': AppColors.streakFire,
      },
      {
        'title': 'Leg Day Destruction',
        'date': '2 days ago',
        'duration': '55 min',
        'xp': 400,
        'icon': Icons.sports_martial_arts_rounded,
        'color': AppColors.accent,
      },
      {
        'title': 'Core & Mobility',
        'date': '3 days ago',
        'duration': '35 min',
        'xp': 220,
        'icon': Icons.self_improvement_rounded,
        'color': AppColors.info,
      },
      {
        'title': 'Push Day',
        'date': '4 days ago',
        'duration': '50 min',
        'xp': 370,
        'icon': Icons.fitness_center_rounded,
        'color': AppColors.levelPurple,
      },
    ];

    return history.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: _HistoryItem(
          title: item['title'] as String,
          date: item['date'] as String,
          duration: item['duration'] as String,
          xp: item['xp'] as int,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
        ),
      );
    }).toList();
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.numberSmall.copyWith(
              color: color,
              fontSize: 20,
            ),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String duration;
  final int xp;
  final IconData icon;
  final Color color;

  const _HistoryItem({
    required this.title,
    required this.date,
    required this.duration,
    required this.xp,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headingSmall),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              XpBadge(xp: xp, compact: true),
              const SizedBox(height: 6),
              Text(
                duration,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}