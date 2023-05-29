import 'dart:ffi';
import 'dart:math';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tongue_cmu_bluetooth/constant.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tongue_cmu_bluetooth/global-variable.dart' as globals;
import 'package:tongue_cmu_bluetooth/db/tongue_database.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:tongue_cmu_bluetooth/model/tongueTest.dart';
import 'package:tongue_cmu_bluetooth/model/tongueTest2.dart';
class TestScreen extends StatelessWidget {
  final User user = globals.user;
  TestScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new WillPopScope (
      onWillPop: () async => false,
      child:Scaffold(
          appBar: AppBar(backgroundColor: mPrimaryColor,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                      onTap: () {},
                      child:
                      Text("ชื่อ: "+ user.name +" "+ user.surname,style: TextStyle(fontSize: 18),)
                  )
              )
            ],),
          body: TestField()
      )
    );
  }
}

class TestField extends StatelessWidget {
  const TestField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Container(
            child:Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: globals.pageNotifier,
                  builder: (context, value, widget) {
                    return SelectTest();
                  },
                ),
            ValueListenableBuilder(
              valueListenable: globals.pageNotifier,
              builder: (context, value, widget) {
                return TestHeader();
              },
            ),
                SizedBox(height: 30),
                MeasureField()
              ],
            )
        )
    );
  }
}
class SelectTest extends StatelessWidget {
  const SelectTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (globals.indexTest == 1){
      return
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //
        //       ElevatedButton(
        //       style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
        //   ),
        //   onPressed: () {
        //   globals.indexTest = 2;
        //   globals.pageNotifier.value = !globals.pageNotifier.value;
        //   },
        //   child:
        //   Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SvgPicture.asset('assets/images/stopwatch-solid.svg',fit: BoxFit.cover,color: mFourthColor,height: 20,
        //         ),
        //   SizedBox(width: 10),
        //   Text("วัดความทนทาน",style: TextStyle(color: Colors.white , fontSize: 15)),
        //   ],
        //
        //   )
        //
        //   ),
        // ],);
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(width: 30,),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                ),
                onPressed: () {
                  globals.indexTest = 2;
                  globals.isfinishCountdown = false;
                  globals.pageNotifier.value = !globals.pageNotifier.value;
                },
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/stopwatch-solid.svg',fit: BoxFit.cover,color: mFourthColor,height: 20,
                    ),
                    SizedBox(width: 10),
                    Text("วัดความทนทาน",style: TextStyle(color: Colors.white , fontSize: 15)),
                  ],)

            )
          ],
        );
    }
    else if (globals.indexTest == 2){
      return
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //
        //     ElevatedButton(
        //       style: ButtonStyle(
        //         backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
        //       ),
        //       onPressed: () {
        //         globals.indexTest = 1;
        //         globals.pageNotifier.value = !globals.pageNotifier.value;
        //       },
        //       child:
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           Text("วัดความแข็งแรง",style: TextStyle(color: Colors.white , fontSize: 15)),
        //         ],)
        //
        //   )],
        // );
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(width: 30,),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                ),
                onPressed: () {
                  globals.indexTest = 1;
                  globals.isfinishCountdown = false;
                  globals.pageNotifier.value = !globals.pageNotifier.value;
                },
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/chart-bar-solid.svg',fit: BoxFit.cover,color: mFourthColor,height: 20,
                    ),
                    SizedBox(width: 10),
                    Text("วัดความแข็งแรง",style: TextStyle(color: Colors.white , fontSize: 15)),
                  ],)

            )
          ],
        );

    }
    else{
      return
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: []
        );

    }

  }
}

class TestHeader extends StatelessWidget {
  const TestHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    if (globals.indexTest == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/cog-solid.svg',fit: BoxFit.cover, // this is the solution for border
              width: 40),
          SizedBox(width: 30),
          Flexible(child: Text("สอบเทียบ",style: TextStyle(color: mPrimaryColor , fontSize: 40)))
        ],
      );
    }
    else if (globals.indexTest == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SvgPicture.asset('assets/images/chart-bar-solid.svg',fit: BoxFit.cover, // this is the solution for border
              width: 40),
          SizedBox(width: 30),
          Flexible(child: Text("วัดความแข็งแรง",style: TextStyle(color: mPrimaryColor , fontSize: 30)))
        ],
      );
    }
    else  {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/stopwatch-solid.svg',fit: BoxFit.cover, // this is the solution for border
              width: 40),
          SizedBox(width: 30),
          Flexible(child: Text("วัดความทนทาน",style: TextStyle(color: mPrimaryColor , fontSize: 28)))
        ],
      );
    }
  }
}


class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}
class MeasureField extends StatefulWidget {

  final BluetoothDevice server = globals.selectedDevice;
  @override
  _MeasureFieldState createState() => _MeasureFieldState();
}

class _MeasureFieldState extends State<MeasureField> {
  bool isStartMeasure = true; //always start when start this page

  static final clientID = 0;
  BluetoothConnection? connection;
  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  String stringMessage = "";
  double newton = 0.0;
  double pressure = 0.0;
  double endPressure= 0.0;
  double endNewton = 0.0;
  bool changeToTimer = false;
  late Timer _timer ;
  // late bool isFinish = false;
  late List<double> listNewton = List<double>.empty(growable: true);
  late List<double> listPressure = List<double>.empty(growable: true);
  double maxNewton  = 0.0;
  double maxPressure = 0.0;
  int _start = 3;
  int countTime = 0;
  double setNewton = 0.0;
  double setPressure = 0.0;
  bool canStart = false;
  int countdown = 2;
  int countdown_2 = 2;
  ValueNotifier indexPage = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();

    connectDevice();
  }
  void connectDevice() async{
    await EasyLoading.show();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
    await EasyLoading.dismiss();
  }
  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    _timer.cancel();
    super.dispose();
  }
  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    // print(dataString);
    int index = buffer.indexOf(13);
    if (~index != 0) {

      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ?
            _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );

        if(backspacesCounter>0){
          stringMessage = _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter);
        }
        else{
          stringMessage = _messageBuffer + dataString.substring(0, index);
        }

        if(stringMessage.length<50){
          // print(stringMessage);
          try{
            newton = double.parse(stringMessage.substring(11,15));
            pressure = double.parse(stringMessage.substring(30,34));

          }
          catch(e){
            newton = newton;
            pressure = pressure;
          }
          // print(newton);
          // print(pressure);
        }


        _messageBuffer = dataString.substring(index);

      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }

    // print(messages.map((_message) =>
    // _message.text.trim()));


  }
  Future createTest_2() async{
    final tongueTest = TongueTest(userId: globals.user.id, time: DateTime.now(), type: "ความแข็งแกร่ง", newton: maxNewton, kiloPascal: maxPressure);
    await TongueDatabase.instance.addTest(tongueTest);
    return tongueTest;
  }
  Future createTest_3() async{
    final tongueTest2 = TongueTest2(userId: globals.user.id, time: DateTime.now(), type: "ความทนทาน", setNewton: setNewton, setKiloPascal: setPressure,duration: _start );
    await TongueDatabase.instance.addTest2(tongueTest2);
    return tongueTest2;
  }

  void startTimer_3() {

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {

        if (newton < maxNewton || pressure < maxPressure) {
          setState(() {
            timer.cancel();
            isStartMeasure = false;
            createTest_3();
          });
          globals.changeToText = false;
          // globals.canChangeToButton = true;
        } else {
          setState(() {
            isStartMeasure = true;
            _start++;
          });
        }
        print("timer start");
      },
    );
  }

  void startCountDown() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (countdown == 0) {
          setState(() {
            globals.isfinishCountdown = true;
            timer.cancel();
          });
        } else {
          setState(() {
            countdown--;
          });
        }
      },
    );
  }
  void startCountDown_2() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (countdown_2 == 0) {
          setState(() {
            globals.isfinishCountdown = true;
            timer.cancel();
          });
        } else {
          setState(() {
            countdown_2--;
          });
        }
      },
    );
  }
  void startTimer_2() {


    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            maxNewton = listNewton.reduce(max);
            maxPressure = listPressure.reduce(max);
            isStartMeasure = false;

            createTest_2();

          });
          globals.changeToText = false;
        } else {
          setState(() {
            isStartMeasure = true;
            listNewton.add(newton);
            listPressure.add(pressure);
            _start--;
          });
        }
      },
    );
  }
  Widget getTest(){
    if (globals.indexTest == 0){
      return Column(
        children: [

          Container(
              height: 300,
              width: 300,
              child: SfRadialGauge(
                axes: <RadialAxis>[

                  RadialAxis(minimum: 0.00,maximum: 15,
                    axisLabelStyle: GaugeTextStyle(fontSize: 20),
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0.00, endValue: 15,color: Colors.grey)
                    ],
                    pointers: <GaugePointer>[
                      isStartMeasure ?
                      NeedlePointer(value:newton,enableAnimation: true):
                      NeedlePointer(value:endNewton),
                      isStartMeasure ?
                      RangePointer(value: newton,enableAnimation: true):
                      RangePointer(value: endNewton)
                    ],
                  )
                ],
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: mPrimaryColor,width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                child: !isStartMeasure? Text(endNewton.toString(),style: TextStyle(color: mPrimaryColor , fontSize: 25)):
                Text(newton.toString(),style: TextStyle(color: mPrimaryColor , fontSize: 25)),
              ),
              Text("นิวตัน",style: TextStyle(color: mPrimaryColor , fontSize: 25))
            ],
          ),

        ],
      );
    }
    else if (globals.indexTest == 1){
      return Column(
          children: [
            Container(
                height: 300,
                width: 300,
                child: SfRadialGauge(
                  axes: <RadialAxis>[

                    RadialAxis(minimum: 0.00,maximum: 15,
                      axisLabelStyle: GaugeTextStyle(fontSize: 20),
                      axisLineStyle: AxisLineStyle(thickness: 0.15,
                          thicknessUnit: GaugeSizeUnit.factor),
                      ranges: <GaugeRange>[
                        GaugeRange(startValue: 0.00, endValue: 0,color: Colors.grey)
                      ],
                      pointers: <GaugePointer>[

                        isStartMeasure ?
                        NeedlePointer(value:newton,enableAnimation: true,needleColor: mSecondaryColor,knobStyle: KnobStyle(knobRadius: 10,
                            sizeUnit: GaugeSizeUnit.logicalPixel, color: mSecondaryColor)):
                        NeedlePointer(value:endNewton,needleColor: mSecondaryColor,knobStyle: KnobStyle(knobRadius: 10,
                            sizeUnit: GaugeSizeUnit.logicalPixel, color: mSecondaryColor)),
                      ],
                    ),

                  ],
                )
            ),
            Row(
                children:[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(

                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: mPrimaryColor,width: 3),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Text(maxNewton.toString(),style: TextStyle(color: mPrimaryColor , fontSize: 25)),
                      ),
                      Text("นิวตัน",style: TextStyle(color: mPrimaryColor , fontSize: 20))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: mPrimaryColor,width: 3),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Text(maxPressure.toString(),style: TextStyle(color: mPrimaryColor , fontSize: 25)),
                      ),
                      Text("กิโลปาสคาล",style: TextStyle(color: mPrimaryColor , fontSize: 20)),

                    ],
                  ),]
            ),

            Row(
              children: [
                Text("ตั้งเวลา",style: TextStyle(color: mPrimaryColor , fontSize: 30)),
                Flexible(
                    child:TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {

                          countTime = int.parse(val);
                        });
                      },
                      // The validator receives the text that the user has entered.
                      decoration: InputDecoration(
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    )
                ),
                Text("วินาที",style: TextStyle(color: mPrimaryColor , fontSize: 30))
              ],
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0,13,0,0),
                constraints: BoxConstraints.tightFor(width: 250, height: 70),
                child:
                globals.changeToText ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !globals.isfinishCountdown ?

                    Text("กำลังเริ่มใน",style: TextStyle(color: mPrimaryColor , fontSize: 25)):
                    Text("เหลือเวลา",style: TextStyle(color: mSecondaryColor , fontSize: 25)),
                    SizedBox(width: 15),
                    !globals.isfinishCountdown ?
                    Text(countdown.toString(),style: TextStyle(color: mPrimaryColor , fontSize: 30)):
                    Text(_start.toString(),style: TextStyle(color: mSecondaryColor , fontSize: 30)),
                    SizedBox(width: 15),
                    !globals.isfinishCountdown ?
                    Text("วินาที",style: TextStyle(color: mPrimaryColor , fontSize: 25)):
                    Text("วินาที",style: TextStyle(color: mSecondaryColor , fontSize: 25))

                  ],

                  // children: [
                  //   Text("เหลือเวลา",style: TextStyle(color: mSecondaryColor , fontSize: 25)),
                  //   SizedBox(width: 15),
                  //   Text(_start.toString(),style: TextStyle(color: mSecondaryColor , fontSize: 30)),
                  //   SizedBox(width: 15),
                  //   Text("วินาที",style: TextStyle(color: mSecondaryColor , fontSize: 25))
                  // ],
                ):
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      )
                  ),
                  onPressed: () {
                    setState(() {
                      maxNewton = 0;
                      maxPressure = 0;
                      globals.changeToText = true;
                      globals.isfinishCountdown = false;

                      countdown = 2;
                      startCountDown();
                      _start = countTime+countdown+1;
                      startTimer_2();

                      // startingMeasure(newton);
                    });

                  },
                  child:
                  Text("เริ่มต้น",style: TextStyle(color: Colors.white , fontSize: 25)),
                )
            )

          ]
      );
    }
    else if (globals.indexTest == 2){
      return Column(
          children: [
            Container(
                height: 300,
                width: 300,
                child: SfRadialGauge(

                  axes: <RadialAxis>[

                    RadialAxis(minimum: 0.00,maximum: 15,
                      axisLabelStyle: GaugeTextStyle(fontSize: 20),
                      ranges: <GaugeRange>[
                        GaugeRange(startValue: setNewton, endValue: 15,color: mPrimaryColor)
                      ],
                      pointers: <GaugePointer>[
                        RangePointer(value: setNewton,color:Colors.grey),
                        isStartMeasure ?

                        NeedlePointer(value:newton,enableAnimation: true,needleColor: mSecondaryColor,knobStyle: KnobStyle(knobRadius: 10,
                            sizeUnit: GaugeSizeUnit.logicalPixel, color: mSecondaryColor)):
                        NeedlePointer(value:0,needleColor: mSecondaryColor,knobStyle: KnobStyle(knobRadius: 10,
                            sizeUnit: GaugeSizeUnit.logicalPixel, color: mSecondaryColor)),
                      ],
                    ),

                  ],
                  // axes: <RadialAxis>[
                  //
                  //
                  //   RadialAxis(minimum: 0.00,maximum: 0.1,
                  //     ranges: <GaugeRange>[
                  //       GaugeRange(startValue: 0.00, endValue: 0.1,color: Colors.grey)
                  //     ],
                  //     pointers: <GaugePointer>[
                  //       isStartMeasure ?
                  //       NeedlePointer(value:pressure):
                  //       NeedlePointer(value:0),
                  //       isStartMeasure ?
                  //       RangePointer(value: maxPressure,enableAnimation: true):
                  //       RangePointer(value: maxPressure)
                  //     ],
                  //   )
                  // ],
                )
            ),
            Row(
              children: [
                Text("ตั้งค่า",style: TextStyle(color: mPrimaryColor , fontSize: 20)),
                Flexible(
                    child:TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          setNewton = double.parse(val);
                        });
                      },
                      // The validator receives the text that the user has entered.
                      decoration: InputDecoration(
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    )
                ),
                Text("นิวตัน",style: TextStyle(color: mPrimaryColor , fontSize: 20)),
              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                !globals.isfinishCountdown ?
                Text("กำลังเริ่มใน",style: TextStyle(color: mPrimaryColor , fontSize: 25)):
                Text("ทำเวลา",style: TextStyle(color: mSecondaryColor , fontSize: 25)),
                SizedBox(width: 15),
                !globals.isfinishCountdown ?
                Text(countdown_2.toString(),style: TextStyle(color: mPrimaryColor , fontSize: 30)):
                Text(_start.toString(),style: TextStyle(color: mSecondaryColor , fontSize: 30)),
                SizedBox(width: 15),
                !globals.isfinishCountdown ?
                Text("วินาที",style: TextStyle(color: mPrimaryColor , fontSize: 25)):
                Text("วินาที",style: TextStyle(color: mSecondaryColor , fontSize: 25))
              ],
            ),




            Container(
                margin: const EdgeInsets.fromLTRB(0,8,0,0),
                constraints: BoxConstraints.tightFor(width: 250, height: 70),
                child:globals.changeToText ?
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(mThirdColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                        )
                    ),
                    onPressed: () {
                    },

                    child: Text("เริ่มต้น",style: TextStyle(color: Colors.white , fontSize: 25))
                )
                    :
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                        )
                    ),
                    onPressed: () {
                      // getMaxTest();
                      setState(() {
                        globals.changeToText = true;
                        _start = 0;
                        globals.isfinishCountdown = false;
                        countdown_2 = 2;

                        startCountDown_2();

                        Future.delayed(const Duration(seconds: 2), () {
                          startTimer_3();
                        });

                        if(setNewton>0) {
                          maxNewton = setNewton;
                        }
                        if(setPressure > 0){
                          maxPressure = setPressure;
                        }
                      });
                    },

                    child: Text("เริ่มต้น",style: TextStyle(color: Colors.white , fontSize: 25))
                )
            )

          ]
      );
    }
    else{
      return Text('error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      ValueListenableBuilder(
        valueListenable: globals.pageNotifier,
        builder: (context, value, widget) {
          return getTest();
        },
      );
      // getTest();
  }
}

