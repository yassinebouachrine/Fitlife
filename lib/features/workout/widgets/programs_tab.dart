import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/xp_badge.dart';

class ProgramsTab extends StatefulWidget {
  const ProgramsTab({super.key});

  @override
  State<ProgramsTab> createState() => _ProgramsTabState();
}

class _ProgramsTabState extends State<ProgramsTab> {
  int _filter = 0;
  final _filters = ['All', 'Upper', 'Lower', 'Core', 'Cardio'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // AI Generate
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Generate AI Workout Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filters
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final sel = _filter == i;
                return GestureDetector(
                  onTap: () => setState(() => _filter = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: sel
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Program cards
          _programCard(theme, 'Power Hypertrophy', 'Build size & strength',
              '60 min', '12 weeks', 'Advanced', 500, AppColors.primaryGradient),
          const SizedBox(height: 12),
          _programCard(theme, 'Shred Protocol', 'Fat burning HIIT',
              '45 min', '8 weeks', 'Intermediate', 380, AppColors.pinkGradient),
          const SizedBox(height: 12),
          _programCard(theme, 'Athletic Performance', 'Speed & power',
              '50 min', '10 weeks', 'Advanced', 450, AppColors.greenGradient),
          const SizedBox(height: 12),
          _programCard(theme, 'Flexibility Flow', 'Mobility & recovery',
              '30 min', '6 weeks', 'Beginner', 200, AppColors.blueGradient),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _programCard(ThemeData theme, String title, String sub, String dur,
      String weeks, String level, int xp, LinearGradient gradient) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradient.colors.first.withOpacity(0.12),
                  gradient.colors.last.withOpacity(0.04),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fitness_center_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          )),
                      Text(sub,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.45),
                          )),
                    ],
                  ),
                ),
                XpBadge(xp: xp, compact: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _info(theme, Icons.schedule_rounded, dur),
                const SizedBox(width: 14),
                _info(theme, Icons.calendar_today_rounded, weeks),
                const SizedBox(width: 14),
                _info(theme, Icons.star_rounded, level),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _info(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon,
            size: 13,
            color: theme.colorScheme.onSurface.withOpacity(0.35)),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            )),
      ],
    );
  }
}