import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'control/database.dart';
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

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkmode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Alarme Residencial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      darkTheme: darkTheme,
      themeMode: darkmode ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/': (context) => const MainPage(),
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(),
        '/home_page': (context) => const HomePage()
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
