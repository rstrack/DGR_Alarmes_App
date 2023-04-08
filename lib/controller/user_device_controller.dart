import 'package:DGR_alarmes/models/user_device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDeviceController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  List<UserDevice> userDevices = [];

  Future<List<UserDevice>> listDevices() async {
    DatabaseEvent event = await _ref
        .child('userdevice')
        .orderByChild("idUser")
        .equalTo(_auth.currentUser!.uid)
        .once();

    final data = event.snapshot.value;
    userDevices = [];
    if (data != null) {
      (data as Map).forEach((key, value) {
        userDevices.add(UserDevice.fromJson(value));
      });
    }
    return userDevices;
  }

  static UserDeviceController instance = UserDeviceController();
}
