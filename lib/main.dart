

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    //scanForDevices();
    check();
  }

  void check() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }
    else{
      print("supported device");
    }

    var subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });

// turn on bluetooth ourself if we can
// for iOS, the user controls bluetooth enable/disable
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

// cancel to prevent duplicate listeners
    subscription.cancel();
  }

  // void scanForDevices() async {
  //   // Check Bluetooth state
  //   if (!await FlutterBluePlus.instance.isOn) {
  //     await FlutterBluePlus.instance.turnOn();
  //   }
  //
  //   // Start scanning
  //   FlutterBluePlus.instance.scanForDevices(withServices: []).listen((device) {
  //     setState(() {
  //       devices.add(device);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Devices'),
        ),
        body: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(devices[index].name ?? 'Unknown Device'),
          ),
        ),
      ),
    );
  }
}

// import 'package:ble_scan/views/homePage.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
