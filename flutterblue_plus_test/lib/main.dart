import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:adobe_xd/pinned.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BleScanner(),
    );
  }
}

class BleScanner extends StatefulWidget {
  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  // FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() async {
    await FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          setState(() {
            if (result.device.platformName == "ESPtest") {
              devices.add(result.device);
            }
          });
        }
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    // Once connected, you can perform operations on the device.
  }

  void readCharacteristic(BluetoothDevice device, Guid characteristicId) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          List<int> value = await characteristic.read();
          print('Read value: $value');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(devices[index].platformName),
                subtitle: Text(devices[index].remoteId.toString()),
              );
            },
          ),
          Pinned.fromPins(
              Pin(start: 100.5, end: 100.0), Pin(size: 50.2, end: 190.0),
              child: ElevatedButton(
                  child: const Text("CONNECT"),
                  onPressed: () {
                    connectToDevice(devices[0]);
                  })),
          Pinned.fromPins(
              Pin(start: 100.5, end: 100.0), Pin(size: 50.2, end: 100.0),
              child: ElevatedButton(
                  child: const Text("GET STUFF"),
                  onPressed: () {
                    readCharacteristic(
                        devices[0],
                        Guid.fromString(
                            "beb5483e-36e1-4688-b7f5-ea07361b26a8"));
                  })),
        ],
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
