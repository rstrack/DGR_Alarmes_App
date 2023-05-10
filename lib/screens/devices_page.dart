import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:DGR_alarmes/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesPage extends ConsumerStatefulWidget {
  const DevicesPage({super.key});

  @override
  ConsumerState<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);
    print(device.userDevices.length);

    return Scaffold(
      appBar: AppBar(title: const Text("Dispositivos")),
      drawer: MenuDrawer(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: device.userDevices
                    .map((userDevice) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton.icon(
                            icon: const SizedBox(
                                width: 40,
                                height: 50,
                                child: Icon(Icons.devices)),
                            label: Text(userDevice.nickname),
                            onPressed: () {
                              ref
                                  .read(deviceProvider.notifier)
                                  .setMacAddress(userDevice.idDevice);
                              Navigator.of(context).pushNamed('/home_page');
                            },
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
