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
  final Map<ArticleModel, String> titles = {
    ArticleModel.Top: '单 读',
    ArticleModel.Text: '文 字',
    ArticleModel.Audio: '声 音',
    ArticleModel.Video: '影 像',
    ArticleModel.Calendar: '单向历',
  };
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
        buildTopbar(articleModel == ArticleModel.Top)
      ]);
    } else if (articleModel == ArticleModel.Text ||
        articleModel == ArticleModel.Video ||
        articleModel == ArticleModel.Audio) {
      return Column(
        children: <Widget>[
          buildTopbar(false),
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

  Widget buildTopbar([bool transparentBackground = true]) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      height: paddingTop + kToolbarHeight,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: paddingTop),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              titles[Provider.of<AppModel>(context).currentArticleModel],
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
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
}
