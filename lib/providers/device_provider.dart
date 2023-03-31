import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:DGR_alarmes/models/device.dart';

class DeviceNotifier extends StateNotifier<String> {
  DeviceNotifier(super.state);

  void changeDevice(String macAddress) {
    state = macAddress;
  }
}

final deviceProvider = StateNotifierProvider<DeviceNotifier, String>(
  (ref) => DeviceNotifier(""),
);

final deviceStreamProvider = StreamProvider<Device>((ref) {
  final selectedDevice = ref.watch(deviceProvider);

  if (selectedDevice != "") {
    var ref = FirebaseDatabase.instance.ref();
    return ref.child('device/$selectedDevice').onValue.map((event) =>
        Device.fromJson(event.snapshot.value as Map<String, dynamic>));
  } else {
    return const Stream.empty();
  }
});
