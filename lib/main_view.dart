import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_read/article_list_view.dart';

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
      return ArticlePageView(title: title);
    } else if (articleModel == ArticleModel.Text ||
        articleModel == ArticleModel.Video ||
        articleModel == ArticleModel.Audio) {
      return ArticleListView(title: title);
    } else {
      return null;
    }
  }
}
