import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart' as c;
import '../../../core/services/history_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/xp_badge.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});
  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final _historyService = HistoryService();

  bool _loading = true;
  String _error = '';
  List<Map<String, dynamic>> _history = [];
  Map<String, dynamic> _totals = {};

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
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() { _loading = true; _error = ''; });

    try {
      final response = await _historyService.getHistory();

      if (response['success'] == true) {
        final data = response['data'] ?? {};
        setState(() {
          _history = List<Map<String, dynamic>>.from(data['history'] ?? []);
          _totals = Map<String, dynamic>.from(data['totals'] ?? {});
          _loading = false;
        });
      } else {
        setState(() { _error = response['message']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _formatDate(dynamic dateVal) {
    if (dateVal == null) return '';
    try {
      final date = DateTime.parse(dateVal.toString());
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (dateOnly == today) return 'Today, ${DateFormat('h:mm a').format(date)}';
      if (dateOnly == yesterday) return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
      final diff = today.difference(dateOnly).inDays;
      if (diff < 7) return '$diff days ago';
      return DateFormat('MMM d, y').format(date);
    } catch (_) {
      return dateVal.toString();
    }
  }

  String _formatMinutes(dynamic mins) {
    final m = _toInt(mins);
    if (m >= 60) return '${(m / 60).toStringAsFixed(0)}h';
    return '${m}m';
  }

  String _formatNumber(dynamic n) {
    final val = _toInt(n);
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(1)}k';
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_loading) return Center(child: CircularProgressIndicator(color: cs.primary));

    if (_error.isNotEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.cloud_off_outlined, size: 40, color: cs.onSurface.withOpacity(0.3)),
        const SizedBox(height: 12),
        Text(_error, style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _loadHistory, child: const Text('Retry')),
      ]));
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      color: cs.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(children: [
          Row(children: [
            _s(cs, Icons.fitness_center_outlined, '${_toInt(_totals['total_sessions'])}', 'Total', c.C.blue500),
            const SizedBox(width: 8),
            _s(cs, Icons.schedule_outlined, _formatMinutes(_totals['total_minutes']), 'Time', c.C.emerald),
            const SizedBox(width: 8),
            _s(cs, Icons.bolt_outlined, _formatNumber(_totals['total_xp']), 'XP', c.C.amber),
          ]),
          const SizedBox(height: 16),

          if (_history.isEmpty)
            Padding(padding: const EdgeInsets.all(40), child: Column(children: [
              Icon(Icons.history_outlined, size: 40, color: cs.onSurface.withOpacity(0.3)),
              const SizedBox(height: 12),
              Text('No workout history yet', style: TextStyle(fontSize: 15, color: cs.onSurface.withOpacity(0.5))),
              const SizedBox(height: 4),
              Text('Complete a workout to see it here', style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.35))),
            ]))
          else
            ..._history.asMap().entries.map((entry) {
              final i = entry.key;
              final h = entry.value;
              final iconsList = [Icons.fitness_center_outlined, Icons.directions_run_outlined,
                Icons.sports_outlined, Icons.self_improvement_outlined];
              final colorsList = [c.C.blue500, c.C.rose, c.C.emerald, c.C.cyan, c.C.violet];

              return Padding(
                padding: EdgeInsets.only(bottom: i < _history.length - 1 ? 8 : 0),
                child: _h(cs,
                  h['workout_name']?.toString() ?? 'Workout',
                  _formatDate(h['completed_at']),
                  '${_toInt(h['duration_min'])} min',
                  _toInt(h['xp_earned']),
                  iconsList[i % iconsList.length],
                  colorsList[i % colorsList.length],
                ),
              );
            }),
        ]),
      ),
    );
  }

  Widget _s(ColorScheme cs, IconData icon, String v, String l, Color col) => Expanded(child: AppCard(
    child: Column(children: [
      Container(width: 32, height: 32,
        decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: col, size: 16)),
      const SizedBox(height: 8),
      Text(v, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: cs.onSurface)),
      Text(l, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
    ]),
  ));

  Widget _h(ColorScheme cs, String t, String d, String dur, int xp, IconData icon, Color col) => AppCard(
    child: Row(children: [
      Container(width: 40, height: 40,
        decoration: BoxDecoration(color: col.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: col, size: 18)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
        const SizedBox(height: 2),
        Text(d, style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        XpBadge(xp: xp, small: true),
        const SizedBox(height: 4),
        Text(dur, style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
      ]),
    ]),
  );
}