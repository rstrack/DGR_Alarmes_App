import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/menu_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final userAuth = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('DGR Alarmes'),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Center(child: Text('Bem vindo ${userAuth.email}!')),
          Center(
            child: Text('DISPOSITIVO SELECIONADO: ${device.device?.toJson()}'),
          )
        ],
      ),
    );
  }
}
