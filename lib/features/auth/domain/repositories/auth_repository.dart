import 'package:dartz/dartz.dart';
import 'package:nexus_gym/core/error/failures.dart';
import 'package:nexus_gym/features/auth/domain/entities/user_entity.dart';

/// Contract for authentication operations
/// Implemented in data/repositories/auth_repository_impl.dart
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Create a new account with email and password
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign in with Google OAuth
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign out from all providers
  Future<Either<Failure, void>> signOut();

  /// Get current authenticated user, null if not logged in
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Watch auth state changes as a stream
  Stream<UserEntity?> watchAuthState();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordReset({required String email});

  /// Update user profile data
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    double? weightKg,
    int? heightCm,
    FitnessGoal? goal,
    ExperienceLevel? experienceLevel,
    List<String>? equipment,
    List<String>? injuries,
  });
}
