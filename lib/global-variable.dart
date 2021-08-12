library my_prj.globals;
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tongue_cmu_bluetooth/db/tongue_database.dart';

late User user;
bool isLoggedIn = false;
late BluetoothDevice selectedDevice ;
bool isConnected = false;
bool changeToText = false;