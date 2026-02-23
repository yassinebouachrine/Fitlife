import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';

/// Dark Neumorphic container with optional glassmorphism overlay
class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double depth;
  final bool isPressed;
  final bool isGlass;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool enableBlur;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.color,
    this.depth = 8,
    this.isPressed = false,
    this.isGlass = false,
    this.gradient,
    this.width,
    this.height,
    this.onTap,
    this.enableBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.backgroundCard;

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: isGlass
            ? LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : gradient,
        color: (gradient == null && !isGlass) ? bgColor : null,
        border: Border.all(
          color: isGlass ? AppColors.glassHighlight : AppColors.glassBorder,
          width: isGlass ? 1.5 : 1,
        ),
        boxShadow: isPressed
            ? [
                // Pressed: reverse — dark from top-left, light from bottom-right
                BoxShadow(
                  color: AppColors.shadowDark.withValues(alpha: 0.9),
                  offset: Offset(depth / 2, depth / 2),
                  blurRadius: depth,
                ),
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.25),
                  offset: Offset(-depth / 4, -depth / 4),
                  blurRadius: depth / 2,
                ),
              ]
            : isGlass
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 8),
                      blurRadius: 32,
                    ),
                    BoxShadow(
                      color: AppColors.primaryViolet.withValues(alpha: 0.04),
                      offset: const Offset(0, 2),
                      blurRadius: 12,
                    ),
                  ]
                : [
                    // Dark Neumorphic raised: dark bottom-right, lighter top-left
                    BoxShadow(
                      color: AppColors.shadowDark.withValues(alpha: 0.85),
                      offset: Offset(depth, depth),
                      blurRadius: depth * 2.5,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.shadowLight.withValues(alpha: 0.35),
                      offset: Offset(-depth, -depth),
                      blurRadius: depth * 2.5,
                      spreadRadius: 0,
                    ),
                  ],
      ),
      child: child,
    );

    if (enableBlur || isGlass) {
      container = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: container,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: container,
    );
  }
}
