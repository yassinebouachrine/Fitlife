import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/login_screen.dart';

class FitLifeApp extends StatefulWidget {
  const FitLifeApp({super.key});

  @override
  State<FitLifeApp> createState() => _FitLifeAppState();
}

class _FitLifeAppState extends State<FitLifeApp> {
  @override
  void initState() {
    super.initState();
    ThemeProvider.instance.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLife',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeProvider.instance.themeMode,
      home: const LoginScreen(),
    );
  }
}