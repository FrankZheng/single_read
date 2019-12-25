import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:single_read/article_detail_view.dart';
import 'package:single_read/model.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePageView extends StatefulWidget {
  final Article article;

  ArticlePageView(this.article);

  @override
  _ArticlePageViewState createState() => _ArticlePageViewState();
}

class _ArticlePageViewState extends State<ArticlePageView> {
  Widget buildArticleContentView(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double thumbnailHeight = height * 0.35;
    if (article.model == 5) {
      return buildPosterView(article);
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
                height: 20,
              ),
              Text(
                article.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  article.excerpt == null ? '' : article.excerpt,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                width: 200,
                height: 1,
                color: Colors.grey,
              ),
              Text(
                article.author,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom),
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
          buildTopbar(),
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
            child: Image.network('${article.thumbnail}', fit: BoxFit.fill),
          ),
          buildTopbar(),
        ],
      ),
    );
  }

  Widget buildTopbar() {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      height: 90,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: paddingTop),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              '单读',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
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
    var article = widget.article;
    return buildArticleContentView(article);
  }
}
