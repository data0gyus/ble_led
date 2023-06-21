import 'package:bluetooth_led_app/src/model/device_model.dart';
import 'package:bluetooth_led_app/src/view/disconnect.dart';
import 'package:bluetooth_led_app/src/view/home.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;
  final _status = Rx<BluetoothState>(BluetoothState.unknown);
  final _bles = Rx<List<BleDevice>>([]);

  List<BleDevice> get bles => _bles.value;

  @override
  void onInit() {
    super.onInit();
    scan();
    _status.bindStream(flutterBluePlus.state);
    ever(_status, (_) => moveToPage());
  }

  void moveToPage() {
    if (_status.value != BluetoothState.on) {
      Get.off(() => const Disconnect());
    } else {
      Get.off(() => const Home());
    }
  }

  void scan() {
    print("scan");
    _bles.bindStream(getDevices());
  }

  Stream<List<BleDevice>> getDevices() {
    flutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    return flutterBluePlus.scanResults.map((results) {
      List<BleDevice> devices = [];
      for (ScanResult result in results) {
        final device = BleDevice.fromScan(result);
        devices.add(device);
      }
      return devices;
    });
  }
}
