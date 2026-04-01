import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/xp_badge.dart';
import '../../core/widgets/section_header.dart';

class MetaverseScreen extends StatelessWidget {
  const MetaverseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  Text('Metaverse Gym',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      )),
                  const Spacer(),
                  const XpBadge(xp: 2840),
                ],
              ),
              const SizedBox(height: 24),
              // Portal
              AppCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.public_rounded,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Enter Virtual Gym',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 4),
                    Text('128 athletes online now',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        )),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Enter Metaverse',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Avatar
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.person_rounded,
                          color: theme.colorScheme.primary, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alex Prime',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              )),
                          Text('Level 12 · Elite Warrior',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.45),
                              )),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _avatarStat(theme, '2,840', 'XP'),
                              const SizedBox(width: 16),
                              _avatarStat(theme, '#24', 'Rank'),
                              const SizedBox(width: 16),
                              _avatarStat(theme, '7', 'Trophies'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
              ),
              const SizedBox(height: 24),
              // Live Classes
              const SectionHeader(title: 'Live Classes'),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _liveCard(theme, 'HIIT Inferno', '45 min', 24, true,
                        AppColors.orangeGradient),
                    const SizedBox(width: 12),
                    _liveCard(theme, 'Power Lifting', '60 min', 12, true,
                        AppColors.primaryGradient),
                    const SizedBox(width: 12),
                    _liveCard(theme, 'Yoga Flow', '30 min', 18, false,
                        AppColors.greenGradient),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Challenges
              const SectionHeader(title: 'Active Challenges'),
              const SizedBox(height: 12),
              _challengeCard(theme, '7-Day Warrior', 'Complete 7 workouts',
                  0.71, 2, 500, AppColors.accent),
              const SizedBox(height: 10),
              _challengeCard(theme, 'Iron Body', 'Lift 10,000 kg total', 0.45,
                  5, 750, AppColors.primary),
              const SizedBox(height: 24),
              // Leaderboard
              const SectionHeader(title: 'Leaderboard'),
              const SizedBox(height: 12),
              _leaderItem(theme, 1, 'ZephyrX99', 'Fire Dragon', 8420),
              const SizedBox(height: 8),
              _leaderItem(theme, 2, 'IronMaiden', 'Steel Titan', 7850),
              const SizedBox(height: 8),
              _leaderItem(theme, 3, 'BeastMode', 'War Chief', 6300),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarStat(ThemeData theme, String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            )),
        Text(label,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            )),
      ],
    );
  }

  Widget _liveCard(ThemeData theme, String title, String dur, int joined,
      bool isLive, LinearGradient gradient) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isLive ? AppColors.error : AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const Spacer(),
              if (isLive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('LIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      )),
                ),
            ],
          ),
          const Spacer(),
          Text(title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              )),
          const SizedBox(height: 4),
          Text('$dur · $joined joined',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              )),
        ],
      ),
    );
  }

  Widget _challengeCard(ThemeData theme, String title, String desc,
      double progress, int daysLeft, int reward, Color color) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.shield_rounded, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        )),
                    Text(desc,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.4),
                        )),
                  ],
                ),
              ),
              XpBadge(xp: reward, compact: true),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Text('$daysLeft days left',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              )),
        ],
      ),
    );
  }

  Widget _leaderItem(
      ThemeData theme, int rank, String name, String title, int xp) {
    final medals = ['🥇', '🥈', '🥉'];
    return AppCard(
      child: Row(
        children: [
          Text(medals[rank - 1], style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    )),
                Text(title,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    )),
              ],
            ),
          ),
          XpBadge(xp: xp, compact: true),
        ],
      ),
    );
  }
}