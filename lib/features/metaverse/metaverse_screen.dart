import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/gradient_card.dart';

class MetaverseScreen extends StatelessWidget {
  const MetaverseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0F2B),
              Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.base),
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildVirtualGymPortal(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildAvatarSection(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildLiveClasses(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildChallenges(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildLeaderboard(),
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(
                colors: [Color(0xFFBB86FC), Color(0xFF6C63FF)],
              ).createShader(bounds),
          child: const Text(
            'Metaverse Gym',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const Spacer(),
        const XpBadge(xp: 2840),
      ],
    );
  }

  Widget _buildVirtualGymPortal() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1044),
            Color(0xFF2D1B69),
            Color(0xFF1A1044),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: const Color(0xFFBB86FC).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Decorative dots
          ...List.generate(8, (index) {
            return Positioned(
              left: (index * 47.0) + 20,
              top: (index % 3) * 30.0 + 15,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2 + (index % 3) * 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBB86FC), Color(0xFF6C63FF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFBB86FC).withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.public_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [Color(0xFFBB86FC), Color(0xFF4ECDC4)],
                      ).createShader(bounds),
                  child: const Text(
                    'Enter Virtual Gym',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '128 athletes online now',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBB86FC), Color(0xFF6C63FF)],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFFBB86FC).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Enter Metaverse',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return GradientCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.xpGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.textSecondary,
                    size: 32,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.xpGold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cardDark,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Avatar — Alex Prime',
                  style: AppTypography.headingSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Level 12 • Elite Warrior Skin',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _AvatarStat(label: 'XP', value: '2,840'),
                    const SizedBox(width: AppSpacing.lg),
                    _AvatarStat(label: 'Rank', value: '#24'),
                    const SizedBox(width: AppSpacing.lg),
                    _AvatarStat(label: 'Trophies', value: '7'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: AppColors.textTertiary.withOpacity(0.15),
              ),
            ),
            child: Text(
              'Edit',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Live Classes', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _LiveClassCard(
                title: 'HIIT Inferno',
                duration: '45 min',
                joined: 24,
                icon: Icons.local_fire_department_rounded,
                isLive: true,
                gradient: AppColors.warmGradient,
              ),
              const SizedBox(width: AppSpacing.md),
              _LiveClassCard(
                title: 'Power Lifting',
                duration: '60 min',
                joined: 12,
                icon: Icons.fitness_center_rounded,
                isLive: true,
                gradient: AppColors.coolGradient,
              ),
              const SizedBox(width: AppSpacing.md),
              _LiveClassCard(
                title: 'Yoga Flow',
                duration: '30 min',
                joined: 18,
                icon: Icons.self_improvement_rounded,
                isLive: false,
                gradient: AppColors.forestGradient,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Active Challenges', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        _ChallengeCard(
          title: '7-Day Warrior Challenge',
          description: 'Complete 7 workouts in a row',
          progress: 0.71,
          daysLeft: 2,
          reward: 500,
          icon: Icons.shield_rounded,
          color: AppColors.xpGold,
        ),
        const SizedBox(height: AppSpacing.md),
        _ChallengeCard(
          title: 'Iron Body',
          description: 'Lift 10,000 kg total volume',
          progress: 0.45,
          daysLeft: 5,
          reward: 750,
          icon: Icons.fitness_center_rounded,
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    final leaders = [
      {'name': 'ZephyrX99', 'title': 'Fire Dragon', 'xp': 8420, 'rank': 1},
      {'name': 'IronMaiden', 'title': 'Steel Titan', 'xp': 7850, 'rank': 2},
      {'name': 'BeastMode', 'title': 'War Chief', 'xp': 6300, 'rank': 3},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Leaderboard', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.md),
        ...leaders.map((leader) {
          final rank = leader['rank'] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GradientCard(
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: rank == 1
                          ? AppColors.xpGold.withOpacity(0.2)
                          : rank == 2
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.brown.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        rank == 1
                            ? '🥇'
                            : rank == 2
                                ? '🥈'
                                : '🥉',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leader['name'] as String,
                          style: AppTypography.headingSmall.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          leader['title'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  XpBadge(xp: leader['xp'] as int, compact: true),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _AvatarStat extends StatelessWidget {
  final String label;
  final String value;

  const _AvatarStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _LiveClassCard extends StatelessWidget {
  final String title;
  final String duration;
  final int joined;
  final IconData icon;
  final bool isLive;
  final LinearGradient gradient;

  const _LiveClassCard({
    required this.title,
    required this.duration,
    required this.joined,
    required this.icon,
    required this.isLive,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isLive ? AppColors.error : AppColors.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'LIVE',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(icon, color: gradient.colors.first, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headingSmall.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$duration • $joined joined',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final int daysLeft;
  final int reward;
  final IconData icon;
  final Color color;

  const _ChallengeCard({
    required this.title,
    required this.description,
    required this.progress,
    required this.daysLeft,
    required this.reward,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    Text(description, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              XpBadge(xp: reward, compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$daysLeft days remaining',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}