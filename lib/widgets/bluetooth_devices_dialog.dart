import 'package:DGR_alarmes/services/bluetooth_controller.dart';
import 'package:DGR_alarmes/widgets/wifi_credentials_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDevicesDialog extends StatelessWidget {
  const BluetoothDevicesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dispositivos'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: StreamBuilder<List<BluetoothDiscoveryResult>>(
            stream: BluetoothController.instance.results,
            initialData: const [],
            builder: (BuildContext context,
                AsyncSnapshot<List<BluetoothDiscoveryResult>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final devicesList = snapshot.data;
              if (devicesList!.isEmpty) {
                return const Text("Nenhum dispositivo encontrado.");
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: devicesList.length,
                itemBuilder: (BuildContext context, int index) {
                  BluetoothDevice device = devicesList[index].device;
                  String? deviceName = "";
                  if (device.name != null) {
                    deviceName = device.name!.isNotEmpty
                        ? device.name
                        : 'Dispositivo desconhecido';
                  }
                  return InkWell(
                    onTap: () async {
                      try {
                        // Exibe o diálogo de carregamento
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Row(
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(width: 20),
                                  Text("Conectando com $deviceName"),
                                ],
                              ),
                            );
                          },
                        );
                        BluetoothController.instance
                            .pairWithBluetoothDevice(device.address)
                            .whenComplete(() async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const WifiCredentialsDialog();
                            },
                          );
                        });
                      } catch (e) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Erro'),
                              content: Text(
                                  'Não foi possível conectar ao dispositivo ${device.address}. Tente novamente.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(
                        deviceName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MAC: ${devicesList[index].device.address.toString()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            'RSSI: ${devicesList[index].rssi.toString()} dBm',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
