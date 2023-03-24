import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String email;

  User({this.id, this.name, required this.email}); //, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // 'password': password,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'];
  // password = map['password'];

  // Método para converter QueryDocumentSnapshot<Object?> em User
  static Future<User?> getUserFromDocument(
      QueryDocumentSnapshot<Object?> document) async {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }
    User user = User.fromMap(data);
    return user;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$id | $name | $email";
  }
}
