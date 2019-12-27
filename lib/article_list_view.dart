import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleDetailView(
                        article: article,
                      )),
            );
          },
          child: ListTile(
            leading: Image.network(
              article.thumbnail,
              width: 100,
              height: 75,
              fit: BoxFit.cover,
            ),
            title: Text(article.title),
            subtitle: Text(
              article.author,
              style: TextStyle(color: Colors.grey),
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
}
