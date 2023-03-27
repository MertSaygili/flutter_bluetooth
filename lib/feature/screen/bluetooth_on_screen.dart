import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothOnScreen extends StatefulWidget {
  const BluetoothOnScreen({super.key, this.state});
  final BluetoothState? state;

  @override
  State<BluetoothOnScreen> createState() => _BluetoothOnScreenState();
}

class _BluetoothOnScreenState extends State<BluetoothOnScreen> {
  late final FlutterBluePlus flutterBlue;
  final String _title = 'Bluetooth Connection Flutter';
  final String _turnOff = 'Turn Off';
  final String _searchNearbyDevices = 'Search Nearby Devices';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: Platform.isAndroid
                ? () async {
                    if (await Permission.bluetoothConnect.isGranted) {
                      FlutterBluePlus.instance.turnOff();
                    } else {
                      PermissionStatus permissionStatus = await Permission.bluetoothConnect.request();
                      if (permissionStatus == PermissionStatus.granted) {
                        FlutterBluePlus.instance.turnOff();
                      }
                    }
                  }
                : null,
            child: Text(_turnOff),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bluetooth_searching, size: 100),
            const SizedBox(height: 20),
            Text(_title),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                flutterBlue = FlutterBluePlus.instance;
                flutterBlue.connectedDevices.asStream().listen((paired) {
                  print('paired device: $paired');
                });

                var scanSubscription = flutterBlue.startScan(timeout: Duration(seconds: 20), scanMode: ScanMode.balanced);
                scanSubscription.asStream().listen((scanResult) {
                  print('scanResult: $scanResult');
                });
              },
              child: Text(_searchNearbyDevices),
            )
          ],
        ),
      ),
    );
  }
}
