import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final LinearGradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: gradient == null ? cs.surface : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          border: gradient == null
              ? Border.all(color: cs.outline.withOpacity(0.6))
              : null,
        ),
        child: child,
      ),
    );
  }
}