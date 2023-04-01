import 'package:DGR_alarmes/models/log.dart';

class Device {
  late String macAddress;
  late bool active;
  late bool triggered;
  late Map<String, Log>? logs;

  Device({
    required this.macAddress,
    required this.active,
    required this.triggered,
    this.logs,
  });

  Device.empty() {
    macAddress = "";
    active = false;
    triggered = false;
    logs = {};
  }

  ///Transforma um Json com chave em um Device
  factory Device.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> logsJson = json['logs'];
    Map<String, Log> logs = {};
    logsJson.forEach((key, value) {
      logs[key] = Log.fromJson(value);
    });
    return Device(
      macAddress: json.keys.first,
      active: json['active'],
      logs: logs,
      triggered: json['triggered'],
    );
  }

  ///Transforma um Json sem chave + a chave [macAddress] em um Device
  factory Device.fromJson2(Map json, String macAddress) {
    Map<String, Log> logs = {};
    if (json.containsKey('logs')) {
      Map<String, dynamic> logsJson = json['logs'];
      logsJson.forEach((key, value) {
        logs[key] = Log.fromJson(value);
      });
    }
    return Device(
      macAddress: macAddress,
      active: json['active'],
      logs: logs,
      triggered: json['triggered'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> logsJson = {};
    logs?.forEach((key, value) {
      logsJson[key] = value.toJson();
    });
    return {
      macAddress: {
        'active': active,
        'logs': logsJson,
        'triggered': triggered,
      }
    };
  }
}
