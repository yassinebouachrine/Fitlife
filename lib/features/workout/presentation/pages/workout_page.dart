import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_container.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';
import 'package:nexus_gym/core/router/app_router.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Upper', 'Lower', 'Core', 'Cardio', 'HIIT'];

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
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            floating: true,
            snap: true,
            title: GradientText(
              'Workout Hub',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded,
                    color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryElectricBlue,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTextStyles.labelM.copyWith(color: AppColors.textPrimary),
              unselectedLabelStyle: AppTextStyles.labelM.copyWith(color: AppColors.textMuted),
              tabs: const [
                Tab(text: 'Programs'),
                Tab(text: 'My Workouts'),
                Tab(text: 'History'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProgramsTab(context),
            _buildMyWorkoutsTab(context),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeumorphicButton(
            label: 'Generate AI Workout Plan',
            icon: Icons.auto_awesome_rounded,
            style: NeuButtonStyle.primary,
            onPressed: () => context.go(AppRoutes.aiCoach),
            isFullWidth: true,
          ).animate().fadeIn(),

          const SizedBox(height: 24),

          // Filter chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _selectedFilter == _filters[i];
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = _filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: selected ? AppColors.primaryGradient : null,
                      color: selected ? null : AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        if (selected)
                          BoxShadow(
                            color: AppColors.primaryElectricBlue.withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        BoxShadow(
                          color: AppColors.shadowDark.withOpacity(0.4),
                          offset: const Offset(2, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      _filters[i],
                      style: AppTextStyles.labelM.copyWith(
                        color: selected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          ..._workoutPrograms.map((program) =>
              _buildWorkoutCard(context, program).animate().fadeIn(
                    delay: Duration(
                        milliseconds: 100 * _workoutPrograms.indexOf(program)),
                  )),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, _WorkoutProgram p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.6),
            offset: const Offset(6, 6),
            blurRadius: 16,
          ),
          BoxShadow(
            color: AppColors.shadowLight.withOpacity(0.3),
            offset: const Offset(-3, -3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: p.gradient,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Icon(p.icon, color: Colors.white, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: AppTextStyles.h3
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        p.description,
                        style: AppTextStyles.bodyS
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                XPBadge(xp: p.xp),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statChip(Icons.timer_outlined, '${p.duration} min'),
                _statChip(Icons.repeat_rounded, '${p.weeks} weeks'),
                _statChip(Icons.star_rounded, p.difficulty),
                NeumorphicButton(
                  label: 'Start',
                  onPressed: () => context.go(AppRoutes.activeWorkout),
                  style: NeuButtonStyle.primary,
                  width: 80,
                  height: 36,
                  borderRadius: 12,
                  textStyle: AppTextStyles.labelM,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.labelS.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMyWorkoutsTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            'Create Custom Workout',
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Build your own workout or let the AI\ncreate one for you',
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          NeumorphicButton(
            label: 'Create Workout',
            onPressed: () {},
            style: NeuButtonStyle.primary,
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _historyItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final item = _historyItems[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: AppTextStyles.h4
                            .copyWith(color: AppColors.textPrimary)),
                    Text(item.date,
                        style: AppTextStyles.bodyS
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  XPBadge(xp: item.xp, compact: true),
                  const SizedBox(height: 4),
                  Text(
                    '${item.duration} min',
                    style: AppTextStyles.labelS
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
      },
    );
  }
}

// Data models
class _WorkoutProgram {
  final String name;
  final String description;
  final int duration;
  final int weeks;
  final String difficulty;
  final Gradient gradient;
  final IconData icon;
  final int xp;

  const _WorkoutProgram({
    required this.name,
    required this.description,
    required this.duration,
    required this.weeks,
    required this.difficulty,
    required this.gradient,
    required this.icon,
    required this.xp,
  });
}

class _HistoryItem {
  final String name;
  final String date;
  final int xp;
  final int duration;
  final IconData icon;

  const _HistoryItem({
    required this.name,
    required this.date,
    required this.xp,
    required this.duration,
    required this.icon,
  });
}

final List<_WorkoutProgram> _workoutPrograms = [
  _WorkoutProgram(
    name: 'Power Hypertrophy',
    description: 'Build serious size & strength',
    duration: 60,
    weeks: 12,
    difficulty: 'Advanced',
    gradient: AppColors.primaryGradient,
    icon: Icons.fitness_center,
    xp: 500,
  ),
  _WorkoutProgram(
    name: 'Shred Protocol',
    description: 'High-intensity fat burning',
    duration: 45,
    weeks: 8,
    difficulty: 'Intermediate',
    gradient: AppColors.goldGradient,
    icon: Icons.local_fire_department_rounded,
    xp: 380,
  ),
  _WorkoutProgram(
    name: 'Athletic Performance',
    description: 'Speed, agility & power',
    duration: 50,
    weeks: 10,
    difficulty: 'Advanced',
    gradient: AppColors.emeraldGradient,
    icon: Icons.directions_run_rounded,
    xp: 450,
  ),
  _WorkoutProgram(
    name: 'Beginner Foundation',
    description: 'Perfect starting point',
    duration: 35,
    weeks: 6,
    difficulty: 'Beginner',
    gradient: AppColors.metaverseGradient,
    icon: Icons.star_border_rounded,
    xp: 200,
  ),
];

final List<_HistoryItem> _historyItems = [
  _HistoryItem(
    name: 'Upper Body Power',
    date: 'Today, 9:30 AM',
    xp: 350,
    duration: 48,
    icon: Icons.fitness_center,
  ),
  _HistoryItem(
    name: 'HIIT Cardio Blast',
    date: 'Yesterday, 7:00 AM',
    xp: 280,
    duration: 30,
    icon: Icons.directions_run_rounded,
  ),
  _HistoryItem(
    name: 'Leg Day Destruction',
    date: '2 days ago',
    xp: 400,
    duration: 55,
    icon: Icons.sports_gymnastics_rounded,
  ),
  _HistoryItem(
    name: 'Core & Mobility',
    date: '3 days ago',
    xp: 220,
    duration: 35,
    icon: Icons.self_improvement_rounded,
  ),
];
