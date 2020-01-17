import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_read/cached_image_view.dart';
import 'package:single_read/video_article_detail_view.dart';

import 'article_detail_view.dart';
import 'model.dart';

class ArticleListView extends StatefulWidget {
  @override
  _ArticleListViewState createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> {
  @override
  Widget build(BuildContext context) {
    final articles = Provider.of<AppModel>(context).articles;
    return ListView.separated(
      padding: EdgeInsets.only(top: 5),
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        final Article article = articles[index];
        return InkWell(
          onTap: () => _onItemTap(article),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            leading: CachedImageView(
              url: article.thumbnail,
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
            title: Text(
              article.title,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              article.author,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
    );
  }

  void _onItemTap(Article article) {
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
}
