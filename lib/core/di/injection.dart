// Dependency injection placeholder — configure with get_it + injectable
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Services
  // getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  // getIt.registerLazySingleton<AICoachService>(() => AICoachServiceImpl());
  // getIt.registerLazySingleton<WorkoutService>(() => WorkoutServiceImpl());
  // etc.
}
