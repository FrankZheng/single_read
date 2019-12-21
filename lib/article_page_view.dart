import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:single_read/model.dart';

class ArticlePageView extends StatefulWidget {
  final Article article;

  ArticlePageView(this.article);

  @override
  _ArticlePageViewState createState() => _ArticlePageViewState();
}

class _ArticlePageViewState extends State<ArticlePageView> {
  Widget buildArticleContentView(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double thumbnailHeight = height * 0.3;
    if (article.model == 5) {
      return buildPosterView(article);
    } else {
      return buildBaseArticleContentView(
          article, buildThumbnailWidget(article, width, thumbnailHeight));
    }
  }

  Widget buildBaseArticleContentView(Article article, Widget thumbnailWidget) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            thumbnailWidget,
            Container(
              width: width,
              height: 1,
              color: Colors.red,
            ),
            Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                article.category,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              article.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                article.excerpt == null ? '' : article.excerpt,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              width: 200,
              height: 1,
              color: Colors.grey,
            ),
            Text(
              article.author,
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(article.comment),
                  SizedBox(
                    width: 30,
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(article.good),
                  Spacer(),
                  Text(
                    '${article.view} views',
                    style: TextStyle(
                        color: Colors.black, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildThumbnailWidget(Article article, double width, double height) {
    return Container(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: article.thumbnail,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget buildPosterView(Article article) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        top: false,
        child: Container(
          width: width,
          height: height,
          child:
              CachedNetworkImage(imageUrl: article.thumbnail, fit: BoxFit.fill),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var article = widget.article;
    return buildArticleContentView(article);
  }
}
