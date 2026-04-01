import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(title, style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w700,
          color: cs.onSurface, letterSpacing: -0.2,
        )),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!, style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: cs.primary,
            )),
          ),
      ],
    );
  }
}