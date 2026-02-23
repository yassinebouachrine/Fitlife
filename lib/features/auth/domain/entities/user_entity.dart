import 'package:equatable/equatable.dart';

/// Core user entity — the domain model for an authenticated user
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final int xp;
  final int level;
  final int streakDays;
  final FitnessGoal goal;
  final ExperienceLevel experienceLevel;
  final double weightKg;
  final int heightCm;
  final int workoutsCompleted;
  final List<String> equipment;
  final List<String> injuries;
  final SubscriptionTier subscription;
  final DateTime createdAt;
  final DateTime? lastWorkoutAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.streakDays = 0,
    this.goal = FitnessGoal.buildMuscle,
    this.experienceLevel = ExperienceLevel.beginner,
    this.weightKg = 70,
    this.heightCm = 175,
    this.workoutsCompleted = 0,
    this.equipment = const [],
    this.injuries = const [],
    this.subscription = SubscriptionTier.free,
    required this.createdAt,
    this.lastWorkoutAt,
  });

  /// XP required to reach next level (exponential curve)
  int get xpForNextLevel => (level * level * 100);

  /// Progress to next level as a 0.0–1.0 value
  double get levelProgress {
    final prevLevelXp = ((level - 1) * (level - 1) * 100);
    final xpInLevel = xp - prevLevelXp;
    final xpNeeded = xpForNextLevel - prevLevelXp;
    return (xpInLevel / xpNeeded).clamp(0.0, 1.0);
  }

  bool get isPremium => subscription != SubscriptionTier.free;

  UserEntity copyWith({
    String? displayName,
    String? avatarUrl,
    int? xp,
    int? level,
    int? streakDays,
    FitnessGoal? goal,
    ExperienceLevel? experienceLevel,
    double? weightKg,
    int? heightCm,
    int? workoutsCompleted,
    List<String>? equipment,
    List<String>? injuries,
    SubscriptionTier? subscription,
    DateTime? lastWorkoutAt,
  }) {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      goal: goal ?? this.goal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      workoutsCompleted: workoutsCompleted ?? this.workoutsCompleted,
      equipment: equipment ?? this.equipment,
      injuries: injuries ?? this.injuries,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt,
      lastWorkoutAt: lastWorkoutAt ?? this.lastWorkoutAt,
    );
  }

  @override
  List<Object?> get props => [id, email, xp, level, streakDays];
}

enum FitnessGoal {
  buildMuscle('Build Muscle'),
  loseFat('Lose Fat'),
  maintain('Maintain'),
  improveEndurance('Improve Endurance'),
  increaseStrength('Increase Strength'),
  flexibility('Flexibility');

  final String label;
  const FitnessGoal(this.label);
}

enum ExperienceLevel {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced'),
  elite('Elite');

  final String label;
  const ExperienceLevel(this.label);
}

enum SubscriptionTier {
  free,
  nexusPro,
  nexusElite,
}
