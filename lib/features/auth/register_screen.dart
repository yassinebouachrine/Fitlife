import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../navigation/main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0;
  bool _hide = true;
  bool _loading = false;
  String _goal = 'Build Muscle';
  String _lvl = 'Intermediate';

  // ✅ Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  // ✅ Service
  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // ✅ Validation étape 1
  void _goToStep2() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showError('Please enter a valid email.');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    setState(() => _step = 1);
  }

  // ✅ Inscription qui appelle le backend
  void _register() async {
    setState(() => _loading = true);

    try {
      final weight = double.tryParse(_weightController.text.trim());
      final height = double.tryParse(_heightController.text.trim());

      final response = await _authService.register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        weight: weight,
        height: height,
        goal: _goal,
        fitnessLevel: _lvl,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        _showSuccess('Account created successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      } else {
        _showError(response['message'] ?? 'Registration failed.');
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
            const Icon(Icons.check_circle_outline, color: Colors.white,
                size: 20),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          onPressed: () =>
              _step > 0 ? setState(() => _step = 0) : Navigator.pop(context),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text('${_step + 1} / 2',
                    style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withOpacity(0.35),
                        fontWeight: FontWeight.w500)),
              )),
        ],
      ),
      body: SafeArea(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Row(
              children: List.generate(
                  2,
                  (i) => Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.only(right: i == 0 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: i <= _step
                                ? cs.primary
                                : cs.outline.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ))),
        ),
        Expanded(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _step == 0 ? _account(cs) : _profile(cs),
        )),
      ])),
    );
  }

  Widget _account(ColorScheme cs) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create account',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    letterSpacing: -0.3)),
            const SizedBox(height: 6),
            Text('Join Lifevora today',
                style: TextStyle(
                    fontSize: 15, color: cs.onSurface.withOpacity(0.4))),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Full name',
              hint: 'Your name',
              prefix: Icons.person_outline_rounded,
              controller: _nameController, // ✅
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email',
              hint: 'you@example.com',
              prefix: Icons.mail_outline_rounded,
              keyboard: TextInputType.emailAddress,
              controller: _emailController, // ✅
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password',
              hint: 'Min. 6 characters',
              prefix: Icons.lock_outline_rounded,
              obscure: _hide,
              controller: _passwordController, // ✅
              suffix: GestureDetector(
                  onTap: () => setState(() => _hide = !_hide),
                  child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                          _hide
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: cs.onSurface.withOpacity(0.3)))),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: 'Continue',
              onPressed: _goToStep2, // ✅ Validation avant d'aller à l'étape 2
            ),
          ]);

  Widget _profile(ColorScheme cs) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your profile',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    letterSpacing: -0.3)),
            const SizedBox(height: 6),
            Text('Personalize your experience',
                style: TextStyle(
                    fontSize: 15, color: cs.onSurface.withOpacity(0.4))),
            const SizedBox(height: 24),
            _lbl(cs, 'Goal'),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _chip(cs, 'Build Muscle', Icons.fitness_center_outlined),
              _chip(cs, 'Lose Weight', Icons.trending_down_rounded),
              _chip(cs, 'Stay Fit', Icons.favorite_outline_rounded),
              _chip(cs, 'Strength', Icons.sports_rounded),
            ]),
            const SizedBox(height: 22),
            _lbl(cs, 'Level'),
            const SizedBox(height: 10),
            Row(
                children: ['Beginner', 'Intermediate', 'Advanced']
                    .map((l) => Expanded(
                            child: GestureDetector(
                          onTap: () => setState(() => _lvl = l),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                              color: _lvl == l
                                  ? cs.primary.withOpacity(0.06)
                                  : cs.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _lvl == l ? cs.primary : cs.outline,
                                  width: _lvl == l ? 1.5 : 1),
                            ),
                            child: Center(
                                child: Text(l,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _lvl == l
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: _lvl == l
                                          ? cs.primary
                                          : cs.onSurface.withOpacity(0.45),
                                    ))),
                          ),
                        )))
                    .toList()),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(
                  child: AppTextField(
                label: 'Weight (kg)',
                hint: '75',
                prefix: Icons.monitor_weight_outlined,
                keyboard: TextInputType.number,
                controller: _weightController, // ✅
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: AppTextField(
                label: 'Height (cm)',
                hint: '175',
                prefix: Icons.straighten_rounded,
                keyboard: TextInputType.number,
                controller: _heightController, // ✅
              )),
            ]),
            const SizedBox(height: 28),
            AppButton(
              label: 'Get started',
              loading: _loading,
              onPressed: _register, // ✅ Appelle le vrai register
            ),
          ]);

  Widget _lbl(ColorScheme cs, String t) => Text(t,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: cs.onSurface.withOpacity(0.5)));

  Widget _chip(ColorScheme cs, String label, IconData icon) {
    final sel = _goal == label;
    return GestureDetector(
      onTap: () => setState(() => _goal = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? cs.primary.withOpacity(0.06) : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: sel ? cs.primary : cs.outline, width: sel ? 1.5 : 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon,
              size: 16,
              color: sel ? cs.primary : cs.onSurface.withOpacity(0.35)),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color:
                      sel ? cs.primary : cs.onSurface.withOpacity(0.5))),
        ]),
      ),
    );
  }
}