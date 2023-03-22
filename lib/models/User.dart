class User {
  String id;
  String? name;
  String email;
  String? password;

  User({required this.id, this.name = '', required this.email, this.password});
}
