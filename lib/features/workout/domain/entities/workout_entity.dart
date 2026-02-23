import 'package:equatable/equatable.dart';

/// Workout program entity — represents a full program (e.g. "Push-Pull-Legs 5-Day")
class WorkoutProgramEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final WorkoutCategory category;
  final DifficultyLevel difficulty;
  final int durationWeeks;
  final int daysPerWeek;
  final List<WorkoutDayEntity> days;
  final String? imageUrl;
  final bool isAIGenerated;
  final int estimatedCalories;
  final List<String> targetMuscles;
  final String createdBy;
  final DateTime createdAt;

  const WorkoutProgramEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationWeeks,
    required this.daysPerWeek,
    required this.days,
    this.imageUrl,
    this.isAIGenerated = false,
    this.estimatedCalories = 0,
    this.targetMuscles = const [],
    required this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, category, difficulty];
}

/// A single training day in a program
class WorkoutDayEntity extends Equatable {
  final String id;
  final String name;
  final int dayNumber;
  final DayFocus focus;
  final List<ExerciseSetEntity> exercises;
  final int estimatedMinutes;

  const WorkoutDayEntity({
    required this.id,
    required this.name,
    required this.dayNumber,
    required this.focus,
    required this.exercises,
    required this.estimatedMinutes,
  });

  @override
  List<Object?> get props => [id, dayNumber, focus];
}

/// An exercise with sets/reps/rest inside a workout day
class ExerciseSetEntity extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final String reps; // "8-12" or "AMRAP" or "60 sec"
  final int restSeconds;
  final double? weightKg;
  final String? notes;
  final String? videoUrl;
  final List<String> formCues;

  const ExerciseSetEntity({
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.weightKg,
    this.notes,
    this.videoUrl,
    this.formCues = const [],
  });

  @override
  List<Object?> get props => [exerciseId, sets, reps, weightKg];
}

/// A completed workout session log
class WorkoutSessionEntity extends Equatable {
  final String id;
  final String userId;
  final String programId;
  final String dayName;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int durationMinutes;
  final int totalVolume; // kg × reps summed
  final int caloriesBurned;
  final int xpEarned;
  final List<CompletedSetEntity> completedSets;
  final String? notes;

  const WorkoutSessionEntity({
    required this.id,
    required this.userId,
    required this.programId,
    required this.dayName,
    required this.startedAt,
    this.completedAt,
    required this.durationMinutes,
    required this.totalVolume,
    this.caloriesBurned = 0,
    this.xpEarned = 0,
    required this.completedSets,
    this.notes,
  });

  bool get isCompleted => completedAt != null;

  @override
  List<Object?> get props => [id, startedAt, totalVolume];
}

class CompletedSetEntity extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final int setNumber;
  final int reps;
  final double weightKg;
  final bool isPR; // Personal Record

  const CompletedSetEntity({
    required this.exerciseId,
    required this.exerciseName,
    required this.setNumber,
    required this.reps,
    required this.weightKg,
    this.isPR = false,
  });

  @override
  List<Object?> get props => [exerciseId, setNumber, reps, weightKg];
}

enum WorkoutCategory {
  strength('Strength'),
  hypertrophy('Hypertrophy'),
  powerlifting('Powerlifting'),
  cardio('Cardio'),
  hiit('HIIT'),
  flexibility('Flexibility'),
  calisthenics('Calisthenics'),
  sport('Sport');

  final String label;
  const WorkoutCategory(this.label);
}

enum DifficultyLevel {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced'),
  elite('Elite');

  final String label;
  const DifficultyLevel(this.label);
}

enum DayFocus {
  chest('Chest'),
  back('Back'),
  legs('Legs'),
  shoulders('Shoulders'),
  arms('Arms'),
  core('Core'),
  fullBody('Full Body'),
  push('Push'),
  pull('Pull'),
  upperBody('Upper Body'),
  lowerBody('Lower Body'),
  cardio('Cardio'),
  rest('Rest & Recovery');

  final String label;
  const DayFocus(this.label);
}
