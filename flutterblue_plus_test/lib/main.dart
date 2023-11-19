import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:adobe_xd/pinned.dart';
import 'good.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  String connectionSubtitle = "Not Connected";

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
    connectionSubtitle = "Connected";
    // Once connected, you can perform operations on the device.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff87bcbf),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 20.0, end: 20.0),
            Pin(size: 300.0, middle: 0.3642),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 0.0, end: 60.5),
            Pin(size: 173.2, start: 0.0),
            child: SvgPicture.string(
              _svg_h8ttb4,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 60.5, end: 0.0),
            Pin(size: 173.2, end: 0.0),
            child: SvgPicture.string(
              _svg_ij9qp,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 256.0,
              height: 126.0,
              child: SvgPicture.string(
                _svg_qzg2bp,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 256.0,
              height: 126.0,
              child: SvgPicture.string(
                _svg_be7s69,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
          ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(devices[index].platformName),
                subtitle: Text(devices[index].remoteId.toString()),
                trailing: Text(connectionSubtitle),
              );
            },
          ),
          Pinned.fromPins(
              Pin(start: 100.5, end: 100.0), Pin(size: 50.2, end: 190.0),
              child: ElevatedButton(
                  child: const Text("CONNECT",
                      style: TextStyle(
                        color: Color(0xff87bcbf),
                      )),
                  onPressed: () {
                    connectToDevice(devices[0]);
                  })),
          // Pinned.fromPins(
          //     Pin(start: 100.5, end: 100.0), Pin(size: 50.2, end: 100.0),
          //     child: ElevatedButton(
          //         child: const Text("GET STUFF"),
          //         onPressed: () {
          //           readCharacteristic(
          //               devices[0],
          //               Guid.fromString(
          //                   "beb5483e-36e1-4688-b7f5-ea07361b26a8"));
          //         })),
          Pinned.fromPins(
              Pin(start: 100.5, end: 100.0), Pin(size: 50.2, end: 110.0),
              child: ElevatedButton(
                  child: const Text("START",
                      style: TextStyle(
                        color: Color(0xff87bcbf),
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoodRoute(devices[0])),
                    );
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

const String _svg_h8ttb4 =
    '<svg viewBox="0.0 0.0 351.5 173.2" ><path transform="translate(11.0, -16.74)" d="M -11 174.7945861816406 C -11 174.7945861816406 82.63148498535156 227.1515045166016 121.1583099365234 137.2556304931641 C 159.6851196289062 47.3597526550293 211.0541839599609 96.75308227539062 253.532470703125 86.87442016601562 C 296.0107727050781 76.99575805664062 340.4647827148438 16.73588562011719 340.4647827148438 16.73588562011719 L -11 16.73588562011719 L -11 174.7945861816406 Z" fill="#c3dddf" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ij9qp =
    '<svg viewBox="60.5 718.8 351.5 173.2" ><path transform="translate(71.54, 702.05)" d="M 340.4647827148438 31.894287109375 C 340.4647827148438 31.894287109375 246.8332977294922 -20.46263122558594 208.3064727783203 69.43324279785156 C 169.7796630859375 159.3291168212891 118.4105987548828 109.935791015625 75.93231201171875 119.814453125 C 33.45401000976562 129.693115234375 -11 189.9529876708984 -11 189.9529876708984 L 340.4647827148438 189.9529876708984 L 340.4647827148438 31.894287109375 Z" fill="#c3dddf" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_qzg2bp =
    '<svg viewBox="0.0 0.0 256.1 126.2" ><path transform="translate(11.0, -16.74)" d="M -11 131.9075927734375 C -11 131.9075927734375 57.22591400146484 170.0582122802734 85.29902648925781 104.5543060302734 C 113.3721389770508 39.05039978027344 150.8029327392578 75.04154968261719 181.7553405761719 67.84332275390625 C 212.7077484130859 60.64509201049805 245.0997924804688 16.73588562011719 245.0997924804688 16.73588562011719 L -11 16.73588562011719 L -11 131.9075927734375 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_be7s69 =
    '<svg viewBox="155.9 765.8 256.1 126.2" ><path transform="translate(166.9, 749.05)" d="M 245.0997924804688 27.78126525878906 C 245.0997924804688 27.78126525878906 176.8738708496094 -10.36935424804688 148.8007659912109 55.13455200195312 C 120.727653503418 120.6384582519531 83.29685974121094 84.64730834960938 52.34445190429688 91.84553527832031 C 21.39204406738281 99.04376220703125 -11 142.9529724121094 -11 142.9529724121094 L 245.0997924804688 142.9529724121094 L 245.0997924804688 27.78126525878906 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

void readCharacteristic(BluetoothDevice device, Guid characteristicId) async {
  List<BluetoothService> services = await device.discoverServices();
  for (BluetoothService service in services) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.uuid == characteristicId) {
        List<int> value = await characteristic.read();
        String valueInString = String.fromCharCodes(value);
        print(valueInString);
        List<String> stringParts = valueInString.split(',');
        stringParts.removeLast();
        List<double> floatList =
            stringParts.map((s) => double.parse(s)).toList();
        print(floatList);
        print(floatList.length);
      }
    }
  }
}
