// ignore_for_file: prefer_final_fields, unused_field

import 'package:DGR_alarmes/dao/user_dao.dart';
import 'package:DGR_alarmes/models/User.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/dao/device_dao.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:DGR_alarmes/dao/device_dao.dart';

class UserDeviceDao {
  List<Device> _devices = [];
  List<UserModel> _users = [];
  List<UserDevice> _usersDevices = [];

  DatabaseReference ref = FirebaseDatabase.instance.ref('userdevice');

  Future<List<Device>> loadDevicesByUser(String idUser) async {
    // _devices = await _deviceDao.loadDevices();
    DataSnapshot dataSnapshot = (await ref
        .orderByChild('idUser')
        .equalTo(idUser)
        .once()) as DataSnapshot;

    dynamic data = dataSnapshot.value;
    if (data is Map<String, dynamic>) {
      for (var d in data.entries) {
        Device device = Device(
          macAddress: d.value['macAddress'],
          active: d.value['active'],
          triggered: d.value['triggered'],
        );
        _devices.add(device);
      }
    }
    return _devices;
  }

  Future<List<UserModel>> loadUsersByDevice(String idDevice) async {
    DataSnapshot dataSnapshot = (await ref
        .orderByChild('idDevice')
        .equalTo(idDevice)
        .once()) as DataSnapshot;

    dynamic data = dataSnapshot.value;
    if (data is Map<String, dynamic>) {
      for (var d in data.entries) {
        UserModel user = UserModel(
            email: d.value['email'], id: d.value['id'], name: d.value['name']);
        _users.add(user);
      }
    }
    return _users;
  }
}
