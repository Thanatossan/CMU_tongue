import 'package:flutter/material.dart';
import 'package:tongue_cmu_bluetooth/constant.dart';
import 'package:tongue_cmu_bluetooth/screen/bluetooth/SelectBondedDevicePage.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'package:tongue_cmu_bluetooth/global-variable.dart' as globals;
import 'package:flutter_svg/svg.dart';
import 'package:tongue_cmu_bluetooth/screen/main/main_screen.dart';

class BluetoothSetting extends StatefulWidget {
  @override
  _BluetoothSettingState createState() => _BluetoothSettingState();
}

class _BluetoothSettingState extends State<BluetoothSetting> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  ValueNotifier devicesString = ValueNotifier<String>("");
  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;
  bool isConnected = false;
  // BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;
  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: mPrimaryColor,
            leading:  new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,MaterialPageRoute(builder: (context) => MainScreen())
              ),
            )),
        body:
        Container(
          child: ListView(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 15, 10,0),
                  child:Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/bluetooth-b-brands.svg',fit: BoxFit.cover, // this is the solution for border
                              width: 30),
                          SizedBox(width: 30),
                          Flexible(child: Text("ตั้งค่า Bluetooth",style: TextStyle(color: mPrimaryColor , fontSize: 30)))
                        ],
                      ),
                      SizedBox(height: 30),
                    ],

                  )
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Pairing Bluetooth Device',style: TextStyle(color: mPrimaryColor , fontSize: 17)),
                trailing: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      )
                  ),
                  child: const Text('Paired Device '),
                  onPressed: () {
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                ),
              ),
              ListTile(
                title: Text('Select Paired Device ',style: TextStyle(color: mPrimaryColor,fontSize: 17)),
                trailing: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      )
                  ),
                  child: Text('Select Device'),
                  onPressed: () async {
                    final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Connect -> selected ' + selectedDevice.address);
                      globals.selectedDevice = selectedDevice ;
                      devicesString.value = selectedDevice.name.toString();
                      globals.isConnected = true;
                    } else {
                      print('Connect -> no device selected');
                    }
                  },
                ),

              ),
              Container(
                padding: const EdgeInsets.fromLTRB(17,15, 10, 0),
                child: Row(
                  children: [
                    Text("Current Devices :" ,style: TextStyle(color: mPrimaryColor, fontSize: 17)),
                    SizedBox(width: 10),
                    // Text(globals.selectedDevice.name.toString() ,style: TextStyle(color: mPrimaryColor, fontSize: 20))
                    ValueListenableBuilder(
                      //TODO 2nd: listen playerPointsToAdd
                      valueListenable: devicesString,
                      builder: (context, value, widget) {
                        //TODO here you can setState or whatever you need
                        return Text(
                          //TODO e.g.: create condition with playerPointsToAdd's value
                            value != ""
                                ? globals.selectedDevice.name.toString()
                                : "" ,textAlign: TextAlign.center, style: TextStyle(color: mSecondaryColor, fontSize: 17,));
                      },
                    ),
                  ],
                ),

              ),
              SizedBox(height: 20),
              Container(
                // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                constraints: BoxConstraints.tightFor(width: 250, height: 40),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      )
                  ),
                  onPressed: () {
                    if (globals.selectedDevice.address != "0") {
                      globals.globalConnect = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  },
                  child: Text('Connect', style: TextStyle(color: mFourthColor, fontSize: 15)),
                ),
              ),
            ],

          ),
        )

    );
  }
}
