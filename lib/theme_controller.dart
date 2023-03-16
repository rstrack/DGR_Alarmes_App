import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  static ThemeController instance = ThemeController();

  bool isDarkTheme = false;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
