import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testes/login_page.dart';
import 'package:testes/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.indigo,
              brightness: ThemeController.instance.isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.indigo)),
          routes: {
            '/': (context) => const MainPage(),
            '/login_page': (context) => const LoginPage(),
            '/home_page': (context) => const HomePage(title: 'DGR Alarme')
          },
        );
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const Drawer(),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //print(">> ${snapshot.hasData} | ${snapshot.toString()}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return const HomePage(title: 'DGR Alarmes');
              } else {
                return const LoginPage();
              }
            }
          },
        ),
      );
}
