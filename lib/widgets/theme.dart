import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
);

ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.indigo),
    scaffoldBackgroundColor: Colors.grey[800]);
