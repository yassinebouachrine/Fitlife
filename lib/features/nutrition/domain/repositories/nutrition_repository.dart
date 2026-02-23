import 'package:dartz/dartz.dart';
import 'package:nexus_gym/core/error/failures.dart';
import 'package:nexus_gym/features/nutrition/domain/entities/nutrition_entity.dart';

/// Contract for nutrition tracking operations
abstract class NutritionRepository {
  /// Search food database
  Future<Either<Failure, List<FoodEntity>>> searchFoods(String query);

  /// Add a food log entry for the current user
  Future<Either<Failure, FoodLogEntry>> logFood({
    required String userId,
    required FoodEntity food,
    required double amountGrams,
    required MealType mealType,
  });

  /// Get all food logs for a specific date
  Future<Either<Failure, List<FoodLogEntry>>> getLogsForDate({
    required String userId,
    required DateTime date,
  });

  /// Delete a food log entry
  Future<Either<Failure, void>> deleteLog(String logId);

  /// Get or calculate nutrition targets for a user
  Future<Either<Failure, NutritionTargetEntity>> getNutritionTargets(
      String userId);

  /// Update nutrition targets
  Future<Either<Failure, NutritionTargetEntity>> updateTargets(
      NutritionTargetEntity targets);

  /// Get weekly nutrition summary
  Future<Either<Failure, Map<DateTime, NutritionValues>>> getWeeklySummary(
      String userId);

  /// AI generates a personalized meal plan
  Future<Either<Failure, Map<String, List<FoodLogEntry>>>> generateMealPlan({
    required String userId,
    required NutritionTargetEntity targets,
    List<String>? dietaryRestrictions,
    String? goal,
  });
}
