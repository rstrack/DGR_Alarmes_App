import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/log.dart';

class database {
  static late CollectionReference collectionUser;
  static late CollectionReference collectionDevice;
  static late CollectionReference collectionLog;

  database.init() {
    var _instance = FirebaseFirestore.instance;
    collectionUser = _instance.collection('user');
    collectionDevice = _instance.collection('device');
    collectionLog = _instance.collection('log');
    print("--> Cria as coleções");
  }

  static Future<void> createUser(user user) async {
    await collectionUser
        .doc(user.id)
        .set(user.toMap()).then((value) => print("--> Usuário ${user.id} | ${user.name} cadastrado!"))
        .catchError((e) => print("Erro em createUser: $e"));
  }

// Obtendo uma lista de todos os usuários
  static Future<List<user>> getUsers() async {
    QuerySnapshot<Object?> snapshot = await collectionUser.get();
    List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
    List<user> users = [];
    for (QueryDocumentSnapshot<Object?> document in documents) {
      user? _user = await user.getUserFromDocument(document);
      if (_user != null) {
        users.add(_user);
      }
    }
    return users;
  }

  //----------------------------------------------------------------

  static Future<void> createDevice(device device) async {
    await collectionDevice
        .doc()
        .set(device.toMap())
        .catchError((e) => print("Erro em createDevice: $e"));
  }

  // Obtendo uma lista de todos os devices
  static Future<List<device>> getDevices() async {
    QuerySnapshot<Object?> snapshot = await collectionDevice.get();
    List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
    List<device> devices = [];
    for (QueryDocumentSnapshot<Object?> document in documents) {
      device? _device = await device.getDeviceFromDocument(document);
      if (_device != null) {
        devices.add(_device);
      }
    }
    return devices;
  }

  //----------------------------------------------------------------

  static Future<void> createLog(log log) async {
    await collectionLog
        .doc()
        .set(log.toMap())
        .catchError((e) => print("Erro em createLog: $e"));
  }

  // Obtendo uma lista de todos os logs
  static Future<List<log>> getLogs() async {
    QuerySnapshot<Object?> snapshot = await collectionLog.get();

    List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
    List<log> logs = [];
    for (QueryDocumentSnapshot<Object?> document in documents) {
      log? _log = await log.getLogFromDocument(document);
      if (_log != null) {
        logs.add(_log);
      }
    }
    return logs;
  }
}
