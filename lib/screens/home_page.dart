import 'package:DGR_alarmes/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

import '../widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var loggedUser = User(id: user.uid, email: user.email.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('DGR Alarmes'),
      ),
      drawer: const MenuDrawer(),
      body: Center(child: Text('Bem vindo ${loggedUser.email}!')),
    );
  }
}
