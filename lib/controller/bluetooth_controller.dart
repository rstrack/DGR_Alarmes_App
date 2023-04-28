import 'package:flutter_blue/flutter_blue.dart';

class BluetoothController {
  // Instância do FlutterBlue
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // Método para iniciar a busca por dispositivos Bluetooth
  Future<void> startScanForDevices() async {
    try {
      // Verifica se o Bluetooth está ligado
      if (!await flutterBlue.isOn) {
        throw Exception('Bluetooth está desligado');
      }

      // Inicia a busca por dispositivos
      await flutterBlue.startScan(timeout: Duration(seconds: 5), scanMode: ScanMode.balanced);

      flutterBlue.stopScan();

    } catch (e) {
      print(e);
    }
  }

  Stream<List<ScanResult>> get listScanResults => flutterBlue.scanResults; 
}
