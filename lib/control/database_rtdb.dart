import 'package:DGR_alarmes/models/User.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/log.dart';

class DatabaseRTDB {
  static late final DatabaseReference realTimeRef;

  static late final String ID_AUTH;

  static late FirebaseAuth authInstance;

  // static late CollectionReference collectionUser;w
  // static late CollectionReference collectionDevice;
  // static late CollectionReference collectionUserDevice;

  static String USER = "user";
  static String DEVICE = "device";
  static String USER_DEVICE = "userdevice";

  DatabaseRTDB.init() {
    // var _firestoreInstance = FirebaseFirestore.instance;

    authInstance = FirebaseAuth.instance;
    getUserUID();

    realTimeRef = FirebaseDatabase.instance.ref();

    // collectionUser = _firestoreInstance.collection('user');
    // collectionDevice = _firestoreInstance.collection('device');
    // collectionUserDevice = _firestoreInstance.collection('userDevice');
    // print("--> Cria as coleções");
  }

  static String getUserUID() {
    try {
      ID_AUTH = authInstance.currentUser!.uid;
      return ID_AUTH;
    } catch (e) {
      print("Erro no Auth: $e");
    }
    return "";
  }

  //Cria um novo usuário apartir do user que é o auth
  static Future<void> createUser(user user) async {
    await realTimeRef.child("$USER/${user.id}").set(user.toMap()).then((value) {
      print("Usuário ${user.id} | ${user.name} cadastrado!}");
    }).catchError((e) => print("Erro em createUser: $e"));
  }

  // Busca o usuário auth
  static Future<user?> getUserAuth() async {
    return realTimeRef
        .child("$USER/$ID_AUTH")
        .get()
        .then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        return user.fromMap(snapshot.value as Map<String, dynamic>);
      } else {
        print("getUserAuth | Consulta não retornou nenhum dado!");
        return null;
      }
    }).catchError((error) => print("Erro em getUserAuth: $error"));
  }

  //---------------------------------------------------------------- DEVICE
  //Cria um novo dispositivo com o doc igual ao macAddress, vincula com o user auth
  static Future<void> createDevice(Device device) async {
    await realTimeRef
        .child("$DEVICE/${device.macAddress}")
        .set(device.toMap())
        .then((value) => print("Device cadastrado!"))
        .catchError((e) => print("Erro em createDevice: $e"));

    await createUserDevice(macAddress: device.macAddress, idUser: ID_AUTH);
  }

  // Consulta o device de um macAddres especifico
  static Future<Device?> getDeviceByMacAddress(
      {required String macAddress}) async {
    return realTimeRef.child("$DEVICE/$macAddress").get().then((snapshot) {
      if (snapshot.exists) {
        Device _device = Device.fromMap(snapshot.value as Map<String, dynamic>);
        return _device;
      } else {
        print("Erro em getDeviceByMacAddress | snapshot.exists == false");
        return null;
      }
    });
  }

  // Obtem uma lista de todos os devices do usuário logado
  static Stream<List<Device>> getDevicesByUserAuth() {
    return realTimeRef
        .child("$USER_DEVICE")
        .orderByChild("idUser")
        .equalTo(ID_AUTH)
        .onValue
        .map((event) {
      List<Device> devices = [];
      Map<String, dynamic> valuesChilds =
          event.snapshot.value as Map<String, dynamic>;
      print("--> ${valuesChilds.toString()}");
      if (valuesChilds.isNotEmpty) {
        valuesChilds.forEach((key, jsonUserDevices) {
          print(
              "---> ${jsonUserDevices.toString()} | $DEVICE/${jsonUserDevices["idDevice"]}");
          realTimeRef
              .child("$DEVICE/${jsonUserDevices["idDevice"]}")
              .onValue
              .listen((objDevice) {
            devices.add(Device
                .fromMap(objDevice.snapshot.value as Map<String, dynamic>));
            print("----> ${objDevice.snapshot.value}");
          });
        });
      }
      return devices;
    });
  }

  // Obtem a lista de todos os usuários relacionados a um device
  // static Future<List<user>> getUsersByDevice(
  //     {required String macAddress}) async {
  //   //Busca dentro de UserDevice os idUsers que se relacionam com idDevice
  //   QuerySnapshot<Object?> snapshot = await collectionUserDevice
  //       .where("idDevice", isEqualTo: macAddress)
  //       .get();

  //   List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
  //   List<user> users = [];
  //   if (documents.isNotEmpty) {
  //     //Para cada idUser encontrado, faz a busca completa do User
  //     for (QueryDocumentSnapshot<Object?> document in documents) {
  //       DocumentSnapshot<Object?> documentSnapshot =
  //           await collectionUser.doc(document['idUser']).get();
  //       if (documentSnapshot.exists) {
  //         user? _user = await user
  //             .fromMap(documentSnapshot.data() as Map<String, dynamic>);
  //         if (_user != null) {
  //           users.add(_user);
  //         }
  //       }
  //     }
  //     return users;
  //   }
  //   return users;
  // }
  //---------------------------------------------------------------- LOGS

  //Cria um novo log dentro da coleção "logs", com um doc unico
  static Future<void> createLog(
      {required Log log, required String macAddress}) async {
    return realTimeRef
        .child("$DEVICE/$macAddress/logs")
        .push()
        .set(log.toMap())
        .then((value) => print("Novo log criado!"))
        .catchError((e) => print("Erro em createLog: $e"));
  }

  // Obtem uma lista de todos os logs de um device identificado pelo macAddress
  static Stream<List<Log>> getLogsByDevice({required String macAddress}) {
    return realTimeRef
        .child("$DEVICE/$macAddress/logs")
        .onValue
        .asyncMap((event) {
      List<Log> logs = [];
      Map<String, dynamic> values =
          event.snapshot.value as Map<String, dynamic>;
      values.forEach((key, value) {
        logs.add(Log.fromMap(value));
      });
      return logs;
    });
  }

  //-------------------------------------------------------------- UserDevice

  //Cria a relação entre o user e o device
  static Future<void> createUserDevice(
      {required String macAddress, required String idUser}) async {
    await realTimeRef
        .child("$USER_DEVICE")
        .push()
        .set({'idDevice': macAddress, 'idUser': idUser})
        .then((value) => print("Novo UserDevice criado!"))
        .catchError((e) => print("Erro em createUserDevice: $e"));
  }

  // -------------------------------------------------------------- REAL TIME DATABASE

  static Stream<dynamic> readRTDB({required String path}) {
    return realTimeRef
        .child(path)
        .onValue
        .asyncMap((event) => event.snapshot.value);
  }
}
