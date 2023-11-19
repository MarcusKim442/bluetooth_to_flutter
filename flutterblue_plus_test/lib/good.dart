import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'main.dart';

class GoodRoute extends StatefulWidget {
  // const GoodRoute({Key? key}) : super(key: key);

  final BluetoothDevice device;
  GoodRoute(this.device);

  @override
  GoodRouteState createState() => GoodRouteState();
}

class GoodRouteState extends State<GoodRoute> {
  final TextEditingController _numberCtrl = TextEditingController();
  late Timer timer;
  late List<charts.Series<DataPoint, int>> seriesList;
  List<double> datapoints = [];
  int currentDatapoint = 0;

  Color currentColor = const Color(0xff9fcaad);
  String currentText = "GOOD";
  String currentTextChange = "Test Database Input";

  @override
  void initState() {
    super.initState();
    _numberCtrl.text = "";
    // loadModel();
    // datapoints = List<int>.generate(10000, (index) => Random().nextInt(100));

    seriesList = _createRandomData();
    timer = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      setState(() {
        seriesList = _createRandomData();
      });
    });
  }

  void changeColor() {
    setState(() {
      if (currentColor == const Color(0xff9fcaad)) {
        currentColor = Color.fromARGB(255, 240, 77, 77);
        currentText = "!!!";
      } else {
        currentColor = const Color(0xff9fcaad);
        currentText = "GOOD";
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // This is just a sample, replace this with your real data.
  List<charts.Series<DataPoint, int>> _createRandomData() {
    readCharacteristicChart(
        widget.device, Guid.fromString("beb5483e-36e1-4688-b7f5-ea07361b26a8"));

    List<double> data_new;
    if (datapoints.length >= 100) {
      data_new = datapoints.sublist(
          currentDatapoint, min(currentDatapoint + 100, datapoints.length));
      currentDatapoint += 1;
    } else {
      data_new = datapoints;
    }

    List<DataPoint> data = data_new.asMap().entries.map<DataPoint>((entry) {
      return DataPoint(entry.key, entry.value);
    }).toList();

    charts.Color white = const charts.Color(r: 255, g: 255, b: 255, a: 255);
    return [
      charts.Series<DataPoint, int>(
        id: 'Sales',
        // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        colorFn: (_, __) => white,
        domainFn: (DataPoint point, _) => point.time,
        measureFn: (DataPoint point, _) => point.value,
        data: data,
      )
    ];
  }

  Future<void> loadModel() async {
    final interpreter =
        await tfl.Interpreter.fromAsset('assets/model_balance_10.tflite');
    var input = [
      98,
      218,
      0.260487361,
      0.271969804,
      -0.101701695,
      -0.798689053,
      -0.101701695,
      4,
      4,
      15,
      7,
      98,
      218,
      0.051481441,
      0.200012086,
      0.608085177,
      0.150409439,
      0.004200646,
      20,
      6,
      29,
      3
    ];

    var output = List<double>.filled(1, 0).reshape([1, 1]);

    // inference
    interpreter.run(input, output);

    // print outputs
    var conf = output[0][0];
    String out = "Model Output: " + conf.toString().substring(0, 5);
    setState(() {
      currentTextChange = out;
    });
    if (conf > 0.5) {
      changeColor();
    }
  }

  void readCharacteristicChart(
      BluetoothDevice device, Guid characteristicId) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          List<int> value = await characteristic.read();
          String valueInString = String.fromCharCodes(value);
          // print(valueInString);
          List<String> stringParts = valueInString.split(',');
          stringParts.removeLast();
          List<double> floatList =
              stringParts.map((s) => double.parse(s)).toList();
          // print(floatList);
          // print(floatList.length);
          add_to_data(floatList[0]);
        }
      }
    }
  }

  void add_to_data(double val) {
    datapoints.add(val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: currentColor,
          // appBar: AppBar(
          //   title: const Text('Plugin example app'),
          // ),
          body: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 60.0, end: 60.0),
                Pin(size: 233.0, middle: 0.1292),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.elliptical(9999.0, 9999.0)),
                    border:
                        Border.all(width: 5.0, color: const Color(0xffffffff)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, -0.671),
                child: SizedBox(
                  width: 250.0,
                  height: 51.0,
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      fontFamily: 'Europa',
                      fontSize: 40,
                      color: const Color(
                          0xffffffff), // COLOUR WILL NEED TO BE CHANGED
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                      height: 1.75,
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),
              ),
              Pinned.fromPins(
                Pin(start: 40.0, end: 40.0),
                Pin(size: 280.0, middle: 0.0892),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    border:
                        Border.all(width: 10.0, color: const Color(0xffffffff)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, -0.529),
                child: SizedBox(
                  width: 250.0,
                  height: 88.0,
                  child: Text(
                    currentText, // THIS PART CHANGE TO BAD!!!!
                    style: TextStyle(
                      fontFamily: 'Europa',
                      fontSize: 70,
                      color: const Color(
                          0xffffffff), // COLOUR WILL NEED TO BE CHANGED TOO
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                      height: 1.7571428571428571,
                      shadows: [
                        Shadow(
                          color: const Color(0x29f6f0f0),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),
              ),
              Pinned.fromPins(
                Pin(start: 70.5, end: 70.0),
                Pin(size: 80.2, end: 170.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _numberCtrl,
                  decoration: const InputDecoration(
                      hintText: "ENTER PRIMARY PHONE #",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                      prefixIconColor: Colors.white),
                  keyboardType: TextInputType.number,
                ),
              ),
              Pinned.fromPins(
                Pin(startFraction: 0.15, endFraction: 0.15),
                Pin(size: 40.2, end: 60.0),
                child: ElevatedButton(
                  child: Text("CALL MEDICAL SERVICES",
                      style: TextStyle(
                          height: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xff9fcaad))),
                          color: currentColor)),
                  // onPressed: () async {
                  //   loadModel();
                  // },
                  onPressed: () async {
                    FlutterPhoneDirectCaller.callNumber("7802670726");
                  },
                ),
              ),
              Pinned.fromPins(
                Pin(startFraction: 0.15, endFraction: 0.15),
                Pin(size: 40.2, end: 130.0),
                child: ElevatedButton(
                  child: Text("CALL PRIMARY CONTACT",
                      style: TextStyle(
                          height: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: currentColor)),
                  onPressed: () async {
                    FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
                  },
                ),
              ),
              Pinned.fromPins(
                Pin(start: 60.5, end: 50.0),
                Pin(size: 20.2, end: 5.0),
                child: ElevatedButton(
                  child: Text(currentTextChange),
                  onPressed: () async {
                    loadModel();
                  },
                ),
              ),
              Pinned.fromPins(
                  Pin(start: 20.5, end: 20.0), Pin(size: 150.2, end: 255.0),
                  child: charts.LineChart(seriesList, animate: false))
            ],
          )),
    );
  }
}

class DataPoint {
  final int time;
  final double value;

  DataPoint(this.time, this.value);
}
