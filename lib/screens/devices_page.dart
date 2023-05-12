import 'package:DGR_alarmes/controllers/device_controller.dart';
import 'package:DGR_alarmes/controllers/user_device_controller.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/widgets/confirmation_bottom_sheet.dart';
import 'package:DGR_alarmes/widgets/custom_snack_bar.dart';
import 'package:DGR_alarmes/widgets/menu_drawer.dart';
import 'package:DGR_alarmes/widgets/new_device_form.dart';
import 'package:DGR_alarmes/widgets/update_device_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesPage extends ConsumerStatefulWidget {
  const DevicesPage({super.key});

  @override
  ConsumerState<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<DevicesPage> {
  Device? selectedDevice;
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Dispositivos")),
      drawer: MenuDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String qrcode = await FlutterBarcodeScanner.scanBarcode(
              "#FFFFFF", "Cancelar", false, ScanMode.QR);
          //print("QR CODE: $qrcode");
          if (qrcode != "-1") {
            RegExp regex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
            if (regex.hasMatch(qrcode) && mounted) {
              showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return NewDeviceForm(macAddress: qrcode);
                  });
            } else {
              if (mounted) {
                showCustomSnackbar(context: context, text: "QR Code inválido");
              }
            }
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(deviceProvider);
        },
        child: Column(
          children: [
            Flexible(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemCount: device.userDevices.length,
                itemBuilder: (context, index) {
                  UserDevice currentDevice =
                      device.userDevices.elementAt(index);
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: (index % 2 == 0)
                          ? Colors.indigo.shade100
                          : Colors.indigo.shade200,
                      child: ListTile(
                        title: Text(currentDevice.nickname),
                        subtitle: Text(currentDevice.idDevice),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return UpdateDeviceForm(
                                        userDevice: currentDevice,
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return ConfirmationBottomSheet(
                                        onConfirming: () async {
                                          await UserDeviceController.instance
                                              .deleteUserDevice(
                                                  currentDevice.id);
                                          if (mounted) {
                                            Navigator.of(context).pop();
                                            showCustomSnackbar(
                                                context: context,
                                                text:
                                                    'Dispositivo excluído com sucesso!');
                                            ref.invalidate(deviceProvider);
                                          }
                                        },
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
