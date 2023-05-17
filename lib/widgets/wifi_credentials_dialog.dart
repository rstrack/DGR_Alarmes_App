import 'package:DGR_alarmes/services/bluetooth_controller.dart';
import 'package:flutter/material.dart';

class WifiCredentialsDialog extends StatefulWidget {
  const WifiCredentialsDialog({super.key});

  @override
  State<WifiCredentialsDialog> createState() => _WifiCredentialsDialogState();
}

class _WifiCredentialsDialogState extends State<WifiCredentialsDialog> {
  String ssid = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rede WiFi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => ssid = value,
            decoration: const InputDecoration(
              labelText: 'SSID',
            ),
          ),
          TextField(
            onChanged: (value) => password = value,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await BluetoothController.instance.sendWifiNetwork(ssid, password);
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
