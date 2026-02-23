import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';
import 'package:nexus_gym/core/router/app_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background orbs
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primaryViolet.withValues(alpha: 0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primaryCyan.withValues(alpha: 0.10),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.primaryViolet.withValues(alpha: 0.5),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(LucideIcons.zap,
                          color: Colors.white, size: 40),
                    ),
                  ).animate().scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 40),

                  // Title
                  GradientText(
                    'Welcome\nBack',
                    style: AppTextStyles.displayM.copyWith(color: Colors.white),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 10),
                  Text(
                    'Sign in to continue your fitness journey',
                    style: AppTextStyles.bodyM
                        .copyWith(color: AppColors.textMuted),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 48),

                  // Form card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color:
                              AppColors.backgroundCard.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.glassBorder,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.shadowDark.withValues(alpha: 0.8),
                              offset: const Offset(8, 8),
                              blurRadius: 20,
                            ),
                            BoxShadow(
                              color:
                                  AppColors.shadowLight.withValues(alpha: 0.15),
                              offset: const Offset(-4, -4),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Email Address'),
                            const SizedBox(height: 8),
                            _buildInput(
                              controller: _emailCtrl,
                              hint: 'you@nexusgym.ai',
                              icon: LucideIcons.mail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            _buildLabel('Password'),
                            const SizedBox(height: 8),
                            _buildInput(
                              controller: _passCtrl,
                              hint: '••••••••',
                              icon: LucideIcons.lock,
                              isPassword: true,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.labelM.copyWith(
                                  color: AppColors.primaryViolet,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            NeumorphicButton(
                              label: 'Sign In',
                              onPressed: _handleLogin,
                              isLoading: _isLoading,
                              style: NeuButtonStyle.primary,
                              icon: LucideIcons.logIn,
                              isFullWidth: true,
                              height: 56,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: _divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: AppTextStyles.labelS
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ),
                      Expanded(child: _divider()),
                    ],
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 20),

                  // Social buttons
                  Row(
                    children: [
                      Expanded(child: _socialButton('Google', null, 'G')),
                      const SizedBox(width: 12),
                      Expanded(
                          child:
                              _socialButton('Apple', LucideIcons.apple, null)),
                    ],
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 36),

                  // Sign up
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(AppRoutes.register),
                      child: RichText(
                        text: TextSpan(
                          text: 'New to NexusGym?  ',
                          style: AppTextStyles.bodyM
                              .copyWith(color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: 'Create Account',
                              style: AppTextStyles.labelM.copyWith(
                                color: AppColors.primaryViolet,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryViolet,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withValues(alpha: 0.6),
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? _obscurePassword : false,
        style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
          prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.glassBorder,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _socialButton(String label, IconData? icon, String? badge) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withValues(alpha: 0.6),
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.15),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: AppColors.textSecondary, size: 22)
          else if (badge != null)
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Text(
            label,
            style:
                AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
