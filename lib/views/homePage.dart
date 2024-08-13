import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceScanner(),
    );
  }
}

class DeviceScanner extends StatefulWidget {
  @override
  _DeviceScannerState createState() => _DeviceScannerState();
}

class _DeviceScannerState extends State<DeviceScanner> {
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  final List<String> targetUuids = [
    "12345678-1234-5678-1234-567812345678",
    // Add more UUIDs if needed
  ];

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    if (!await FlutterBluePlus.isSupported) {
      print('Bluetooth is not supported');
      return;
    }

    FlutterBluePlus.adapterState.listen((state) {
      print('Bluetooth state: $state');
      if (state == BluetoothAdapterState.on) {
        startScan();
      } else {
        stopScan();
      }
    });
  }

  Future<void> startScan() async {
    if (!isScanning) {
      setState(() {
        isScanning = true;
        scanResults.clear();
      });

      try {
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 10),
        );
        FlutterBluePlus.scanResults.listen((results) {
          setState(() {
            scanResults = results;
          });

          // Log all scan results data
          results.forEach((result) {
            print('Device: ${result.device.platformName}');
            print('UUIDs: ${result.advertisementData.serviceUuids}');
            print('Manufacturer Data: ${result.advertisementData.manufacturerData}');
            print('Service Data: ${result.advertisementData.serviceData}');
          });
        });
      } catch (e) {
        print('Error starting scan: $e');
      }
    }
  }

  Future<void> stopScan() async {
    if (isScanning) {
      await FlutterBluePlus.stopScan();
      setState(() {
        isScanning = false;
      });
    }
  }

  bool containsTargetUuid(ScanResult result) {

    for (var uuid in result.advertisementData.serviceUuids) {
      if (targetUuids.contains(uuid)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Scanner'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => startScan(),
            child: Text('Start Scan'),
          ),
          ElevatedButton(
            onPressed: () => stopScan(),
            child: Text('Stop Scan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final result = scanResults[index];
                final device = result.device;
                final rssi = result.rssi;
                final isTargetDevice = containsTargetUuid(result);

                return ListTile(
                  title: Text(device.platformName.isNotEmpty ? device.platformName : 'Unnamed Device'),
                  subtitle: Text('UUIDs: ${result.advertisementData.serviceUuids.join(", ")}'),
                  trailing: Text(rssi.toString()),
                  tileColor: isTargetDevice ? Colors.green[100] : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
