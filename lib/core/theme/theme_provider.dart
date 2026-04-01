import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider._();
  static final I = ThemeProvider._();

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}