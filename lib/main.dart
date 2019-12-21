import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:single_read/main_view.dart';
import 'package:single_read/splash_screen.dart';

import 'model.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, statusBarBrightness: Brightness.dark));
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
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Center(
            child: Stack(
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
    )));
  }
}
