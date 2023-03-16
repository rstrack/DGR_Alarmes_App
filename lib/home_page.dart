import 'package:flutter/material.dart';
import 'package:testes/menu_drawer.dart';
import 'package:testes/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const MenuDrawer(),
      body: Container(),
    );
  }
}
