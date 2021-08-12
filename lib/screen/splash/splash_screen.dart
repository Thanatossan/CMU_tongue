// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tongue_cmu_bluetooth/screen/home/home_screen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var d = Duration(seconds: 3);
    // delayed 3 seconds to next page
    Future.delayed(d, () {
      // to next page and close this page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
            (route) => false,
      );
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(50),
          alignment: AlignmentDirectional.center ,
          color: Colors.white,
          child: Column(
            children: [
              Image.asset('assets/icons/CMU.png'),
              Image.asset('assets/icons/Tongue Strength & Endurance measurement device.png'),
              SvgPicture.asset('assets/icons/Image 1.svg')

            ],
          )
      );
  }
}
