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

  Future<bool> changeDeviceState(Device device) async {
    double unixTime = DateTime.now().millisecondsSinceEpoch / 1000;

    await _ref.child('device/${device.macAddress}/active').set(!device.active);

    Completer<bool> completer = Completer<bool>();

    var stream =
        _ref.child('log/${device.macAddress}').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        if (completer.isCompleted == false &&
            (event.snapshot.value as Map)['time'] > unixTime) {
          completer.complete(true);
        }
      }
    });
    // verificar se foi adicionado um log para a alteração de estado. Se der timeout,
    // o alarme nao respondeu, então reseta a mudança de estado.
    Timer(const Duration(seconds: 5), () async {
      if (completer.isCompleted == false) {
        await stream.cancel();
        _ref.child('device/${device.macAddress}/active').set(device.active);
        completer.complete(false);
      }
    });

    bool logAdded = await completer.future;

    if (logAdded) {
      await stream.cancel();
      return true;
    }
    return false;
  }

  Future<void> disableBuzzer(Device device) async {
    await _ref.child('device/${device.macAddress}/triggered').set(false);
  }

  static DeviceController instance = DeviceController();
}
