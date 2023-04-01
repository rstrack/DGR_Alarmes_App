import 'package:DGR_alarmes/models/device.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceController {
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  Device device = Device.empty();

  Future<Device> getDevice(String macAddress) async {
    DatabaseEvent event = await _ref.child('/device/$macAddress').once();
    final data = event.snapshot.value as Map;
    device = Device.fromJson2(data as Map, macAddress);
    return device;
  }

  static DeviceController instance = DeviceController();
}
