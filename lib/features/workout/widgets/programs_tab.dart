import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/xp_badge.dart';

class ProgramsTab extends StatefulWidget {
  const ProgramsTab({super.key});

  @override
  State<ProgramsTab> createState() => _ProgramsTabState();
}

class _ProgramsTabState extends State<ProgramsTab> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Upper', 'Lower', 'Core', 'Cardio', 'Stretch'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildAIGenerateButton(),
          const SizedBox(height: AppSpacing.lg),
          _buildFilterChips(),
          const SizedBox(height: AppSpacing.lg),
          ..._buildProgramCards(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildAIGenerateButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Generate AI Workout Plan',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textTertiary.withOpacity(0.1),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildProgramCards() {
    final programs = [
      {
        'title': 'Power Hypertrophy',
        'subtitle': 'Build serious size & strength',
        'duration': '60 min',
        'weeks': '12 weeks',
        'level': 'Advanced',
        'xp': 500,
        'gradient': const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        'icon': Icons.fitness_center_rounded,
      },
      {
        'title': 'Shred Protocol',
        'subtitle': 'High-intensity fat burning',
        'duration': '45 min',
        'weeks': '8 weeks',
        'level': 'Intermediate',
        'xp': 380,
        'gradient': const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        ),
        'icon': Icons.local_fire_department_rounded,
      },
      {
        'title': 'Athletic Performance',
        'subtitle': 'Speed, agility & power',
        'duration': '50 min',
        'weeks': '10 weeks',
        'level': 'Advanced',
        'xp': 450,
        'gradient': const LinearGradient(
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
        ),
        'icon': Icons.directions_run_rounded,
      },
      {
        'title': 'Flexibility Flow',
        'subtitle': 'Improve mobility & recovery',
        'duration': '30 min',
        'weeks': '6 weeks',
        'level': 'Beginner',
        'xp': 200,
        'gradient': const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        'icon': Icons.self_improvement_rounded,
      },
    ];

    return programs.map((program) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: _ProgramCard(
          title: program['title'] as String,
          subtitle: program['subtitle'] as String,
          duration: program['duration'] as String,
          weeks: program['weeks'] as String,
          level: program['level'] as String,
          xp: program['xp'] as int,
          gradient: program['gradient'] as LinearGradient,
          icon: program['icon'] as IconData,
        ),
      );
    }).toList();
  }
}

class _ProgramCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String weeks;
  final String level;
  final int xp;
  final LinearGradient gradient;
  final IconData icon;

  const _ProgramCard({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.weeks,
    required this.level,
    required this.xp,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradient.colors.first.withOpacity(0.25),
                  gradient.colors.last.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusXl),
                topRight: Radius.circular(AppSpacing.radiusXl),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.headingSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                XpBadge(xp: xp, compact: true),
              ],
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                _InfoChip(
                  icon: Icons.schedule_rounded,
                  label: duration,
                ),
                const SizedBox(width: AppSpacing.md),
                _InfoChip(
                  icon: Icons.calendar_today_rounded,
                  label: weeks,
                ),
                const SizedBox(width: AppSpacing.md),
                _InfoChip(
                  icon: Icons.star_rounded,
                  label: level,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusRound),
                  ),
                  child: Text(
                    'Start',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}