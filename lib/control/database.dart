import 'package:DGR_alarmes/models/User.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/log.dart';

class Database {
  static late final DatabaseReference realTimeRef;
  static late final FirebaseAuth firebaseAuth;

  static String userPath = "user";
  static String devicePath = "device";
  static String userDevicePath = "userdevice";

  Database.init() {
    firebaseAuth = FirebaseAuth.instance;
    realTimeRef = FirebaseDatabase.instance.ref();
  }

  //Cria um novo usuário apartir do user que é o auth
  static Future<void> createUser(UserModel user) async {
    await realTimeRef
        .child("$userPath/${user.id}")
        .set(user.toMap())
        .then((value) {
      print("Usuário ${user.id} | ${user.name} cadastrado!}");
    }).catchError((e) => print("Erro em createUser: $e"));
  }

  // Busca o usuário auth
  static Future<UserModel?> getUserAuth() async {
    return realTimeRef
        .child("$userPath/${firebaseAuth.currentUser!.uid}")
        .get()
        .then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.value as Map<String, dynamic>);
      } else {
        print("getUserAuth | Consulta não retornou nenhum dado!");
        return null;
      }
    }).catchError((error) => print("Erro em getUserAuth: $error"));
  }

  //---------------------------------------------------------------- DEVICE
  //Cria um novo dispositivo com o child igual ao macAddress, vincula com o user auth
  static Future<void> createDevice(Device device) async {
    await realTimeRef
        .child("$devicePath/${device.macAddress}")
        .set(device.toMap())
        .then((value) async {
      print("Device cadastrado!");
      await createUserDevice(
          macAddress: device.macAddress, idUser: firebaseAuth.currentUser!.uid);
    }).catchError((e) => print("Erro em createDevice: $e"));
  }

  //Atualiza o dispositivo pelo macAddress
  static Future<void> updateDevice(Device device) async {
    await realTimeRef
        .child("$devicePath/${device.macAddress}")
        .update(device.toMap())
        .then((value) async {
      print("Device atualizado!");
      await createUserDevice(
          macAddress: device.macAddress, idUser: firebaseAuth.currentUser!.uid);
    }).catchError((e) => print("Erro em updateDevice: $e"));
  }

  // Consulta o device de um macAddres especifico
  static Future<Device?> getDeviceByMacAddress(
      {required String macAddress}) async {
    return realTimeRef.child("$devicePath/$macAddress").get().then((snapshot) {
      if (snapshot.exists) {
        Device _device = Device.fromMap(snapshot.value as Map<String, dynamic>);
        return _device;
      } else {
        print("Erro em getDeviceByMacAddress");
        return null;
      }
    });
  }

  // Obtem uma lista de todos os devices do usuário logado
  static Stream<List<Device>> getDevicesByUserAuth() {
    return realTimeRef
        .child("$userDevicePath")
        .orderByChild("idUser")
        .equalTo(firebaseAuth.currentUser!.uid)
        .onValue
        .asyncMap((event) async {
      List<Device> devices = [];
      Map<String, dynamic> valuesChilds =
          event.snapshot.value as Map<String, dynamic>;
      if (valuesChilds.isNotEmpty) {
        List<Future<Device>> futures = [];
        valuesChilds.forEach((key, jsonUserDevices) {
          futures.add(realTimeRef
              .child("$devicePath/${jsonUserDevices["idDevice"]}")
              .once()
              .then((objDevice) {
            return Device.fromMap(
                objDevice.snapshot.value as Map<String, dynamic>);
          }));
        });
        devices = await Future.wait(futures);
      }
      return devices;
    });
  }

  //---------------------------------------------------------------- LOGS

  //Cria um novo log dentro da coleção "logs", com um doc unico
  static Future<void> createLog(
      {required Log log, required String macAddress}) async {
    return realTimeRef
        .child("$devicePath/$macAddress/logs")
        .push()
        .set(log.toMap())
        .then((value) => print("Novo log criado!"))
        .catchError((e) => print("Erro em createLog: $e"));
  }

  // Obtem uma lista de todos os logs de um device identificado pelo macAddress
  static Stream<List<Log>> getLogsByDevice({required String macAddress}) {
    return realTimeRef
        .child("$devicePath/$macAddress/logs")
        .orderByChild("time")
        .limitToLast(20)
        .onValue
        .asyncMap((event) {
      List<Log> logs = [];
      Map<String, dynamic> values =
          event.snapshot.value as Map<String, dynamic>;
      values.forEach((key, value) {
        logs.add(Log.fromMap(value));
      });
      if (logs.isNotEmpty) {
        print("--> ${logs.toList()}");
      } else {
        print("Logs está vazio!");
      }
      return logs;
    });
  }

  //-------------------------------------------------------------- UserDevice

  //Cria a relação entre o user e o device
  static Future<void> createUserDevice(
      {required String macAddress, required String idUser}) async {
    await realTimeRef
        .child("$userDevicePath")
        .push()
        .set({'idDevice': macAddress, 'idUser': idUser})
        .then((value) => print("Novo UserDevice criado!"))
        .catchError((e) => print("Erro em createUserDevice: $e"));
  }

  static Future<void> unlinkUserDevice({required String childID}) async {
    await realTimeRef
        .child(childID)
        .remove()
        .then((value) => print("UserDevice removido!"))
        .catchError((e) => print("Erro em unlinkUserDevice: $e"));
  }
}
