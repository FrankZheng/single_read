import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_read/article_cover_view.dart';
import 'package:single_read/article_detail_view.dart';
import 'package:single_read/model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cached_image_view.dart';
import 'model.dart';
import 'top_bar.dart';
import 'video_article_detail_view.dart';

class ArticlePageView extends StatelessWidget {
  final String title;
  final PageController pageController = new PageController();

  ArticlePageView({@required this.title});

  @override
  Widget build(BuildContext context) {
    AppModel model = Provider.of<AppModel>(context);
    return Stack(children: <Widget>[
      PageView.builder(
        itemCount: model.articles.length,
        scrollDirection: Axis.vertical,
        controller: pageController,
        onPageChanged: (index) => _onPageChanged(context, index),
        itemBuilder: (context, index) {
          return _buildArticleContentView(context, model.articles[index]);
        },
      ),
      TopBar(
          title: title,
          transparentBackground: model.currentArticleModel == ArticleModel.Top),
    ]);
  }

  Widget _buildArticleContentView(BuildContext context, Article article) {
    if (article.model == 5) {
      return ActivityAriticleView(article);
    } else if (article.model == 4) {
      return CalendarArticleView(article);
    } else {
      return ArticleCoverView(
        article: article,
        onArticleTapped: () => this._onArticleTapped(context, article),
      );
    }
  }

  void _onArticleTapped(BuildContext context, Article article) {
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

  void _onPageChanged(BuildContext context, int index) {
    //each page has 11 articles
    AppModel model = Provider.of<AppModel>(context);
    print('curent index: $index, total: ${model.articles.length}');
    final int prefetchPageCount = 3;
    if (index == model.articles.length - prefetchPageCount) {
      print('load more articles');
      model.loadMoreArticles();
    }
  }
}

class ActivityAriticleView extends StatelessWidget {
  final Article article;
  ActivityAriticleView(this.article);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onPosterViewTapped(article),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              child: CachedImageView(
            url: article.thumbnail,
            fit: BoxFit.fill,
          )),
        ],
      ),
    );
  }

  void _onPosterViewTapped(Article article) async {
    final String url = article.html5;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open $url');
    }
  }
}

class CalendarArticleView extends StatelessWidget {
  final Article article;
  CalendarArticleView(this.article);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
          child: CachedImageView(
        url: article.thumbnail,
      )),
    );
  }
}
