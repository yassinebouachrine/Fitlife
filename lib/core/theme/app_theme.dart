import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => darkTheme;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryViolet,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryViolet,
        secondary: AppColors.primaryCyan,
        tertiary: AppColors.accentGold,
        surface: AppColors.backgroundCard,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge:
            AppTextStyles.displayXL.copyWith(color: AppColors.textPrimary),
        displayMedium:
            AppTextStyles.displayL.copyWith(color: AppColors.textPrimary),
        displaySmall:
            AppTextStyles.displayM.copyWith(color: AppColors.textPrimary),
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        headlineSmall: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        titleLarge: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        titleMedium:
            AppTextStyles.labelL.copyWith(color: AppColors.textPrimary),
        titleSmall:
            AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
        bodyLarge: AppTextStyles.bodyL.copyWith(color: AppColors.textPrimary),
        bodyMedium:
            AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
        bodySmall: AppTextStyles.bodyS.copyWith(color: AppColors.textMuted),
        labelLarge:
            AppTextStyles.buttonL.copyWith(color: AppColors.textPrimary),
        labelMedium:
            AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
        labelSmall: AppTextStyles.labelS.copyWith(color: AppColors.textMuted),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.primaryViolet, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
        labelStyle:
            AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.buttonM,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primaryViolet,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundSurface,
        selectedColor: AppColors.primaryViolet,
        labelStyle:
            AppTextStyles.labelM.copyWith(color: AppColors.textSecondary),
        side: const BorderSide(color: AppColors.glassBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryViolet,
        inactiveTrackColor: AppColors.backgroundElevated,
        thumbColor: AppColors.primaryViolet,
        overlayColor: AppColors.primaryViolet.withValues(alpha: 0.15),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        trackHeight: 4,
      ),
    );
  }
}
