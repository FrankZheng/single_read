import 'package:flutter/material.dart';

import 'cached_image_view.dart';
import 'model.dart';

class ArticleCoverView extends StatelessWidget {
  final Article article;
  final VoidCallback onArticleTapped;

  ArticleCoverView({@required this.article, @required this.onArticleTapped});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double thumbnailHeight = width * 3 / 4;
    return InkWell(
      onTap: onArticleTapped,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: width,
                  height: thumbnailHeight,
                  color: Colors.black54,
                  child: CachedImageView(url: article.thumbnail)),
              Container(
                width: width,
                height: 1,
                color: Colors.red,
              ),
              Container(
                color: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  article.category,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  article.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36),
                  maxLines: 2,
                ),
              ),
              Spacer(
                flex: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  article.excerpt == null ? '' : article.excerpt,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  maxLines: 3,
                ),
              ),
              Spacer(flex: 3),
              Container(
                color: Colors.grey,
                width: 200,
                height: 1,
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  article.author,
                  style: TextStyle(fontSize: 20),
                  maxLines: 1,
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 10),
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
                      '${article.view}',
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
