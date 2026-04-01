import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
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
  int _i = 0;
  final _pages = const [
    HomeScreen(), WorkoutScreen(), AiCoachScreen(),
    MetaverseScreen(), ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(index: _i, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outline.withOpacity(0.4))),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _item(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                _item(1, Icons.fitness_center_outlined, Icons.fitness_center_rounded, 'Workout'),
                _ai(),
                _item(3, Icons.explore_outlined, Icons.explore_rounded, 'Metaverse'),
                _item(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int idx, IconData off, IconData on, String label) {
    final cs = Theme.of(context).colorScheme;
    final sel = _i == idx;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _i = idx),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(sel ? on : off, size: 22,
              color: sel ? cs.primary : cs.onSurface.withOpacity(0.35)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(
              fontSize: 10, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
              color: sel ? cs.primary : cs.onSurface.withOpacity(0.35),
              letterSpacing: 0.1,
            )),
          ],
        ),
      ),
    );
  }

  Widget _ai() {
    final cs = Theme.of(context).colorScheme;
    final sel = _i == 2;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _i = 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: sel ? cs.primary : cs.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.auto_awesome_outlined, size: 20,
                color: sel ? Colors.white : cs.primary),
            ),
            const SizedBox(height: 2),
            Text('AI Coach', style: TextStyle(
              fontSize: 10,
              fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
              color: sel ? cs.primary : cs.onSurface.withOpacity(0.35),
            )),
          ],
        ),
      ),
    );
  }
}