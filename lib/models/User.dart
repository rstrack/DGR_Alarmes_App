import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String email;

  UserModel({this.id, this.name, required this.email}); //, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // 'password': password,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'];
  // password = map['password'];

  // Método para converter QueryDocumentSnapshot<Object?> em User
  static Future<UserModel?> getUserFromDocument(
      QueryDocumentSnapshot<Object?> document) async {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }
    UserModel user = UserModel.fromMap(data);
    return user;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$id | $name | $email";
  }
}
