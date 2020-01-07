import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

const String DB_NAME = "app.db";
const String ARTICLES_TABLE_NAME = 'articles';

enum ArticleModel { Top, Text, Video, Audio, Calendar, Activity }

class Article {
  final String id;
  final String uid;
  final String title;
  final String excerpt;
  final String lead;
  final String thumbnail;
  final String video;
  final String fm;
  final String view;
  final String html5;
  final String comment;
  final String good;
  final String author;
  final String avatar;
  final String category;
  final String updateTime;
  final int createTime;
  final int parseXML;
  final int model;
  String data;

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
      this.model,
      this.updateTime,
      this.createTime,
      this.parseXML,
      this.data});

  factory Article.fromMap(Map<String, dynamic> json) {
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
      model: int.parse(json['model'].toString()),
      updateTime: json['update_time'].toString(),
      createTime: int.parse(json['create_time'].toString()),
      parseXML: json['parseXML'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'article_id': id,
      'uid': uid,
      'title': title,
      'excerpt': excerpt,
      'lead': lead,
      'thumbnail': thumbnail,
      'video': video,
      'fm': fm,
      'view': view,
      'html5': html5,
      'comment': comment,
      'good': good,
      'author': author,
      'avatar': avatar,
      'category': category,
      'model': model,
      'update_time': updateTime,
      'create_time': createTime,
      'parseXML': parseXML,
    };
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
  final int _pageSize;
  Model({ArticleModel model = ArticleModel.Top})
      : _dio = Dio(),
        _model = model,
        _pageSize = model == ArticleModel.Top ? 10 : 30 {
    _dio.options.baseUrl = 'http://static.owspace.com';
  }
  final List<Article> _articles = [];
  int _page = 1;

  Future<Database> _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = openDatabase(join(await getDatabasesPath(), DB_NAME),
        onCreate: (db, version) {
      return db.execute('''
            BEGIN;
            CREATE TABLE IF NOT EXISTS $ARTICLES_TABLE_NAME(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            article_id TEXT,
            uid TEXT,
            title TEXT,
            excerpt TEXT,
            lead TEXT,
            thumbnail TEXT,
            video TEXT,
            fm TEXT,
            view TEXT,
            html5 TEXT,
            comment TEXT,
            good TEXT,
            author TEXT,
            avatar TEXT,
            category TEXT,
            update_time TEXT,
            create_time INTEGER, 
            parseXML INTEGER,
            model INTEGER,
            data TEXT);
            CREATE INDEX idx_articles_model ON articles (model);
            CREATE INDEX idx_articles_create_time ON articles (create_time);
            COMMIT;
            ''');
    }, version: 1);
    return _database;
  }

  List<Article> get articles => _articles;
  ArticleModel get articleModel => _model;

  Future<Map<String, Article>> loadMoreArticlesFromDB() async {
    print(
        'load more articles from db, pageSize:$_pageSize, offset:${_articles.length}:$articleModel');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ARTICLES_TABLE_NAME,
        where: 'model=?',
        whereArgs: [_model.index],
        orderBy: 'create_time DESC',
        limit: _pageSize,
        offset: _articles.length);

    Map<String, Article> saved = {};
    for (Map<String, dynamic> map in maps) {
      Article article = Article.fromMap(map);
      saved[article.id] = article;
    }
    return saved;
  }

  Future<void> loadMoreArticles() async {
    print('load more articles, page:$_page, model:$articleModel');

    List<Map<String, Article>> allArticles = await Future.wait(
        [loadMoreArticlesFromDB(), getArticles(model: _model, page: _page)]);
    Map<String, Article> articles1 = allArticles[0];
    Map<String, Article> articles2 = allArticles[1];

    //merge the articles together
    List<Article> newArticles = [];
    for (String articleId in articles2.keys) {
      if (!articles1.containsKey(articleId)) {
        articles1[articleId] = articles2[articleId];
        newArticles.add(articles2[articleId]);
      }
    }

    //merge and sort by create time
    List<Article> merged = articles1.values.toList();
    merged.sort((a1, a2) {
      return a1.createTime.compareTo(a2.createTime);
    });

    if (merged.isNotEmpty) {
      _articles.addAll(merged);
      _page++;
    }

    //TODO: save the new articles later
  }

  Future<Map<String, Article>> getArticles(
      {ArticleModel model = ArticleModel.Top, int page = 1}) async {
    //http://static.owspace.com/?c=api&a=getList&p=1&model=1&page_id=0&create_time=0&client=android&version=1.3.0&time=1467867330&device_id=866963027059338&show_sdv=1

    Map<String, Article> articles = {};
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
              Article article = Article.fromMap(a);
              articles[article.id] = article;
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
