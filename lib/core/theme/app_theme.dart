import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: C.slate50,
    primaryColor: C.blue600,
    colorScheme: const ColorScheme.light(
      primary: C.blue600,
      onPrimary: Colors.white,
      secondary: C.emerald,
      surface: Colors.white,
      onSurface: C.slate900,
      outline: C.slate200,
      error: C.rose,
      surfaceContainerHighest: C.slate100,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.slate50,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: C.slate200),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.slate50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.slate200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.slate200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.blue500, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        color: C.slate400,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: C.slate400,
    ),
    dividerTheme: const DividerThemeData(color: C.slate100, thickness: 1, space: 0),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? C.blue600 : C.slate300,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? C.blue200 : C.slate200,
      ),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: C.slate900,
    primaryColor: C.blue500,
    colorScheme: const ColorScheme.dark(
      primary: C.blue500,
      onPrimary: Colors.white,
      secondary: C.emerald,
      surface: C.slate800,
      onSurface: C.slate50,
      outline: C.slate700,
      error: C.rose,
      surfaceContainerHighest: C.slate700,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.slate900,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    cardTheme: CardThemeData(
      color: C.slate800,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: C.slate700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.slate800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.slate700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.slate700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.blue400, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        color: C.slate500,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: C.slate500,
    ),
    dividerTheme: const DividerThemeData(color: C.slate700, thickness: 1, space: 0),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? C.blue400 : C.slate500,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? C.blue800 : C.slate700,
      ),
    ),
  );
}