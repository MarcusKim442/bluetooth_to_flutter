import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoodRoute extends StatefulWidget {
  const GoodRoute({Key? key}) : super(key: key);

  @override
  GoodRouteState createState() => GoodRouteState();
}

class GoodRouteState extends State<GoodRoute> {
  final TextEditingController _numberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberCtrl.text = "";
    loadModel();
  }

  Future<void> loadModel() async {
    final interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');
    var input = [
      0.358431004,
      0.289353311,
      -0.024218344,
      -0.684444689,
      -0.024218344,
      4,
      4,
      15,
      7,
      0.059910037,
      0.204313865,
      0.506367518,
      0.157496101,
      0.014414963,
      21,
      10,
      35,
      4
    ];

    var output = List<double>.filled(1, 0).reshape([1, 1]);

    // inference
    interpreter.run(input, output);

    // print outputs
    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xff9fcaad),
          // appBar: AppBar(
          //   title: const Text('Plugin example app'),
          // ),
          body: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 58.0, end: 58.0),
                Pin(size: 283.0, middle: 0.3957),
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
                alignment: Alignment(0.0, -0.291),
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
                      letterSpacing: 4,
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
                Pin(start: 40.0, end: 39.0),
                Pin(size: 319.0, middle: 0.3892),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    border:
                        Border.all(width: 10.0, color: const Color(0xffffffff)),
                  ),
                ),
              ),
              Pinned.fromPins(
                Pin(start: 40.0, end: 39.0),
                Pin(size: 319.0, middle: 0.3892),
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
                alignment: Alignment(0.0, -0.109),
                child: SizedBox(
                  width: 250.0,
                  height: 88.0,
                  child: Text(
                    'GOOD', // THIS PART CHANGE TO BAD!!!!
                    style: TextStyle(
                      fontFamily: 'Europa',
                      fontSize: 70,
                      color: const Color(
                          0xffffffff), // COLOUR WILL NEED TO BE CHANGED TOO
                      letterSpacing: 7,
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
                Pin(start: 100.5, end: 170.0),
                Pin(size: 173.2, end: 250.0),
                child: TextField(
                  controller: _numberCtrl,
                  decoration: const InputDecoration(
                      labelText: "Enter Primary Contact Phone Number"),
                  keyboardType: TextInputType.number,
                ),
              ),
              Pinned.fromPins(
                Pin(start: 100.5, end: 100.0),
                Pin(size: 50.2, end: 150.0),
                child: ElevatedButton(
                  child: const Text("Call Medical Services (911) TEMP:MODEL"),
                  onPressed: () async {
                    loadModel();
                  },
                ),
              ),
              Pinned.fromPins(
                Pin(start: 100.5, end: 100.0),
                Pin(size: 50.2, end: 250.0),
                child: ElevatedButton(
                  child: const Text("Call Primary Contact"),
                  onPressed: () async {
                    FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
