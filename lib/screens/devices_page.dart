import 'dart:math';

import 'package:flutter/material.dart';

import '../control/database.dart';
import '../models/device.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device'),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        child: Icon(Icons.add),
        onPressed: () async {
          await Database.createDevice(Device(
              macAddress: _generateMacAddress(),
              active: false,
              triggered: false));
        },
      ),
      body: Column(
        children: [
          Center(child: const Text('Bem vindo!')),
          StreamBuilder(
              stream: Database.getDevicesByUserAuth(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(
                    color: Colors.amber,
                  );
                }
                return Flexible(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length  ,
                    itemBuilder: (context, index) => Center(
                        child: Text(
                            "$index | ${snapshot.data!.elementAt(index)}")),
                  ),
                );
              })
        ],
      ),
    );
  }
}

String _generateMacAddress() {
  var random = Random();
  var macBytes = List.generate(6, (_) => random.nextInt(256));
  var macAddress =
      macBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(':');
  return macAddress;
}
