import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';

class ActiveWorkoutPage extends StatefulWidget {
  const ActiveWorkoutPage({super.key});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage>
    with TickerProviderStateMixin {
  int _currentExercise = 0;
  int _currentSet = 0;
  bool _isResting = false;
  int _restSeconds = 90;
  late AnimationController _timerController;
  late AnimationController _pulseController;

  final List<_Exercise> _exercises = const [
    _Exercise('Bench Press', 4, 8, '80 kg', 90),
    _Exercise('Incline Press', 3, 10, '70 kg', 75),
    _Exercise('Cable Fly', 3, 12, '25 kg', 60),
    _Exercise('Overhead Press', 4, 8, '55 kg', 90),
    _Exercise('Lateral Raise', 3, 15, '15 kg', 45),
    _Exercise('Tricep Pushdown', 3, 12, '40 kg', 60),
  ];

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _restSeconds),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _completeSet() {
    final ex = _exercises[_currentExercise];
    if (_currentSet < ex.sets - 1) {
      setState(() {
        _currentSet++;
        _isResting = true;
      });
    } else if (_currentExercise < _exercises.length - 1) {
      setState(() {
        _currentExercise++;
        _currentSet = 0;
        _isResting = true;
        _restSeconds = 120;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withOpacity(0.5),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              GradientText(
                'Workout\nComplete!',
                style: AppTextStyles.displayM.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
                gradient: AppColors.goldGradient,
              ),
              const SizedBox(height: 12),
              Text(
                '+350 XP earned! Amazing performance!',
                style:
                    AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              NeumorphicButton(
                label: 'Epic! Back to Home',
                onPressed: () => Navigator.of(context).pop(),
                style: NeuButtonStyle.gold,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercises[_currentExercise];
    final totalSets = exercise.sets;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
            ),
            title: Text(
              'Upper Body Power',
              style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentExercise + 1}/${_exercises.length}',
                  style: AppTextStyles.labelM.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentExercise + (_currentSet / totalSets)) /
                        _exercises.length,
                    backgroundColor: AppColors.backgroundSurface,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryElectricBlue),
                    minHeight: 6,
                  ),
                ),

                const SizedBox(height: 28),

                // Exercise hero card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryElectricBlue.withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 0.92, end: 1.08)
                            .animate(_pulseController),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        exercise.name,
                        style:
                            AppTextStyles.displayM.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _badge('${exercise.reps} reps'),
                          const SizedBox(width: 12),
                          _badge(exercise.weight),
                        ],
                      ),
                    ],
                  ),
                ).animate().scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 24),

                // Set tracker
                Container(
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
                    children: [
                      Text(
                        'Sets',
                        style: AppTextStyles.labelL
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          totalSets,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 6),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: i < _currentSet
                                  ? AppColors.emeraldGradient
                                  : i == _currentSet
                                      ? AppColors.primaryGradient
                                      : null,
                              color: i >= _currentSet
                                  ? AppColors.backgroundSurface
                                  : null,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: i <= _currentSet
                                  ? [
                                      BoxShadow(
                                        color: (i < _currentSet
                                                ? AppColors.accentEmerald
                                                : AppColors.primaryElectricBlue)
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: AppTextStyles.h4.copyWith(
                                  color: i >= _currentSet
                                      ? AppColors.textMuted
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Set ${_currentSet + 1} of $totalSets',
                        style: AppTextStyles.bodyM
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                if (_isResting) ...[
                  _buildRestTimer(),
                  const SizedBox(height: 16),
                ],

                NeumorphicButton(
                  label: _isResting ? 'Skip Rest' : 'Complete Set ✓',
                  onPressed: _isResting
                      ? () => setState(() => _isResting = false)
                      : _completeSet,
                  style: _isResting ? NeuButtonStyle.secondary : NeuButtonStyle.primary,
                  isFullWidth: true,
                  height: 58,
                  borderRadius: 20,
                ),

                const SizedBox(height: 24),

                // Exercise list
                Text(
                  'Exercise List',
                  style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                ..._exercises.asMap().entries.map((entry) {
                  final i = entry.key;
                  final e = entry.value;
                  final isDone = i < _currentExercise;
                  final isCurrent = i == _currentExercise;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primaryElectricBlue.withOpacity(0.1)
                          : AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(14),
                      border: isCurrent
                          ? Border.all(
                              color: AppColors.primaryElectricBlue.withOpacity(0.4))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: isDone
                                ? AppColors.emeraldGradient
                                : isCurrent
                                    ? AppColors.primaryGradient
                                    : null,
                            color: (!isDone && !isCurrent)
                                ? AppColors.backgroundSurface
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 16)
                                : Text(
                                    '${i + 1}',
                                    style: AppTextStyles.labelM.copyWith(
                                      color: isCurrent
                                          ? Colors.white
                                          : AppColors.textMuted,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e.name,
                            style: AppTextStyles.bodyM.copyWith(
                              color: isDone
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Text(
                          '${e.sets}×${e.reps}',
                          style: AppTextStyles.labelS
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelM.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildRestTimer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.accentOrange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_rounded,
              color: AppColors.accentOrange, size: 20),
          const SizedBox(width: 10),
          Text(
            'Rest: ${_restSeconds}s',
            style: AppTextStyles.h4.copyWith(color: AppColors.accentOrange),
          ),
          const Spacer(),
          Text(
            'Recover & breathe 🧘',
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _Exercise {
  final String name;
  final int sets;
  final int reps;
  final String weight;
  final int restSeconds;

  const _Exercise(
      this.name, this.sets, this.reps, this.weight, this.restSeconds);
}
