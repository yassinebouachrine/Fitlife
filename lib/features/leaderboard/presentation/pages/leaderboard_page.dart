import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<_Leader> _leaders = const [
    _Leader('ZephyrX99', 8420, 42, '🔥', 5, 'Fire Dragon Skin'),
    _Leader('IronWill', 7890, 38, '💪', 5, 'Liquid Metal'),
    _Leader('NovaNight', 7340, 35, '⚡', 4, 'Cosmic Void'),
    _Leader('QuantumFit', 6980, 33, '🎯', 4, 'Neon Ghost'),
    _Leader('SteelTitan', 6540, 31, '🏆', 4, 'Titan Armor'),
    _Leader('VortexGym', 6120, 29, '🌀', 3, 'Vortex Blue'),
    _Leader('BlazeRunner', 5890, 27, '🔴', 3, 'Blaze Core'),
    _Leader('NexusPrime', 5640, 26, '✨', 3, 'Prime White'),
    _Leader('ThunderLift', 5280, 24, '⚡', 3, 'Thunder Yellow'),
    _Leader('Alex (You)', 2840, 18, '🩵', 2, 'Elite Warrior'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            title: GradientText(
              'Leaderboard',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
              gradient: AppColors.goldGradient,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accentGold,
              tabs: const [
                Tab(text: 'Global'),
                Tab(text: 'Friends'),
                Tab(text: 'Weekly'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildLeaderList(),
            _buildFriendsTab(),
            _buildWeeklyTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderList() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: _buildPodium(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final leader = _leaders[i + 3];
                final isMe = leader.name.contains('You');
                return _buildLeaderRow(i + 4, leader, isMe);
              },
              childCount: _leaders.length - 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium() {
    final top3 = _leaders.take(3).toList();
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1A2B), Color(0xFF13161E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(child: _podiumItem(top3[1], 2, 120)),
          // 1st place
          Expanded(child: _podiumItem(top3[0], 1, 160)),
          // 3rd place
          Expanded(child: _podiumItem(top3[2], 3, 95)),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _podiumItem(_Leader leader, int rank, double height) {
    final colors = [
      AppColors.accentGold,
      AppColors.textSecondary,
      AppColors.accentOrange
    ];
    final medals = ['🥇', '🥈', '🥉'];
    final color = colors[rank - 1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(leader.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          leader.name.length > 8
              ? '${leader.name.substring(0, 8)}..'
              : leader.name,
          style: AppTextStyles.labelS.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        Text(
          '${leader.xp} XP',
          style: AppTextStyles.labelM.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border(
              top: BorderSide(color: color.withOpacity(0.5), width: 2),
              left: BorderSide(color: color.withOpacity(0.3), width: 1),
              right: BorderSide(color: color.withOpacity(0.3), width: 1),
            ),
          ),
          child: Center(
            child: Text(medals[rank - 1],
                style: const TextStyle(fontSize: 24)),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderRow(int rank, _Leader leader, bool isMe) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primaryElectricBlue.withOpacity(0.08)
            : AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: isMe
            ? Border.all(
                color: AppColors.primaryElectricBlue.withOpacity(0.35))
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.4),
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: AppTextStyles.labelL.copyWith(
                color: rank <= 10
                    ? AppColors.textSecondary
                    : AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          Text(leader.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leader.name,
                  style: AppTextStyles.h4.copyWith(
                    color: isMe
                        ? AppColors.primaryElectricBlue
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  leader.skinName,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              XPBadge(xp: leader.xp, compact: true),
              const SizedBox(height: 4),
              Text(
                '${leader.streak}d 🔥',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.accentOrange),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: rank * 60));
  }

  Widget _buildFriendsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_rounded,
              color: AppColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text('Connect with friends',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Challenge each other and track progress together',
              style: AppTextStyles.bodyM
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.calendar_today_rounded,
                color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text('Weekly Reset: Sunday',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('3 days remaining in current week',
              style: AppTextStyles.bodyM
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Leader {
  final String name;
  final int xp;
  final int streak;
  final String emoji;
  final int level;
  final String skinName;

  const _Leader(
      this.name, this.xp, this.streak, this.emoji, this.level, this.skinName);
}
