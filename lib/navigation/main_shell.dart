import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/workout/workout_screen.dart';
import '../features/ai_coach/ai_coach_screen.dart';
import '../features/metaverse/metaverse_screen.dart';
import '../features/profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    WorkoutScreen(),
    AiCoachScreen(),
    MetaverseScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _navItem(0, Icons.home_rounded, 'Home'),
                _navItem(1, Icons.fitness_center_rounded, 'Workout'),
                _centerItem(),
                _navItem(3, Icons.public_rounded, 'Metaverse'),
                _navItem(4, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final selected = _index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerItem() {
    final theme = Theme.of(context);
    final selected = _index == 2;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      )
                    : null,
                color: selected
                    ? null
                    : theme.colorScheme.onSurface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.psychology_rounded,
                color: selected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.4),
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'AI Coach',
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}