// ignore_for_file: prefer_final_fields

import 'package:DGR_alarmes/dao/user_device_dao.dart';
import 'package:DGR_alarmes/models/User.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceDao {
  DatabaseReference ref = FirebaseDatabase.instance.ref('device');
  List<Device> _devices = [];
  UserDeviceDao _userDeviceDao = UserDeviceDao();

  Future<List<Device>> loadDevices({UserModel? user}) async {
    ref.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot
          .value; // Pega os dados do snapshot no momento que ocorrer o evento
      if (user == null) {
        if (data != null && data is Map) {
          for (var d in data.entries) {
            Device device = Device(
              macAddress: d.value['macAddress'],
              active: d.value['active'],
              triggered: d.value['triggered'],
            );
            _devices.add(device);
          }
        }
      } else {
        _devices = _userDeviceDao.loadDevicesByUser(user.id!) as List<Device>;
      }
    });
    return _devices;
  }

  Future<String> saveDevice(Device device) async {
    await ref.push().set(device.toMap());
    return ref.key!;
  }

  Future<void> updateDevice(String key, Device device) async {
    await ref.child(key).update(device.toMap as Map<String, Object?>);
  }

  Future<void> deleteDevice(String key) async {
    await ref.child(key).remove();
  }

  // Future<void>
}
