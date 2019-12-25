import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:single_read/main_view.dart';
import 'package:single_read/splash_screen.dart';

import 'model.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark));
  runApp(ChangeNotifierProvider.value(value: Model(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool splashVisible = true;

  void init() async {
    Timer(Duration(milliseconds: 4000), () {
      setState(() {
        splashVisible = false;
      });
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 1000);
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //color: Colors.black.withAlpha((255 * 0.5).toInt()),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)))),
        ),
        body: Stack(
          children: <Widget>[
            AnimatedOpacity(
                duration: duration,
                opacity: splashVisible ? 1.0 : 0.0,
                child: SplashScreen()),
            AnimatedOpacity(
                duration: duration,
                opacity: splashVisible ? 0.0 : 1.0,
                child: MainView()),
          ],
        ));
  }
}
