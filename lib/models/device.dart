import 'package:DGR_alarmes/models/log.dart';

class Device {
  String macAddress;
  bool active;
  bool triggered;
  Map<String, Log> logs;

  Device({
    required this.macAddress,
    required this.active,
    required this.triggered,
    required this.logs,
  });

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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> logsJson = {};
    logs.forEach((key, value) {
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
