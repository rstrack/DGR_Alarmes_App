class User {
  String id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map json) {
    return User(
      id: json.keys.first,
      name: json['name'],
      email: json['email'],
    );
  }

  Map toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
