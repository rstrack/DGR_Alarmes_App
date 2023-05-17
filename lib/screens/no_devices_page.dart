import 'package:DGR_alarmes/widgets/bluetooth_devices_dialog.dart';
import 'package:DGR_alarmes/widgets/custom_snack_bar.dart';
import 'package:DGR_alarmes/widgets/new_device_form.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/bluetooth_controller.dart';

class NoDevicesPage extends ConsumerStatefulWidget {
  const NoDevicesPage({super.key});

  @override
  ConsumerState<NoDevicesPage> createState() => _NoDevicesPageState();
}

class _NoDevicesPageState extends ConsumerState<NoDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Wrap(
          runSpacing: 20,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Você não possui nenhum ",
                    ),
                    TextSpan(
                      text: "dispositivo ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    TextSpan(
                      text: "vinculado. Se já adquiriu seu ",
                    ),
                    TextSpan(
                      text: "alarme ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    TextSpan(
                      text: ", ligue-o e configure-o.",
                    ),
                  ]),
            ),
            Center(
              child: FilledButton(
                  onPressed: () async {
                    var result = await BluetoothEnable.enableBluetooth;
                    bool? isOn = await BluetoothController
                        .instance.flutterBluetoothSerial.isEnabled;
                    var scanPermission =
                        await Permission.bluetoothScan.request();
                    if (isOn! &&
                        result == "true" &&
                        scanPermission == PermissionStatus.granted) {
                      BluetoothController.instance.startScanForDevices();
                      if (mounted) {
                        await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const BluetoothDevicesDialog();
                          },
                        );
                      }
                    } else {
                      await FlutterBluetoothSerial.instance.requestEnable();
                    }
                  },
                  // onPressed: () => Navigator.pushNamed(context, '/bluetooth_page'),
                  child: const Text("Configurar novo alarme")),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Se já configurou a conexão de seu ",
                    ),
                    TextSpan(
                      text: "alarme ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    TextSpan(
                      text: ", leia seu ",
                    ),
                    TextSpan(
                      text: "QR code ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    TextSpan(
                      text: "para vinculá-lo a sua conta.",
                    ),
                  ]),
            ),
            Center(
                child: FilledButton(
                    onPressed: () async {
                      String qrcode = await FlutterBarcodeScanner.scanBarcode(
                          "#FFFFFF", "Cancelar", false, ScanMode.QR);
                      //print("QR CODE: $qrcode");
                      if (qrcode != "-1") {
                        RegExp regex = RegExp(
                            r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
                        if (regex.hasMatch(qrcode) && mounted) {
                          showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return NewDeviceForm(macAddress: qrcode);
                              });
                        } else {
                          if (mounted) {
                            showCustomSnackbar(
                                context: context, text: "QR Code inválido");
                          }
                        }
                      }
                    },
                    child: const Text("Ler QR Code"))),
          ],
        ),
      ),
    );
  }
}
