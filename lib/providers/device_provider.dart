import 'package:DGR_alarmes/controller/device_controller.dart';
import 'package:DGR_alarmes/controller/log_controller.dart';
import 'package:DGR_alarmes/controller/user_device_controller.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:DGR_alarmes/models/log.dart';
import 'package:flutter/material.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceNotifier extends ChangeNotifier {
  List<Log> logs = [];
  List<UserDevice> userDevices = [];
  String? device;

  DeviceNotifier() {
    _init();
  }

  void _init() async {
    await listDevices();
    if (userDevices.isNotEmpty) {
      getDevice(userDevices[0].idDevice);
    }
  }

  listDevices() async {
    userDevices = await UserDeviceController.instance.listDevices();
    notifyListeners();
  }

  getDevice(String macAddress) {
    device = macAddress;
    notifyListeners();
  }

  getLogs(String macAddress) async {
    List<Log> aux = await LogController.instance.getLogs(macAddress);
    if (aux.isNotEmpty) {
      logs = aux;
      notifyListeners();
    }
  }
}

final deviceProvider = ChangeNotifierProvider<DeviceNotifier>((ref) {
  return DeviceNotifier();
});
