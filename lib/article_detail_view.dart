import 'package:flutter/material.dart';
import 'package:single_read/audio_player_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model.dart';
import 'video_player_view.dart';

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
    //print(url);
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (navigation) async {
        print('navigation: ${navigation.url}');
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

  Widget buildThumbnailWidget(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = width * 9 / 16;
    Widget imgWidget = Image.network(
      article.thumbnail,
      fit: BoxFit.cover,
    );
    Widget child = imgWidget;
    if (article.model == ArticleModel.Audio.index ||
        article.model == ArticleModel.Video.index) {
      child = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          imgWidget,
          article.model == ArticleModel.Audio.index
              ? AudioPlayerCoverView(
                  article: article,
                  coverWidth: width,
                  coverHeight: height,
                )
              : VideoPlayerView(
                  article: article,
                  coverWidth: width,
                  coverHeight: height,
                )
        ],
      );
    }

    return Container(
      width: width,
      height: height,
      color: Colors.black54,
      child: child,
    );
  }

  Widget buildContentWidget(Article article) {
    if (article.model == ArticleModel.Text.index ||
        article.model == ArticleModel.Calendar.index) {
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

  Widget buildNavBarWidget(
      [double height = 40, bool transparentBackground = true]) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
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

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    double navBarHeight = 58;
    bool showNavBar = false; //widget.article.model == ArticleModel.Video.index;
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
            padding:
                EdgeInsets.only(top: showNavBar ? top + navBarHeight : top),
            child: buildContentWidget(widget.article),
          ),
          Positioned(
            child: buildNavBarWidget(navBarHeight, !showNavBar),
            top: top,
          )
        ],
      ),
    ));
  }
}
