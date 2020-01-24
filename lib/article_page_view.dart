import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:single_read/article_cover_view.dart';
import 'package:single_read/article_detail_view.dart';
import 'package:single_read/model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cached_image_view.dart';
import 'model.dart';
import 'video_article_detail_view.dart';

class ArticlePageView extends StatefulWidget {
  final Article article;

  ArticlePageView(this.article);

  @override
  _ArticlePageViewState createState() => _ArticlePageViewState();
}

class _ArticlePageViewState extends State<ArticlePageView> {
  Widget buildArticleContentView(Article article) {
    if (article.model == 5) {
      return buildPosterView(article);
    } else if (article.model == 4) {
      return buildCalendarWidget(article);
    } else {
      return ArticleCoverView(
        article: article,
        onArticleTapped: () => this.onArticleTapped(article),
      );
    }
  }

  void onArticleTapped(Article article) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return article.model == ArticleModel.Video.index
          ? VideoArticleDetailView(
              article: article,
            )
          : ArticleDetailView(
              article: article,
            );
    }));
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
              child: CachedImageView(
                url: article.thumbnail,
                fit: BoxFit.fill,
              )),
        ],
      ),
    );
  }

  Widget buildCalendarWidget(Article article) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
          child: CachedImageView(
        url: article.thumbnail,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildArticleContentView(widget.article);
  }
}
