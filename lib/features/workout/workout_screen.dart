import 'package:flutter/material.dart';
import 'widgets/programs_tab.dart';
import 'widgets/my_workouts_tab.dart';
import 'widgets/history_tab.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with SingleTickerProviderStateMixin {
  late final _tab = TabController(length: 3, vsync: this);
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Row(children: [
            Text('Workouts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
            const Spacer(),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: cs.surface,
                side: BorderSide(color: cs.outline.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              ),
              icon: Icon(Icons.search_rounded, size: 20, color: cs.onSurface.withOpacity(0.45)),
            ),
          ]),
        ),
        TabBar(
          controller: _tab,
          labelColor: cs.onSurface,
          unselectedLabelColor: cs.onSurface.withOpacity(0.35),
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
          indicatorColor: cs.primary,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: cs.outline.withOpacity(0.2),
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [Tab(text: 'Programs'), Tab(text: 'My Workouts'), Tab(text: 'History')],
        ),
        Expanded(child: TabBarView(controller: _tab, children: const [ProgramsTab(), MyWorkoutsTab(), HistoryTab()])),
      ])),
    );
  }
}