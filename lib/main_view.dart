import 'dart:async';

import 'package:flutter/material.dart';

import 'article_page_view.dart';
import 'model.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final PageController pageController = new PageController();
  int itemCount = 0;
  List<Article> articles = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: itemCount,
      scrollDirection: Axis.vertical,
      controller: pageController,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        return contentPage(index);
      },
    );
  }

  void init() async {
    List<Article> articles = await Model.shared.getTestArticles();
    setState(() {
      this.articles = articles;
      this.itemCount = articles.length;
    });
    print(articles.length);
  }

  void _onPageChanged(int page) {}

  Widget contentPage(int index) {
    if (articles.isEmpty) {
      return Center(
        child: Text('loading'),
      );
    }

    Article article = articles[index];
    return ArticlePageView(article);
  }
}
