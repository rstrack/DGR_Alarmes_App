import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<bool> {
  late SharedPreferences prefs;

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    var darkMode = prefs.getBool("isDarkMode");
    state = darkMode ?? false;
  }

  ThemeNotifier() : super(false) {
    _init();
  }

  void toggle() async {
    state = !state;
    prefs.setBool("isDarkMode", state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>(
  (ref) => ThemeNotifier(),
);
