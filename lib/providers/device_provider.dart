import 'package:DGR_alarmes/controller/device_controller.dart';
import 'package:DGR_alarmes/controller/log_controller.dart';
import 'package:DGR_alarmes/controller/user_device_controller.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/models/log.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceNotifier extends ChangeNotifier {
  List<Log> logs = [];
  List<UserDevice> userDevices = [];
  String? macAddress;
  Device? device;

  DeviceNotifier() {
    _init();
  }

  void _init() async {
    await listDevices();
    if (userDevices.isNotEmpty) {
      getMacAddress(userDevices[0].idDevice);
    }
    device = await DeviceController.instance.getDevice(macAddress!);
    notifyListeners();
  }

  listDevices() async {
    userDevices = await UserDeviceController.instance.listDevices();
    notifyListeners();
  }

  getMacAddress(String mac) {
    macAddress = mac;
    notifyListeners();
  }

  setDevice(Device newDevice) {
    device = newDevice;
    notifyListeners();
  }

  updateDevice(String key, bool value) {
    if (key == 'active') {
      device!.active = value;
    } else if (key == 'triggered') {
      device!.triggered = value;
    }
    notifyListeners();
  }

  changeDeviceState() async {
    await DeviceController.instance.changeDeviceState(device!);
    notifyListeners();
  }

  getLogs(String macAddress) async {
    List<Log> aux = await LogController.instance.getLogs(macAddress);
    if (aux.isNotEmpty) {
      logs = aux;
      notifyListeners();
    }
  }

  listenDevice() {
    if (macAddress != null) {
      final ref = FirebaseDatabase.instance.ref();
      ref.child('device/$macAddress').onChildChanged.listen((event) {
        if (event.snapshot.value != null) {
          updateDevice(
              event.snapshot.key as String, event.snapshot.value as bool);
        }
      });
    }
  }
}

final deviceProvider = ChangeNotifierProvider<DeviceNotifier>((ref) {
  return DeviceNotifier();
});
