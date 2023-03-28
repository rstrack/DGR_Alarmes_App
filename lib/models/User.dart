import 'package:cloud_firestore/cloud_firestore.dart';

class user{
  String id;
  String? name;
  String email;
  // String? password;

  user(
      {required this.id,
      this.name = '',
      required this.email}); //, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // 'password': password,
    };
  }

  user.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'];
  // password = map['password'];

  // Método para converter QueryDocumentSnapshot<Object?> em User
  static Future<user?> getUserFromDocument(
      QueryDocumentSnapshot<Object?> document) async {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }
    user _user = user.fromMap(data);
    return _user;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$id | $name | $email";
  }

}
