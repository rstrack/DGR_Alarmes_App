import 'dart:async';
import 'package:DGR_alarmes/services/firebase_messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:DGR_alarmes/controllers/device_controller.dart';
import 'package:DGR_alarmes/controllers/log_controller.dart';
import 'package:DGR_alarmes/controllers/user_device_controller.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/models/log.dart';
import 'package:DGR_alarmes/models/user_device.dart';

class DeviceNotifier extends ChangeNotifier {
  List<Log> logs = [];
  List<UserDevice> userDevices = [];
  String? macAddress;
  Device? device;
  bool isLoading = false;
  bool _isListening = true;
  StreamSubscription<DatabaseEvent>? _subscription;

  DeviceNotifier() {
    _init();
  }

  void _init() async {
    await listUserDevices();
    if (userDevices.isNotEmpty) {
      await setMacAddress(userDevices[0].idDevice);
      listenDevice();
      FirebaseMessagingService.instance.fcmTopicsConfig(userDevices);
    }
  }

  listUserDevices() async {
    isLoading = true;
    notifyListeners();
    userDevices = await UserDeviceController.instance.listUserDevices();
    isLoading = false;
    notifyListeners();
  }

  setMacAddress(String mac) async {
    isLoading = true;
    notifyListeners();
    macAddress = mac;
    device = await DeviceController.instance.getDevice(macAddress!);
    logs = await LogController.instance.getLogs(macAddress!, limit: 10);
    isLoading = false;
    notifyListeners();
  }

  updateDevice(String key, bool value) async {
    isLoading = true;
    notifyListeners();
    if (key == 'active') {
      device!.active = value;
    } else if (key == 'triggered') {
      device!.triggered = value;
    }
    isLoading = false;
    notifyListeners();
  }

  setListening(bool isListening) {
    _isListening = isListening;
  }

  listenDevice() {
    if (macAddress != null) {
      final ref = FirebaseDatabase.instance.ref();
      _subscription =
          ref.child('device/$macAddress').onChildChanged.listen((event) {
        if (event.snapshot.value != null && _isListening == true) {
          updateDevice(
              event.snapshot.key as String, event.snapshot.value as bool);
        }
      });
    }
  }

  Future<void> cancelListen() async {
    if (_subscription != null) {
      await _subscription!.cancel();
    }
    _subscription = null;
  }
}

final deviceProvider = ChangeNotifierProvider<DeviceNotifier>((ref) {
  return DeviceNotifier();
});
