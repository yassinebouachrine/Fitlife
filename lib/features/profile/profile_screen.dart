import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_card.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Top bar
              Row(
                children: [
                  Text('Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      )),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(Icons.settings_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 44),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 3,
                      ),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(AppConstants.userFullName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  )),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Level ${AppConstants.userLevel} — ${AppConstants.userTitle}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Stats row
              Row(
                children: [
                  _statBox(theme, Icons.fitness_center_rounded, '142',
                      'Workouts', AppColors.primary),
                  const SizedBox(width: 10),
                  _statBox(theme, Icons.local_fire_department_rounded, '18d',
                      'Streak', AppColors.streak),
                  const SizedBox(width: 10),
                  _statBox(theme, Icons.bolt_rounded, '2,840', 'XP',
                      AppColors.accent),
                ],
              ),
              const SizedBox(height: 24),
              // Achievements
              _sectionTitle(theme, 'Achievements'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _achievement(theme, Icons.local_fire_department_rounded,
                      'Hot Streak', AppColors.streak),
                  _achievement(theme, Icons.fitness_center_rounded,
                      'Iron Will', AppColors.primary),
                  _achievement(theme, Icons.emoji_events_rounded, 'Champion',
                      AppColors.accent),
                  _achievement(theme, Icons.bolt_rounded, 'Speed',
                      AppColors.warning),
                  _achievement(theme, Icons.gps_fixed_rounded, 'Focused',
                      AppColors.error),
                ],
              ),
              const SizedBox(height: 24),
              // Fitness Profile
              Row(
                children: [
                  _sectionTitle(theme, 'Fitness Profile'),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _infoRow(theme, Icons.gps_fixed_rounded, 'Goal',
                        'Build Muscle', AppColors.error),
                    _div(theme),
                    _infoRow(theme, Icons.bar_chart_rounded, 'Level',
                        'Intermediate', AppColors.primary),
                    _div(theme),
                    _infoRow(theme, Icons.monitor_weight_rounded, 'Weight',
                        '${AppConstants.userWeight} kg', AppColors.secondary),
                    _div(theme),
                    _infoRow(theme, Icons.height_rounded, 'Height',
                        '${AppConstants.userHeight} cm', AppColors.info),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Settings
              _sectionTitle(theme, 'Settings'),
              const SizedBox(height: 12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _settingToggle(theme, Icons.dark_mode_rounded,
                        'Dark Mode', isDark, (val) {
                      ThemeProvider.instance.toggleTheme();
                    }),
                    _div(theme),
                    _settingRow(
                        theme, Icons.notifications_none_rounded, 'Notifications'),
                    _div(theme),
                    _settingRow(
                        theme, Icons.language_rounded, 'Language'),
                    _div(theme),
                    _settingRow(
                        theme, Icons.lock_outline_rounded, 'Privacy'),
                    _div(theme),
                    _settingRow(
                        theme, Icons.help_outline_rounded, 'Help'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Logout
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.2),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded,
                          color: AppColors.error, size: 18),
                      SizedBox(width: 8),
                      Text('Sign Out',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(
      ThemeData theme, IconData icon, String val, String label, Color color) {
    return Expanded(
      child: AppCard(
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(val,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                )),
            Text(label,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                )),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          )),
    );
  }

  Widget _achievement(
      ThemeData theme, IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            )),
      ],
    );
  }

  Widget _infoRow(
      ThemeData theme, IconData icon, String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              )),
          const Spacer(),
          Text(val,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              )),
        ],
      ),
    );
  }

  Widget _settingRow(ThemeData theme, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                )),
          ),
          Icon(Icons.chevron_right_rounded,
              size: 20,
              color: theme.colorScheme.onSurface.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _settingToggle(ThemeData theme, IconData icon, String label,
      bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                )),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _div(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: theme.colorScheme.outline.withOpacity(0.15),
    );
  }
}