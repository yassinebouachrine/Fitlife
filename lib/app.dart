import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/login_screen.dart';

class LifevoraApp extends StatefulWidget {
  const LifevoraApp({super.key});

  @override
  State<LifevoraApp> createState() => _LifevoraAppState();
}

class _LifevoraAppState extends State<LifevoraApp> {
  @override
  void initState() {
    super.initState();
    ThemeProvider.I.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifevora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeProvider.I.mode,
      home: const LoginScreen(),
    );
  }
}