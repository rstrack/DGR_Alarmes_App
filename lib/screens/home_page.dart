import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:DGR_alarmes/widgets/menu_drawer.dart';
import 'package:DGR_alarmes/models/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var usuarioLogado = Usuario(id: user.uid, email: user.email.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const MenuDrawer(),
      body: Center(child: Text('Bem vindo ${usuarioLogado.email}!')),
    );
  }
}
