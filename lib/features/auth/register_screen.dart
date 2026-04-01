import 'package:flutter/material.dart';
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
  String _goal = 'Build Muscle';
  String _lvl = 'Intermediate';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          onPressed: () => _step > 0 ? setState(() => _step = 0) : Navigator.pop(context),
        ),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16), child: Center(
            child: Text('${_step + 1} / 2', style: TextStyle(
              fontSize: 13, color: cs.onSurface.withOpacity(0.35), fontWeight: FontWeight.w500)),
          )),
        ],
      ),
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Row(children: List.generate(2, (i) => Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(right: i == 0 ? 6 : 0),
              decoration: BoxDecoration(
                color: i <= _step ? cs.primary : cs.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ))),
        ),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _step == 0 ? _account(cs) : _profile(cs),
        )),
      ])),
    );
  }

  Widget _account(ColorScheme cs) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Create account', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
    const SizedBox(height: 6),
    Text('Join Lifevora today', style: TextStyle(fontSize: 15, color: cs.onSurface.withOpacity(0.4))),
    const SizedBox(height: 28),
    const AppTextField(label: 'Full name', hint: 'Your name', prefix: Icons.person_outline_rounded),
    const SizedBox(height: 16),
    const AppTextField(label: 'Email', hint: 'you@example.com', prefix: Icons.mail_outline_rounded, keyboard: TextInputType.emailAddress),
    const SizedBox(height: 16),
    AppTextField(label: 'Password', hint: 'Min. 8 characters', prefix: Icons.lock_outline_rounded, obscure: _hide,
      suffix: GestureDetector(onTap: () => setState(() => _hide = !_hide),
        child: Padding(padding: const EdgeInsets.only(right: 12),
          child: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: cs.onSurface.withOpacity(0.3))))),
    const SizedBox(height: 28),
    AppButton(label: 'Continue', onPressed: () => setState(() => _step = 1)),
  ]);

  Widget _profile(ColorScheme cs) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Your profile', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: cs.onSurface, letterSpacing: -0.3)),
    const SizedBox(height: 6),
    Text('Personalize your experience', style: TextStyle(fontSize: 15, color: cs.onSurface.withOpacity(0.4))),
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
    Row(children: ['Beginner', 'Intermediate', 'Advanced'].map((l) => Expanded(child: GestureDetector(
      onTap: () => setState(() => _lvl = l),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: _lvl == l ? cs.primary.withOpacity(0.06) : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _lvl == l ? cs.primary : cs.outline, width: _lvl == l ? 1.5 : 1),
        ),
        child: Center(child: Text(l, style: TextStyle(
          fontSize: 12, fontWeight: _lvl == l ? FontWeight.w600 : FontWeight.w400,
          color: _lvl == l ? cs.primary : cs.onSurface.withOpacity(0.45),
        ))),
      ),
    ))).toList()),
    const SizedBox(height: 22),
    const Row(children: [
      Expanded(child: AppTextField(label: 'Weight (kg)', hint: '75', prefix: Icons.monitor_weight_outlined, keyboard: TextInputType.number)),
      SizedBox(width: 12),
      Expanded(child: AppTextField(label: 'Height (cm)', hint: '175', prefix: Icons.straighten_rounded, keyboard: TextInputType.number)),
    ]),
    const SizedBox(height: 28),
    AppButton(label: 'Get started', onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()))),
  ]);

  Widget _lbl(ColorScheme cs, String t) => Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.5)));

  Widget _chip(ColorScheme cs, String label, IconData icon) {
    final sel = _goal == label;
    return GestureDetector(
      onTap: () => setState(() => _goal = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? cs.primary.withOpacity(0.06) : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sel ? cs.primary : cs.outline, width: sel ? 1.5 : 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: sel ? cs.primary : cs.onSurface.withOpacity(0.35)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13,
            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
            color: sel ? cs.primary : cs.onSurface.withOpacity(0.5))),
        ]),
      ),
    );
  }
}