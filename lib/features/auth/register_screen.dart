import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
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
  bool _obscure = true;
  String _selectedGoal = 'Build Muscle';
  String _selectedLevel = 'Intermediate';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Step ${_step + 1}/2',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: _step >= 1
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _step == 0 ? _accountStep(theme) : _profileStep(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create\nAccount',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start your fitness transformation today',
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 32),
        const AppTextField(
          label: 'Full Name',
          hint: 'Your full name',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 20),
        const AppTextField(
          label: 'Email',
          hint: 'your@email.com',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        AppTextField(
          label: 'Password',
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscure,
          suffix: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'Continue',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  Widget _profileStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness\nProfile',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us personalize your experience',
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Fitness Goal',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _goalChip('Build Muscle', Icons.fitness_center_rounded, theme),
            _goalChip('Lose Weight', Icons.local_fire_department_rounded, theme),
            _goalChip('Stay Fit', Icons.favorite_rounded, theme),
            _goalChip('Strength', Icons.sports_martial_arts_rounded, theme),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Experience Level',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Beginner', 'Intermediate', 'Advanced']
              .map((l) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLevel = l),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedLevel == l
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedLevel == l
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.5),
                            width: _selectedLevel == l ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            l,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedLevel == l
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedLevel == l
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(
              child: AppTextField(
                label: 'Weight (kg)',
                hint: '75',
                prefixIcon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                label: 'Height (cm)',
                hint: '175',
                prefixIcon: Icons.height_rounded,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'Get Started',
          icon: Icons.rocket_launch_rounded,
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainShell()),
          ),
        ),
      ],
    );
  }

  Widget _goalChip(String label, IconData icon, ThemeData theme) {
    final selected = _selectedGoal == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}