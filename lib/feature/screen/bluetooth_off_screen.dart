import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothOffScreen extends StatefulWidget {
  const BluetoothOffScreen({super.key, this.state});

  final BluetoothState? state;

  @override
  State<BluetoothOffScreen> createState() => _BluetoothOffScreenState();
}

class _BluetoothOffScreenState extends State<BluetoothOffScreen> {
  final String _title = 'Bluetooth Connection Flutter';

  final String _turnOn = 'Turn On';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title), centerTitle: false),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bluetooth_disabled, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text(_title),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: Platform.isAndroid
                  ? () async {
                      PermissionStatus permissionStatus = await Permission.bluetoothConnect.request();
                      if (permissionStatus == PermissionStatus.granted) {
                        await FlutterBluePlus.instance.turnOn();
                      }
                    }
                  : null,
              child: Text(_turnOn),
            )
          ],
        ),
      ),
    );
  }
}
