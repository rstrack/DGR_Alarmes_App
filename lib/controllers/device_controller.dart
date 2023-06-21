import 'dart:async';

import 'package:DGR_alarmes/models/device.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceController {
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  Device device = Device.empty();

  Future<Device> getDevice(String macAddress) async {
    DatabaseEvent event = await _ref.child('/device/$macAddress').once();
    final data = event.snapshot.value as Map;
    device = Device.fromJson2(data, macAddress);
    return device;
  }

  Future<void> changeDeviceState(Device device) async {
    await _ref.child('device/${device.macAddress}/active').set(!device.active);
  }

  Future<bool> checkDeviceChange(double unixTime) async {
    Completer<bool> completer = Completer<bool>();
    Timer timeoutTimer = Timer(const Duration(seconds: 5), () {
      completer.complete(false);
    });

    Timer checkTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      DatabaseEvent event = await _ref.child('log/${device.macAddress}').once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> logs =
            event.snapshot.value as Map<dynamic, dynamic>;
        bool logFound = false;

        logs.forEach((key, value) {
          if (!logFound &&
              value['time'] > unixTime - 1 &&
              !completer.isCompleted) {
            logFound = true;
            completer.complete(true);
          }
        });
      }
    });

    bool logAdded = await completer.future;

    timeoutTimer.cancel();
    checkTimer.cancel();
    return logAdded;
  }

  static DeviceController instance = DeviceController();
}
