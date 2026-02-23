import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_gym/features/workout/domain/entities/workout_entity.dart';

/// Active workout session state
class ActiveWorkoutState {
  final WorkoutSessionEntity? session;
  final List<CompletedSetEntity> completedSets;
  final int currentExerciseIndex;
  final int currentSetIndex;
  final bool isResting;
  final int restSecondsRemaining;
  final int elapsedSeconds;
  final bool isComplete;

  const ActiveWorkoutState({
    this.session,
    this.completedSets = const [],
    this.currentExerciseIndex = 0,
    this.currentSetIndex = 0,
    this.isResting = false,
    this.restSecondsRemaining = 0,
    this.elapsedSeconds = 0,
    this.isComplete = false,
  });

  ActiveWorkoutState copyWith({
    WorkoutSessionEntity? session,
    List<CompletedSetEntity>? completedSets,
    int? currentExerciseIndex,
    int? currentSetIndex,
    bool? isResting,
    int? restSecondsRemaining,
    int? elapsedSeconds,
    bool? isComplete,
  }) {
    return ActiveWorkoutState(
      session: session ?? this.session,
      completedSets: completedSets ?? this.completedSets,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      isResting: isResting ?? this.isResting,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  /// Total volume lifted in this session (kg × reps)
  int get totalVolume => completedSets.fold(
      0, (sum, set) => sum + (set.weightKg * set.reps).round());

  /// Number of new PRs achieved
  int get prCount => completedSets.where((s) => s.isPR).length;

  /// XP earned (base: 100 per workout + 10 per set + 50 per PR)
  int get xpEarned =>
      100 + (completedSets.length * 10) + (prCount * 50);
}

/// Active workout state notifier — manages the in-progress workout
class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  Timer? _workoutTimer;
  Timer? _restTimer;

  ActiveWorkoutNotifier() : super(const ActiveWorkoutState());

  /// Start the workout — begins the elapsed timer
  void startWorkout() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  /// Log a completed set for the current exercise
  void logSet({
    required String exerciseId,
    required String exerciseName,
    required int reps,
    required double weightKg,
    bool isPR = false,
  }) {
    final newSet = CompletedSetEntity(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      setNumber: state.currentSetIndex + 1,
      reps: reps,
      weightKg: weightKg,
      isPR: isPR,
    );
    state = state.copyWith(
      completedSets: [...state.completedSets, newSet],
      currentSetIndex: state.currentSetIndex + 1,
    );
  }

  /// Start rest timer (called after logging a set)
  void startRest(int seconds) {
    _restTimer?.cancel();
    state = state.copyWith(isResting: true, restSecondsRemaining: seconds);
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restSecondsRemaining <= 1) {
        timer.cancel();
        state = state.copyWith(isResting: false, restSecondsRemaining: 0);
      } else {
        state = state.copyWith(
            restSecondsRemaining: state.restSecondsRemaining - 1);
      }
    });
  }

  void skipRest() {
    _restTimer?.cancel();
    state = state.copyWith(isResting: false, restSecondsRemaining: 0);
  }

  void nextExercise() {
    state = state.copyWith(
      currentExerciseIndex: state.currentExerciseIndex + 1,
      currentSetIndex: 0,
    );
  }

  /// Complete the entire workout session
  void completeWorkout() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    state = state.copyWith(isComplete: true);
  }

  /// Reset for a fresh session
  void reset() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    state = const ActiveWorkoutState();
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(
  (ref) => ActiveWorkoutNotifier(),
);

/// Formatted elapsed time string: "MM:SS"
final elapsedTimeProvider = Provider<String>((ref) {
  final elapsed = ref.watch(activeWorkoutProvider).elapsedSeconds;
  final m = elapsed ~/ 60;
  final s = elapsed % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
});
