import 'package:DGR_alarmes/models/log.dart';
import 'package:firebase_database/firebase_database.dart';

class LogController {
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  ///recupera os 30 últimos logs e, se existir mais de 30 logs, exclui os mais antigos
  Future<List<Log>> getLogs(String macAddress, {int limit = 30}) async {
    DataSnapshot snapshot = await _ref
        .child('log/$macAddress')
        .orderByChild('time')
        .limitToLast(limit)
        .get();
    if (snapshot.value == null) return [];

    final data = snapshot.value as Map;

    if (data.length == 30) {
      //exclusão de logs excedentes
      DatabaseEvent surplusEvent = await _ref
          .child('log/$macAddress')
          .orderByChild('time')
          .endBefore(data.entries.first.value['time'] - 1,
              key: 'time') //endBefore está bugado, por isso o uso do -1
          .once();
      if (surplusEvent.snapshot.value != null) {
        (surplusEvent.snapshot.value as Map).forEach((key, value) async {
          await _ref.child('log/$macAddress/$key').remove();
        });
      }
    }
    List<Log> logs = [];
    data.forEach((key, value) {
      logs.add(Log.fromJson(value));
    });
    logs.sort((a, b) => b.time.compareTo(a.time));
    return logs;
  }

  static LogController instance = LogController();
}
