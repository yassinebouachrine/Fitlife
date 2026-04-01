import 'package:flutter/material.dart';
import 'widgets/programs_tab.dart';
import 'widgets/my_workouts_tab.dart';
import 'widgets/history_tab.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    'Workout Hub',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tab,
              labelColor: theme.colorScheme.onSurface,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withOpacity(0.4),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              dividerColor: theme.colorScheme.outline.withOpacity(0.2),
              tabs: const [
                Tab(text: 'Programs'),
                Tab(text: 'My Workouts'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  ProgramsTab(),
                  MyWorkoutsTab(),
                  HistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}