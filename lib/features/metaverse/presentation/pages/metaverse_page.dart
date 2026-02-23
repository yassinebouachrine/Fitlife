import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';

class MetaversePage extends StatefulWidget {
  const MetaversePage({super.key});

  @override
  State<MetaversePage> createState() => _MetaversePageState();
}

class _MetaversePageState extends State<MetaversePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isEntering = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            title: GradientText(
              'Metaverse Gym',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
              gradient: AppColors.metaverseGradient,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: const XPBadge(xp: 2840),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildEnterButton(context),
                const SizedBox(height: 24),
                _buildAvatarSection(),
                const SizedBox(height: 24),
                _buildSectionLabel('Live Classes'),
                const SizedBox(height: 12),
                _buildLiveClasses(),
                const SizedBox(height: 24),
                _buildSectionLabel('Leaderboard'),
                const SizedBox(height: 12),
                _buildMetaLeaderboard(),
                const SizedBox(height: 24),
                _buildSectionLabel('NFT Trophies'),
                const SizedBox(height: 12),
                _buildTrophyGrid(),
                const SizedBox(height: 24),
                _buildTokenWallet(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (_, __) => Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0D0F1E),
              Color(0xFF1A0E35),
              Color(0xFF0D1A2E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.primaryNeonPurple
                .withOpacity(0.3 + _glowController.value * 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryNeonPurple
                  .withOpacity(0.15 + _glowController.value * 0.15),
              blurRadius: 30 + _glowController.value * 20,
              spreadRadius: -5,
            ),
            BoxShadow(
              color: AppColors.primaryElectricBlue
                  .withOpacity(0.1 + _glowController.value * 0.1),
              blurRadius: 40,
              spreadRadius: -10,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Star field background
            ...List.generate(
              12,
              (i) => Positioned(
                left: 20.0 + (i * 28.0) % 320,
                top: 20.0 + (i * 17.0) % 150,
                child: Container(
                  width: 2 + (i % 3).toDouble(),
                  height: 2 + (i % 3).toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.2 + _glowController.value * 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.metaverseGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryNeonPurple
                            .withOpacity(0.5 + _glowController.value * 0.3),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.public_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                GradientText(
                  'Enter Virtual Gym',
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                  gradient: AppColors.metaverseGradient,
                ),
                const SizedBox(height: 6),
                Text(
                  '128 athletes online now',
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                NeumorphicButton(
                  label: _isEntering ? 'Entering...' : '  Enter Metaverse  ',
                  onPressed: () => setState(() => _isEntering = !_isEntering),
                  isLoading: _isEntering,
                  style: NeuButtonStyle.primary,
                  icon: Icons.login_rounded,
                  borderRadius: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.6),
            offset: const Offset(6, 6),
            blurRadius: 16,
          ),
          BoxShadow(
            color: AppColors.shadowLight.withOpacity(0.3),
            offset: const Offset(-3, -3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.metaverseGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryNeonPurple.withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 36),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star_rounded,
                    color: Colors.white, size: 12),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Avatar — Alex Prime',
                  style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level 12 • Elite Warrior Skin',
                  style: AppTextStyles.bodyS
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _stat('XP', '2,840'),
                    const SizedBox(width: 16),
                    _stat('Rank', '#24'),
                    const SizedBox(width: 16),
                    _stat('Trophies', '7'),
                  ],
                ),
              ],
            ),
          ),
          NeumorphicButton(
            label: 'Edit',
            onPressed: () {},
            style: NeuButtonStyle.ghost,
            width: 64,
            height: 36,
            borderRadius: 12,
            textStyle: AppTextStyles.labelM,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary)),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildLiveClasses() {
    final classes = [
      ('🔥 HIIT Inferno', '45 min', 24, AppColors.accentOrange),
      ('💪 Power Lifting', '60 min', 12, AppColors.primaryElectricBlue),
      ('🧘 Recovery Flow', '30 min', 38, AppColors.accentEmerald),
      ('⚡ Sprint Circuit', '25 min', 19, AppColors.primaryNeonPurple),
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: classes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final c = classes[i];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.$4.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: c.$4.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.shadowDark.withOpacity(0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlowDot(color: c.$4, size: 8),
                      Text(
                        'LIVE',
                        style: AppTextStyles.labelS
                            .copyWith(color: c.$4, letterSpacing: 1),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    c.$1,
                    style: AppTextStyles.h4
                        .copyWith(color: AppColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${c.$2} • ${c.$3} joined',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 100));
        },
      ),
    );
  }

  Widget _buildMetaLeaderboard() {
    final leaders = [
      ('🥇', 'ZephyrX99', 8420, 'Fire Dragon'),
      ('🥈', 'IronWill', 7890, 'Liquid Metal'),
      ('🥉', 'NovaNight', 7340, 'Cosmic Void'),
      ('4th', 'Alex (You)', 2840, 'Elite Warrior'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.5),
            offset: const Offset(5, 5),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        children: leaders.asMap().entries.map((entry) {
          final i = entry.key;
          final l = entry.value;
          final isUser = l.$2.contains('You');
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser
                  ? AppColors.primaryElectricBlue.withOpacity(0.08)
                  : null,
              border: i < leaders.length - 1
                  ? const Border(
                      bottom: BorderSide(color: AppColors.glassBorder, width: 1))
                  : null,
              borderRadius: i == leaders.length - 1
                  ? const BorderRadius.vertical(bottom: Radius.circular(20))
                  : null,
            ),
            child: Row(
              children: [
                Text(l.$1,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.$2,
                          style: AppTextStyles.h4.copyWith(
                              color: isUser
                                  ? AppColors.primaryElectricBlue
                                  : AppColors.textPrimary)),
                      Text(l.$4,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                XPBadge(xp: l.$3),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  Widget _buildTrophyGrid() {
    final trophies = [
      ('🏆', 'Iron Warrior', true, AppColors.accentGold),
      ('⚡', 'Speed Demon', true, AppColors.primaryElectricBlue),
      ('🔥', '30-Day Blaze', true, AppColors.accentOrange),
      ('💀', 'PR Crusher', true, AppColors.accentRose),
      ('🌟', 'Perfect Form', false, AppColors.primaryNeonPurple),
      ('🚀', 'Elite 100', false, AppColors.accentEmerald),
    ];

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 0.9,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: trophies.asMap().entries.map((entry) {
        final i = entry.key;
        final t = entry.value;
        final unlocked = t.$3;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: unlocked ? t.$4.withOpacity(0.3) : AppColors.glassBorder,
            ),
            boxShadow: [
              if (unlocked)
                BoxShadow(
                  color: t.$4.withOpacity(0.2),
                  blurRadius: 16,
                  spreadRadius: -3,
                ),
              BoxShadow(
                color: AppColors.shadowDark.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                unlocked ? t.$1 : '🔒',
                style: TextStyle(
                    fontSize: 32,
                    color: unlocked ? null : AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Text(
                t.$2,
                style: AppTextStyles.labelS.copyWith(
                  color: unlocked ? t.$4 : AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 80));
      }).toList(),
    );
  }

  Widget _buildTokenWallet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.metaverseGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNeonPurple.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXUS Token Wallet',
                  style: AppTextStyles.labelL
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  '1,240 NXT',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                Text(
                  'Earn tokens by completing workouts!',
                  style: AppTextStyles.bodyS
                      .copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
          NeumorphicButton(
            label: 'Shop',
            onPressed: () {},
            style: NeuButtonStyle.secondary,
            width: 72,
            height: 36,
            borderRadius: 12,
            textStyle: AppTextStyles.labelM,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms);
  }
}
