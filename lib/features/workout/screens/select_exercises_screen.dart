import 'package:flutter/material.dart';
import '../../../core/services/program_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class SelectExercisesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selected;
  const SelectExercisesScreen({super.key, this.selected = const []});

  @override
  State<SelectExercisesScreen> createState() => _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends State<SelectExercisesScreen> {
  final _api = ApiClient.instance;
  final _searchCtrl = TextEditingController();

  bool _loading = true;
  List<Map<String, dynamic>> _exercises = [];
  List<Map<String, dynamic>> _filtered = [];
  List<Map<String, dynamic>> _selected = [];
  String _category = 'All';
  final _categories = ['All', 'Upper', 'Lower', 'Core', 'Cardio'];

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
    _selected = List.from(widget.selected);
    _loadExercises();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    setState(() => _loading = true);
    try {
      final params = <String, dynamic>{};
      if (_category != 'All') params['category'] = _category;

      final response = await _api.get(ApiEndpoints.exercises, queryParameters: params);
      final data = response.data;

      if (data['success'] == true) {
        setState(() {
          _exercises = List<Map<String, dynamic>>.from(data['data'] ?? []);
          _applyFilter();
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List.from(_exercises);
      } else {
        _filtered = _exercises.where((e) =>
          (e['name']?.toString() ?? '').toLowerCase().contains(query) ||
          (e['muscle_group']?.toString() ?? '').toLowerCase().contains(query)
        ).toList();
      }
    });
  }

  bool _isSelected(int id) => _selected.any((e) => _toInt(e['id']) == id);

  void _toggle(Map<String, dynamic> exercise) {
    final id = _toInt(exercise['id']);
    setState(() {
      if (_isSelected(id)) {
        _selected.removeWhere((e) => _toInt(e['id']) == id);
      } else {
        _selected.add({
          ...exercise,
          'sets': 3,
          'reps': '10',
          'rest_seconds': 60,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercises (${_selected.length})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: cs.primary, fontSize: 15)),
          ),
        ],
      ),
      body: Column(children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (_) => _applyFilter(),
            style: TextStyle(fontSize: 14, color: cs.onSurface),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: Icon(Icons.search_rounded, size: 20, color: cs.onSurface.withOpacity(0.4)),
              filled: true, fillColor: cs.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline.withOpacity(0.5))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),

        // Category filters
        SizedBox(height: 36, child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, i) {
            final sel = _category == _categories[i];
            return GestureDetector(
              onTap: () { setState(() => _category = _categories[i]); _loadExercises(); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: sel ? cs.primary.withOpacity(0.06) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: sel ? cs.primary : cs.outline.withOpacity(0.5)),
                ),
                child: Center(child: Text(_categories[i], style: TextStyle(
                  fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? cs.primary : cs.onSurface.withOpacity(0.45),
                ))),
              ),
            );
          },
        )),
        const SizedBox(height: 8),

        // Exercise list
        Expanded(
          child: _loading
              ? Center(child: CircularProgressIndicator(color: cs.primary))
              : _filtered.isEmpty
                  ? Center(child: Text('No exercises found', style: TextStyle(color: cs.onSurface.withOpacity(0.5))))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final ex = _filtered[i];
                        final id = _toInt(ex['id']);
                        final sel = _isSelected(id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => _toggle(ex),
                            child: Row(children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: sel ? cs.primary.withOpacity(0.1) : cs.onSurface.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(10),
                                  border: sel ? Border.all(color: cs.primary, width: 2) : null,
                                ),
                                child: Icon(
                                  sel ? Icons.check_rounded : Icons.fitness_center_outlined,
                                  color: sel ? cs.primary : cs.onSurface.withOpacity(0.4),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(ex['name']?.toString() ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
                                const SizedBox(height: 2),
                                Text('${ex['muscle_group'] ?? ''} · ${ex['equipment'] ?? 'None'}',
                                  style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.38))),
                              ])),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: cs.onSurface.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(ex['difficulty']?.toString() ?? '', style: TextStyle(fontSize: 10, color: cs.onSurface.withOpacity(0.5))),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
        ),
      ]),
    );
  }
}