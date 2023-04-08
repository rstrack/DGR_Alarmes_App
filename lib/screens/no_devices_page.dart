import 'package:flutter/material.dart';

class NoDevicesPage extends StatefulWidget {
  const NoDevicesPage({super.key});

  @override
  State<NoDevicesPage> createState() => _NoDevicesPageState();
}

class _NoDevicesPageState extends State<NoDevicesPage> {
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
                onPressed: () {}, child: const Text("Configurar novo alarme")),
          ),
          Text(
              "Se já configurou a conexão de seu dispositivo, leia seu QR code para vinculá-lo a sua conta.",
              style: Theme.of(context).textTheme.titleMedium),
          Center(
              child: FilledButton(
                  onPressed: () {}, child: const Text("Ler QR Code"))),
        ],
      ),
    );
  }
}
