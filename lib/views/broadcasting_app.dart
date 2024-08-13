import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';


void main() {
  runApp(BroadcastingApp());
}

class BroadcastingApp extends StatefulWidget {
  @override
  _BroadcastingAppState createState() => _BroadcastingAppState();
}

class _BroadcastingAppState extends State<BroadcastingApp> {
  final flutterBlePeripheral = FlutterBlePeripheral();
  final String serviceUuid =
      "12345678-1234-5678-1234-567812345678"; // Replace with your UUID

  @override
  void initState() {
    super.initState();
    startAdvertising();
  }

  void startAdvertising() {
    flutterBlePeripheral.start(
        advertiseData: AdvertiseData(
            includeDeviceName: true,
            includePowerLevel: true,
            serviceDataUuid: serviceUuid,
            manufacturerId: 1234,
            serviceUuid: serviceUuid,

        ));
  }

  @override
  void dispose() {
    flutterBlePeripheral.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Broadcasting App')),
        body: Center(
          child: Text('Broadcasting UUID: $serviceUuid'),
        ),
      ),
    );
  }
}
