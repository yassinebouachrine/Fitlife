import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: _buildByType(context),
    );
  }

  Widget _buildByType(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimary(context);
      case ButtonType.secondary:
        return _buildSecondary(context);
      case ButtonType.outline:
        return _buildOutline(context);
      case ButtonType.text:
        return _buildText(context);
    }
  }

  Widget _buildPrimary(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(child: _content(Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Center(child: _content(theme.colorScheme.primary)),
      ),
    );
  }

  Widget _buildOutline(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1.5,
            ),
          ),
          child: Center(child: _content(theme.colorScheme.onSurface)),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _content(theme.colorScheme.primary),
    );
  }

  Widget _content(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2.5,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}