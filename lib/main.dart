import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:DGR_alarmes/control/database.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/providers/user_provider.dart';
import 'package:DGR_alarmes/screens/devices_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/firebase_options.dart';
import 'providers/theme_provider.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'widgets/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Database.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeviceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: AnimatedBuilder(
        animation: ThemeProvider.instance,
        builder: (context, child) {
          return MaterialApp(
            title: 'Alarme Residencial',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.instance.isDarkTheme ? darkTheme : lightTheme,
            routes: {
              '/': (context) => const MainPage(),
              '/login_page': (context) => const LoginPage(),
              '/register_page': (context) => const RegisterPage(),
              '/home_page': (context) => const HomePage(),
              '/devices_page': (context) => const DevicesPage()
            },
          );
        },
      ),
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
