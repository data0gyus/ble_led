import 'package:bluetooth_led_app/src/controller/bluetooth_controller.dart';
import 'package:bluetooth_led_app/src/view/device.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends GetView<BluetoothController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('202316726 KimGyuSeok'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.scan,
        child: const Icon(Icons.search),
      ),
      body: Obx(
        () => (controller.bles.isEmpty)
            ? const Center(
                child: Text(
                  'bluetooth not find',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: controller.bles.length,
                itemBuilder: (context, index) {
                  final device = controller.bles[index];
                  return ListTile(
                    onTap: () {
                      Get.to(() => Device(ble: device));
                    },
                    title: Text(
                      (device.name == '') ? 'N/A' : device.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      device.id,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }),
      ),
    );
  }
}
