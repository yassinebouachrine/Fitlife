import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1330), AppColors.background],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildProfileHeader(),
                const SizedBox(height: AppSpacing.xl),
                _buildStats(),
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      _buildAchievements(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildFitnessProfile(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildSettings(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildLogoutButton(context),
                      const SizedBox(height: AppSpacing.huge),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Settings icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textTertiary.withOpacity(0.1),
                  ),
                ),
                child: const Icon(
                  Icons.settings_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.xpGold,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          AppConstants.userFullName,
          style: AppTypography.displaySmall.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.coolGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Level ${AppConstants.userLevel} — ${AppConstants.userTitle}',
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _ProfileStatCard(
              icon: Icons.fitness_center_rounded,
              value: '${AppConstants.userWorkouts}',
              label: 'Workouts',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _ProfileStatCard(
              icon: Icons.local_fire_department_rounded,
              value: '${AppConstants.userStreak}d',
              label: 'Streak',
              color: AppColors.streakFire,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _ProfileStatCard(
              icon: Icons.bolt_rounded,
              value: '${AppConstants.userXP}',
              label: 'XP',
              color: AppColors.xpGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {'icon': Icons.local_fire_department_rounded, 'label': 'Hot Streak', 'color': AppColors.streakFire},
      {'icon': Icons.fitness_center_rounded, 'label': 'Iron Will', 'color': AppColors.primary},
      {'icon': Icons.emoji_events_rounded, 'label': 'Champion', 'color': AppColors.xpGold},
      {'icon': Icons.bolt_rounded, 'label': 'Speed Demon', 'color': AppColors.warning},
      {'icon': Icons.gps_fixed_rounded, 'label': 'Focused', 'color': AppColors.error},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: achievements.map((achievement) {
            return Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (achievement['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (achievement['color'] as Color).withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: achievement['color'] as Color,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  achievement['label'] as String,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFitnessProfile() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Fitness Profile', style: AppTypography.headingMedium),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Text(
                  'Edit',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        GradientCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ProfileInfoRow(
                icon: Icons.gps_fixed_rounded,
                iconColor: AppColors.error,
                label: 'Goal',
                value: 'Build Muscle',
              ),
              _divider(),
              _ProfileInfoRow(
                icon: Icons.bar_chart_rounded,
                iconColor: AppColors.primary,
                label: 'Level',
                value: 'Intermediate',
              ),
              _divider(),
              _ProfileInfoRow(
                icon: Icons.monitor_weight_rounded,
                iconColor: AppColors.accent,
                label: 'Weight',
                value: '${AppConstants.userWeight} kg',
              ),
              _divider(),
              _ProfileInfoRow(
                icon: Icons.height_rounded,
                iconColor: AppColors.info,
                label: 'Height',
                value: '${AppConstants.userHeight} cm',
              ),
              _divider(),
              _ProfileInfoRow(
                icon: Icons.cake_rounded,
                iconColor: AppColors.warning,
                label: 'Age',
                value: '28 years',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      color: AppColors.textTertiary.withOpacity(0.08),
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        GradientCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsRow(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
                hasToggle: true,
              ),
              _divider(),
              _SettingsRow(
                icon: Icons.dark_mode_rounded,
                label: 'Dark Mode',
                hasToggle: true,
                isEnabled: true,
              ),
              _divider(),
              _SettingsRow(
                icon: Icons.language_rounded,
                label: 'Language',
                value: 'English',
              ),
              _divider(),
              _SettingsRow(
                icon: Icons.lock_outline_rounded,
                label: 'Privacy',
              ),
              _divider(),
              _SettingsRow(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: AppColors.error.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Sign Out',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ProfileStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.numberSmall.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool hasToggle;
  final bool isEnabled;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    this.hasToggle = false,
    this.isEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (hasToggle)
            Switch(
              value: isEnabled,
              onChanged: (_) {},
              activeColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceVariant,
            )
          else if (value != null)
            Text(
              value!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
        ],
      ),
    );
  }
}