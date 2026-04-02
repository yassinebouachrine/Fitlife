import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/services/program_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/xp_badge.dart';

class ProgramsTab extends StatefulWidget {
  const ProgramsTab({super.key});
  @override
  State<ProgramsTab> createState() => _ProgramsTabState();
}

class _ProgramsTabState extends State<ProgramsTab> {
  final _programService = ProgramService();

  int _f = 0;
  final _tags = ['All', 'Upper', 'Lower', 'Core', 'Cardio'];

  bool _loading = true;
  String _error = '';
  List<Map<String, dynamic>> _programs = [];

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    setState(() { _loading = true; _error = ''; });

    try {
      final category = _tags[_f];
      final response = await _programService.getPrograms(
        category: category == 'All' ? null : category,
      );

      if (response['success'] == true) {
        setState(() {
          _programs = List<Map<String, dynamic>>.from(response['data'] ?? []);
          _loading = false;
        });
      } else {
        setState(() { _error = response['message']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _loadPrograms,
      color: cs.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(children: [
          SizedBox(width: double.infinity, height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome_outlined, size: 18),
              label: const Text('Generate AI Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary, foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              ),
            ),
          ),
          const SizedBox(height: 14),

          SizedBox(height: 34, child: ListView.separated(
            scrollDirection: Axis.horizontal, itemCount: _tags.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final sel = _f == i;
              return GestureDetector(
                onTap: () { setState(() => _f = i); _loadPrograms(); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: sel ? cs.primary.withOpacity(0.06) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sel ? cs.primary : cs.outline.withOpacity(0.5)),
                  ),
                  child: Center(child: Text(_tags[i], style: TextStyle(
                    fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? cs.primary : cs.onSurface.withOpacity(0.45),
                  ))),
                ),
              );
            },
          )),
          const SizedBox(height: 14),

          if (_loading)
            const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())
          else if (_error.isNotEmpty)
            Padding(padding: const EdgeInsets.all(40), child: Column(children: [
              Icon(Icons.cloud_off_outlined, size: 40, color: cs.onSurface.withOpacity(0.3)),
              const SizedBox(height: 12),
              Text(_error, style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _loadPrograms, child: const Text('Retry')),
            ]))
          else if (_programs.isEmpty)
            Padding(padding: const EdgeInsets.all(40), child: Column(children: [
              Icon(Icons.fitness_center_outlined, size: 40, color: cs.onSurface.withOpacity(0.3)),
              const SizedBox(height: 12),
              Text('No programs found', style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
            ]))
          else
            ..._programs.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              final iconsList = [Icons.fitness_center_outlined, Icons.local_fire_department_outlined,
                Icons.directions_run_outlined, Icons.self_improvement_outlined];
              final colorsList = [c.C.blue600, c.C.rose, c.C.emerald, c.C.cyan];

              return Padding(
                padding: EdgeInsets.only(bottom: i < _programs.length - 1 ? 10 : 0),
                child: _card(cs,
                  p['name']?.toString() ?? '',
                  p['description']?.toString() ?? '',
                  '${_toInt(p['session_duration_min'])} min',
                  '${_toInt(p['duration_weeks'])} wk',
                  p['difficulty']?.toString() ?? '',
                  _toInt(p['xp_reward']),
                  iconsList[i % iconsList.length],
                  colorsList[i % colorsList.length],
                ),
              );
            }),
        ]),
      ),
    );
  }

  Widget _card(ColorScheme cs, String title, String sub, String dur, String wk, String lvl, int xp,
      IconData icon, Color col) => AppCard(
    padding: EdgeInsets.zero,
    child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: col, size: 19)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38)),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          XpBadge(xp: xp, small: true),
        ]),
      ),
      Divider(height: 1, color: cs.outline.withOpacity(0.3)),
      Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Row(children: [
          _tag(cs, Icons.schedule_outlined, dur),
          const SizedBox(width: 12),
          _tag(cs, Icons.date_range_outlined, wk),
          const SizedBox(width: 12),
          _tag(cs, Icons.bar_chart_outlined, lvl),
          const Spacer(),
          SizedBox(height: 32, child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: col, foregroundColor: Colors.white, elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            child: const Text('Start'),
          )),
        ]),
      ),
    ]),
  );

  Widget _tag(ColorScheme cs, IconData icon, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 13, color: cs.onSurface.withOpacity(0.3)),
    const SizedBox(width: 3),
    Text(t, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.4))),
  ]);
}