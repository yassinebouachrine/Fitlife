import 'package:dartz/dartz.dart';
import 'package:nexus_gym/core/error/failures.dart';
import 'package:nexus_gym/features/workout/domain/entities/workout_entity.dart';
import 'package:nexus_gym/features/workout/domain/repositories/workout_repository.dart';

/// Use case: Get all public workout programs with optional filters
class GetWorkoutProgramsUseCase {
  final WorkoutRepository _repository;
  const GetWorkoutProgramsUseCase(this._repository);

  Future<Either<Failure, List<WorkoutProgramEntity>>> call({
    WorkoutCategory? category,
    DifficultyLevel? difficulty,
  }) =>
      _repository.getPrograms(category: category, difficulty: difficulty);
}

/// Use case: Start an active workout session
class StartWorkoutSessionUseCase {
  final WorkoutRepository _repository;
  const StartWorkoutSessionUseCase(this._repository);

  Future<Either<Failure, WorkoutSessionEntity>> call({
    required String userId,
    required String programId,
    required String dayName,
  }) =>
      _repository.startSession(
          userId: userId, programId: programId, dayName: dayName);
}

/// Use case: Log a single completed set during a workout
class LogSetUseCase {
  final WorkoutRepository _repository;
  const LogSetUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String sessionId,
    required CompletedSetEntity set,
  }) {
    if (set.reps <= 0) {
      return Future.value(
          Left(ValidationFailure(message: 'Reps must be greater than 0')));
    }
    if (set.weightKg < 0) {
      return Future.value(
          Left(ValidationFailure(message: 'Weight cannot be negative')));
    }
    return _repository.logSet(sessionId: sessionId, completedSet: set);
  }
}

/// Use case: Complete a workout session and earn XP
class CompleteWorkoutSessionUseCase {
  final WorkoutRepository _repository;
  const CompleteWorkoutSessionUseCase(this._repository);

  Future<Either<Failure, WorkoutSessionEntity>> call({
    required String sessionId,
    required int durationMinutes,
    String? notes,
  }) async {
    if (durationMinutes < 1) {
      return Left(ValidationFailure(
          message: 'Session duration must be at least 1 minute'));
    }
    return _repository.completeSession(
      sessionId: sessionId,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }
}

/// Use case: Get workout history
class GetWorkoutHistoryUseCase {
  final WorkoutRepository _repository;
  const GetWorkoutHistoryUseCase(this._repository);

  Future<Either<Failure, List<WorkoutSessionEntity>>> call({
    required String userId,
    int limit = 20,
    DateTime? before,
  }) =>
      _repository.getHistory(userId: userId, limit: limit, before: before);
}

/// Use case: Get personal records for all exercises
class GetPersonalRecordsUseCase {
  final WorkoutRepository _repository;
  const GetPersonalRecordsUseCase(this._repository);

  Future<Either<Failure, Map<String, CompletedSetEntity>>> call(
          String userId) =>
      _repository.getPersonalRecords(userId);
}

/// Use case: AI generates a fully personalized workout program
class GenerateAIWorkoutUseCase {
  final WorkoutRepository _repository;
  const GenerateAIWorkoutUseCase(this._repository);

  Future<Either<Failure, WorkoutProgramEntity>> call({
    required String userId,
    required String goal,
    required String experienceLevel,
    required int daysPerWeek,
    required List<String> equipment,
    String? specialInstructions,
  }) {
    if (daysPerWeek < 1 || daysPerWeek > 7) {
      return Future.value(Left(
          ValidationFailure(message: 'Days per week must be between 1 and 7')));
    }
    return _repository.generateAIProgram(
      userId: userId,
      goal: goal,
      experienceLevel: experienceLevel,
      daysPerWeek: daysPerWeek,
      equipment: equipment,
      specialInstructions: specialInstructions,
    );
  }
}
