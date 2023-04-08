import 'package:firebase_database/firebase_database.dart';

import 'package:DGR_alarmes/models/user.dart';

class UserController {
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  //cria usuário no RTDB
  Future<void> createUser(User user) async {
    await _ref.child("user/${user.id}").set(user.toJson());
  }

  static UserController instance = UserController();
}
