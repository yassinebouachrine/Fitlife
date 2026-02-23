import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/router/app_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 3400), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _orbController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // ── Animated mesh gradient orbs ──
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final t = _orbController.value;
              return Stack(
                children: [
                  // Violet orb top-right
                  Positioned(
                    top: -80 + math.sin(t * math.pi * 2) * 30,
                    right: -60 + math.cos(t * math.pi * 2) * 20,
                    child: Container(
                      width: 360,
                      height: 360,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppColors.primaryViolet.withValues(alpha: 0.18),
                          AppColors.primaryMagenta.withValues(alpha: 0.06),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                  // Cyan orb bottom-left
                  Positioned(
                    bottom: -100 + math.cos(t * math.pi * 2) * 25,
                    left: -80 + math.sin(t * math.pi * 2) * 15,
                    child: Container(
                      width: 380,
                      height: 380,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppColors.primaryCyan.withValues(alpha: 0.12),
                          AppColors.accentEmerald.withValues(alpha: 0.04),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                  // Gold accent orb mid
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    left: 20 + math.sin(t * math.pi * 4) * 10,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppColors.accentGold.withValues(alpha: 0.08),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Floating geometric particles ──
          ..._buildFloatingShapes(),

          // ── Main content ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Logo
                _buildAnimatedLogo(),

                const SizedBox(height: 44),

                // Brand name
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: const Text(
                    'NEXUSGYM',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 12,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 700.ms)
                    .slideY(begin: 0.3, end: 0, delay: 400.ms),

                const SizedBox(height: 10),

                // Tagline
                const Text(
                  'AI  ·  FITNESS  ·  METAVERSE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                    color: AppColors.textMuted,
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

                const Spacer(flex: 2),

                // Progress section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Column(
                    children: [
                      // Progress track
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSurface,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.shadowDark.withValues(alpha: 0.8),
                              offset: const Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (_, __) {
                            final value = Curves.easeInOut
                                .transform(_progressController.value);
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: AppColors.primaryGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryViolet
                                          .withValues(alpha: 0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _LoadingDots(),
                    ],
                  ),
                ).animate().fadeIn(delay: 900.ms, duration: 500.ms),

                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _ringController]),
      builder: (_, __) {
        final pulse = _pulseController.value;
        final ring = _ringController.value;

        return SizedBox(
          width: 170,
          height: 170,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryViolet
                          .withValues(alpha: 0.12 + pulse * 0.1),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: AppColors.primaryCyan
                          .withValues(alpha: 0.06 + pulse * 0.05),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Orbital ring 1
              Transform.rotate(
                angle: ring * math.pi * 2,
                child: CustomPaint(
                  size: const Size(155, 155),
                  painter: _RingPainter(
                    progress: ring,
                    color: AppColors.primaryViolet.withValues(alpha: 0.25),
                  ),
                ),
              ),

              // Orbital ring 2 (counter)
              Transform.rotate(
                angle: -ring * math.pi * 2 + math.pi / 3,
                child: CustomPaint(
                  size: const Size(140, 140),
                  painter: _RingPainter(
                    progress: ring,
                    color: AppColors.primaryCyan.withValues(alpha: 0.18),
                  ),
                ),
              ),

              // Main neumorphic circle
              Container(
                width: 114,
                height: 114,
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.glassBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark.withValues(alpha: 0.9),
                      offset: const Offset(10, 10),
                      blurRadius: 24,
                    ),
                    BoxShadow(
                      color: AppColors.shadowLight.withValues(alpha: 0.3),
                      offset: const Offset(-8, -8),
                      blurRadius: 20,
                    ),
                    BoxShadow(
                      color: AppColors.primaryViolet
                          .withValues(alpha: 0.08 + pulse * 0.08),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: const Icon(LucideIcons.zap,
                        size: 52, color: Colors.white),
                  ),
                ),
              ),

              // Orbiting dot
              Transform.rotate(
                angle: ring * math.pi * 2,
                child: Transform.translate(
                  offset: const Offset(0, -72),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryViolet.withValues(alpha: 0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Second orbiting dot
              Transform.rotate(
                angle: -ring * math.pi * 2 + math.pi,
                child: Transform.translate(
                  offset: const Offset(0, -65),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: AppColors.emeraldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryCyan.withValues(alpha: 0.7),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    )
        .animate()
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 500.ms);
  }

  List<Widget> _buildFloatingShapes() {
    return [
      Positioned(
        top: MediaQuery.of(context).size.height * 0.15,
        right: 40,
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.primaryViolet.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: -12, duration: 3000.ms)
          .fadeIn(duration: 1000.ms),
      Positioned(
        bottom: MediaQuery.of(context).size.height * 0.25,
        left: 50,
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: AppColors.accentEmerald.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: 10, duration: 2500.ms, delay: 500.ms)
          .fadeIn(duration: 1000.ms),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.65,
        right: 60,
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            shape: BoxShape.circle,
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: -8, duration: 2800.ms, delay: 300.ms)
          .fadeIn(duration: 1000.ms),
    ];
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    for (int i = 0; i < 4; i++) {
      final startAngle = (i * math.pi / 2) + progress * math.pi * 2;
      canvas.drawArc(rect, startAngle, math.pi / 4, false, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => true;
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final phase = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
            final opacity = math.sin(phase * math.pi).clamp(0.15, 1.0);
            final scale = 0.8 + math.sin(phase * math.pi) * 0.4;
            final isFirst = i == 0;
            final isLast = i == 2;
            final dotColor = isFirst
                ? AppColors.primaryViolet
                : isLast
                    ? AppColors.primaryCyan
                    : AppColors.primaryMagenta;
            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor.withValues(alpha: opacity),
                  boxShadow: [
                    BoxShadow(
                      color: dotColor.withValues(alpha: opacity * 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
