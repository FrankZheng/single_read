import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget menuTextItem(String text, ArticleModel articleModel,
      {Color color = Colors.white, double fontSize = 40}) {
    return InkWell(
        onTap: () {
          final appModel = Provider.of<AppModel>(context, listen: false);
          appModel.changeArticleModel(articleModel, true);
          Navigator.of(context).pop();
        },
        child: Text(text, style: TextStyle(color: color, fontSize: fontSize)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      //color: Colors.black.withAlpha((255 * 0.5).toInt()),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
              child: SafeArea(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.search, color: Colors.white, size: 30),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('单读',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  menuTextItem('首    页', ArticleModel.Top),
                  SizedBox(
                    height: 10,
                  ),
                  menuTextItem('文    字', ArticleModel.Text),
                  SizedBox(
                    height: 10,
                  ),
                  menuTextItem('声    音', ArticleModel.Audio),
                  SizedBox(
                    height: 10,
                  ),
                  menuTextItem('影    像', ArticleModel.Video),
                  SizedBox(
                    height: 10,
                  ),
                  menuTextItem('单向历', ArticleModel.Calendar),
                  Spacer(),
                  Text(
                    'Powered by OWSPACE',
                    style: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.w300),
                  ),
                ],
              )),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)))),
    );
  }
}
