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

import 'package:flutter/services.dart';

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

  Article(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    uid = jsonData['uid'];
    title = jsonData['title'];
    excerpt = jsonData['excerpt'];
    lead = jsonData['lead'];
    thumbnail = jsonData['thumbnail'];
    video = jsonData['video'];
    fm = jsonData['fm'];
    view = jsonData['view'].toString();
    html5 = jsonData['html5'];
    comment = jsonData['comment'].toString();
    good = jsonData['good'].toString();
    author = jsonData['author'];
    avatar = jsonData['avatar'];
    category = jsonData['category'];
  }
}

class Model {
  static Model shared = new Model();

  Future<List<Article>> getTestArticles() async {
    List<Article> articles = [];
    String jsonStr = await rootBundle.loadString('assets/test_data.json');
    Map<String, dynamic> jsonData = json.decode(jsonStr);
    if (jsonData.containsKey('status') && jsonData['status'] == 'ok') {
      if (jsonData.containsKey('code') && jsonData['code'] == 0) {
        if (jsonData.containsKey('datas')) {
          List<dynamic> data = jsonData['datas'];
          for (Map<String, dynamic> a in data) {
            articles.add(new Article(a));
          }
        }
      }
    }
    return articles;
  }
}
