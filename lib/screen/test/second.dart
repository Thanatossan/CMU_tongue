import 'dart:ffi';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tongue_cmu_bluetooth/constant.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tongue_cmu_bluetooth/db/tongue_database.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:tongue_cmu_bluetooth/model/tongueTest.dart';
import 'dart:typed_data';
import 'package:tongue_cmu_bluetooth/global-variable.dart' as globals;
import 'package:tongue_cmu_bluetooth/screen/main/main_screen.dart';
class SecondTestScreen extends StatelessWidget {
  final User user;
  const SecondTestScreen({
    Key? key,
    required this.user
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: mPrimaryColor,
          leading:  new IconButton(
          icon: new Icon(Icons.arrow_back),
      onPressed: () => Navigator.push(
          context,MaterialPageRoute(builder: (context) => MainScreen(user:globals.user))
      ),
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
      body: Container(
          padding: const EdgeInsets.all(32),
          child: Container(
              child:Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/chart-bar-solid.svg',fit: BoxFit.cover, // this is the solution for border
                          width: 80),
                      SizedBox(width: 30),
                      Flexible(child: Text("วัดความแข็งแกร่ง",style: TextStyle(color: mPrimaryColor , fontSize: 30)))                    ],
                  ),
                  SizedBox(height: 30),
                  StatefulComponent()
                ],

              )

          )

      ),
    );
  }
}
class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}
class StatefulComponent extends StatefulWidget {

  final BluetoothDevice server = globals.selectedDevice;
  @override
  _StatefulComponentState createState() => _StatefulComponentState();
}

class _StatefulComponentState extends State<StatefulComponent> {



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
  bool isStartMeasure = false;
  Future createTest() async{
    final tongueTest = TongueTest(userId: globals.user.id, time: DateTime.now(), type: "ความแข็งแกร่ง", newton: maxNewton, kiloPascal: maxPressure);
    await TongueDatabase.instance.addTest(tongueTest);
    return tongueTest;
  }
  void startTimer() {
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
            createTest();

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
      _timer.cancel();
      connection = null;
    }
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
          print(stringMessage);

          newton = double.parse(stringMessage.substring(11,15));
          print(newton);
          pressure = double.parse(stringMessage.substring(30,34));
          print(pressure);
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
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
            height: 300,
            width: 300,
            child: SfRadialGauge(
              axes: <RadialAxis>[

                RadialAxis(minimum: 0.00,maximum: 30,
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: 0.00, endValue: 0,color: Colors.grey)
                  ],
                  pointers: <GaugePointer>[
                    isStartMeasure ?
                    MarkerPointer(value:newton,enableAnimation: true):
                    MarkerPointer(value:endNewton),
                    isStartMeasure ?
                    MarkerPointer(value: newton,enableAnimation: true):
                    MarkerPointer(value: endNewton)
                  ],
                ),
                RadialAxis(minimum: 0.00,maximum: 500,
                  radiusFactor: 0.5,
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: 0.00, endValue: 0,color: Colors.grey)
                  ],
                  pointers: <GaugePointer>[
                    isStartMeasure ?
                    MarkerPointer(value:pressure,enableAnimation: true):
                    MarkerPointer(value:endPressure),
                    isStartMeasure ?
                    MarkerPointer(value: pressure,enableAnimation: true ):
                    MarkerPointer(value: endPressure)
                  ],
                )

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
          child:globals.changeToText ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("เหลือเวลา",style: TextStyle(color: mSecondaryColor , fontSize: 25)),
              SizedBox(width: 15),
              Text(_start.toString(),style: TextStyle(color: mSecondaryColor , fontSize: 30)),
              SizedBox(width: 15),
              Text("วินาที",style: TextStyle(color: mSecondaryColor , fontSize: 25))
            ],
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
                  globals.changeToText = true;
                  _start = countTime;
                  startTimer();
                });
              },
              child:
      Text("เริ่มต้น",style: TextStyle(color: Colors.white , fontSize: 25)),
          )
    )

    ]
    );
  }

}




