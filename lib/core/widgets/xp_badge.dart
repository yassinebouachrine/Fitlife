import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class XpBadge extends StatelessWidget {
  final int xp;
  final bool compact;

  const XpBadge({super.key, required this.xp, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            color: Colors.white,
            size: compact ? 12 : 14,
          ),
          const SizedBox(width: 2),
          Text(
            '${xp}XP',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}