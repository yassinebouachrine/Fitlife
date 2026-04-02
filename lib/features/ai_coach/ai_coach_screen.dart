import 'package:flutter/material.dart';
import '../../core/services/ai_service.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});
  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final _ctrl = TextEditingController();
  final _scrollController = ScrollController();
  final _aiService = AiService();

  final _msgs = <Map<String, dynamic>>[
    {
      't': 'Hey! I\'m your Lifevora coach. I can help with workout plans, nutrition, form checks, and motivation. What would you like to work on?',
      'u': false,
    },
  ];

  bool _sending = false;
  bool _loadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final response = await _aiService.getChatHistory();
      if (response['success'] == true) {
        final history = List<Map<String, dynamic>>.from(response['data'] ?? []);

        if (history.isNotEmpty) {
          setState(() {
            _msgs.clear();
            // History comes in DESC order, reverse it
            for (final chat in history.reversed) {
              _msgs.add({'t': chat['message'] ?? '', 'u': true});
              _msgs.add({'t': chat['response'] ?? '', 'u': false});
            }
          });
          _scrollToBottom();
        }
      }
    } catch (_) {
      // Silent fail — keep default welcome message
    } finally {
      setState(() => _loadingHistory = false);
    }
  }

  void _send() async {
    final t = _ctrl.text.trim();
    if (t.isEmpty || _sending) return;

    setState(() {
      _msgs.add({'t': t, 'u': true});
      _ctrl.clear();
      _sending = true;
    });
    _scrollToBottom();

    try {
      final response = await _aiService.sendMessage(t);

      if (response['success'] == true) {
        final aiMessage = response['data']?['message'] ?? 'I couldn\'t process that. Try again!';
        setState(() => _msgs.add({'t': aiMessage, 'u': false}));
      } else {
        setState(() => _msgs.add({
              't': response['message'] ?? 'Something went wrong. Try again!',
              'u': false,
            }));
      }
    } catch (e) {
      setState(() => _msgs.add({
            't': 'Sorry, I couldn\'t connect to the server. Please check your connection and try again.',
            'u': false,
          }));
    } finally {
      setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  void _clearChat() async {
    try {
      await _aiService.clearChat();
      setState(() {
        _msgs.clear();
        _msgs.add({
          't': 'Chat reset. How can I help you today?',
          'u': false,
        });
      });
    } catch (e) {
      setState(() {
        _msgs.clear();
        _msgs.add({'t': 'Chat reset. How can I help?', 'u': false});
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      // Header
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 10),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(11)),
              child: const Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Lifevora Coach',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurface)),
                const SizedBox(width: 5),
                Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
              ]),
              Text('Always here to help',
                  style: TextStyle(fontSize: 11, color: cs.onSurface.withOpacity(0.38))),
            ])),
            IconButton(
                icon: Icon(Icons.refresh_outlined, size: 20, color: cs.onSurface.withOpacity(0.35)),
                onPressed: _clearChat),
          ])),
      Divider(height: 1, color: cs.outline.withOpacity(0.3)),

      // Chat
      Expanded(
          child: _loadingHistory
              ? Center(child: CircularProgressIndicator(color: cs.primary))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _msgs.length + (_sending ? 1 : 0),
                  itemBuilder: (_, i) {
                    // Show typing indicator
                    if (i == _msgs.length && _sending) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(4),
                            ),
                            border: Border.all(color: cs.outline.withOpacity(0.4)),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary)),
                            const SizedBox(width: 10),
                            Text('Thinking...', style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.5))),
                          ]),
                        ),
                      );
                    }

                    final m = _msgs[i];
                    final u = m['u'] as bool;
                    return Align(
                      alignment: u ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                        decoration: BoxDecoration(
                          color: u ? cs.primary.withOpacity(0.06) : cs.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(u ? 16 : 4),
                            bottomRight: Radius.circular(u ? 4 : 16),
                          ),
                          border: Border.all(color: u ? cs.primary.withOpacity(0.12) : cs.outline.withOpacity(0.4)),
                        ),
                        child: Text(m['t'] as String,
                            style: TextStyle(fontSize: 14, color: cs.onSurface, height: 1.45)),
                      ),
                    );
                  },
                )),

      // Suggestions
      SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _sug(cs, Icons.calendar_today_outlined, 'Weekly plan'),
              const SizedBox(width: 6),
              _sug(cs, Icons.restaurant_outlined, 'Nutrition'),
              const SizedBox(width: 6),
              _sug(cs, Icons.trending_up_outlined, 'Progress'),
              const SizedBox(width: 6),
              _sug(cs, Icons.help_outline_rounded, 'Form tips'),
              const SizedBox(width: 6),
              _sug(cs, Icons.emoji_emotions_outlined, 'Motivation'),
            ],
          )),
      const SizedBox(height: 6),

      // Input
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Row(children: [
            Expanded(
                child: TextField(
              controller: _ctrl,
              style: TextStyle(fontSize: 14, color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                filled: true,
                fillColor: cs.surface,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.outline.withOpacity(0.5))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.primary)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _send(),
              enabled: !_sending,
            )),
            const SizedBox(width: 8),
            SizedBox(
                width: 44,
                height: 44,
                child: ElevatedButton(
                  onPressed: _sending ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: cs.primary.withOpacity(0.5),
                  ),
                  child: _sending
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.arrow_upward_rounded, size: 20),
                )),
          ])),
    ])));
  }

  Widget _sug(ColorScheme cs, IconData icon, String l) => GestureDetector(
        onTap: _sending
            ? null
            : () {
                _ctrl.text = l;
                _send();
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.outline.withOpacity(0.4)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 13, color: cs.primary),
            const SizedBox(width: 5),
            Text(l,
                style:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.55))),
          ]),
        ),
      );
}