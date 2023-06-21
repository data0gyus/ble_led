import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDevice {
  BluetoothDevice device;
  String name;
  String id;

  BleDevice({required this.device, required this.name, required this.id});

  factory BleDevice.fromScan(ScanResult result) {
    return BleDevice(
        device: result.device,
        name: result.device.name,
        id: result.device.id.id);
  }
}
