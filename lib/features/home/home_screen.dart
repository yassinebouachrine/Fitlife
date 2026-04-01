import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/section_header.dart';
import '../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1330), AppColors.background],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.base),
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildLevelCard(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildStatsGrid(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTodaysProgram(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildWeeklyOverview(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildQuickActions(),
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening,',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    AppConstants.userName,
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🔥', style: TextStyle(fontSize: 26)),
                ],
              ),
            ],
          ),
        ),
        _buildNotificationButton(),
        const SizedBox(width: AppSpacing.sm),
        const XpBadge(xp: AppConstants.userXP),
        const SizedBox(width: AppSpacing.sm),
        _buildAvatarButton(),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.1),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarButton() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildLevelCard() {
    const progress = AppConstants.userXP / AppConstants.userMaxXP;
    const xpToNext = AppConstants.userMaxXP - AppConstants.userXP;

    return GradientCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF1A1E44), Color(0xFF151937)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: Border.all(
        color: AppColors.primary.withOpacity(0.2),
        width: 1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'LVL ${AppConstants.userLevel}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                AppConstants.userTitle,
                style: AppTypography.headingSmall,
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.xpGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.xpGold,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              Text(
                '${AppConstants.userXP}',
                style: AppTypography.numberSmall.copyWith(
                  color: AppColors.accent,
                ),
              ),
              Text(
                ' / ${AppConstants.userMaxXP} XP',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$xpToNext XP to Level ${AppConstants.userLevel + 1}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.success,
                    size: 16,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '+320 this week',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.35,
      children: const [
        StatCard(
          icon: Icons.fitness_center_rounded,
          iconColor: AppColors.primary,
          value: '142',
          label: 'Workouts',
          progress: 0.71,
        ),
        StatCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.streakFire,
          value: '1,840',
          unit: 'kcal',
          label: 'Calories',
          progress: 0.84,
        ),
        StatCard(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.warning,
          value: '18',
          unit: 'days',
          label: 'Streak',
          progress: 0.60,
        ),
        StatCard(
          icon: Icons.monitor_weight_rounded,
          iconColor: AppColors.accent,
          value: '82.3',
          unit: 'kg',
          label: 'Weight',
          progress: 0.55,
        ),
      ],
    );
  }

  Widget _buildTodaysProgram() {
    return Column(
      children: [
        SectionHeader(
          title: "Today's Program",
          actionText: 'See all',
          onAction: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        _ProgramCard(
          title: 'Upper Body Power',
          exercises: 6,
          duration: 45,
          xp: 350,
          level: 'Advanced',
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          icon: Icons.fitness_center_rounded,
        ),
        const SizedBox(height: AppSpacing.md),
        _ProgramCard(
          title: 'Core Stability',
          exercises: 8,
          duration: 30,
          xp: 200,
          level: 'Intermediate',
          gradient: const LinearGradient(
            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          ),
          icon: Icons.self_improvement_rounded,
        ),
      ],
    );
  }

  Widget _buildWeeklyOverview() {
    return Column(
      children: [
        const SectionHeader(title: 'Weekly Activity'),
        const SizedBox(height: AppSpacing.md),
        GradientCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  final active = [true, true, true, false, true, true, false];
                  final today = index == 4;
                  return _WeekDay(
                    label: days[index],
                    isActive: active[index],
                    isToday: today,
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.base),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _WeekStat(label: 'Workouts', value: '5'),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.textTertiary.withOpacity(0.15),
                  ),
                  _WeekStat(label: 'Minutes', value: '245'),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.textTertiary.withOpacity(0.15),
                  ),
                  _WeekStat(label: 'Calories', value: '1.8k'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add_rounded,
                label: 'New\nWorkout',
                gradient: AppColors.primaryGradient,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.psychology_rounded,
                label: 'Ask\nAI Coach',
                gradient: AppColors.accentGradient,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.bar_chart_rounded,
                label: 'View\nProgress',
                gradient: AppColors.warmGradient,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String title;
  final int exercises;
  final int duration;
  final int xp;
  final String level;
  final LinearGradient gradient;
  final IconData icon;

  const _ProgramCard({
    required this.title,
    required this.exercises,
    required this.duration,
    required this.xp,
    required this.level,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradient.colors.first.withOpacity(0.15),
            gradient.colors.last.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: gradient.colors.first.withOpacity(0.2),
          width: 1,
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
                Text(title, style: AppTypography.headingSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$exercises exercises',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 3),
                    Text('$duration min', style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              XpBadge(xp: xp, compact: true),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  level,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekDay extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isToday;

  const _WeekDay({
    required this.label,
    required this.isActive,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isToday ? AppColors.primary : AppColors.textTertiary,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? (isToday ? AppColors.primary : AppColors.accent)
                : AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: isActive
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
              : null,
        ),
      ],
    );
  }
}

class _WeekStat extends StatelessWidget {
  final String label;
  final String value;

  const _WeekStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.numberSmall.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: AppColors.textTertiary.withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}