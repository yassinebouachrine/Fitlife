import 'package:flutter/material.dart';

/// NexusGym Design System — Dark Neumorphism + Glassmorphism Color System
class AppColors {
  AppColors._();

  // ─── Background System (Dark Neumorphic Base) ─────────────────────────────
  /// Deep space dark — the neumorphic base canvas
  static const Color backgroundDark = Color(0xFF13151F);

  /// Slightly lighter card surface
  static const Color backgroundCard = Color(0xFF1A1D2E);

  /// Elevated surface (inputs, chips)
  static const Color backgroundElevated = Color(0xFF1F2235);

  /// Deeper inset surface
  static const Color backgroundSurface = Color(0xFF11131C);

  // ─── Neumorphic Shadows (Dark Mode) ────────────────────────────────────────
  /// Dark shadow — deep dark (recessed effect)
  static const Color shadowDark = Color(0xFF0A0B13);

  /// Light shadow — subtle lighter highlight
  static const Color shadowLight = Color(0xFF22263A);

  // ─── Primary Brand Palette ─────────────────────────────────────────────────
  static const Color primaryViolet = Color(0xFF6C63FF);
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color primaryMagenta = Color(0xFFD946EF);

  // ─── Accent ─────────────────────────────────────────────────────────────────
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentRose = Color(0xFFF43F5E);

  /// Electric Coral — replaces warm orange; bridges magenta & rose family
  static const Color accentCoral = Color(0xFFFF6B9D);
  static const Color accentPurple = Color(0xFFA855F7);

  // ─── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryViolet, primaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [primaryViolet, primaryMagenta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFFD166)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coralGradient = LinearGradient(
    colors: [accentCoral, primaryMagenta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFD946EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient metaverseGradient = LinearGradient(
    colors: [primaryViolet, primaryMagenta, primaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0x201A1D2E), Color(0x101A1D2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F2FF);
  static const Color textSecondary = Color(0xFFA0A8C8);
  static const Color textMuted = Color(0xFF5A6080);
  static const Color textDisabled = Color(0xFF353856);

  // ─── Status ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF43F5E);
  static const Color info = Color(0xFF6C63FF);

  // ─── Glass / Border ─────────────────────────────────────────────────────────
  static const Color glassWhite = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x20FFFFFF);
  static const Color glassHighlight = Color(0x30FFFFFF);

  // Convenience aliases (backward compat)
  static const Color primaryElectricBlue = primaryViolet;
  static const Color primaryNeonPurple = primaryIndigo;

  /// Backward-compat alias — use accentCoral for new code
  static const Color accentOrange = accentCoral;
}
