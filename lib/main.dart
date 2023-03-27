import 'package:bluetooth_flutter/feature/screen/bluetooth_on_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'feature/screen/bluetooth_off_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) return BluetoothOnScreen(state: state);
          return BluetoothOffScreen(state: state);
        },
      ),
    );
  }
}
