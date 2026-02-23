import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_gym/features/auth/domain/entities/user_entity.dart';

/// Auth state — three clear states: loading, authenticated, unauthenticated
sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  final String? message; // optional error message
  const AuthUnauthenticated({this.message});
}

/// Auth state notifier — handles all authentication logic
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthLoading()) {
    _init();
  }

  /// Check if user is already logged in when app starts
  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate auth check
    // In production: check Firebase Auth current user
    state = const AuthUnauthenticated();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate API call
      // In production: call auth repository via use case
      state = AuthAuthenticated(
        UserEntity(
          id: 'user-001',
          email: email,
          displayName: 'Alex Johnson',
          xp: 2840,
          level: 12,
          streakDays: 18,
          goal: FitnessGoal.buildMuscle,
          experienceLevel: ExperienceLevel.intermediate,
          weightKg: 82.3,
          heightCm: 181,
          workoutsCompleted: 142,
          subscription: SubscriptionTier.nexusElite,
          createdAt: DateTime(2024, 6, 1),
        ),
      );
    } catch (e) {
      state = AuthUnauthenticated(message: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthLoading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = AuthAuthenticated(
        UserEntity(
          id: 'user-new',
          email: email,
          displayName: displayName,
          xp: 0,
          level: 1,
          streakDays: 0,
          goal: FitnessGoal.buildMuscle,
          experienceLevel: ExperienceLevel.beginner,
          weightKg: 70,
          heightCm: 175,
          workoutsCompleted: 0,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      state = AuthUnauthenticated(message: e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AuthUnauthenticated();
  }

  void updateUser(UserEntity updated) {
    if (state is AuthAuthenticated) {
      state = AuthAuthenticated(updated);
    }
  }
}

// ─── Providers ──────────────────────────────────────────────────────────────

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Convenient derived providers
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (authState is AuthAuthenticated) return authState.user;
  return null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider) is AuthAuthenticated;
});

final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider) is AuthLoading;
});
