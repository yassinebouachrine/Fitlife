import 'package:flutter/material.dart';
import '../theme/app_colors.dart' as colors;

class XpBadge extends StatelessWidget {
  final int xp;
  final bool small;
  const XpBadge({super.key, required this.xp, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 7 : 10,
        vertical: small ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: colors.C.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.C.amber.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, color: colors.C.amber, size: small ? 12 : 14),
          const SizedBox(width: 2),
          Text(
            '$xp XP',
            style: TextStyle(
              color: colors.C.amber,
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}