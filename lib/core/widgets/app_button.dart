import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum Btn { filled, outline, soft }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Btn type;
  final IconData? icon;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = Btn.filled,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: _build(cs),
    );
  }

  Widget _build(ColorScheme cs) {
    switch (type) {
      case Btn.filled:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          child: _child(cs.onPrimary),
        );
      case Btn.outline:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.onSurface,
            side: BorderSide(color: cs.outline),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          child: _child(cs.onSurface),
        );
      case Btn.soft:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary.withOpacity(0.08),
            foregroundColor: cs.primary,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          child: _child(cs.primary),
        );
    }
  }

  Widget _child(Color color) {
    if (loading) {
      return SizedBox(
        width: 20, height: 20,
        child: CircularProgressIndicator(color: color, strokeWidth: 2),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}