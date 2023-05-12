class UserDevice {
  String id;
  String idUser;
  String idDevice;
  String nickname;

  UserDevice({
    required this.id,
    required this.idUser,
    required this.idDevice,
    required this.nickname,
  });

  factory UserDevice.fromJson(String id, Map json) {
    return UserDevice(
      id: id,
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
