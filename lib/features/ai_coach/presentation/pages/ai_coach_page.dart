import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/neumorphic_container.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';
import 'package:nexus_gym/features/ai_coach/data/services/ai_coach_service.dart';

// Providers
final aiCoachServiceProvider =
    Provider<AICoachService>((ref) => AICoachService());

final coachMessagesProvider =
    StateNotifierProvider<CoachMessagesNotifier, List<CoachMessage>>(
  (ref) => CoachMessagesNotifier(),
);

class CoachMessagesNotifier extends StateNotifier<List<CoachMessage>> {
  CoachMessagesNotifier()
      : super([
          const CoachMessage(
            text:
                "Hey! I'm NEXUS — your elite AI fitness coach. I'm here to help you dominate your goals. Tell me what you need — workout plans, nutrition advice, technique tips, or just some motivation. What's on your agenda today? 💪",
            isUser: false,
            timestamp: '',
          ),
        ]);

  void addMessage(CoachMessage msg) => state = [...state, msg];
  void clear() => state = [
        const CoachMessage(
          text: "Session reset. How can I help you today?",
          isUser: false,
          timestamp: '',
        ),
      ];
}

final isLoadingProvider = StateProvider<bool>((ref) => false);

final userContextProvider = Provider<UserFitnessContext>(
  (ref) => const UserFitnessContext(
    goal: 'Build Muscle',
    experienceLevel: 'Intermediate',
    weightKg: 82,
    heightCm: 181,
    workoutsPerWeek: 5,
    streakDays: 18,
  ),
);

class AiCoachPage extends ConsumerStatefulWidget {
  const AiCoachPage({super.key});

  @override
  ConsumerState<AiCoachPage> createState() => _AiCoachPageState();
}

class _AiCoachPageState extends ConsumerState<AiCoachPage> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();

  final List<String> _quickPrompts = [
    '📅 Generate my weekly plan',
    '🍎 Optimize my nutrition',
    '💪 Form tips for bench press',
    '🔥 10 min HIIT workout',
    '😴 Recovery advice',
    '📊 Assess my progress',
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final service = ref.read(aiCoachServiceProvider);
    final context = ref.read(userContextProvider);
    final messages = ref.read(coachMessagesProvider.notifier);

    _messageCtrl.clear();

    // Add user message
    messages.addMessage(CoachMessage(
      text: text,
      isUser: true,
      timestamp: _timeString(),
    ));

    // Set loading
    ref.read(isLoadingProvider.notifier).state = true;

    // Scroll to bottom
    _scrollToBottom();

    // Get AI response
    try {
      final response =
          await service.sendMessage(userMessage: text, context: context);

      messages.addMessage(CoachMessage(
        text: response.message,
        isUser: false,
        timestamp: _timeString(),
        response: response,
      ));
    } catch (_) {
      messages.addMessage(const CoachMessage(
        text: 'Connection error. Please check your internet and try again.',
        isUser: false,
        timestamp: '',
      ));
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _timeString() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(coachMessagesProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == messages.length && isLoading) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessage(messages[i], i);
                },
              ),
            ),
            _buildQuickPrompts(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        border: const Border(
            bottom: BorderSide(color: AppColors.glassBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryElectricBlue.withOpacity(0.5),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GradientText(
                    'NEXUS AI Coach',
                    style: AppTextStyles.h4.copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const GlowDot(color: AppColors.accentEmerald, size: 7),
                ],
              ),
              Text(
                'Powered by Advanced AI • Always evolving',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              ref.read(aiCoachServiceProvider).clearHistory();
              ref.read(coachMessagesProvider.notifier).clear();
            },
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.textMuted, size: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.textMuted, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(CoachMessage msg, int index) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.smart_toy_rounded,
                      color: Colors.white, size: 14),
                ),
                const SizedBox(width: 8),
                Text('NEXUS',
                    style: AppTextStyles.labelS
                        .copyWith(color: AppColors.primaryElectricBlue)),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isUser ? AppColors.primaryGradient : null,
              color: isUser ? null : AppColors.backgroundCard,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isUser
                    ? const Radius.circular(18)
                    : const Radius.circular(4),
                bottomRight: isUser
                    ? const Radius.circular(4)
                    : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: isUser
                      ? AppColors.primaryElectricBlue.withOpacity(0.3)
                      : AppColors.shadowDark.withOpacity(0.4),
                  blurRadius: isUser ? 16 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.text,
                  style: AppTextStyles.bodyM.copyWith(
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
                if (msg.response != null && msg.response!.weeklyPlan.isNotEmpty)
                  _buildWeeklyPlanPreview(msg.response!),
                if (msg.response != null &&
                    msg.response!.nutritionAdvice.isNotEmpty)
                  _buildNutritionTip(msg.response!.nutritionAdvice),
              ],
            ),
          ),
          if (msg.timestamp.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              msg.timestamp,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: min(index * 50, 300)))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildWeeklyPlanPreview(AICoachResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📅 Weekly Plan',
                  style: AppTextStyles.labelM
                      .copyWith(color: AppColors.primaryElectricBlue),
                ),
                const SizedBox(height: 8),
                ...response.weeklyPlan.take(4).map((day) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            day.day.substring(0, 3),
                            style: AppTextStyles.labelS.copyWith(
                                color: AppColors.accentGold, letterSpacing: 0),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            day.focus,
                            style: AppTextStyles.bodyS
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionTip(String tip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accentEmerald.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accentEmerald.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Text('🥗 ', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Text(
                  tip,
                  style: AppTextStyles.bodyS
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryElectricBlue,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scaleXY(
                      begin: 0.5,
                      end: 1.2,
                      delay: Duration(milliseconds: i * 150),
                      duration: 600.ms,
                    )
                    .then()
                    .scaleXY(begin: 1.2, end: 0.5, duration: 600.ms),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickPrompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _sendMessage(_quickPrompts[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowDark.withOpacity(0.4),
                  offset: const Offset(2, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              _quickPrompts[i],
              style:
                  AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        border: const Border(
            top: BorderSide(color: AppColors.glassBorder, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: TextField(
                controller: _messageCtrl,
                focusNode: _focusNode,
                style:
                    AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Ask NEXUS anything...',
                  hintStyle:
                      AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_messageCtrl.text),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryElectricBlue.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

int min(int a, int b) => a < b ? a : b;

class CoachMessage {
  final String text;
  final bool isUser;
  final String timestamp;
  final AICoachResponse? response;

  const CoachMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.response,
  });
}
