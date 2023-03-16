import 'package:flutter/material.dart';
import 'package:testes/theme_controller.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'Alarme Residencial',
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness: ThemeController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
          ),
          home: const HomePage(title: 'DGR Alarmes'),
        );
      },
    );
  }
}
