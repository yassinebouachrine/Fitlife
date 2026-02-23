import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_gym/features/ai_coach/presentation/pages/ai_coach_page.dart';
import 'package:nexus_gym/features/auth/presentation/pages/login_page.dart';
import 'package:nexus_gym/features/auth/presentation/pages/register_page.dart';
import 'package:nexus_gym/features/challenges/presentation/pages/challenges_page.dart';
import 'package:nexus_gym/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:nexus_gym/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:nexus_gym/features/main_shell/main_shell.dart';
import 'package:nexus_gym/features/metaverse/presentation/pages/metaverse_page.dart';
import 'package:nexus_gym/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:nexus_gym/features/onboarding/onboarding_screen.dart';
import 'package:nexus_gym/features/profile/presentation/pages/profile_page.dart';
import 'package:nexus_gym/features/progress/presentation/pages/progress_page.dart';
import 'package:nexus_gym/features/splash/splash_screen.dart';
import 'package:nexus_gym/features/workout/presentation/pages/active_workout_page.dart';
import 'package:nexus_gym/features/workout/presentation/pages/workout_page.dart';

// ─── Route names ────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';

  // Auth
  static const login = '/login';
  static const register = '/register';

  // Main shell (tab-based)
  static const home = '/home';
  static const workout = '/workout';
  static const aiCoach = '/ai-coach';
  static const metaverse = '/metaverse';
  static const nutrition = '/nutrition';

  // Sub-pages (pushed on top of shell)
  static const activeWorkout = '/active-workout';
  static const progress = '/progress';
  static const leaderboard = '/leaderboard';
  static const challenges = '/challenges';
  static const profile = '/profile';
}

// ─── Router provider ────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // ── Splash ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Onboarding ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Auth ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // ── Main Shell (Bottom Nav) ──────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.workout,
            name: 'workout',
            builder: (context, state) => const WorkoutPage(),
          ),
          GoRoute(
            path: AppRoutes.aiCoach,
            name: 'ai-coach',
            builder: (context, state) => const AiCoachPage(),
          ),
          GoRoute(
            path: AppRoutes.metaverse,
            name: 'metaverse',
            builder: (context, state) => const MetaversePage(),
          ),
          GoRoute(
            path: AppRoutes.nutrition,
            name: 'nutrition',
            builder: (context, state) => const NutritionPage(),
          ),
        ],
      ),

      // ── Full-screen sub-pages ────────────────────────────────
      GoRoute(
        path: AppRoutes.activeWorkout,
        name: 'active-workout',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ActiveWorkoutPage(),
          transitionsBuilder: _fadeScaleTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.progress,
        name: 'progress',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProgressPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.leaderboard,
        name: 'leaderboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LeaderboardPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.challenges,
        name: 'challenges',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ChallengesPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfilePage(),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],

    // ── Error page ──────────────────────────────────────────────
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚡', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'Unknown route',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home',
                  style: TextStyle(color: Color(0xFF4F8EFF))),
            ),
          ],
        ),
      ),
    ),
  );
});

// ─── Page transitions ───────────────────────────────────────────

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    )),
    child: child,
  );
}

Widget _fadeScaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      ),
      child: child,
    ),
  );
}
