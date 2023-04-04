import 'package:DGR_alarmes/controller/device_controller.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/screens/summary_page.dart';
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
    ref.read(deviceProvider.notifier).listenDevice();
    return Scaffold(
        appBar: AppBar(
          title: const Text('DGR Alarmes'),
        ),
        drawer: MenuDrawer(),
        body: device.userDevices.isNotEmpty ? const SummaryPage() : null);
  }
}
