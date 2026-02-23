import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            title: GradientText(
              'Challenges',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
              gradient: AppColors.primaryGradient,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryElectricBlue,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Discover'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildActiveTab(),
            _buildDiscoverTab(),
            _buildCompletedTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTab() {
    final active = [
      _Challenge(
        '30-Day Warrior',
        'Complete 30 workouts in 30 days',
        18,
        30,
        AppColors.primaryGradient,
        AppColors.primaryElectricBlue,
        '🏆',
        '3 days left',
        600,
      ),
      _Challenge(
        'Iron Will',
        'Deadlift your bodyweight x 3 reps',
        1,
        1,
        AppColors.goldGradient,
        AppColors.accentGold,
        '⚡',
        'Completed',
        400,
      ),
      _Challenge(
        'Calorie Crusher',
        'Burn 10,000 calories this month',
        7200,
        10000,
        AppColors.emeraldGradient,
        AppColors.accentEmerald,
        '🔥',
        '8 days left',
        500,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: active.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _buildChallengeCard(active[i], i),
    );
  }

  Widget _buildChallengeCard(_Challenge c, int index) {
    final progress = (c.current / c.target).clamp(0.0, 1.0);
    final done = progress >= 1.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: c.color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.6),
            offset: const Offset(6, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: c.gradient,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Text(c.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: AppTextStyles.h3
                              .copyWith(color: Colors.white)),
                      Text(c.description,
                          style: AppTextStyles.bodyS
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
                XPBadge(xp: c.reward),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      done
                          ? '✅ Completed!'
                          : '${c.current} / ${c.target}',
                      style: AppTextStyles.labelL.copyWith(color: c.color),
                    ),
                    Text(
                      c.timeLeft,
                      style: AppTextStyles.labelM
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.backgroundSurface,
                    valueColor: AlwaysStoppedAnimation<Color>(c.color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 150));
  }

  Widget _buildDiscoverTab() {
    final discover = [
      ('💪 Seasonal: Winter Shred', '500 XP', 'Jan–Mar', AppColors.primaryGradient, 892),
      ('🌐 Metaverse Marathon', '750 XP', '30 days', AppColors.metaverseGradient, 344),
      ('🍎 Nutrition Mastery', '400 XP', '2 weeks', AppColors.emeraldGradient, 156),
      ('⚡ HIIT 100', '350 XP', '10 days', AppColors.goldGradient, 2300),
      ('🤝 Squad Power', '600 XP', '1 month', AppColors.primaryGradient, 78),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: discover.length,
      itemBuilder: (_, i) {
        final d = discover[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.backgroundCard, AppColors.backgroundCard],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: d.$4,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(d.$1.substring(0, 2),
                      style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.$1.substring(3),
                        style: AppTextStyles.h4
                            .copyWith(color: AppColors.textPrimary)),
                    Text('${d.$3} • ${d.$5} participants',
                        style: AppTextStyles.bodyS
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(d.$2,
                      style: AppTextStyles.labelL
                          .copyWith(color: AppColors.accentGold)),
                  const SizedBox(height: 4),
                  NeumorphicButton(
                    label: 'Join',
                    onPressed: () {},
                    style: NeuButtonStyle.primary,
                    width: 72,
                    height: 32,
                    borderRadius: 10,
                    textStyle: AppTextStyles.labelS,
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
      },
    );
  }

  Widget _buildCompletedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('3 Challenges Completed!',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('You\'ve earned 1,400 XP from challenges',
              style: AppTextStyles.bodyM
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Challenge {
  final String name;
  final String description;
  final int current;
  final int target;
  final Gradient gradient;
  final Color color;
  final String emoji;
  final String timeLeft;
  final int reward;

  const _Challenge(this.name, this.description, this.current, this.target,
      this.gradient, this.color, this.emoji, this.timeLeft, this.reward);
}
