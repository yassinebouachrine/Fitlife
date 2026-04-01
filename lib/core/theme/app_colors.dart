import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark = Color(0xFF4A42D4);

  // Accent colors
  static const Color accent = Color(0xFF00D4AA);
  static const Color accentLight = Color(0xFF33DDBB);
  static const Color accentDark = Color(0xFF00B894);

  // Background colors
  static const Color background = Color(0xFF0A0E21);
  static const Color surface = Color(0xFF131736);
  static const Color surfaceLight = Color(0xFF1C2044);
  static const Color surfaceVariant = Color(0xFF252952);

  // Card colors
  static const Color cardDark = Color(0xFF151937);
  static const Color cardMedium = Color(0xFF1A1E3D);
  static const Color cardLight = Color(0xFF1F2347);

  // Text colors
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFB0B3C6);
  static const Color textTertiary = Color(0xFF6B6F8D);
  static const Color textDisabled = Color(0xFF4A4D65);

  // Status colors
  static const Color success = Color(0xFF00C48C);
  static const Color warning = Color(0xFFFFB946);
  static const Color error = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF5B9BFF);

  // XP & Gamification
  static const Color xpGold = Color(0xFFFFD700);
  static const Color xpOrange = Color(0xFFFF8C00);
  static const Color levelPurple = Color(0xFFBB86FC);
  static const Color streakFire = Color(0xFFFF6B35);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF8C00), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF151937), Color(0xFF1A1E3D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1C2044), Color(0xFF151937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFfa709a), Color(0xFFfee140)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}