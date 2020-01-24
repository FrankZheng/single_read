import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool transparentBackground;
  final String title;

  TopBar({@required this.title, @required this.transparentBackground});

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      height: paddingTop + kToolbarHeight,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: paddingTop),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              //titles[Provider.of<AppModel>(context).currentArticleModel],
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                //fontWeight: FontWeight.w100
              ),
            ),
            Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
      decoration: transparentBackground
          ? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  Colors.black.withAlpha((255 * 0.5).toInt()),
                  Colors.black.withAlpha((255 * 0.05).toInt())
                ]))
          : BoxDecoration(color: Colors.black),
    );
  }
}
