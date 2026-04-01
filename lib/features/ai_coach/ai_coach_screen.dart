import 'package:flutter/material.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});
  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final _ctrl = TextEditingController();
  final _msgs = <Map<String, dynamic>>[
    {'t': 'Hey! I\'m your Lifevora coach. I can help with workout plans, nutrition, form checks, and motivation. What would you like to work on?', 'u': false},
  ];

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() { _msgs.add({'t': t, 'u': true}); _ctrl.clear(); });
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _msgs.add({'t': 'Based on your profile, I recommend progressive overload this week. Increase compound lifts by 2.5kg with 60-90s rest. Want a detailed plan?', 'u': false}));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(body: SafeArea(child: Column(children: [
      // Header
      Padding(padding: const EdgeInsets.fromLTRB(16, 12, 8, 10), child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(11)),
          child: const Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Lifevora Coach', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(width: 5),
            Container(width: 6, height: 6, decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle)),
          ]),
          Text('Always here to help', style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
        ])),
        IconButton(icon: Icon(Icons.refresh_outlined, size: 20, color: cs.onSurface.withOpacity(0.35)),
          onPressed: () => setState(() { _msgs.clear(); _msgs.add({'t': 'Chat reset. How can I help?', 'u': false}); })),
      ])),
      Divider(height: 1, color: cs.outline.withOpacity(0.3)),

      // Chat
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(16), itemCount: _msgs.length,
        itemBuilder: (_, i) {
          final m = _msgs[i]; final u = m['u'] as bool;
          return Align(
            alignment: u ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
              decoration: BoxDecoration(
                color: u ? cs.primary.withOpacity(0.06) : cs.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(u ? 16 : 4), bottomRight: Radius.circular(u ? 4 : 16),
                ),
                border: Border.all(color: u ? cs.primary.withOpacity(0.12) : cs.outline.withOpacity(0.4)),
              ),
              child: Text(m['t'] as String, style: TextStyle(fontSize: 14, color: cs.onSurface, height: 1.45)),
            ),
          );
        },
      )),

      // Suggestions
      SizedBox(height: 36, child: ListView(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _sug(cs, Icons.calendar_today_outlined, 'Weekly plan'),
          const SizedBox(width: 6),
          _sug(cs, Icons.restaurant_outlined, 'Nutrition'),
          const SizedBox(width: 6),
          _sug(cs, Icons.trending_up_outlined, 'Progress'),
          const SizedBox(width: 6),
          _sug(cs, Icons.help_outline_rounded, 'Form tips'),
        ],
      )),
      const SizedBox(height: 6),

      // Input
      Padding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 8), child: Row(children: [
        Expanded(child: TextField(
          controller: _ctrl,
          style: TextStyle(fontSize: 14, color: cs.onSurface),
          decoration: InputDecoration(
            hintText: 'Ask anything...',
            filled: true, fillColor: cs.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline.withOpacity(0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.primary)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onSubmitted: (_) => _send(),
        )),
        const SizedBox(width: 8),
        SizedBox(width: 44, height: 44, child: ElevatedButton(
          onPressed: _send,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary, foregroundColor: Colors.white, elevation: 0, padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Icon(Icons.arrow_upward_rounded, size: 20),
        )),
      ])),
    ])));
  }

  Widget _sug(ColorScheme cs, IconData icon, String l) => GestureDetector(
    onTap: () { _ctrl.text = l; _send(); },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surface, borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withOpacity(0.4)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: cs.primary),
        const SizedBox(width: 5),
        Text(l, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.55))),
      ]),
    ),
  );
}