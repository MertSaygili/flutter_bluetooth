// ignore_for_file: argument_type_not_assignable_to_error_handler, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothNearbyDevices extends StatefulWidget {
  const BluetoothNearbyDevices({super.key});

  @override
  State<BluetoothNearbyDevices> createState() => _BluetoothNearbyDevicesState();
}

class _BluetoothNearbyDevicesState extends State<BluetoothNearbyDevices> {
  final FlutterBluetoothSerial flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  final FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
  String data = '';

  @override
  void initState() {
    super.initState();
    _check();
    getBluetoothDevices();

    // x();
    // requestAccess();
  }

  void getBluetoothDevices() async {
    List<dynamic> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    print('ssssssssssssssssssssssssssssssssssssssssssss');
    print(devices[0].name);
    print('ssssssssssssssssssssssssssssssssssssssssssss');
  }

  void _check() async {
    // returns true/false asynchronously.
    bool a = await Nearby().checkLocationPermission();
    // asks for permission only if its not given
    // returns true/false if the location permission is granted on/off resp.
    bool b = await Nearby().askLocationPermission();

    // // OPTIONAL: if you need to transfer files and rename it on device
    // bool c = await Nearby().checkExternalStoragePermission();
    // // asks for READ + WRTIE EXTERNAL STORAGE permission only if its not given
    // Nearby().askExternalStoragePermission();

    // Nearby().askLocationAndExternalStoragePermission(); // for all permissions in one go..

    // For bluetooth permissions on Android 12+.

    bool d = await Nearby().checkBluetoothPermission();
    // asks for BLUETOOTH_ADVERTISE, BLUETOOTH_CONNECT, BLUETOOTH_SCAN permissions.
    Nearby().askBluetoothPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("checkLocationPermission"),
              onPressed: () async {
                if (await Nearby().checkLocationPermission()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permissions granted :)")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permissions not granted :(")));
                }
              },
            ),
            ElevatedButton(
              child: const Text("checkBluetoothPermission"),
              onPressed: () async {
                if (await Nearby().checkBluetoothPermission()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bluetooth permissions granted :)")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bluetooth permissions not granted :(")));
                }
              },
            ),
            ElevatedButton(
              child: const Text("Start Discovery"),
              onPressed: () async {
                // Some simplest connection :F
                // Start scanning
                // var tmp = <String, dynamic>{};
                // String data = '';

                // bluetoothScan okey
                // bluetoothAdvertise okey
                // bluetoothConnect okey
                // location okey

                try {
                  bool a = await Nearby().startDiscovery(
                    'userName',
                    Strategy.P2P_STAR,
                    onEndpointFound: (String id, String userName, String serviceId) {
                      print(id);
                      // called when an advertiser is found
                    },
                    onEndpointLost: (String? id) {
                      //called when an advertiser is lost (only if we weren't connected to it )
                    },
                    serviceId: "com.yourdomain.appname", // uniquely identifies your app
                  );
                  Nearby().stopDiscovery();
                } catch (e) {
                  // platform exceptions like unable to start bluetooth or insufficient permissions
                }
                // await Permission.bluetoothAdvertise.request();

                // if (await Permission.bluetooth.isGranted) {
                //   print('yes anam');
                // }

                // await _bluetooth.startScan(pairedDevices: false);

                // _bluetooth.devices.listen(
                //   (device) {
                //     print('ssss');
                //     print('${device.name} (${device.address})');

                //     setState(() {
                //       data += '${device.name} (${device.address})\n';
                //     });
                //   },
                // );

                // Listen to scan results

                // // bagli olduklarini gosteriyor
                // flutterBluetoothSerial.startDiscovery().listen((r) {
                //   tmp.putIfAbsent(r.device.address, () => r.device);
                // }).onDone(() {
                //   print('sssss');
                //   for (dynamic item in tmp.values) {
                //     print(item.name);
                //   }
                //   // print(tmp);
                // });

                // bool? result = await flutterBluetoothSerial.isEnabled; // Check if Bluetooth
                // print(result);

                // List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
                // print(devices);

                // try {
                //   flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
                //     print('s');
                //     print(device);
                //     //code for handling results
                //   }, onError: () {
                //     //code for handling error
                //   });
                // } catch (exception) {
                //   print(exception);
                //   print('Cannot connect, exception occured');
                // }
              },
            ),
            ElevatedButton(
              child: const Text("Stop Discovery"),
              onPressed: () async {
                await _bluetooth.stopScan();
                // Some simplest connection :F
                try {} catch (exception) {
                  print('Cannot connect, exception occured');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                    child: const Text('Check permissions'),
                    onPressed: () async {
                      try {
                        Nearby().stopDiscovery();
                        await _bluetooth.requestPermissions();
                        print('All good with perms');
                      } on Exception catch (e) {
                        print(e);
                        // debugPrint(e.toString());
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
