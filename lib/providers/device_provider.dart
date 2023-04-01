import 'package:DGR_alarmes/controller/device_controller.dart';
import 'package:DGR_alarmes/controller/user_device_controller.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:flutter/material.dart';
import 'package:DGR_alarmes/models/user_device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceNotifier extends ChangeNotifier {
  List<UserDevice> userDevices = [];
  Device? device;

  DeviceNotifier() {
    _init();
  }

  //TENTAR FAZER UMA LÓGICA PARA DEIXAR O PRIMEIRO DISPOSITIVO DA LISTA SELECIONADO
  void _init() {
    listDevices().whenComplete(() {
      if (userDevices.isNotEmpty) {
        getDevice(userDevices[0].idDevice);
      }
    });
  }

  Future listDevices() async {
    UserDeviceController.instance.listDevices().then((response) {
      userDevices = response;
      notifyListeners();
    });
  }

  getDevice(String macAddress) {
    try {
      DeviceController.instance.getDevice(macAddress).then((response) {
        device = response;
        notifyListeners();
      });
    } catch (e) {
      print('ERRO: $e');
    }
  }
}

final deviceProvider = ChangeNotifierProvider<DeviceNotifier>((ref) {
  return DeviceNotifier();
});
