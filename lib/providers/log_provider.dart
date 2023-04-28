import 'package:DGR_alarmes/controller/log_controller.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:DGR_alarmes/models/log.dart';

final DatabaseReference _ref = FirebaseDatabase.instance.ref();

final logProvider = FutureProvider<List<Log>>((ref) async {
  final deviceNotifier = ref.watch(deviceProvider);
  final device = deviceNotifier.device;
  if (device != null) {
    await Future.delayed(const Duration(seconds: 1));
    final response =
        await LogController.instance.getLogs(device.macAddress, limit: 10);
    return response;
  } else {
    return [];
  }
});


  // Future<Log> getLogs(int type) async {
  //   DatabaseEvent event = await _ref.child('/log/$type').once();
  //   final data = event.snapshot.value as Map;
  //   device = Device.fromJson2(data, macAddress);
  //   return device;
  // }
