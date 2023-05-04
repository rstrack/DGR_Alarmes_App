import 'dart:async';
import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController {
  BluetoothConnection? _bluetoothConnection;

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;

  StreamController<List<BluetoothDiscoveryResult>> _streamController =
      StreamController.broadcast();

  List<BluetoothDiscoveryResult> listScanResults = [];

  bool isConnected = false;

  // Instância do FlutterBlue
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;

  startScanForDevices() async {
    try {
      listScanResults.clear();

      // Inicia a busca por dispositivos
      _streamSubscription =
          flutterBluetoothSerial.startDiscovery().listen((event) {
        final existingIndex = listScanResults.indexWhere(
            (element) => element.device.address == event.device.address);
        if (existingIndex >= 0)
          listScanResults[existingIndex] = event;
        else
          listScanResults.add(event);
      });

      // Quando a descoberta Bluetooth terminar, envie a lista de resultados através do fluxo
      _streamSubscription?.onDone(() {
        _streamController.add(listScanResults);
        _streamController.close();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopScanForDevices() async {
    try {
      // Para a busca por dispositivos
      flutterBluetoothSerial.cancelDiscovery();
    } catch (e) {
      print(e);
    }
  }

  Stream<List<BluetoothDiscoveryResult>> get results =>
      _streamController.stream;

  Future<void> pairWithBluetoothDevice(String address) async {
    try {
      final bondState =
          await flutterBluetoothSerial.getBondStateForAddress(address);
      if (bondState == BluetoothBondState.none) {
        await flutterBluetoothSerial.bondDeviceAtAddress(address);
      }
      _bluetoothConnection = await BluetoothConnection.toAddress(address);
      isConnected = true;
    } catch (e) {
      isConnected = false;
      print(e);
    }
  }

  Future<void> sendWifiNetwork(String ssid, String password) async {
    try {
      // Envia a rede WiFi para o dispositivo ESP32
      final wifiNetwork = '$ssid\n$password';
      _bluetoothConnection!.output.add(ascii.encode(wifiNetwork));
      await _bluetoothConnection!.output.allSent;

      // Desconecta do dispositivo Bluetooth
      await _bluetoothConnection!.close();
      _bluetoothConnection = null;
    } catch (e) {
      print(e);
    }
  }
}
