import 'package:flutter/material.dart';
import 'package:single_read/article_detail_view.dart';
import 'package:single_read/model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';

class ArticlePageView extends StatefulWidget {
  final Article article;

  ArticlePageView(this.article);

  @override
  _ArticlePageViewState createState() => _ArticlePageViewState();
}

class _ArticlePageViewState extends State<ArticlePageView> {
  Widget buildArticleContentView(Article article) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    double thumbnailHeight = width * 3 / 4; //height * 0.35;
    if (article.model == 5) {
      return buildPosterView(article);
    } else if (article.model == 4) {
      return buildCalendarWidget(article);
    } else {
      return buildBaseArticleContentView(
          article, buildThumbnailWidget(article, width, thumbnailHeight));
    }
  }

  void onArticleTapped(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArticleDetailView(
                article: article,
              )),
    );
  }

  Widget buildBaseArticleContentView(Article article, Widget thumbnailWidget) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => onArticleTapped(article),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              thumbnailWidget,
              Container(
                width: width,
                height: 1,
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  article.category,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                article.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36),
                maxLines: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 100,
                  child: Text(
                    article.excerpt == null ? '' : article.excerpt,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                    maxLines: 3,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                width: 200,
                height: 1,
                color: Colors.grey,
              ),
              Text(
                article.author,
                style: TextStyle(fontSize: 20),
                maxLines: 1,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.comment,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(article.comment),
                    SizedBox(
                      width: 30,
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(article.good),
                    Spacer(),
                    Text(
                      '${article.view}',
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildThumbnailWidget(Article article, double width, double height) {
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

  void onPosterViewTapped(Article article) async {
    final String url = article.html5;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open $url');
    }
  }

  Widget buildPosterView(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => onPosterViewTapped(article),
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            child: Image.network(article.thumbnail, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }

  Widget buildCalendarWidget(Article article) {
    return InkWell(
      onTap: () => onArticleTapped(article),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Image.network(article.thumbnail, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var article = widget.article;
    return buildArticleContentView(article);
  }
}
