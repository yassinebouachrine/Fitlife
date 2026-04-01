import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final LinearGradient? gradient;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.gradient,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: gradient == null
              ? (color ?? theme.colorScheme.surface)
              : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: gradient == null
              ? Border.all(
                  color: theme.colorScheme.outline.withOpacity(isDark ? 0.3 : 0.8),
                  width: 1,
                )
              : null,
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}