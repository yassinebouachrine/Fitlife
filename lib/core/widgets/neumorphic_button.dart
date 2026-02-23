import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';

enum NeuButtonStyle { primary, secondary, ghost, danger, gold, emerald }

class NeumorphicButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final NeuButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double borderRadius;
  final double? width;
  final double height;
  final TextStyle? textStyle;

  const NeumorphicButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = NeuButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderRadius = 16,
    this.width,
    this.height = 52,
    this.textStyle,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  Gradient? _getGradient() {
    switch (widget.style) {
      case NeuButtonStyle.primary:
        return AppColors.primaryGradient;
      case NeuButtonStyle.gold:
        return AppColors.goldGradient;
      case NeuButtonStyle.emerald:
        return AppColors.emeraldGradient;
      case NeuButtonStyle.danger:
        return AppColors.roseGradient;
      default:
        return null;
    }
  }

  Color _getBackground() {
    switch (widget.style) {
      case NeuButtonStyle.ghost:
        return Colors.transparent;
      case NeuButtonStyle.secondary:
        return AppColors.backgroundCard;
      default:
        return AppColors.backgroundCard;
    }
  }

  Color _getForeground() {
    switch (widget.style) {
      case NeuButtonStyle.primary:
      case NeuButtonStyle.gold:
      case NeuButtonStyle.danger:
      case NeuButtonStyle.emerald:
        return Colors.white;
      case NeuButtonStyle.ghost:
        return AppColors.primaryViolet;
      case NeuButtonStyle.secondary:
        return AppColors.textPrimary;
    }
  }

  List<BoxShadow> _getShadows() {
    const depth = 6.0;
    if (_isPressed) {
      return [
        BoxShadow(
          color: AppColors.shadowDark.withValues(alpha: 0.9),
          offset: const Offset(2, 2),
          blurRadius: 6,
        ),
        BoxShadow(
          color: AppColors.shadowLight.withValues(alpha: 0.2),
          offset: const Offset(-1, -1),
          blurRadius: 4,
        ),
      ];
    }

    final hasGradient = _getGradient() != null;

    if (hasGradient) {
      // Glowing shadow for gradient buttons
      return [
        BoxShadow(
          color: _getGlowColor().withValues(alpha: 0.4),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.shadowDark.withValues(alpha: 0.7),
          offset: const Offset(depth, depth),
          blurRadius: depth * 2,
        ),
        BoxShadow(
          color: AppColors.shadowLight.withValues(alpha: 0.15),
          offset: const Offset(-depth / 2, -depth / 2),
          blurRadius: depth,
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.shadowDark.withValues(alpha: 0.8),
        offset: const Offset(depth, depth),
        blurRadius: depth * 2.5,
      ),
      BoxShadow(
        color: AppColors.shadowLight.withValues(alpha: 0.2),
        offset: const Offset(-depth, -depth),
        blurRadius: depth * 2.5,
      ),
    ];
  }

  Color _getGlowColor() {
    switch (widget.style) {
      case NeuButtonStyle.gold:
        return AppColors.accentGold;
      case NeuButtonStyle.danger:
        return AppColors.accentRose;
      case NeuButtonStyle.emerald:
        return AppColors.accentEmerald;
      default:
        return AppColors.primaryViolet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGhost = widget.style == NeuButtonStyle.ghost;
    final hasGradient = _getGradient() != null;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.isFullWidth ? double.infinity : widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: hasGradient ? _getGradient() : null,
            color: hasGradient ? null : _getBackground(),
            border: isGhost
                ? Border.all(
                    color: AppColors.primaryViolet.withValues(alpha: 0.6),
                    width: 1.5)
                : Border.all(
                    color: AppColors.glassBorder,
                    width: 1,
                  ),
            boxShadow: _getShadows(),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                          hasGradient ? Colors.white : AppColors.primaryViolet,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: _getForeground(), size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: (widget.textStyle ?? AppTextStyles.buttonM)
                            .copyWith(color: _getForeground()),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
