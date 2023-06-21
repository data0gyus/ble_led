import 'package:bluetooth_led_app/src/controller/bluetooth_controller.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BluetoothController(), permanent: true);
  }
}
