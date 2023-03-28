// import 'package:DGR_alarmes/models/device.dart';
// import 'package:DGR_alarmes/models/User.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../models/log.dart';

// class database {
//   static late CollectionReference collectionUser;
//   static late CollectionReference collectionDevice;
//   static late CollectionReference collectionUserDevice;

//   database.init() {
//     var _instance = FirebaseFirestore.instance;
//     collectionUser = _instance.collection('user');
//     collectionDevice = _instance.collection('device');
//     collectionUserDevice = _instance.collection('userDevice');
//     // print("--> Cria as coleções");
//   }

//   //Cria um novo usuário apartir do user que é o auth
//   static Future<void> createUser(User user) async {
//     await collectionUser.doc(user.id).set(user.toMap()).then((value) {
//       print("Usuário ${user.id} | ${user.name} cadastrado!}");
//     }).catchError((e) => print("Erro em createUser: $e"));
//   }

//   // Busca o usuário auth
//   static Future<User?> getUserAuth() async {
//     DocumentSnapshot<Object?> documentSnapshot = await collectionUser
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get(); // where('userId', isEqualTo: userId).get();
//     if (documentSnapshot.exists) {
//       User? _user =
//           User.fromMap(documentSnapshot.data() as Map<String, dynamic>);
//       print("--> Usuário | getUser | $_user");
//       return _user;
//     } else {
//       return null;
//     }
//   }

//   //----------------------------------------------------------------
//   //Cria um novo dispositivo com o doc igual ao macAddress
//   static Future<void> createDevice(Device device) async {
//     await collectionDevice
//         .doc(device.macAddress)
//         .set(device.toMap())
//         .then((value) => print("Device cadastrado!"))
//         .catchError((e) => print("Erro em createDevice: $e"));
//   }

//   // Consulta o device de um macAddres especifico 
//   static Future<Device?> getDeviceByMacAddress(
//       {required String macAddress}) async {
//     DocumentSnapshot<Object?> snapshot =
//         await collectionDevice.doc(macAddress).get();

//     if (snapshot.exists) {
//       Device _device = Device.fromMap(snapshot.data() as Map<String, dynamic>);
//       return _device;
//     } else {
//       print("Erro em getDeviceByMacAddress | snapshot.exists == false");
//       return null;
//     }
//   }

//   // Obtem uma lista de todos os devices do usuário logado
//   static Future<List<Device>> getDevicesByUserAuth() async {
//     List<Device> devices = [];
//     await collectionUserDevice
//         .where("idUser", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then(
//       (snapshot) async {
//         print("Consulta getDevicesByUserAuth completa!");
//         List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
//         for (QueryDocumentSnapshot<Object?> document in documents) {
//           Device? _device = await Device.getDeviceFromDocument(document);
//           if (_device != null) {
//             devices.add(_device);
//           }
//         }
//         return devices;
//       },
//       onError: (e) => print("Erro em getDevicesByUserAuth: $e"),
//     );
//     return devices;
//   }

//   // Obtem a lista de todos os usuários relacionados a um device
//   static Future<List<User>> getUsersByDevice(
//       {required String macAddress}) async {
//     //Busca dentro de UserDevice os idUsers que se relacionam com idDevice
//     QuerySnapshot<Object?> snapshot = await collectionUserDevice
//         .where("idDevice", isEqualTo: macAddress)
//         .get();

//     List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
//     List<User> users = [];
//     if (documents.isNotEmpty) {
//       //Para cada idUser encontrado, faz a busca completa do User
//       for (QueryDocumentSnapshot<Object?> document in documents) {
//         var doc = document;
//         DocumentSnapshot<Object?> documentSnapshot =
//             await collectionUser.doc(doc['idUser']).get();
//         if (documentSnapshot.exists) {
//           User? _user = await User
//               .fromMap(documentSnapshot.data() as Map<String, dynamic>);
//           if (_user != null) {
//             users.add(_user);
//           }
//         }
//       }
//       return users;
//     }
//     return users;
//   }
//   //----------------------------------------------------------------

//   //Cria um novo log dentro da coleção "logs", com um doc unico
//   static Future<void> createLog(
//       {required Log log, required String macAddress}) async {
//     // userDevice/doc(macAddress)/logs
//     CollectionReference collectionReference =
//         collectionUserDevice.doc(macAddress).collection("logs");

//     // ../doc()
//     await collectionReference
//         .add(log.toMap())
//         .then((value) => print("Novo log criado!"))
//         .catchError((e) => print("Erro em createLog: $e"));
//   }

//   // Obtem uma lista de todos os logs de um device identificado pelo macAddress
//   static Future<List<Log>> getLogsByDevice({required String macAddress}) async {
//     CollectionReference collectionReference =
//         collectionUserDevice.doc(macAddress).collection("logs");

//     QuerySnapshot<Object?> snapshot = await collectionReference.get();

//     List<QueryDocumentSnapshot<Object?>> documents = snapshot.docs;
//     List<Log> logs = [];
//     if (documents.isNotEmpty) {
//       for (QueryDocumentSnapshot<Object?> document in documents) {
//         Log? _log = await Log.getLogFromDocument(document);
//         if (_log != null) {
//           logs.add(_log);
//         }
//       }
//     }
//     return logs;
//   }

//   //--------------------------------------------------------------

//   //Cria a relação entre o user e o device
//   static Future<void> createUserDevice(
//       {required String macAddress, required String idUser}) async {
//     await collectionUserDevice
//         .doc()
//         .set({'idDevice': macAddress, 'idUser': idUser})
//         .then((value) => print("Novo UserDevice criado!"))
//         .catchError((e) => print("Erro em createUserDevice: $e"));
//   }
// }
