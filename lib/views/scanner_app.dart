import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(ScanningApp());
}

class ScanningApp extends StatefulWidget {
  @override
  _ScanningAppState createState() => _ScanningAppState();
}

class _ScanningAppState extends State<ScanningApp> {
  //final flutterBlue = FlutterBluePlus.instance;
  final String serviceUuid = "12345678-1234-5678-1234-567812345678"; // Replace with your UUID
  final List<BluetoothDevice> _foundDevices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() {
    FlutterBluePlus.startScan(withServices: [Guid(serviceUuid)]);

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.advertisementData.serviceUuids.contains(serviceUuid)) {
          setState(() {
            _foundDevices.add(r.device);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Scanning App')),
        body: ListView.builder(
          itemCount: _foundDevices.length,
          itemBuilder: (context, index) {
            final device = _foundDevices[index];
            return ListTile(
              title: Text(device.name.isNotEmpty ? device.name : 'Unnamed Device'),
              subtitle: Text(device.id.toString()),
            );
          },
        ),
      ),
    );
  }
}
