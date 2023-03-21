class Usuario {
  String id;
  String? name;
  String email;
  String? password;

  Usuario({required this.id, this.name = '', required this.email, this.password});
}
