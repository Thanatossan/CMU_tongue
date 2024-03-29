import 'dart:io';
import 'package:excel/excel.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sqflite_common_porter/utils/csv_utils.dart';
import 'package:tongue_cmu_bluetooth/screen/register/register_screen.dart';
import 'package:tongue_cmu_bluetooth/screen/main/main_screen.dart';
import 'package:tongue_cmu_bluetooth/constant.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:tongue_cmu_bluetooth/db/tongue_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tongue_cmu_bluetooth/global-variable.dart' as globals;
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AlertUserPressed(context) {
    Alert(
      context: context,
      desc: "เลือกนามสกุลของไฟล์ข้อมูล",
      content: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.attach_file),
            labelText: 'กรอกชื่อไฟล์ข้อมูล',
          ),
          onChanged: (val) {
            setState(() {
              globals.FileName = val;
            });
          }
      ),
      buttons: [
        DialogButton(
            child: Text(
              ".xlsx",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => exportUserDataXlsx(globals.FileName),
            color: mSecondaryColor
        ),
        DialogButton(
            child: Text(
              ".csv",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => exportUserDataCsv(globals.FileName),
            color: mPrimaryColor
        )
      ],
    ).show();
  }

  AlertTestPressed(context) {
    Alert(
      context: context,
      desc: "เลือกนามสกุลของไฟล์ข้อมูล",
      content: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.attach_file),
            labelText: 'กรอกชื่อไฟล์ข้อมูล',
          ),
          onChanged: (val) {
            setState(() {
              globals.FileName = val;
            });
          }
      ),
      buttons: [
        DialogButton(
            child: Text(
              ".xlsx",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => exportTestDataXlsx(globals.FileName),
            color: mSecondaryColor
        ),
        DialogButton(
            child: Text(
              ".csv",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => exportTestDataCsv(globals.FileName),
            color: mPrimaryColor
        )
      ],
    ).show();
  }
  firebase_storage.UploadTask uploadString(String putStringText,String filename) {
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('testDataCSV')
        .child('/'+filename);

    // Start upload of putString
    return ref.putString(putStringText,
        metadata: firebase_storage.SettableMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'example': 'putString'}));
  }
  firebase_storage.UploadTask uploadXlsx(Uint8List file,String filename) {
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('testDataXlsx')
        .child('/'+filename);

    // Start upload of putString
    return ref.putData(file);
  }

  void exportUserDataCsv(String InputFileName) async{
    await EasyLoading.show();
    final userData = await TongueDatabase.instance.exportUserData();
    print(userData);
    var csvUser = mapListToCsv(userData);
    print(csvUser);
    var fileString = csvUser;
    String filename = "userData_" + InputFileName +".csv";
    print(userData.toString());
    uploadString(fileString.toString(),filename);

    await EasyLoading.dismiss();

  }

  void exportUserDataXlsx(String InputFileName) async{
    // requestPermission(_permission);
    await EasyLoading.show();
    final userData = await TongueDatabase.instance.exportUserData();
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    var csvUser = mapListToCsv(userData);
    // print(csvUser);
    List<String> header = csvUser!.substring(0,csvUser.indexOf('\n')).split(',');
    sheetObject.insertRowIterables(header,0);
    csvUser = csvUser.substring(csvUser.indexOf('\n')+1);
    print(csvUser);
    final numLines = '\n'.allMatches(csvUser).length + 1;
    print(numLines);

    for (var i=1; i<= numLines;i++){
      List<String> dataList = [];
      if(i !=numLines){
        dataList = csvUser!.substring(0,csvUser.indexOf('\n')).split(',');
        csvUser = csvUser.substring(csvUser.indexOf('\n')+1);
        sheetObject.insertRowIterables(dataList,i);
      }
      else{
        dataList = csvUser!.split(',');
        sheetObject.insertRowIterables(dataList,i);
      }
      print(dataList);
    }

    List<int>? fileBytes = excel.save();
    Uint8List data = Uint8List.fromList(fileBytes!);
    String filename = "userData_" + InputFileName +".xlsx";
    uploadXlsx(data,filename);
    await EasyLoading.dismiss();

  }
  void exportTestDataCsv(String InputFileName) async{
    await EasyLoading.show();
    final testData  =await TongueDatabase.instance.exportTestData();
    var csvTest = mapListToCsv(testData);
    var fileString = csvTest;
    String filename = "TestData_" + InputFileName +".csv";
    uploadString(fileString.toString(),filename);
    print("export testData");
    final testData2  =await TongueDatabase.instance.exportTest2Data();
    var csvTest2 = mapListToCsv(testData2);
    var fileString2 = csvTest2;
    String filename2 = "TestData2_" + InputFileName +".csv";
    uploadString(fileString2.toString(),filename2);
    await EasyLoading.dismiss();
  }
  void exportTestDataXlsx(String InputFileName) async{
    // requestPermission(_permission);
    await EasyLoading.show();
    final testData  =await TongueDatabase.instance.exportTestData();
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    var csvUser = mapListToCsv(testData);
    // print(csvUser);
    List<String> header = csvUser!.substring(0,csvUser.indexOf('\n')).split(',');
    sheetObject.insertRowIterables(header,0);
    csvUser = csvUser.substring(csvUser.indexOf('\n')+1);
    print(csvUser);
    final numLines = '\n'.allMatches(csvUser).length + 1;
    print(numLines);

    for (var i=1; i<= numLines;i++){
      List<String> dataList = [];
      if(i !=numLines){
        dataList = csvUser!.substring(0,csvUser.indexOf('\n')).split(',');
        csvUser = csvUser.substring(csvUser.indexOf('\n')+1);
        sheetObject.insertRowIterables(dataList,i);
      }
      else{
        dataList = csvUser!.split(',');
        sheetObject.insertRowIterables(dataList,i);
      }
      print(dataList);
    }

    List<int>? fileBytes = excel.save();
    Uint8List data = Uint8List.fromList(fileBytes!);
    String filename = "TestData_" + InputFileName +".xlsx";
    uploadXlsx(data,filename);

    final testData2  =await TongueDatabase.instance.exportTest2Data();
    var excel2 = Excel.createExcel();
    Sheet sheetObject2 = excel2['Sheet1'];
    var csvUser2 = mapListToCsv(testData2);
    // print(csvUser);
    List<String> header2 = csvUser2!.substring(0,csvUser2.indexOf('\n')).split(',');
    sheetObject2.insertRowIterables(header2,0);
    csvUser2 = csvUser2.substring(csvUser2.indexOf('\n')+1);
    print(csvUser2);
    final numLines2 = '\n'.allMatches(csvUser2).length + 1;
    print(numLines2);

    for (var i=1; i<= numLines2;i++){
      List<String> dataList2 = [];
      if(i !=numLines2){
        dataList2 = csvUser2!.substring(0,csvUser2.indexOf('\n')).split(',');
        csvUser2 = csvUser2.substring(csvUser2.indexOf('\n')+1);
        sheetObject2.insertRowIterables(dataList2,i);
      }
      else{
        dataList2 = csvUser!.split(',');
        sheetObject2.insertRowIterables(dataList2,i);
      }
      print(dataList2);
    }

    List<int>? fileBytes2 = excel2.save();
    Uint8List data2 = Uint8List.fromList(fileBytes2!);
    String filename2 = "TestData2_" + InputFileName +".xlsx";
    uploadXlsx(data2,filename2);

    await EasyLoading.dismiss();

  }
  Future<String?> externalPath() async {
    final dir = await getExternalStorageDirectory();
    return dir?.path;
  }

  void exportUserData() async{
    await EasyLoading.show();
    final userData = await TongueDatabase.instance.exportUserData();
    var csvUser = mapListToCsv(userData);
    // String? path = await externalPath();
    // print(path);
    // final File file = File('$path/userData.csv');
    //
    // await file.writeAsString(csvUser!);
    // globals.pathUser = path!+'/userData.csv';
    // print(userData.toString());
    // print("export userData");
    var fileString = csvUser;
    String filename = "userData.csv";
    uploadString(fileString.toString(),filename);
    await EasyLoading.dismiss();
  }

  void exportTestData() async{
    await EasyLoading.show();
    final testData  =await TongueDatabase.instance.exportTestData();
    final testData2 = await TongueDatabase.instance.exportTest2Data();
    var csvTest = mapListToCsv(testData);
    var csvTest2 = mapListToCsv(testData2);
    // print(testData.type);
    // String? path = await externalPath();
    // print(path);
    // print(testData2.toString());
    // final File file = File('$path/testData.csv');
    // final File file2 = File('$path/testData2.csv');
    // await file.writeAsString(csvTest!);
    // await file2.writeAsString(csvTest2!);
    // globals.pathTest = path!+'/testData';
    var fileString = csvTest;
    var fileString2 = csvTest2;
    String filename = "TestData.csv";
    String filename2 = "TestData2.csv";
    uploadString(fileString.toString(),filename);
    uploadString(fileString2.toString(),filename2);
    print("export testData");
    await EasyLoading.dismiss();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: mPrimaryColor,
      automaticallyImplyLeading: false,
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
              AlertUserPressed(context);
            },
            child: Text('นำออกข้อมูลผู้ใช้งาน'),
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
              AlertTestPressed(context);
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
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
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
