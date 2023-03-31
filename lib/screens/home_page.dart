import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

import '../widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userAuth = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DGR Alarmes'),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Center(child: Text('Bem vindo ${userAuth.email}!')),
        ],
      ),
    );
  }
}
