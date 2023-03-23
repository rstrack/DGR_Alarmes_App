import 'package:cloud_firestore/cloud_firestore.dart';

class log {
  String idLog;
  String device_idDevice;
  DateTime time;
  String type;

  log({
    required this.idLog,
    required this.device_idDevice,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'idLog': idLog,
      'device_idDevice': device_idDevice,
      'time': time.toIso8601String(),
      'type': type,
    };
  }

  log.fromMap(Map<String, dynamic> map)
      : idLog = map['idLog'],
        device_idDevice = map['device_idDevice'],
        time = DateTime.parse(map['time']),
        type = map['type'];

  // Obtendo um objeto Log a partir de um documento
static Future<log?> getLogFromDocument(QueryDocumentSnapshot<Object?> document) async {
  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
  if (data == null) {
    return null;
  }
  log _log = log.fromMap(data);
  return _log;
}
}
