class UserDevice {
  String idUser;
  String idDevice;
  String nickname;

  UserDevice({
    required this.idUser,
    required this.idDevice,
    required this.nickname,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      idUser: json['idUser'],
      idDevice: json['idDevice'],
      nickname: json['nickname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idDevice': idDevice,
      'nickname': nickname,
    };
  }
}
