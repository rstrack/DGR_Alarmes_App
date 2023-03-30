import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  // String idDevice;
  String macAddress;
  bool active;
  bool triggered;

  Device({
    // required this.idDevice,
    required this.macAddress,
    required this.active,
    required this.triggered,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'idDevice': idDevice,
      'macAddress': macAddress,
      'active': active,
      'triggered': triggered,
    };
  }

  Device.fromMap(Map<String, dynamic> map)
      // : idDevice = map['idDevice'],
      :
        macAddress = map['macAddress'],
        active = map['active'],
        triggered = map['triggered'];

  // Obtendo um objeto Device a partir de um documento
  static Future<Device?> getDeviceFromDocument(
      QueryDocumentSnapshot<Object?> document) async {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }
    Device _device = Device.fromMap(data);
    return _device;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Device | MAC: $macAddress | Active: $active | Triggered: $triggered";
  }

}
