

import 'package:flutter/material.dart';
import 'package:tongue_cmu_bluetooth/screen/test/first.dart';
import 'package:tongue_cmu_bluetooth/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tongue_cmu_bluetooth/screen/test/second.dart';
import 'package:tongue_cmu_bluetooth/screen/home/home_screen.dart';
import 'package:tongue_cmu_bluetooth/screen/test/third.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:tongue_cmu_bluetooth/screen/bluetooth/bluetooth_setting.dart';
import 'package:tongue_cmu_bluetooth/global-variable.dart' as globals;
import 'package:tongue_cmu_bluetooth/model/user.dart';
class MainScreen extends StatelessWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mPrimaryColor,
        // automaticallyImplyLeading: false,
      leading:  new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())
          );
        }
        ,
      ),
      actions: [
          Padding(
          padding: EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () {},
          child:
              Text("ชื่อ: "+ user.name +" "+ user.surname,style: TextStyle(fontSize: 18),)
          )
        )
        ],
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: SvgPicture.asset('assets/icons/home_logo.svg'),
            ),
            GestureDetector(
              onTap: () {
                if(globals.isConnected){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstTestScreen(user: user)),
                  );
                }
                else{
                  AlertDialog(
                    content: Text('กรุณา Connect Device' ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
              }, // handle your image tap here
              child: Image.asset(
                'assets/images/testButton.png',
                fit: BoxFit.cover, // this is the solution for border
                width: 250,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if(globals.isConnected){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondTestScreen(user: user)),
                );
              }
              else{
                AlertDialog(
                  content: Text('กรุณา Connect Device' ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              }
              }, // handle your image tap here
              child: Image.asset(
                'assets/images/test_strength.png',
                fit: BoxFit.cover, // this is the solution for border
                width: 250,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if(globals.isConnected){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdTestScreen(user: user)),
                  );
                }
                else{
                  AlertDialog(
                    content: Text('กรุณา Connect Device' ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
              }, // handle your image tap here
              child: Image.asset(
                'assets/images/testTolerance.png',
                fit: BoxFit.cover, // this is the solution for border
                width: 250,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonAppBluetooth(),
    );
  }
}

// ignore: must_be_immutable
class ButtonAppBluetooth extends StatefulWidget {


  @override
  _ButtonAppBluetoothState createState() => _ButtonAppBluetoothState();
}

class _ButtonAppBluetoothState extends State<ButtonAppBluetooth> {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: mSecondaryColor,
      // child: Text("สถานะเชื่อมต่อ Bluetooth : ",style: TextStyle(
      //   fontSize: 15 , color: Colors.white
      // ),
      // )
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
            child: Icon(Icons.bluetooth, color: Colors.white),
          ),

          Text("สถานะ Bluetooth :",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mPrimaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BluetoothSetting()),
                );
              },

              child: globals.isConnected? Text('เชื่อมต่อแล้ว'):Text('ตั้งค่า'),
            ),

          ),
        ],
      ),
    );
  }
}
