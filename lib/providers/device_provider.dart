// ignore_for_file: prefer_final_fields, unused_local_variable

import 'package:DGR_alarmes/dao/device_dao.dart';
import 'package:DGR_alarmes/models/User.dart';
import 'package:DGR_alarmes/models/device.dart';
import 'package:flutter/foundation.dart';

class DeviceProvider extends ChangeNotifier {
  List<Device> _devices = [];
  DeviceDao _deviceDao = DeviceDao();

  Future<void> fetchDevices({UserModel? user}) async {
    _devices = await _deviceDao.loadDevices(user: user);
    notifyListeners();
  }

  Future<void> saveDevice(Device device) async {
    String key = await _deviceDao.saveDevice(device);
    device.macAddress = key; //usando macAdress para identificar
    _devices.add(device);
    notifyListeners();
  }

  Future<void> updateDevice(Device device) async {
    await _deviceDao.updateDevice(device.macAddress, device);
    var contains = _devices.indexWhere((element) =>
        element.macAddress ==
        device.macAddress); //verificar se retorna indice correto
    _devices[contains] = device;
    notifyListeners();
  }

  Future<void> deleteDevice(Device device) async {
    await _deviceDao.deleteDevice(device.macAddress);
    _devices.removeWhere((element) => element.macAddress == device.macAddress);
    notifyListeners();
  }
}
