import 'package:DGR_alarmes/models/log.dart';

class Device {
  late String macAddress;
  late bool active;
  late bool triggered;

  Device({
    required this.macAddress,
    required this.active,
    required this.triggered,
  });

  Device.empty() {
    macAddress = "";
    active = false;
    triggered = false;
  }

  ///Transforma um Json com chave em um Device
  factory Device.fromJson(Map json) {
    return Device(
      macAddress: json.keys.first,
      active: json['active'],
      triggered: json['triggered'],
    );
  }

  ///Transforma um Json sem chave + a chave [macAddress] em um Device
  factory Device.fromJson2(Map json, String macAddress) {
    return Device(
      macAddress: macAddress,
      active: json['active'],
      triggered: json['triggered'],
    );
  }

  Map toJson() {
    return {
      macAddress: {
        'active': active,
        'triggered': triggered,
      }
    };
  }
}
