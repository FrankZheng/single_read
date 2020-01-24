import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_read/article_list_view.dart';
import 'package:single_read/top_bar.dart';

import 'article_page_view.dart';
import 'model.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final Map<ArticleModel, String> titles = ARTICLE_MODEL_TITLES;
  final PageController pageController = new PageController();

  AppModel get _model => Provider.of<AppModel>(context);

  @override
  void initState() {
    super.initState();
    print('main view init');
    Timer(Duration(milliseconds: 100), () {
      _model.loadMoreArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return contentWidget();
  }

  Widget contentWidget() {
    final articleModel = Provider.of<AppModel>(context).currentArticleModel;
    final String title =
        titles[Provider.of<AppModel>(context).currentArticleModel];

    if (articleModel == ArticleModel.Top ||
        articleModel == ArticleModel.Calendar) {
      return Stack(children: <Widget>[
        PageView.builder(
          itemCount: _model.articles.length,
          scrollDirection: Axis.vertical,
          controller: pageController,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return ArticlePageView(_model.articles[index]);
          },
        ),
        TopBar(
            title: title,
            transparentBackground: articleModel == ArticleModel.Top),
      ]);
    } else if (articleModel == ArticleModel.Text ||
        articleModel == ArticleModel.Video ||
        articleModel == ArticleModel.Audio) {
      return Column(
        children: <Widget>[
          TopBar(title: title, transparentBackground: false),
          Expanded(child: ArticleListView()),
        ],
      );
    } else {
      return null;
    }
  }

  void _onPageChanged(int index) {
    //each page has 11 articles
    print('curent index: $index, total: ${_model.articles.length}');
    final int prefetchPageCount = 3;
    if (index == _model.articles.length - prefetchPageCount) {
      print('load more articles');
      _model.loadMoreArticles();
    }
  }
}
