import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;
  double imgOffset = 0;

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //Color textColor = Colors.white70;

    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          AnimatedOpacity(
            onEnd: onBackgroundImageShowed,
            opacity: opacity,
            duration: Duration(milliseconds: 2000),
            child: Image(
                width: width,
                height: height,
                image: AssetImage('assets/singe_read_splash_1.jpg'),
                fit: BoxFit.cover),
          ),
          ...textWidget(),
        ],
      ),
      width: width,
      height: height,
      color: Colors.black87,
    );
  }

  List<Widget> textWidget() {
    //double width = MediaQuery.of(context).size.width;
    Color textColor = Colors.white70;
    double height = MediaQuery.of(context).size.height;
    return <Widget>[
      Positioned(
          child: Text(
            '单\n读',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 50),
          ),
          top: height * 0.2),
      Positioned(
          child: Text(
            'We Read the World',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
          top: height * 0.6),
      Positioned(
          child: Column(
            children: <Widget>[
              Text(
                '单向空间',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 26),
              ),
              Text(
                'OWSPACE',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ],
          ),
          top: height * 0.8)
    ];
  }

  void onBackgroundImageShowed() {
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        imgOffset = 30;
      });
    });
  }
}
