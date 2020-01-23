import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;

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
        fit: StackFit.expand,
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          ImageAnimationView(),
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
    Color textColor = Colors.white;
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
}

class ImageAnimationView extends StatefulWidget {
  @override
  _ImageAnimationViewState createState() => _ImageAnimationViewState();
}

class _ImageAnimationViewState extends State<ImageAnimationView>
    with SingleTickerProviderStateMixin {
  ui.Image _image;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    var controller = AnimationController(
        duration: Duration(milliseconds: 1600), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    animation.addListener(() {
      //debugPrint('${animation.value}');
      setState(() {});
    });

    var random = new Random();
    int num = random.nextInt(9) + 1;
    rootBundle.load('assets/single_read_splash_$num.jpg').then((byteData) {
      var bytes = Uint8List.view(byteData.buffer);
      ui.decodeImageFromList(bytes, (img) {
        controller.forward();
        setState(() {
          _image = img;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return CustomPaint(
        painter: ImagePainter(image: _image, fraction: animation.value),
      );
    }
    return Container();
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final double fraction;
  final double _maxOffsetX = 64.0;

  ImagePainter({this.image, this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    //debugPrint('$size');
    var background = image;
    Size imgSize =
        Size(background.width.toDouble(), background.height.toDouble());

    Rect dstRect =
        Rect.fromLTWH(0, 0, size.width + _maxOffsetX * 2, size.height);
    // 根据适配模式，计算适合的缩放尺寸
    FittedSizes fittedSizes = applyBoxFit(BoxFit.cover, imgSize, dstRect.size);

    // 获得一个图片区域中，指定大小的，居中位置处的 Rect
    Offset offset = Offset(_maxOffsetX * fraction, 0);
    Rect inputRect =
        Alignment.center.inscribe(fittedSizes.source, offset & imgSize);
    // 获得一个绘制区域内，指定大小的，居中位置处的 Rect

    Rect outputRect =
        Alignment.center.inscribe(fittedSizes.destination, dstRect);

    canvas.drawImageRect(background, inputRect, outputRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    ImagePainter old = oldDelegate;
    return old.fraction != this.fraction;
  }
}
