class UserDevice {
  String? id;
  String userId;
  String deviceId;

  UserDevice({this.id, required this.userId, required this.deviceId});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'deviceId': deviceId,
    };
  }

  static UserDevice fromMap(Map<String, dynamic> map) {
    return UserDevice(
      id: map['id'],
      userId: map['userId'],
      deviceId: map['deviceId'],
    );
  }
}
