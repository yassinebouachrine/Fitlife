import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          "Hey! I'm NEXUS — your AI fitness coach. Tell me what you need: workout plans, nutrition tips, or motivation. What's on your agenda today? 💪",
      'isUser': false,
    },
  ];

  void _send() {
    final t = _controller.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add({'text': t, 'isUser': true});
      _controller.clear();
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text':
              'Great question! Based on your Level 12 profile, I recommend increasing your compound lifts by 2.5kg this week. Want a detailed plan?',
          'isUser': false,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.psychology_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('NEXUS AI Coach',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                )),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Text('Powered by Advanced AI',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.4),
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh_rounded,
                        color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    onPressed: () {
                      setState(() {
                        _messages.clear();
                        _messages.add({
                          'text':
                              "Chat reset! How can I help you today? 💪",
                          'isUser': false,
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: theme.colorScheme.outline.withOpacity(0.2),
              height: 1,
            ),
            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  return _bubble(theme, m['text'], m['isUser']);
                },
              ),
            ),
            // Suggestions
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _suggestion(theme, Icons.calendar_today_rounded,
                      'Weekly plan'),
                  const SizedBox(width: 8),
                  _suggestion(
                      theme, Icons.restaurant_rounded, 'Nutrition tips'),
                  const SizedBox(width: 8),
                  _suggestion(
                      theme, Icons.trending_up_rounded, 'Track progress'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask NEXUS anything...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.35),
                          ),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(ThemeData theme, String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: Border.all(
            color: isUser
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _suggestion(ThemeData theme, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
        _send();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                )),
          ],
        ),
      ),
    );
  }
}