import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class MyWorkoutsTab extends StatelessWidget {
  const MyWorkoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Show empty state or list of user's custom workouts
    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Create Custom Workout',
              style: AppTypography.headingMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Build your own workout or let the AI\ncreate one for you',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Create Workout',
              icon: Icons.add_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Generate with AI',
              icon: Icons.auto_awesome_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}