import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tongue_cmu_bluetooth/screen/register/register_screen.dart';
import 'package:tongue_cmu_bluetooth/screen/main/main_screen.dart';
import 'package:tongue_cmu_bluetooth/constant.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:tongue_cmu_bluetooth/db/tongue_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tongue_cmu_bluetooth/global-variable.dart' as globals;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void exportUserData() async{

    final userData = await TongueDatabase.instance.exportUserData();
    String? path = await externalPath();
    print(path);
    final File file = File('$path/userData.csv');
    await file.writeAsString(userData.toString());
    print("export userData");
  }
  void exportTestData() async{
    final testData  =await TongueDatabase.instance.exportTestData();
    String? path = await externalPath();
    final File file = File('$path/testData.csv');
    await file.writeAsString(testData.toString());
    print("export testData");
  }
  Future<String?> externalPath() async {
    final dir = await getExternalStorageDirectory();
    return dir?.path;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: mPrimaryColor,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ))),
                onPressed: () {
                  exportUserData();
                },
                child: Text('นำออกข้อมูลผู้ใข้งาน'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ))),
                onPressed: () {
                  exportTestData();
                },
                child: Text('นำออกข้อมูลทดสอบ'),
              ),
            )
          ],

        ),
        body: Container(

            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 32),
                  child: SvgPicture.asset('assets/icons/home_logo.svg'),
                ),
                HomeForm(),
                Line(),
                RegisterButton()
              ],
            )));
  }
}


class HomeForm extends StatefulWidget {
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final _formKey = GlobalKey<FormState>();
  late User user;
  late String name;
  late String surname;
  bool _loginFail = false;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: TextFormField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              // The validator receives the text that the user has entered.
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mThirdColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mThirdColor, width: 2.0),
                  ),
                  hintText: 'ชื่อ',
                  hintStyle: TextStyle(color: mSecondaryColor)),
              validator: (val) {
                if (val == null || val.isEmpty && _loginFail == false) {
                  return 'Name cannot be empty';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            onChanged: (val) {
              setState(() {
                surname = val;
              });
            },
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mThirdColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mThirdColor, width: 2.0),
                ),
                hintText: 'นามสกุล',
                hintStyle: TextStyle(color: mSecondaryColor)),
            validator: (val) {
              if (val == null || val.isEmpty && _loginFail == false) {
                return 'Surname cannot be empty';
              }
              return null;
            },
          ),
          Text((() {
            if (_loginFail) {
              return "ไม่พบชื่อ-นามสกุลนี้ กรุณาลงทะเบียน";
            }
            return "";
          })()),
          // Text("hi"),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            constraints: BoxConstraints.tightFor(width: 250, height: 100),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(mSecondaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () {
                login(name, surname);
              },
              child: Text('เข้าสู่ระบบ'),
            ),
          )),
        ],
      ),
    );
  }

  void login(String loginName, String loginSurname) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      this.user =
          await TongueDatabase.instance.getLogin(loginName, loginSurname);
      globals.user = this.user;
      globals.isLoggedIn = true ;
      // print(globals.user.name);
      if (this.user.name != "") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(user: globals.user)),
        );
      }
      // else {
      //   Navigator.of(context).pop();
      //   _loginFail = true;
      // }
    }
  }
}

class Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(300, 50),
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, 25);
    final p2 = Offset(300, 25);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      constraints: BoxConstraints.tightFor(width: 250, height: 100),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mSecondaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: Text('ลงทะเบียน'),
      ),
    ));
  }
}
