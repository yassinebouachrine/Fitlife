import 'package:equatable/equatable.dart';

/// A single food item in the nutrition database
class FoodEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatsPer100g;
  final double fiberPer100g;
  final String servingUnit; // 'g', 'ml', 'piece'

  const FoodEntity({
    required this.id,
    required this.name,
    this.brand = '',
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatsPer100g,
    this.fiberPer100g = 0,
    this.servingUnit = 'g',
  });

  NutritionValues forAmount(double amount) {
    final ratio = amount / 100;
    return NutritionValues(
      calories: caloriesPer100g * ratio,
      protein: proteinPer100g * ratio,
      carbs: carbsPer100g * ratio,
      fats: fatsPer100g * ratio,
      fiber: fiberPer100g * ratio,
    );
  }

  @override
  List<Object?> get props => [id, name, caloriesPer100g];
}

/// A log entry — a food item consumed at a specific time
class FoodLogEntry extends Equatable {
  final String id;
  final String userId;
  final FoodEntity food;
  final double amountGrams;
  final MealType mealType;
  final DateTime loggedAt;

  const FoodLogEntry({
    required this.id,
    required this.userId,
    required this.food,
    required this.amountGrams,
    required this.mealType,
    required this.loggedAt,
  });

  NutritionValues get nutrition => food.forAmount(amountGrams);

  @override
  List<Object?> get props => [id, food, amountGrams, mealType, loggedAt];
}

/// Aggregated nutrition values for a given amount/meal/day
class NutritionValues {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;

  const NutritionValues({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.fiber = 0,
  });

  NutritionValues operator +(NutritionValues other) => NutritionValues(
        calories: calories + other.calories,
        protein: protein + other.protein,
        carbs: carbs + other.carbs,
        fats: fats + other.fats,
        fiber: fiber + other.fiber,
      );

  static const NutritionValues zero =
      NutritionValues(calories: 0, protein: 0, carbs: 0, fats: 0);
}

/// Daily nutrition target based on user's goal and biometrics
class NutritionTargetEntity extends Equatable {
  final String userId;
  final int targetCalories;
  final int targetProteinG;
  final int targetCarbsG;
  final int targetFatsG;
  final DateTime setAt;

  const NutritionTargetEntity({
    required this.userId,
    required this.targetCalories,
    required this.targetProteinG,
    required this.targetCarbsG,
    required this.targetFatsG,
    required this.setAt,
  });

  /// Calculates macro targets using Mifflin-St Jeor + TDEE
  factory NutritionTargetEntity.calculate({
    required String userId,
    required double weightKg,
    required int heightCm,
    required int ageYears,
    required bool isMale,
    required double activityMultiplier, // 1.2–1.9
    required String goal, // 'build' | 'lose' | 'maintain'
  }) {
    // BMR (Mifflin-St Jeor)
    final bmr = isMale
        ? (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) + 5
        : (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears) - 161;

    final tdee = bmr * activityMultiplier;

    final kcal = switch (goal) {
      'build' => tdee + 300,
      'lose' => tdee - 400,
      _ => tdee,
    };

    // Protein: 2.0g/kg for muscle building, 2.2g/kg for fat loss
    final protein = (weightKg * (goal == 'lose' ? 2.2 : 2.0)).round();
    // Fat: 25% of calories
    final fats = ((kcal * 0.25) / 9).round();
    // Remaining → carbs
    final proteinKcal = protein * 4;
    final fatKcal = fats * 9;
    final carbs = ((kcal - proteinKcal - fatKcal) / 4).round();

    return NutritionTargetEntity(
      userId: userId,
      targetCalories: kcal.round(),
      targetProteinG: protein,
      targetCarbsG: carbs.clamp(0, 9999),
      targetFatsG: fats,
      setAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props =>
      [userId, targetCalories, targetProteinG, targetCarbsG, targetFatsG];
}

enum MealType {
  breakfast('Breakfast'),
  lunch('Lunch'),
  dinner('Dinner'),
  snack('Snack'),
  preWorkout('Pre-Workout'),
  postWorkout('Post-Workout');

  final String label;
  const MealType(this.label);
}
