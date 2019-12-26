/*
"id": "296491",
"uid": "1999",
"name": "",
"title": "如何正确打开\r\n单读十周年特辑",
"excerpt": "《单读十周年特辑》可能是你读到过封面最长的书，封面同时也是护封和可以收藏的海报。",
"lead": "这周起，读者们开始陆续收到了《单读十周年特辑》。你知道吗？《单读十周年特辑》可能是你读到过封面最长的书，封面同时也是护封和可以收藏的海报。可是，想要打开这本书需要动一点小脑筋呢！",
"model": "2",
"position": "0",
"thumbnail": "https://img.owspace.com/Public/uploads/Picture/2019-12-16/5df70316ee23e.jpg",
"create_time": "1576503000",
"update_time": "2019/12/16",
"tags": [
{
"name": ""
}
],
"status": "1",
"video": "http://img.owspace.com/V_vgo1067920_1576467280.8197489.mp4",
"fm": "",
"link_url": "",
"publish_time": "0",
"view": "1.1w",
"share": "http://static.owspace.com/wap/296491.html",
"comment": "2",
"good": "3",
"bookmark": "0",
"show_uid": "1999",
"fm_play": "",
"lunar_type": "1",
"hot_comments": [],
"html5": "http://static.owspace.com/wap/296491.html",
"author": "单读",
"tpl": 2,
"avatar": "https://img.owspace.com//Public/uploads/Picture/2016-01-17/569b9c2490755.png",
"category": "TO WATCH",
"parseXML": 1
*/

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

enum ArticleModel { Top, Text, Video, Audio, Calendar, Activity }

class Article {
  String id;
  String uid;
  String title;
  String excerpt;
  String lead;
  String thumbnail;
  String video;
  String fm;
  String view;
  String html5;
  String comment;
  String good;
  String author;
  String avatar;
  String category;
  int model;

  Article(
      {this.id,
      this.uid,
      this.title,
      this.excerpt,
      this.lead,
      this.thumbnail,
      this.video,
      this.fm,
      this.view,
      this.html5,
      this.comment,
      this.good,
      this.author,
      this.avatar,
      this.category,
      this.model});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['id'],
        uid: json['uid'],
        title: json['title'],
        excerpt: json['excerpt'],
        lead: json['lead'],
        thumbnail: json['thumbnail'],
        video: json['video'],
        fm: json['fm'],
        view: json['view'].toString(),
        html5: json['html5'],
        comment: json['comment'].toString(),
        good: json['good'].toString(),
        author: json['author'],
        avatar: json['avatar'],
        category: json['category'],
        model: int.parse(json['model'].toString()));
  }
}

class AppModel with ChangeNotifier {
  ArticleModel _articleModel = ArticleModel.Top;

  ArticleModel get currentArticleModel => _articleModel;

  void changeArticleModel(ArticleModel articleModel, bool loadArticles) {
    if (articleModel != _articleModel) {
      _articleModel = articleModel;
      notifyListeners();

      if (currentModel.articles.isEmpty) {
        loadMoreArticles();
      }
    }
  }

  final Map<ArticleModel, Model> _models = {
    ArticleModel.Top: Model(),
    ArticleModel.Text: Model(model: ArticleModel.Text),
    ArticleModel.Video: Model(model: ArticleModel.Video),
    ArticleModel.Audio: Model(model: ArticleModel.Audio),
    ArticleModel.Calendar: Model(model: ArticleModel.Calendar),
  };

  Model get currentModel => _models[_articleModel];

  Future<void> loadMoreArticles() async {
    await currentModel.loadMoreArticles();
    notifyListeners();
  }

  List<Article> get articles => currentModel.articles;
}

class Model {
  //static Model shared = new Model();
  final Dio _dio;
  final ArticleModel _model;
  Model({ArticleModel model = ArticleModel.Top})
      : _dio = Dio(),
        _model = model {
    _dio.options.baseUrl = 'http://static.owspace.com';
  }
  final List<Article> _articles = [];
  int _page = 1;

  List<Article> get articles => _articles;
  ArticleModel get articleModel => _model;

  Future<void> loadMoreArticles() async {
    print('load more articles, page:$_page, model:$articleModel');
    List<Article> a = await getArticles(model: _model, page: _page);
    if (a.isNotEmpty) {
      _articles.addAll(a);
      _page++;
    }
  }

  Future<List<Article>> getArticles(
      {ArticleModel model = ArticleModel.Top, int page = 1}) async {
    //http://static.owspace.com/?c=api&a=getList&p=1&model=1&page_id=0&create_time=0&client=android&version=1.3.0&time=1467867330&device_id=866963027059338&show_sdv=1

    List<Article> articles = [];
    try {
      Response response = await _dio.get("/", queryParameters: {
        "c": "api",
        "a": "getList",
        "p": "$page",
        "model": "${model.index}",
        "create_time": 0,
        "client": Platform.isAndroid ? "andorid" : "ios",
        "version": "1.3.0",
        "time": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "device_id": 866963027059338, //figure out the random number logic later
        "show_sdv": 1
      });
      Map<String, dynamic> jsonData = response.data as Map<String, dynamic>;
      if (jsonData.containsKey('status') && jsonData['status'] == 'ok') {
        if (jsonData.containsKey('code') && jsonData['code'] == 0) {
          if (jsonData.containsKey('datas')) {
            List<dynamic> data = jsonData['datas'];
            for (Map<String, dynamic> a in data) {
              articles.add(Article.fromJson(a));
            }
          }
        }
      }

      //TODO: handle erros

    } catch (e) {
      //TODO: handle errors
      print(e);
    }
    return articles;
  }
}
