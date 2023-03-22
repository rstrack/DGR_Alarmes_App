import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeProvider instance = ThemeProvider();

  bool isDarkTheme = false;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
