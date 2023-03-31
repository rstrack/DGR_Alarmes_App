// ignore_for_file: prefer_final_fields

import 'package:DGR_alarmes/dao/user_device_dao.dart';
import 'package:DGR_alarmes/models/User.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/device.dart';

class UserDao {
  DatabaseReference ref = FirebaseDatabase.instance.ref('user');
  List<UserModel> _users = [];
  UserDeviceDao _userDeviceDao = UserDeviceDao();

  Future<List<UserModel>> loadUsers({Device? device}) async {
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot
          .value; // Pega os dados do snapshot no momento que ocorrer o evento
      if (device == null) {
        if (data != null && data is Map) {
          for (var d in data.entries) {
            UserModel user = UserModel(
              email: d.value['email'],
              id: d.value['id'],
              name: d.value['name'],
            );
            _users.add(user);
          }
        }
      } else {
        _users = _userDeviceDao.loadUsersByDevice(device.macAddress)
            as List<UserModel>;
      }
    });
    return _users;
  }

  Future<String> saveUser(UserModel user) async {
    await ref.push().set(user.toMap());
    return ref.key!;
  }

  Future<void> updateUser(String key, UserModel user) async {
    await ref.child(key).update(user.toMap as Map<String, Object?>);
  }

  Future<void> deleteUser(String key) async {
    await ref.child(key).remove();
  }
}
