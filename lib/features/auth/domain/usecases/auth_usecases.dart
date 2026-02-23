import 'package:dartz/dartz.dart';
import 'package:nexus_gym/core/error/failures.dart';
import 'package:nexus_gym/features/auth/domain/entities/user_entity.dart';
import 'package:nexus_gym/features/auth/domain/repositories/auth_repository.dart';

/// Use case: Sign in with email & password
class SignInWithEmailUseCase {
  final AuthRepository _repository;
  const SignInWithEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || !email.contains('@')) {
      return Left(
          ValidationFailure(message: 'Please enter a valid email address'));
    }
    if (password.length < 6) {
      return Left(
          ValidationFailure(message: 'Password must be at least 6 characters'));
    }
    return _repository.signInWithEmail(email: email, password: password);
  }
}

/// Use case: Register with email & password
class RegisterWithEmailUseCase {
  final AuthRepository _repository;
  const RegisterWithEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String displayName,
    required String confirmPassword,
  }) async {
    if (displayName.length < 2) {
      return Left(
          ValidationFailure(message: 'Name must be at least 2 characters'));
    }
    if (!email.contains('@')) {
      return Left(
          ValidationFailure(message: 'Please enter a valid email address'));
    }
    if (password.length < 8) {
      return Left(
          ValidationFailure(message: 'Password must be at least 8 characters'));
    }
    if (password != confirmPassword) {
      return Left(ValidationFailure(message: 'Passwords do not match'));
    }
    return _repository.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}

/// Use case: Sign in with Google
class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  const SignInWithGoogleUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.signInWithGoogle();
}

/// Use case: Sign out
class SignOutUseCase {
  final AuthRepository _repository;
  const SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.signOut();
}

/// Use case: Get current user
class GetCurrentUserUseCase {
  final AuthRepository _repository;
  const GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity?>> call() => _repository.getCurrentUser();
}

/// Use case: Watch auth state stream
class WatchAuthStateUseCase {
  final AuthRepository _repository;
  const WatchAuthStateUseCase(this._repository);

  Stream<UserEntity?> call() => _repository.watchAuthState();
}

/// Use case: Update user profile
class UpdateProfileUseCase {
  final AuthRepository _repository;
  const UpdateProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String userId,
    String? displayName,
    String? avatarUrl,
    double? weightKg,
    int? heightCm,
    FitnessGoal? goal,
    ExperienceLevel? experienceLevel,
    List<String>? equipment,
    List<String>? injuries,
  }) {
    return _repository.updateProfile(
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
      weightKg: weightKg,
      heightCm: heightCm,
      goal: goal,
      experienceLevel: experienceLevel,
      equipment: equipment,
      injuries: injuries,
    );
  }
}
