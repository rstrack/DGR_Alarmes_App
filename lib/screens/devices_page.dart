import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
                                child: Icon(Icons.devices)
                                // Icon(Icons.devices_other_rounded)
                                // CircleAvatar(
                                //   backgroundImage:
                                //       AssetImage('assets/casa_dgr.png'),
                                // ),
                                ),
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
