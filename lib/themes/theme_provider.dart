import 'package:flutter/material.dart';
import 'package:d_app/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeKey = 'isDark';
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeMode get currentTheme => isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);
    notifyListeners();
  }

  // ThemeData _themeData = lightMode;

  // ThemeData get themeData => _themeData;

  // bool get isDarkMode => _themeData == darkMode;

  // set themeData(ThemeData themeData) {
  //   _themeData = themeData;
  //   notifyListeners();
  // }

  // void toggleTheme() {
  //   if (_themeData == lightMode) {
  //     themeData = darkMode;
  //   } else {
  //     themeData = lightMode;
  //   }
  // }
}
