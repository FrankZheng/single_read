import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model.dart';

class ArticleDetailView extends StatefulWidget {
  final Article article;
  ArticleDetailView({this.article});

  @override
  _ArticleDetailViewState createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  Widget buildWebView(Article article) {
    final String url =
        '${article.html5}?client=iOS&device_id=866963027059338&version=1.3.0';
    print(url);
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Stack(
        children: <Widget>[
          Container(
            height: top,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(top: top),
            child: buildWebView(widget.article),
          ),
          Positioned(
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white)),
            top: top + 5,
            left: 5,
          )
        ],
      ),
    ));
  }
}
