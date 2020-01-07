import 'package:flutter/material.dart';
import 'article_webview.dart';
import 'audio_player_view.dart';
import 'model.dart';

class ArticleDetailView extends StatefulWidget {
  final Article article;
  ArticleDetailView({this.article});

  @override
  _ArticleDetailViewState createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  Widget buildThumbnailWidget(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = width * 9 / 16;
    Widget imgWidget = Image.network(
      article.thumbnail,
      fit: BoxFit.cover,
    );
    Widget child = imgWidget;
    if (article.model == ArticleModel.Audio.index) {
      child = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          imgWidget,
          AudioPlayerCoverView(
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
      return ArticleWebView(article: article);
    } else if (article.model == ArticleModel.Audio.index) {
      return Column(
        children: <Widget>[
          buildThumbnailWidget(article),
          Container(
            color: Colors.red,
            height: 2,
          ),
          Expanded(
            child: ArticleWebView(article: article),
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
