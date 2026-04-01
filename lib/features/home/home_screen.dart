import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _header(theme),
              const SizedBox(height: 24),
              _levelCard(theme),
              const SizedBox(height: 24),
              _statsGrid(theme),
              const SizedBox(height: 24),
              _todayProgram(theme),
              const SizedBox(height: 24),
              _weeklyActivity(theme),
              const SizedBox(height: 24),
              _quickActions(theme),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening,',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Alex 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        const XpBadge(xp: AppConstants.userXP),
      ],
    );
  }

  Widget _levelCard(ThemeData theme) {
    const progress = AppConstants.userXP / AppConstants.userMaxXP;

    return AppCard(
      gradient: AppColors.primaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'LVL ${AppConstants.userLevel}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Elite Warrior',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${AppConstants.userXP} / ${AppConstants.userMaxXP} XP',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppConstants.userMaxXP - AppConstants.userXP} XP to Level ${AppConstants.userLevel + 1}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded,
                      color: Colors.greenAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '+320 this week',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
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

  Widget _statsGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _statCard(theme, Icons.fitness_center_rounded, '142', 'Workouts',
            AppColors.primary, 0.71),
        _statCard(theme, Icons.local_fire_department_rounded, '1,840',
            'Calories', AppColors.error, 0.84),
        _statCard(theme, Icons.bolt_rounded, '18d', 'Streak',
            AppColors.accent, 0.60),
        _statCard(theme, Icons.monitor_weight_rounded, '82.3 kg', 'Weight',
            AppColors.secondary, 0.55),
      ],
    );
  }

  Widget _statCard(ThemeData theme, IconData icon, String value, String label,
      Color color, double progress) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _todayProgram(ThemeData theme) {
    return Column(
      children: [
        SectionHeader(
          title: "Today's Program",
          action: 'See all',
          onAction: () {},
        ),
        const SizedBox(height: 12),
        _programItem(
            theme, 'Upper Body Power', 6, 45, 350, AppColors.primaryGradient),
        const SizedBox(height: 10),
        _programItem(
            theme, 'Core Stability', 8, 30, 200, AppColors.greenGradient),
      ],
    );
  }

  Widget _programItem(ThemeData theme, String title, int exercises, int mins,
      int xp, LinearGradient gradient) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$exercises exercises · $mins min',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          XpBadge(xp: xp, compact: true),
        ],
      ),
    );
  }

  Widget _weeklyActivity(ThemeData theme) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final active = [true, true, true, false, true, true, false];

    return Column(
      children: [
        const SectionHeader(title: 'Weekly Activity'),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  return Column(
                    children: [
                      Text(
                        days[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: active[i]
                              ? AppColors.primary
                              : theme.colorScheme.outline.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: active[i]
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _weekStat(theme, '5', 'Workouts'),
                  _weekStat(theme, '245', 'Minutes'),
                  _weekStat(theme, '1.8k', 'Calories'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekStat(ThemeData theme, String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget _quickActions(ThemeData theme) {
    return Column(
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionCard(theme, Icons.add_rounded, 'New\nWorkout',
                  AppColors.primaryGradient),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionCard(theme, Icons.psychology_rounded,
                  'Ask\nAI Coach', AppColors.greenGradient),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionCard(theme, Icons.bar_chart_rounded,
                  'View\nProgress', AppColors.orangeGradient),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionCard(
      ThemeData theme, IconData icon, String label, LinearGradient gradient) {
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}