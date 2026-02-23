import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '3M';

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
              'Progress',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
              gradient: AppColors.goldGradient,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accentGold,
              tabs: const [
                Tab(text: 'Body'),
                Tab(text: 'Strength'),
                Tab(text: 'Workouts'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBodyTab(),
            _buildStrengthTab(),
            _buildWorkoutsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 20),
          _buildBodyChart(),
          const SizedBox(height: 24),
          _buildBodyStats(),
          const SizedBox(height: 24),
          _buildMilestones(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['1W', '1M', '3M', '6M', '1Y'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: periods.map((p) {
        final selected = _selectedPeriod == p;
        return GestureDetector(
          onTap: () => setState(() => _selectedPeriod = p),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.goldGradient : null,
              color: selected ? null : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: AppColors.accentGold.withOpacity(0.3),
                    blurRadius: 12,
                  ),
              ],
            ),
            child: Text(
              p,
              style: AppTextStyles.labelM.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBodyChart() {
    // Simplified bar chart using raw Flutter widgets
    final data = [68.0, 74.0, 78.0, 80.5, 81.2, 82.0, 82.3];
    final labels = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'];
    final maxVal = 90.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.6),
            offset: const Offset(6, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Body Weight',
                      style: AppTextStyles.labelL
                          .copyWith(color: AppColors.textSecondary)),
                  GradientText(
                    '82.3 kg',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                    gradient: AppColors.goldGradient,
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+14.2 kg',
                  style: AppTextStyles.labelM
                      .copyWith(color: AppColors.accentEmerald),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Bar chart
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((e) {
                final height = (e.value / maxVal) * 100;
                final isLast = e.key == data.length - 1;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400 + e.key * 80),
                        curve: Curves.easeOutCubic,
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          gradient: isLast
                              ? AppColors.goldGradient
                              : LinearGradient(
                                  colors: [
                                    AppColors.primaryElectricBlue.withOpacity(0.5),
                                    AppColors.primaryElectricBlue.withOpacity(0.2),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: isLast
                              ? [
                                  BoxShadow(
                                    color: AppColors.accentGold.withOpacity(0.4),
                                    blurRadius: 12,
                                  )
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(labels[e.key],
                          style: AppTextStyles.caption.copyWith(
                              color: isLast
                                  ? AppColors.accentGold
                                  : AppColors.textMuted)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildBodyStats() {
    final measurements = [
      ('Chest', '104 cm', '+8 cm'),
      ('Waist', '84 cm', '-4 cm'),
      ('Arms', '38 cm', '+5 cm'),
      ('Legs', '62 cm', '+6 cm'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.6,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: measurements.asMap().entries.map((e) {
        final m = e.value;
        final gain = m.$3.startsWith('+');
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.$1,
                  style: AppTextStyles.labelM
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Text(m.$2,
                  style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
              Text(
                m.$3,
                style: AppTextStyles.labelM.copyWith(
                    color: gain ? AppColors.accentEmerald : AppColors.accentRose),
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: e.key * 80));
      }).toList(),
    );
  }

  Widget _buildMilestones() {
    final milestones = [
      ('First 10kg added', '🏋️', true),
      ('100 workouts', '💯', true),
      ('30-day streak', '🔥', true),
      ('200lb bench press', '⚡', false),
      ('6 pack visible', '✨', false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Milestones',
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        ...milestones.asMap().entries.map((e) {
          final m = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: m.$3
                  ? Border.all(color: AppColors.accentGold.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                Text(m.$2, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    m.$1,
                    style: AppTextStyles.bodyM.copyWith(
                      color: m.$3
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      decoration:
                          m.$3 ? null : TextDecoration.none,
                    ),
                  ),
                ),
                Icon(
                  m.$3 ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                  color: m.$3 ? AppColors.accentGold : AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: e.key * 80));
        }),
      ],
    );
  }

  Widget _buildStrengthTab() {
    final lifts = [
      ('Bench Press', 80, 100, AppColors.primaryElectricBlue),
      ('Squat', 120, 150, AppColors.primaryNeonPurple),
      ('Deadlift', 140, 180, AppColors.accentOrange),
      ('OHP', 60, 80, AppColors.accentEmerald),
      ('Pull-ups', 16, 20, AppColors.accentGold),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: lifts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final l = lifts[i];
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.$1,
                      style:
                          AppTextStyles.h4.copyWith(color: AppColors.textPrimary)),
                  Text(
                    '${l.$2} / ${l.$3} kg',
                    style: AppTextStyles.labelM.copyWith(color: l.$4),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: l.$2 / l.$3,
                  backgroundColor: AppColors.backgroundSurface,
                  valueColor: AlwaysStoppedAnimation<Color>(l.$4),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${((l.$2 / l.$3) * 100).toInt()}% of goal',
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 100));
      },
    );
  }

  Widget _buildWorkoutsTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 8,
      itemBuilder: (_, i) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark.withOpacity(0.4),
              offset: const Offset(3, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day ${i + 1} — ${['Upper Body', 'Legs', 'Push', 'Pull', 'Core', 'Cardio', 'Full Body', 'HIIT'][i]}',
                      style: AppTextStyles.bodyM
                          .copyWith(color: AppColors.textPrimary)),
                  Text('Week ${(i ~/ 3) + 1} of 8',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentEmerald.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Done',
                style: AppTextStyles.labelS
                    .copyWith(color: AppColors.accentEmerald),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: i * 80)),
    );
  }
}
