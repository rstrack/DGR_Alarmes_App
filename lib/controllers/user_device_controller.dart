import 'package:DGR_alarmes/models/user_device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDeviceController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  List<UserDevice> userDevices = [];

  Future<bool> createUserDevice(String macAddress, String nickname) async {
    DatabaseEvent event = await _ref
        .child('userdevice')
        .orderByChild("user")
        .equalTo(_auth.currentUser!.uid)
        .once();

    final data = event.snapshot.value;
    if (data != null) {
      for (Map value in (data as Map).values) {
        if (value['device'] == macAddress) {
          return false;
        }
      }
    }
    final newKey = _ref.child('userdevice').push().key;
    await _ref.child('userdevice/$newKey').set({
      'user': _auth.currentUser!.uid,
      'device': macAddress,
      'nickname': nickname
    });
    return true;
  }

  Future<void> updateUserDevice(String id, String nickname) async {
    await _ref.child('userdevice/$id').update({'nickname': nickname});
  }

  Future<void> deleteUserDevice(String id) async {
    await _ref.child('userdevice/$id').remove();
  }

  Future<List<UserDevice>> listUserDevices() async {
    if (_auth.currentUser != null) {
      DatabaseEvent event = await _ref
          .child('userdevice')
          .orderByChild("user")
          .equalTo(_auth.currentUser!.uid)
          .once();

      final data = event.snapshot.value;
      userDevices = [];
      if (data != null) {
        (data as Map).forEach((key, value) {
          userDevices.add(UserDevice.fromJson(key, value));
        });
      }
      return userDevices;
    }
    return [];
  }

  static UserDeviceController instance = UserDeviceController();
}
