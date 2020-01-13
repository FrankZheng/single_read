import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model.dart';

class ArticleWebView extends StatefulWidget {
  final Article article;

  ArticleWebView({@required this.article});

  @override
  _ArticleWebViewState createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  @override
  Widget build(BuildContext context) {
    final Article article = widget.article;
    final String client = Platform.isAndroid ? "andorid" : "iOS";
    //TODO: add device_id and verison later
    final String url =
        '${article.html5}?client=$client&device_id=866963027059338&version=1.3.0';
    //print(url);
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (navigation) async {
        //print('navigation: ${navigation.url}');
        String nurl = navigation.url;
        if (nurl == url) {
          return NavigationDecision.navigate;
        }
        if (nurl.startsWith('http://static.owspace.com/wap/')) {
          //open another article
          //here need parse the article id out and check the article model by api first
        } else {
          //user external browser to open the url
          if (await canLaunch(nurl)) {
            await launch(nurl);
          } else {
            print('can not launch $nurl');
          }
        }
        return NavigationDecision.prevent;
      },
    );
  }
}
