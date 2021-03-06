import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:path/path.dart';
import 'package:single_read/device_id.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'app_info.dart';
import 'utils.dart';

const String DB_NAME = "app.db";
const String ARTICLES_TABLE_NAME = 'articles';

enum ArticleModel { Top, Text, Video, Audio, Calendar, Activity }

const Map<ArticleModel, String> ARTICLE_MODEL_TITLES = {
  ArticleModel.Top: '单读',
  ArticleModel.Text: '文字',
  ArticleModel.Audio: '声音',
  ArticleModel.Video: '影像',
  ArticleModel.Calendar: '单向历',
};

class ResponseWrapper {
  final String status;
  final int code;
  final String msg;
  final dynamic datas;

  ResponseWrapper({this.status, this.code, this.msg, this.datas});

  factory ResponseWrapper.fromMap(Map<String, dynamic> map) {
    return ResponseWrapper(
        status: map['status'],
        code: map['code'],
        msg: map['msg'],
        datas: map['datas']);
  }

  bool get isSuccessful => code == 0;

  @override
  String toString() {
    return 'status: $status, msg: $msg, code: $code, datas: ${datas.length}';
  }
}

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
  String content;
  int rowId; //table id

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
      this.content,
      this.rowId});

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      uid: map['uid'],
      title: map['title'],
      excerpt: map['excerpt'],
      lead: map['lead'],
      thumbnail: map['thumbnail'],
      video: map['video'],
      fm: map['fm'],
      view: map['view'].toString(),
      html5: map['html5'],
      comment: map['comment'].toString(),
      good: map['good'].toString(),
      author: map['author'],
      avatar: map['avatar'],
      category: map['category'],
      model: safeParseInt(map['model']),
      updateTime: map['update_time'].toString(),
      createTime: safeParseInt(map['create_time']),
      parseXML: safeParseInt(map['parseXML']),
      content: map['content'],
      rowId: map['row_id'],
    );
  }

  //for insert / update db row
  // not include 'content' field here
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  bool socialDataUpdated(Article other) {
    return other.view != view ||
        other.good != other.good ||
        other.comment != comment;
  }

  Map<String, dynamic> socialDataMap() {
    return {'view': view, 'comment': comment, 'good': good};
  }

  bool get contentIsReady => content != null && content.isNotEmpty;
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
  int _pageSize;
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
    //Sqflite.devSetDebugModeOn(true);
    String dbPath = join(await getDatabasesPath(), DB_NAME);
    print('dbPath:$dbPath');
    _database = openDatabase(dbPath, onCreate: (db, version) {
      return db.execute('''
            CREATE TABLE IF NOT EXISTS $ARTICLES_TABLE_NAME(
            row_id INTEGER PRIMARY KEY AUTOINCREMENT,
            id TEXT UNIQUE,
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
            content TEXT);
            CREATE INDEX idx_articles_model ON articles (model);
            CREATE INDEX idx_articles_create_time ON articles (create_time);
            ''');
    }, version: 1);
    return _database;
  }

  List<Article> get articles => _articles;
  ArticleModel get articleModel => _model;

  Future<Map<String, Article>> loadMoreArticlesFromDB() async {
    debugPrint(
        'load more articles from db, pageSize:$_pageSize, offset:${_articles.length}, $articleModel');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ARTICLES_TABLE_NAME,
        where: _model == ArticleModel.Top ? 'model != ?' : 'model = ?',
        whereArgs: _model == ArticleModel.Top
            ? [ArticleModel.Calendar.index]
            : [_model.index],
        orderBy: 'create_time DESC',
        limit: _pageSize,
        offset: _articles.length);
    debugPrint('load ${maps.length} records from db');

    Map<String, Article> saved = {};
    for (Map<String, dynamic> map in maps) {
      Article article = Article.fromMap(map);
      saved[article.id] = article;
    }
    return saved;
  }

  Future<void> loadMoreArticles() async {
    debugPrint('load more articles, page:$_page, model:$articleModel');

    List<Map<String, Article>> allArticles = await Future.wait(
        [loadMoreArticlesFromDB(), fetchArticles(model: _model, page: _page)]);
    Map<String, Article> articles1 = allArticles[0]; //local
    Map<String, Article> articles2 = allArticles[1]; //remote
    if (articles2.isNotEmpty) {
      //fix the _pageSize by received articles
      _pageSize = articles2.length;
    }

    //merge the articles together
    List<Article> newArticles = [];
    List<Article> modifiedArticles = [];
    for (String articleId in articles2.keys) {
      Article article = articles2[articleId];
      if (!articles1.containsKey(articleId)) {
        newArticles.add(article);
      } else {
        //update local articles
        Article oldArticle = articles1[articleId];
        article.rowId = oldArticle.rowId; //for update db
        article.content = oldArticle.content;
        if (oldArticle.socialDataUpdated(article)) {
          modifiedArticles.add(article);
        }
      }
      articles1[articleId] = article;
    }
    debugPrint('has ${newArticles.length} new articles');
    debugPrint('has ${modifiedArticles.length} modified articles');

    //sort by create time
    List<Article> merged = articles1.values.toList();
    merged.sort((a1, a2) {
      return a2.createTime.compareTo(a1.createTime);
    });

    if (merged.isNotEmpty) {
      //only add articles which amount <= _pageSize
      _articles.addAll(merged.sublist(
          0, merged.length > _pageSize ? _pageSize : merged.length));
      _page++;
    }

    final db = await database;
    for (Article article in newArticles) {
      // if (article.model == ArticleModel.Activity.index) {
      //   //don't cache the activity article
      //   continue;
      // }
      article.rowId = await db.insert(
        ARTICLES_TABLE_NAME,
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    //update modified articles
    //for now we only check if the social data updated
    //only update social data
    for (Article article in modifiedArticles) {
      await db.update(ARTICLES_TABLE_NAME, article.socialDataMap(),
          where: 'row_id = ?', whereArgs: [article.rowId]);
    }
  }

  Future<Map<String, Article>> fetchArticles(
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
        "client": Platform.isAndroid ? "android" : "iOS",
        "version": await AppInfo.shared.version,
        "time": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "device_id": await DeviceIdProvider
            .shared.deviceId, //figure out the random number logic later
        "show_sdv": 1
      });
      ResponseWrapper res = ResponseWrapper.fromMap(response.data);
      if (res.isSuccessful) {
        Article lastArticle;
        //datas is a json list
        for (Map<String, dynamic> a in res.datas) {
          if (!a.containsKey('create_time')) {
            //fix the create_time, activity doesn't have a create_time
            int createTime = lastArticle != null
                ? lastArticle.createTime - 1
                : DateTime.now().millisecondsSinceEpoch ~/ 1000; //seconds
            a['create_time'] = createTime.toString();
          }
          Article article = Article.fromMap(a);
          if (article.model == 11) {
            continue;
          }
          articles[article.id] = article;
          lastArticle = article;
        }
        debugPrint('load ${articles.length} articles from server');
      } else {
        print('Failed to fetch articles, ${res.toString()}');
      }
      //TODO: handle erros

    } on DioError catch (e) {
      //TODO: handle errors
      print(e);
    }
    return articles;
  }

  Future<Article> getArticleDetail(String articleId) async {
    //http://static.owspace.com/?c=api&a=getPost&post_id=296471&show_sdv=1
    try {
      Response response = await _dio.get("/", queryParameters: {
        "c": "api",
        "a": "getPost",
        "post_id": articleId,
        "show_sdv": 1
      });
      ResponseWrapper res = ResponseWrapper.fromMap(response.data);
      if (res.isSuccessful) {
        //datas is a json object
        return Article.fromMap(res.datas);
      }
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }

  Future<int> updateArticleContent(Article article) async {
    final db = await database;
    return await db.update(ARTICLES_TABLE_NAME, {'content': article.content},
        where: 'row_id = ?', whereArgs: [article.rowId]);
  }
}
