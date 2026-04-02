import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../navigation/main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _hide = true;
  bool _loading = false;

  // ✅ Controllers pour récupérer les valeurs des champs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ✅ Service d'authentification
  final _authService = AuthService();

  late final _anim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));
  late final _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
  late final _slide = Tween(begin: const Offset(0, 0.04), end: Offset.zero)
      .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ Méthode de connexion qui appelle le backend
  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validation basique
    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        // ✅ Connexion réussie → naviguer vers MainShell
        _showSuccess('Welcome back!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      } else {
        _showError(response['message'] ?? 'Login failed.');
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Logo
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.favorite_rounded,
                                  color: Colors.white, size: 28),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Lifevora',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                              letterSpacing: -0.3,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text('Welcome back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                        letterSpacing: -0.5,
                        height: 1.2,
                      )),
                  const SizedBox(height: 6),
                  Text('Sign in to your account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: cs.onSurface.withOpacity(0.45),
                      )),
                  const SizedBox(height: 32),

                  // ✅ Form avec controllers
                  AppTextField(
                    label: 'Email',
                    hint: 'you@example.com',
                    prefix: Icons.mail_outline_rounded,
                    keyboard: TextInputType.emailAddress,
                    controller: _emailController, // ✅ Ajouté
                  ),
                  const SizedBox(height: 18),
                  AppTextField(
                    label: 'Password',
                    hint: 'Enter password',
                    prefix: Icons.lock_outline_rounded,
                    obscure: _hide,
                    controller: _passwordController, // ✅ Ajouté
                    suffix: GestureDetector(
                      onTap: () => setState(() => _hide = !_hide),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          _hide
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: cs.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: cs.primary,
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                      label: 'Sign In',
                      loading: _loading,
                      onPressed: _login), // ✅ Appelle le vrai login
                  const SizedBox(height: 24),

                  // Divider
                  Row(children: [
                    Expanded(
                        child:
                            Divider(color: cs.outline.withOpacity(0.5))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text('or',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withOpacity(0.3),
                          )),
                    ),
                    Expanded(
                        child:
                            Divider(color: cs.outline.withOpacity(0.5))),
                  ]),
                  const SizedBox(height: 18),

                  // Social
                  Row(children: [
                    Expanded(
                        child: _social(
                            cs, 'Google', Icons.g_mobiledata_rounded)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _social(cs, 'Apple', Icons.apple_rounded)),
                  ]),
                  const SizedBox(height: 32),

                  // Register
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen())),
                      child: Text.rich(TextSpan(
                        text: 'No account? ',
                        style: TextStyle(
                            fontSize: 14,
                            color: cs.onSurface.withOpacity(0.4)),
                        children: [
                          TextSpan(
                              text: 'Create one',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: cs.primary)),
                        ],
                      )),
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

  Widget _social(ColorScheme cs, String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.onSurface,
        side: BorderSide(color: cs.outline),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
      ),
    );
  }
}