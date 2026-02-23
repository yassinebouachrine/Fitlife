import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';
import 'package:nexus_gym/core/router/app_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String _selectedGoal = 'Build Muscle';

  final List<String> _goals = [
    'Build Muscle',
    'Lose Weight',
    'Maintain',
    'Improve Endurance',
    'Elite Performance',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          context.go(AppRoutes.home);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.8, -0.5),
            radius: 1.0,
            colors: [
              AppColors.primaryViolet.withValues(alpha: 0.08),
              AppColors.backgroundDark,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCard,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowDark.withValues(alpha: 0.7),
                            offset: const Offset(3, 3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                  GradientText(
                    'Create Your\nAccount 🚀',
                    style: AppTextStyles.displayL.copyWith(
                      fontFamily: 'Rajdhani',
                      color: Colors.white,
                    ),
                    gradient: AppColors.emeraldGradient,
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Begin your AI-powered transformation',
                    style: AppTextStyles.bodyM
                        .copyWith(color: AppColors.textSecondary),
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 40),
                  _buildField(
                      'Full Name', _nameCtrl, 'John Doe', LucideIcons.user),
                  const SizedBox(height: 18),
                  _buildField(
                      'Email', _emailCtrl, 'you@example.com', LucideIcons.mail,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 18),
                  _buildField(
                      'Password', _passCtrl, '••••••••', LucideIcons.lock,
                      obscure: _obscure,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      )),
                  const SizedBox(height: 24),
                  Text(
                    'Primary Goal',
                    style: AppTextStyles.labelL
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _goals.map((goal) {
                      final selected = _selectedGoal == goal;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedGoal = goal),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient:
                                selected ? AppColors.emeraldGradient : null,
                            color: selected ? null : AppColors.backgroundCard,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              if (selected)
                                BoxShadow(
                                  color: AppColors.accentEmerald
                                      .withValues(alpha: 0.4),
                                  blurRadius: 12,
                                ),
                              BoxShadow(
                                color:
                                    AppColors.shadowDark.withValues(alpha: 0.6),
                                offset: const Offset(3, 3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            goal,
                            style: AppTextStyles.labelM.copyWith(
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  NeumorphicButton(
                    label: 'Create Account',
                    onPressed: _register,
                    isLoading: _isLoading,
                    isFullWidth: true,
                    style: NeuButtonStyle.primary,
                    icon: LucideIcons.rocket,
                    height: 56,
                    borderRadius: 18,
                  ).animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppTextStyles.bodyM
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: Text(
                            'Sign In',
                            style: AppTextStyles.bodyM.copyWith(
                              color: AppColors.primaryViolet,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType? type,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                AppTextStyles.labelL.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark.withValues(alpha: 0.6),
                offset: const Offset(4, 4),
                blurRadius: 12,
              ),
              BoxShadow(
                color: AppColors.shadowLight.withValues(alpha: 0.3),
                offset: const Offset(-2, -2),
                blurRadius: 8,
              ),
            ],
          ),
          child: TextFormField(
            controller: ctrl,
            keyboardType: type,
            obscureText: obscure,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              filled: false,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
              suffixIcon: suffix,
              hintStyle:
                  AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
            ),
            validator: (v) =>
                (v?.isEmpty ?? true) ? 'This field is required' : null,
          ),
        ),
      ],
    );
  }
}
