import 'package:DGR_alarmes/models/log.dart';
import 'package:firebase_database/firebase_database.dart';

class LogController {
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  getLogs(String macAddress, {int limit = 10}) async {
    var event = await _ref
        .child('log/$macAddress')
        .orderByChild('time')
        .limitToLast(limit)
        .once();
    final data = event.snapshot.value;
    List<Log> logs = [];
    if (data != null) {
      (data as Map).forEach((key, value) {
        logs.add(Log.fromJson(value));
      });
      return logs;
    }
  }

  static LogController instance = LogController();
}
