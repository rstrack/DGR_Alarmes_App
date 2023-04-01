import 'dart:math';

import 'package:DGR_alarmes/models/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          String _macAddress = _generateMacAddress();
          await Database.createDevice(
              Device(macAddress: _macAddress, active: false, triggered: false));

          // FOR Criado para testes
          for (int j = 0; j < 25; j++) {
            Log log = Log(
              device_idDevice: _macAddress,
              time: (DateTime.now().millisecondsSinceEpoch/1000).toInt()-(j*100),
              type: Random().nextInt(3).toString(),
            );
            await Database.createLog(log: log, macAddress: _macAddress)
            .then((value) => print("--> $log"))
            .catchError((e) => print("Erro teste de createLog $e"));
          }
        },
      ),
      body: Column(
        children: [
          Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Bem vindo!'),
              )),
          StreamBuilder(
              stream: Database.getDevicesByUserAuth(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(
                    color: Colors.amber,
                  );
                }
                return Flexible(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Device _currentDevice = snapshot.data!.elementAt(index);
                      return Center(
                          child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        color: (index % 2 == 0)
                            ? Colors.indigo.shade100
                            : Colors.indigo.shade200,
                        child: Row(
                          children: [
                            Expanded(child: Text("$index | $_currentDevice")),
                            SizedBox(width: 20),
                            IconButton(
                              onPressed: () async {
                                //Aqui tem que usar um StreamBuild (eu acho) para o getLogsByDevice
                                await Database.getTestFutureLogsByDevice(macAddress: _currentDevice.macAddress);
                              },
                              icon: Icon(Icons.segment_outlined),
                            ),
                          ],
                        ),
                      ));
                    },
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
