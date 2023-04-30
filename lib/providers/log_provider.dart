import 'package:DGR_alarmes/controller/log_controller.dart';
import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:DGR_alarmes/providers/device_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:DGR_alarmes/models/log.dart';

final logProvider = FutureProvider.family<List<Log>, int>((ref, limit) async {
  final deviceNotifier = ref.watch(deviceProvider);
  final userStream = ref.watch(streamAuthProvider);
  final device = deviceNotifier.device;
  var user = userStream.value;
  if (device != null && user != null) {
    await Future.delayed(const Duration(seconds: 1));
    final response =
        await LogController.instance.getLogs(device.macAddress, limit: limit);
    return response;
  } else {
    return [];
  }
});
