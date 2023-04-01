import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  // String idLog;
  String device_idDevice;
  int time;
  String type;

  Log({
    // required this.idLog,
    required this.device_idDevice,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'idLog': idLog,
      'device_idDevice': device_idDevice,
      'time': time,
      'type': type,
    };
  }

  Log.fromMap(Map<String, dynamic> map)
      // : idLog = map['idLog'],
      :
        device_idDevice = map['device_idDevice'],
        time = map['time'],
        type = map['type'];

  // Obtendo um objeto Log a partir de um documento
static Future<Log?> getLogFromDocument(QueryDocumentSnapshot<Object?> document) async {
  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
  if (data == null) {
    return null;
  }
  Log _log = Log.fromMap(data);
  return _log;
}

@override
  String toString() {
    // TODO: implement toString
    return "Log | $device_idDevice | $time | ${DateTime.fromMillisecondsSinceEpoch(time*1000)} | $type";
  }

}
