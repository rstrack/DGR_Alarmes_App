import 'dart:async';
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
  bool isLoading = true;
  StreamSubscription<DatabaseEvent>? _subscription;

  DeviceNotifier() {
    _init();
  }

  void _init() async {
    await listDevices();
    if (userDevices.isNotEmpty) {
      await setMacAddress(userDevices[0].idDevice);
      listenDevice();
    }
  }

  listDevices() async {
    isLoading = true;
    notifyListeners();
    userDevices = await UserDeviceController.instance.listDevices();
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

  changeDeviceState() async {
    await DeviceController.instance.changeDeviceState(device!);
    notifyListeners();
  }

  disableBuzzer() async {
    isLoading = true;
    notifyListeners();
    await DeviceController.instance.disableBuzzer(device!);
    isLoading = false;
    notifyListeners();
  }

  listenDevice() {
    if (macAddress != null) {
      final ref = FirebaseDatabase.instance.ref();
      _subscription =
          ref.child('device/$macAddress').onChildChanged.listen((event) {
        if (event.snapshot.value != null) {
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
