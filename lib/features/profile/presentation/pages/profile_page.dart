import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/neumorphic_container.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildProfileHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsRow(),
                const SizedBox(height: 24),
                _buildAchievementsStrip(),
                const SizedBox(height: 24),
                _buildFitnessProfile(),
                const SizedBox(height: 24),
                _buildSubscriptionCard(),
                const SizedBox(height: 24),
                _buildSettings(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: AppColors.backgroundDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryElectricBlue.withValues(alpha: 0.08),
                AppColors.primaryNeonPurple.withValues(alpha: 0.04),
                AppColors.backgroundDark,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // Avatar with ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow ring
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryElectricBlue
                                .withValues(alpha: 0.2),
                            AppColors.primaryNeonPurple.withValues(alpha: 0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Avatar circle
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCard,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowDark.withValues(alpha: 0.4),
                            offset: const Offset(6, 6),
                            blurRadius: 16,
                          ),
                          BoxShadow(
                            color: AppColors.shadowLight.withValues(alpha: 0.6),
                            offset: const Offset(-4, -4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 40),
                      ),
                    ),
                    // Edit badge
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.backgroundDark, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.accentGold.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.edit_rounded,
                            color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: 16),
                Text('Alex Johnson',
                        style: AppTextStyles.h2
                            .copyWith(color: AppColors.textPrimary))
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 4),
                // Level badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGold.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.military_tech_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Level 12 — Elite Warrior',
                        style: AppTextStyles.labelS.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 350.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, delay: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statPill('Workouts', '142', Icons.fitness_center,
            AppColors.primaryElectricBlue),
        const SizedBox(width: 10),
        _statPill('Streak', '18d', Icons.local_fire_department_rounded,
            AppColors.accentOrange),
        const SizedBox(width: 10),
        _statPill('XP', '2,840', Icons.bolt_rounded, AppColors.accentGold),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _statPill(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(14),
        borderRadius: 18,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(value,
                  style:
                      AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(label,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsStrip() {
    final achievements = [
      ('🔥', 'Hot Streak', AppColors.accentOrange),
      ('💪', 'Iron Will', AppColors.primaryElectricBlue),
      ('🏆', 'Champion', AppColors.accentGold),
      ('⚡', 'Speed Demon', AppColors.primaryNeonPurple),
      ('🎯', 'Focused', AppColors.accentEmerald),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Achievements',
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final a = achievements[i];
              return Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark.withValues(alpha: 0.35),
                          offset: const Offset(3, 3),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: AppColors.shadowLight.withValues(alpha: 0.5),
                          offset: const Offset(-2, -2),
                          blurRadius: 6,
                        ),
                      ],
                      border: Border.all(
                        color: a.$3.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(a.$1, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a.$2,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted, fontSize: 9),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 250 + i * 80))
                  .scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1, 1),
                    delay: Duration(milliseconds: 250 + i * 80),
                    curve: Curves.easeOutBack,
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFitnessProfile() {
    final data = [
      (
        'Goal',
        'Build Muscle',
        Icons.track_changes_rounded,
        AppColors.accentRose
      ),
      (
        'Level',
        'Intermediate',
        Icons.signal_cellular_alt_rounded,
        AppColors.primaryElectricBlue
      ),
      (
        'Weight',
        '82.3 kg',
        Icons.monitor_weight_rounded,
        AppColors.accentEmerald
      ),
      ('Height', '181 cm', Icons.height_rounded, AppColors.primaryNeonPurple),
      ('Equipment', 'Full Gym', Icons.fitness_center, AppColors.accentOrange),
      ('Injuries', 'None', Icons.healing_rounded, AppColors.accentGold),
    ];

    return NeumorphicContainer(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fitness Profile',
                    style: AppTextStyles.h3
                        .copyWith(color: AppColors.textPrimary)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        AppColors.primaryElectricBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Edit',
                      style: AppTextStyles.labelM.copyWith(
                        color: AppColors.primaryElectricBlue,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ...data.asMap().entries.map((e) {
            final item = e.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: e.key < data.length - 1
                    ? Border(
                        bottom: BorderSide(
                            color: AppColors.glassBorder.withValues(alpha: 0.5),
                            width: 1))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: item.$4.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.$3, color: item.$4, size: 16),
                  ),
                  const SizedBox(width: 14),
                  Text(item.$1,
                      style: AppTextStyles.bodyM
                          .copyWith(color: AppColors.textSecondary)),
                  const Spacer(),
                  Text(item.$2,
                      style: AppTextStyles.labelL.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms);
  }

  Widget _buildSubscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryElectricBlue.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: -5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PRO',
                        style: AppTextStyles.labelS.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'NEXUS Elite',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Unlimited AI coaching, Metaverse & more',
                  style: AppTextStyles.bodyS.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Active — \$29/mo',
                    style: AppTextStyles.labelM.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: Colors.white70, size: 40),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  Widget _buildSettings(BuildContext context) {
    final settings = [
      (
        'Notifications',
        Icons.notifications_rounded,
        true,
        AppColors.primaryElectricBlue
      ),
      ('Dark Mode', Icons.dark_mode_rounded, true, AppColors.primaryNeonPurple),
      (
        'Health Sync',
        Icons.monitor_heart_rounded,
        false,
        AppColors.accentEmerald
      ),
      ('Privacy & Data', Icons.shield_rounded, null, AppColors.accentGold),
      ('Help & Support', Icons.help_rounded, null, AppColors.textMuted),
      ('Sign Out', Icons.logout_rounded, null, AppColors.accentRose),
    ];

    return NeumorphicContainer(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      child: Column(
        children: settings.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          final isLast = i == settings.length - 1;
          final isSignOut = s.$1 == 'Sign Out';
          return Container(
            decoration: BoxDecoration(
              border: !isLast
                  ? Border(
                      bottom: BorderSide(
                          color: AppColors.glassBorder.withValues(alpha: 0.5),
                          width: 1))
                  : null,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              leading: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: s.$4.withValues(alpha: isSignOut ? 0.1 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(s.$2,
                    color: isSignOut ? AppColors.error : s.$4, size: 18),
              ),
              title: Text(s.$1,
                  style: AppTextStyles.bodyM.copyWith(
                      color:
                          isSignOut ? AppColors.error : AppColors.textPrimary)),
              trailing: s.$3 != null
                  ? Switch.adaptive(
                      value: s.$3!,
                      onChanged: (_) {},
                      activeColor: AppColors.primaryElectricBlue,
                    )
                  : Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isSignOut
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: AppColors.textMuted,
                        size: 12,
                      ),
                    ),
              onTap: isSignOut
                  ? () => Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (_) => false,
                      )
                  : () {},
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 500.ms);
  }
}
