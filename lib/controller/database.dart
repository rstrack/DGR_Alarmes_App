import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/models/user.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_database/firebase_database.dart';

class Database {
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //cria usuário no RTDB
  static Future<void> createUser(User user) async {
    _ref.child("user/${user.id}").set(user.toJson()).whenComplete(() {
      //print("Usuário ${user.id} | ${user.name} cadastrado!}");
      // ignore: avoid_print
    }).catchError((e) => print("Erro em createUser: $e"));
  }

  //retorna o usuário no RTDB que estiver autenticado no app
  static Future<User?> getUserAuth() {
    _ref.child("user/${_auth.currentUser!.uid}").get().then((snapshot) {
      if (snapshot.exists) {
        return snapshot.value;
      } else {
        //print("getUserAuth | Consulta não retornou nenhum dado!");
        return null;
      }
    }).catchError((error) {
      //print("Erro em getUserAuth: $error");
      return null;
    });
    return Future.value();
  }

  //cria vinculo entre usuário e dispositivo
  static Future<void> createUserDevice(UserDevice userDevice) async {
    _ref.child("userDevice").push().set(userDevice.toJson()).whenComplete(() {
      //print("Novo UserDevice criado!");
    }).catchError((e) {
      //print("Erro em createUserDevice: $e");
    });
  }

  static Future<List<UserDevice>> getDevicesByUser() async {
    List<UserDevice> listUserDevice = [];
    _ref
        .child('userdevice')
        .orderByChild("idUser")
        .equalTo(_auth.currentUser!.uid)
        .once()
        .then((DatabaseEvent event) {
      (event.snapshot.value as Map).forEach((key, value) {
        listUserDevice.add(UserDevice.fromJson(value));
      });
      return listUserDevice;
    }).catchError((e) {
      return listUserDevice;
    });
    return [];
  }

  static Future<Device?> getDevice(String macAddress) {
    _ref.child('device/$macAddress').once().then((DatabaseEvent event) {
      return Device.fromJson2(event.snapshot.value as Map, macAddress);
    });
    return Future.value();
  }
}
