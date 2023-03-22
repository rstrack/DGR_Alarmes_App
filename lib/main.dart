import 'package:DGR_alarmes/screens/register_page.dart';
import 'package:DGR_alarmes/widgets/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:DGR_alarmes/screens/login_page.dart';
import 'package:DGR_alarmes/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';

import 'screens/home_page.dart';

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
          theme: ThemeController.instance.isDarkTheme ? darkTheme : darkTheme,
          routes: {
            '/': (context) => const MainPage(),
            '/login_page': (context) => const LoginPage(),
            '/register_page': (context) => const RegisterPage(),
            '/home_page': (context) => const HomePage()
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
                return const HomePage();
              } else {
                return const LoginPage();
              }
            }
          },
        ),
      );
}
