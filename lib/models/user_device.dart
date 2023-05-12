class UserDevice {
  String idUser;
  String idDevice;
  String nickname;

  UserDevice({
    required this.idUser,
    required this.idDevice,
    required this.nickname,
  });

  factory UserDevice.fromJson(Map json) {
    return UserDevice(
      idUser: json['user'],
      idDevice: json['device'],
      nickname: json['nickname'],
    );
  }

  Map toJson() {
    return {
      'user': idUser,
      'device': idDevice,
      'nickname': nickname,
    };
  }
}
