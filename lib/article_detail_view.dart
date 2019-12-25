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

  Widget buildThumbnailWidget(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height * 0.25;
    return Container(
      width: width,
      height: height,
      color: Colors.black54,
      child: Image.network(
        '${article.thumbnail}',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildContentWidget(Article article) {
    if (article.model == ArticleModel.Text.index) {
      //for text article, the html has thumbnail already
      return buildWebView(article);
    } else if (article.model == ArticleModel.Video.index ||
        article.model == ArticleModel.Audio.index) {
      return Column(
        children: <Widget>[
          buildThumbnailWidget(article),
          Container(
            color: Colors.red,
            height: 2,
          ),
          Expanded(
            child: buildWebView(article),
          )
        ],
      );
    } else {
      return null;
    }
  }

  Widget buildNavBarWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              )),
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.black.withAlpha((255 * 0.5).toInt()),
            Colors.black.withAlpha((255 * 0.05).toInt())
          ])),
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
            child: buildContentWidget(widget.article),
          ),
          Positioned(
            child: buildNavBarWidget(),
            top: top,
          )
        ],
      ),
    ));
  }
}
