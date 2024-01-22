import 'dart:async';
import 'package:blog/homepage.dart';
import 'package:flutter/material.dart';
//import 'package:permissionleave/main.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                'assets/P.png',
              ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Center(
              //     child: Text(
              //       'Develop by CGPIT',
              //       style: TextStyle(
              //         fontSize: 24,
              //         color: Colors.black45,
              //           fontStyle: FontStyle.italic,
              //           fontFamily: 'cursive',
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
