import 'package:flutter/material.dart';

import 'model.dart';

class ArticleDetailView extends StatefulWidget {
  final Article article;
  ArticleDetailView({this.article});

  @override
  _ArticleDetailViewState createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text('article detail'),
        ),
      ),
    );
  }
}
