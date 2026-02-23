import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_container.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';
import 'package:nexus_gym/core/router/app_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 4),
                _buildXPProgressCard(),
                const SizedBox(height: 20),
                _buildQuickStats(),
                const SizedBox(height: 24),
                _buildSectionTitle('Today\'s Program'),
                const SizedBox(height: 12),
                _buildTodayWorkout(context),
                const SizedBox(height: 24),
                _buildSectionTitle('Quick Actions'),
                const SizedBox(height: 12),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildSectionTitle('AI Coach Insights'),
                const SizedBox(height: 12),
                _buildAIInsightCard(context),
                const SizedBox(height: 24),
                _buildSectionTitle('Weekly Streak'),
                const SizedBox(height: 12),
                _buildWeeklyStreak(),
                const SizedBox(height: 24),
                _buildSectionTitle('Community'),
                const SizedBox(height: 12),
                _buildCommunityRow(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.backgroundDark,
      expandedHeight: 110,
      floating: true,
      pinned: false,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getGreeting(),
                    style: AppTextStyles.bodyM
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (b) => AppColors.primaryGradient
                        .createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
                    child: Text(
                      'Alex 🔥',
                      style: AppTextStyles.h1.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.15, end: 0),
              Row(
                children: [
                  // Notification bell — glass style
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color:
                              AppColors.backgroundCard.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.glassBorder, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.shadowDark.withValues(alpha: 0.6),
                              offset: const Offset(3, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(LucideIcons.bell,
                                color: AppColors.textSecondary, size: 22),
                            Positioned(
                              top: 10,
                              right: 11,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: AppColors.accentRose,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentRose
                                          .withValues(alpha: 0.7),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const XPBadge(xp: 2840),
                  const SizedBox(width: 10),
                  _buildAvatarButton(context),
                ],
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  Widget _buildAvatarButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.profile),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryViolet.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(LucideIcons.user, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildXPProgressCard() {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.accentGold.withValues(alpha: 0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          'LVL 12',
                          style: AppTextStyles.labelS.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Elite Warrior',
                        style: AppTextStyles.labelL
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (b) => AppColors.goldGradient
                        .createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
                    child: Text(
                      '2,840 / 3,500 XP',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.medal,
                    color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Custom gradient progress bar
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowDark.withValues(alpha: 0.7),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 2840 / 3500,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: AppColors.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '660 XP to Level 13',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
              Row(
                children: [
                  Icon(LucideIcons.trendingUp,
                      color: AppColors.accentEmerald, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '+320 this week',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accentEmerald),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _buildQuickStats() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        StatCard(
          label: 'Workouts',
          value: '142',
          icon: LucideIcons.dumbbell,
          color: AppColors.primaryViolet,
          progress: 0.71,
        ),
        StatCard(
          label: 'Calories',
          value: '1,840',
          unit: 'kcal',
          icon: LucideIcons.flame,
          color: AppColors.accentOrange,
          progress: 0.84,
        ),
        StatCard(
          label: 'Streak',
          value: '18',
          unit: 'days',
          icon: LucideIcons.zap,
          color: AppColors.accentGold,
          progress: 0.60,
        ),
        StatCard(
          label: 'Weight',
          value: '82.3',
          unit: 'kg',
          icon: LucideIcons.scale,
          color: AppColors.accentEmerald,
          progress: 0.55,
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms);
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark.withValues(alpha: 0.5),
                offset: const Offset(2, 2),
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            'See all',
            style:
                AppTextStyles.labelS.copyWith(color: AppColors.primaryViolet),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayWorkout(BuildContext context) {
    return NeumorphicContainer(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      child: Column(
        children: [
          // Gradient header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryViolet.withValues(alpha: 0.18),
                  AppColors.primaryCyan.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryViolet.withValues(alpha: 0.45),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.activity,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upper Body Power',
                        style: AppTextStyles.h4
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _workoutMetaChip(LucideIcons.dumbbell, '6 exercises'),
                          const SizedBox(width: 12),
                          _workoutMetaChip(LucideIcons.timer, '45 min'),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const XPBadge(xp: 350),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentRose.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.accentRose.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Advanced',
                        style: AppTextStyles.labelS.copyWith(
                          color: AppColors.accentRose,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Exercise list
          ...[
            (
              'Bench Press',
              '4×8 @ 80kg',
              Icons.fitness_center_rounded,
              AppColors.primaryViolet
            ),
            (
              'Overhead Press',
              '3×10 @ 60kg',
              Icons.fitness_center_rounded,
              AppColors.primaryCyan
            ),
            (
              'Pull-Ups',
              '4×8 BW',
              Icons.fitness_center_rounded,
              AppColors.accentEmerald
            ),
          ].asMap().entries.map((entry) {
            final e = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.glassBorder,
                    width: entry.key < 2 ? 1 : 0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: e.$4.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: e.$4.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: AppTextStyles.labelM.copyWith(
                          color: e.$4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      e.$1,
                      style: AppTextStyles.bodyM
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Text(
                      e.$2,
                      style: AppTextStyles.labelS
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            );
          }),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: NeumorphicButton(
              label: 'Start Workout',
              onPressed: () => context.go(AppRoutes.activeWorkout),
              style: NeuButtonStyle.primary,
              icon: LucideIcons.play,
              isFullWidth: true,
              height: 52,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  Widget _workoutMetaChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 12),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.labelS.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      (
        'AI Coach',
        LucideIcons.brain,
        AppColors.primaryGradient,
        AppColors.primaryViolet,
        AppRoutes.aiCoach
      ),
      (
        'Metaverse',
        LucideIcons.layoutGrid,
        AppColors.metaverseGradient,
        AppColors.primaryCyan,
        AppRoutes.metaverse
      ),
      (
        'Nutrition',
        LucideIcons.apple,
        AppColors.emeraldGradient,
        AppColors.accentEmerald,
        AppRoutes.nutrition
      ),
      (
        'Progress',
        LucideIcons.lineChart,
        AppColors.goldGradient,
        AppColors.accentGold,
        AppRoutes.progress
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.asMap().entries.map((entry) {
        final a = entry.value;
        return GestureDetector(
          onTap: () => context.go(a.$5),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: a.$3,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: a.$4.withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.shadowDark.withValues(alpha: 0.7),
                      offset: const Offset(3, 3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(a.$2, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                a.$1,
                style: AppTextStyles.labelS.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 450 + entry.key * 80))
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              delay: Duration(milliseconds: 450 + entry.key * 80),
              duration: 300.ms,
              curve: Curves.easeOutBack,
            );
      }).toList(),
    );
  }

  Widget _buildAIInsightCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.aiCoach),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryViolet.withValues(alpha: 0.12),
                  AppColors.primaryCyan.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryViolet.withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryViolet.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.shadowDark.withValues(alpha: 0.5),
                  offset: const Offset(4, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryViolet.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.brain,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryViolet
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.primaryViolet
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'AI COACH',
                              style: AppTextStyles.labelS.copyWith(
                                color: AppColors.primaryViolet,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const GlowDot(
                              color: AppColors.accentEmerald, size: 6),
                          const SizedBox(width: 4),
                          Text(
                            'Live',
                            style: AppTextStyles.labelS
                                .copyWith(color: AppColors.accentEmerald),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"Great 18-day streak! Your recovery is optimal — push for 90kg bench today!"',
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      color: AppColors.textMuted, size: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 500.ms);
  }

  Widget _buildWeeklyStreak() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final completed = [true, true, true, true, true, false, false];
    const today = 4;

    return NeumorphicContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final done = completed[i];
              final isToday = i == today;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? AppColors.primaryGradient
                          : done
                              ? AppColors.emeraldGradient
                              : null,
                      color: !done && !isToday
                          ? AppColors.backgroundSurface
                          : null,
                      borderRadius: BorderRadius.circular(13),
                      border: !done && !isToday
                          ? Border.all(color: AppColors.glassBorder)
                          : null,
                      boxShadow: (done || isToday)
                          ? [
                              BoxShadow(
                                color: (isToday
                                        ? AppColors.primaryViolet
                                        : AppColors.accentEmerald)
                                    .withValues(alpha: 0.45),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color:
                                    AppColors.shadowDark.withValues(alpha: 0.6),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                    ),
                    child: Center(
                      child: done || isToday
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[i],
                    style: AppTextStyles.labelS.copyWith(
                      color: isToday
                          ? AppColors.primaryViolet
                          : AppColors.textMuted,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentOrange.withValues(alpha: 0.12),
                  AppColors.accentGold.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentOrange.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department_rounded,
                    color: AppColors.accentOrange, size: 20),
                const SizedBox(width: 8),
                Text(
                  '18-day streak! You\'re on fire!',
                  style: AppTextStyles.labelM.copyWith(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Text('🔥', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 550.ms, duration: 500.ms);
  }

  Widget _buildCommunityRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCommunityCard(
            context,
            title: 'Leaderboard',
            subtitle: 'Rank #24',
            icon: Icons.leaderboard_rounded,
            gradient: AppColors.goldGradient,
            color: AppColors.accentGold,
            route: AppRoutes.leaderboard,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCommunityCard(
            context,
            title: 'Challenges',
            subtitle: '3 Active',
            icon: Icons.flag_rounded,
            gradient: AppColors.primaryGradient,
            color: AppColors.primaryViolet,
            route: AppRoutes.challenges,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms);
  }

  Widget _buildCommunityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark.withValues(alpha: 0.7),
              offset: const Offset(5, 5),
              blurRadius: 14,
            ),
            BoxShadow(
              color: AppColors.shadowLight.withValues(alpha: 0.2),
              offset: const Offset(-3, -3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      color: AppColors.textMuted, size: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyles.bodyS.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
