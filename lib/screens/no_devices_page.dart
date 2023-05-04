import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'
    as flutterBarcodeScanner;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../controller/bluetooth_controller.dart';

class NoDevicesPage extends StatefulWidget {
  const NoDevicesPage({super.key});

  @override
  State<NoDevicesPage> createState() => _NoDevicesPageState();
}

class _NoDevicesPageState extends State<NoDevicesPage> {
  BluetoothController bluetoothController = BluetoothController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        runSpacing: 20,
        children: [
          Text(
              "Você não possui nenhum dispositivo vinculado. \nSe já adquiriu seu dispositivo, ligue-o e configure-o.",
              style: Theme.of(context).textTheme.titleMedium),
          Center(
            child: FilledButton(
                onPressed: () async {
                  bool? isOn = await bluetoothController
                      .flutterBluetoothSerial.isEnabled;
                  if (isOn!) {
                    bluetoothController.startScanForDevices();
                    await _showDevicesListModal();
                  } else {
                    alertBluetoothIsNotOn();
                  }
                },
                // onPressed: () => Navigator.pushNamed(context, '/bluetooth_page'),
                child: const Text("Configurar novo alarme")),
          ),
          Text(
              "Se já configurou a conexão de seu dispositivo, leia seu QR code para vinculá-lo a sua conta.",
              style: Theme.of(context).textTheme.titleMedium),
          Center(
              child: FilledButton(
                  onPressed: () async {
                    String barcode =
                        await flutterBarcodeScanner.FlutterBarcodeScanner
                            .scanBarcode("#FFFFFF", "Cancelar", false,
                                flutterBarcodeScanner.ScanMode.QR);
                    print("QR CODE: $barcode");
                    //CRIAR DIPOSITIVO
                  },
                  child: const Text("Ler QR Code"))),
        ],
      ),
    );
  }

  // Crie um método que exibe o modal com a lista de dispositivos
  Future<void> _showDevicesListModal() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // Crie o AlertDialog com um ListView.builder que lista os dispositivos
        return AlertDialog(
          title: Text('Dispositivos'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: StreamBuilder<List<BluetoothDiscoveryResult>>(
                stream: bluetoothController.results,
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<BluetoothDiscoveryResult>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final devicesList = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: devicesList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      BluetoothDevice device = devicesList[index].device;
                      String? deviceName = "";
                      if (device.name != null) {
                        deviceName = device.name!.isNotEmpty
                            ? device.name
                            : 'Dispositivo desconhecido';
                      }
                      return GestureDetector(
                        onLongPress: () async {
                          try {
                            // Exibe o diálogo de carregamento
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text("Conectando com ${deviceName}"),
                                    ],
                                  ),
                                );
                              },
                            );

                            await bluetoothController
                                .pairWithBluetoothDevice(device.address);

                            // Fecha o diálogo de carregamento e faça algo quando um dispositivo for selecionado
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            
                            await openWifiNetworkModal(context);

                          } catch (e) {
                            print(
                                'Erro ao conectar ao dispositivo ${device.address}: $e');
                            // Fecha o diálogo de carregamento e exibe uma mensagem de erro
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Erro'),
                                  content: Text(
                                      'Não foi possível conectar ao dispositivo ${device.address}. Tente novamente.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: ListTile(
                          leading: Icon(Icons.bluetooth),
                          title: Text(
                            deviceName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MAC: ${devicesList[index].device.address.toString()}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                'RSSI: ${devicesList[index].rssi.toString()} dBm',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Feche o modal e faça algo quando um dispositivo for selecionado
                            Navigator.of(context).pop();
                            // Faça algo com o dispositivo selecionado aqui
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> openWifiNetworkModal(
      BuildContext context) async {
    String ssid = '';
    String password = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rede WiFi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => ssid = value,
                decoration: InputDecoration(
                  labelText: 'SSID',
                ),
              ),
              TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                bluetoothController.sendWifiNetwork(ssid, password);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  alertBluetoothIsNotOn() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            alignment: Alignment.center,
            width: 50,
            height: 20,
            child: Text("Ligue o Bluetooth e a localização!"),
          ),
          icon: Icon(Icons.bluetooth_disabled_outlined, size: 40),
        );
      },
    );
  }
}
