import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/router/app_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _controller = PageController();
  int _currentPage = 0;
  late AnimationController _floatController;
  late AnimationController _glowController;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      gradient: AppColors.primaryGradient,
      icon: LucideIcons.bot,
      title: 'AI Personal\nTrainer',
      subtitle:
          'Your elite AI coach powered by advanced LLM technology. Get personalized plans, real-time feedback, and psychology-backed motivation.',
      color: AppColors.primaryElectricBlue,
      secondaryIcon: LucideIcons.cpu,
      featureChips: [
        'Personalised Plans',
        'Real-time Feedback',
        'Smart Coaching'
      ],
    ),
    _OnboardingPage(
      gradient: AppColors.metaverseGradient,
      icon: LucideIcons.boxes,
      title: 'Metaverse\nGym Space',
      subtitle:
          'Enter your 3D virtual gym. Train your avatar, join live classes, compete with others, and earn digital trophies.',
      color: AppColors.primaryNeonPurple,
      secondaryIcon: LucideIcons.scan,
      featureChips: ['3D Virtual Gym', 'Live Classes', 'Digital Trophies'],
    ),
    _OnboardingPage(
      gradient: AppColors.goldGradient,
      icon: LucideIcons.trophy,
      title: 'Gamified\nFitness',
      subtitle:
          'Earn XP, climb leaderboards, unlock NFT trophies, and join seasonal challenges. Fitness has never felt this rewarding.',
      color: AppColors.accentGold,
      secondaryIcon: LucideIcons.medal,
      featureChips: ['XP & Leveling', 'Leaderboards', 'Weekly Challenges'],
    ),
    _OnboardingPage(
      gradient: AppColors.emeraldGradient,
      icon: LucideIcons.salad,
      title: 'Smart\nNutrition AI',
      subtitle:
          'Macro calculator, AI meal plans, grocery lists, and smart calorie adjustment — all personalized to your body and goals.',
      color: AppColors.accentEmerald,
      secondaryIcon: LucideIcons.pieChart,
      featureChips: ['Macro Tracking', 'AI Meal Plans', 'Grocery Lists'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Animated background accent
          AnimatedBuilder(
            animation: _floatController,
            builder: (_, __) {
              final page = _pages[_currentPage];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                child: Stack(
                  children: [
                    Positioned(
                      top: -100 + _floatController.value * 20,
                      right: -80,
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            page.color.withValues(alpha: 0.08),
                            page.color.withValues(alpha: 0.02),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100 + _floatController.value * 15,
                      left: -60,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            page.color.withValues(alpha: 0.05),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) => _OnboardingPageView(
              page: _pages[index],
              floatAnimation: _floatController,
              glowAnimation: _glowController,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final isLast = _currentPage == _pages.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 52),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.backgroundDark.withValues(alpha: 0.6),
            AppColors.backgroundDark.withValues(alpha: 0.95),
            AppColors.backgroundDark,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Column(
        children: [
          // Page indicator with progress style
          SmoothPageIndicator(
            controller: _controller,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: _pages[_currentPage].color,
              dotColor: AppColors.backgroundSurface,
              dotHeight: 5,
              dotWidth: 5,
              expansionFactor: 5,
              spacing: 6,
            ),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              if (!isLast)
                GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark.withValues(alpha: 0.3),
                          offset: const Offset(3, 3),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: AppColors.shadowLight.withValues(alpha: 0.5),
                          offset: const Offset(-2, -2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.labelL
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
              const Spacer(),
              NeumorphicButton(
                label: isLast ? 'Get Started' : 'Next',
                onPressed: _nextPage,
                style: NeuButtonStyle.primary,
                icon: isLast ? LucideIcons.rocket : LucideIcons.moveRight,
                width: isLast ? 200 : 130,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;
  final Animation<double> floatAnimation;
  final Animation<double> glowAnimation;

  const _OnboardingPageView({
    required this.page,
    required this.floatAnimation,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 80, 28, 240),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated icon cluster
          _buildIconCluster(),

          const SizedBox(height: 52),

          // Title with gradient
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => page.gradient
                .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              page.title,
              style: AppTextStyles.displayL.copyWith(
                fontFamily: 'Rajdhani',
                color: Colors.white,
                height: 1.0,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 600.ms)
              .slideX(begin: -0.15, end: 0, delay: 100.ms),

          const SizedBox(height: 20),

          // Subtitle
          Text(
            page.subtitle,
            style: AppTextStyles.bodyL.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          )
              .animate()
              .fadeIn(delay: 250.ms, duration: 500.ms)
              .slideY(begin: 0.15, end: 0, delay: 250.ms),

          const SizedBox(height: 28),

          // Feature chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: page.featureChips.asMap().entries.map((entry) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark.withValues(alpha: 0.3),
                      offset: const Offset(2, 2),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: AppColors.shadowLight.withValues(alpha: 0.5),
                      offset: const Offset(-1, -1),
                      blurRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: page.color.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: page.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: page.color.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.value,
                      style: AppTextStyles.labelS.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 400 + entry.key * 100),
                    duration: 400.ms,
                  )
                  .slideX(
                    begin: 0.2,
                    end: 0,
                    delay: Duration(milliseconds: 400 + entry.key * 100),
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconCluster() {
    return AnimatedBuilder(
      animation: Listenable.merge([floatAnimation, glowAnimation]),
      builder: (_, __) {
        final floatY = math.sin(floatAnimation.value * math.pi) * 8;
        final glow = glowAnimation.value;

        return SizedBox(
          width: 150,
          height: 120,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background shadow icon (parallax)
              Positioned(
                right: 0,
                top: 10 + floatY * 0.5,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowDark.withValues(alpha: 0.35),
                        offset: const Offset(4, 4),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: AppColors.shadowLight.withValues(alpha: 0.5),
                        offset: const Offset(-3, -3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (b) => LinearGradient(
                      colors: [
                        page.color,
                        page.color.withValues(alpha: 0.35),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
                    child:
                        Icon(page.secondaryIcon, color: Colors.white, size: 24),
                  ),
                ),
              ),

              // Main icon
              Positioned(
                left: 0,
                top: floatY,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: page.gradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: page.color.withValues(alpha: 0.35 + glow * 0.15),
                        blurRadius: 30 + glow * 10,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.shadowDark.withValues(alpha: 0.4),
                        offset: const Offset(6, 6),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Icon(page.icon, color: Colors.white, size: 46),
                ),
              ),
            ],
          ),
        );
      },
    )
        .animate()
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn();
  }
}

class _OnboardingPage {
  final Gradient gradient;
  final IconData icon;
  final IconData secondaryIcon;
  final String title;
  final String subtitle;
  final Color color;
  final List<String> featureChips;

  const _OnboardingPage({
    required this.gradient,
    required this.icon,
    required this.secondaryIcon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.featureChips,
  });
}
