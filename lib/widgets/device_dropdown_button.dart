import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDropdownButton extends ConsumerWidget {
  const DeviceDropdownButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(deviceProvider);
    return DropdownButton<String>(
      value: device.device,
      items: device.userDevices
          .map((userDevice) => DropdownMenuItem(
                value: userDevice.idDevice,
                child: Text(userDevice.nickname),
              ))
          .toList(),
      onChanged: (String? value) {
        if (value != null) {
          ref.read(deviceProvider.notifier).getDevice(value);
        }
      },
    );
  }
}
