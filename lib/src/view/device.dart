import 'dart:convert';

import 'package:bluetooth_led_app/src/model/device_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Device extends StatefulWidget {
  final BleDevice ble;
  const Device({super.key, required this.ble});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  bool isConnect = false;

  void connect() async {
    try {
      await widget.ble.device.connect();
      initLedStatus();
    } catch (e) {
      print("Error");
    }
  }

  void disconnect() {
    try {
      widget.ble.device.disconnect();
    } catch (e) {
      print('Error');
    }
  }

  Future<void> initLedStatus() async {
    List<int> result = [];

    return widget.ble.device.discoverServices().then((services) {
      for (var service in services) {
        if (service.uuid.toString() == '4fafc201-1fb5-459e-8fcc-c5c9c331914b') {
          var cs = service.characteristics;
          for (BluetoothCharacteristic c in cs) {
            c.read().then((value) => result = value);
          }
        }
      }
      if (String.fromCharCodes(result) == "1") {
        setState(() {
          isConnect = true;
        });
      } else {
        setState(() {
          isConnect = false;
        });
      }
    });
  }

  void sendData(String data) async {
    Guid serviceUuid = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
    Guid characteristicUuid = Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8");

    List<BluetoothService> services =
        await widget.ble.device.discoverServices();
    BluetoothService service =
        services.firstWhere((s) => s.uuid == serviceUuid);
    BluetoothCharacteristic characteristic =
        service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

    List<int> value = utf8.encode(data); //

    try {
      await characteristic.write(value);

      print("Data sent successfully");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ble.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _status(),
            _toggle(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  Widget _status() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        height: 300,
        child: CircleAvatar(
          backgroundColor: (isConnect) ? Colors.orange : Colors.white,
        ),
      ),
    );
  }

  Widget _toggle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoSwitch(
          value: isConnect,
          onChanged: (value) {
            if (value) {
              sendData("0");
            } else {
              sendData("1");
            }
            initLedStatus();
          }),
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: connect,
          child: const Text('Connect'),
        ),
        const SizedBox(
          width: 50,
        ),
        ElevatedButton(
          onPressed: disconnect,
          child: const Text('Disconnect'),
        ),
      ],
    );
  }
}
