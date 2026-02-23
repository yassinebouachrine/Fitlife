import 'package:dartz/dartz.dart';
import 'package:nexus_gym/core/error/failures.dart';
import 'package:nexus_gym/features/workout/domain/entities/workout_entity.dart';

/// Contract for workout data operations
abstract class WorkoutRepository {
  /// Get all public workout programs
  Future<Either<Failure, List<WorkoutProgramEntity>>> getPrograms({
    WorkoutCategory? category,
    DifficultyLevel? difficulty,
  });

  /// Get programs created by or saved by current user
  Future<Either<Failure, List<WorkoutProgramEntity>>> getUserPrograms(
      String userId);

  /// Get a specific program by ID
  Future<Either<Failure, WorkoutProgramEntity>> getProgramById(String id);

  /// Create a new custom workout program
  Future<Either<Failure, WorkoutProgramEntity>> createProgram(
      WorkoutProgramEntity program);

  /// Start a workout session (creates an active session record)
  Future<Either<Failure, WorkoutSessionEntity>> startSession({
    required String userId,
    required String programId,
    required String dayName,
  });

  /// Log a completed set during an active session
  Future<Either<Failure, void>> logSet({
    required String sessionId,
    required CompletedSetEntity completedSet,
  });

  /// Complete and save the workout session
  Future<Either<Failure, WorkoutSessionEntity>> completeSession({
    required String sessionId,
    required int durationMinutes,
    String? notes,
  });

  /// Get workout history for a user
  Future<Either<Failure, List<WorkoutSessionEntity>>> getHistory({
    required String userId,
    int limit = 20,
    DateTime? before,
  });

  /// Get personal records for a specific exercise
  Future<Either<Failure, Map<String, CompletedSetEntity>>> getPersonalRecords(
      String userId);

  /// AI generates a custom workout program based on user context
  Future<Either<Failure, WorkoutProgramEntity>> generateAIProgram({
    required String userId,
    required String goal,
    required String experienceLevel,
    required int daysPerWeek,
    required List<String> equipment,
    String? specialInstructions,
  });
}
