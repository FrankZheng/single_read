import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'article_page_view.dart';
import 'model.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final PageController pageController = new PageController();

  Model get _model => Provider.of<Model>(context);

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
    return PageView.builder(
      itemCount: _model.articles.length,
      scrollDirection: Axis.vertical,
      controller: pageController,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        return ArticlePageView(_model.articles[index]);
      },
    );
  }

  void _onPageChanged(int index) {
    //each page has 11 articles
    print('curent index: $index, total: ${_model.articles.length}');
    int numPerPage = 11;
    if (index == _model.articles.length - numPerPage ~/ 2) {
      print('load more articles');
      _model.loadMoreArticles();
    }
  }
}
