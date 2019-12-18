import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, statusBarBrightness: Brightness.light));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: Colors.blue,
          ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController pageController = new PageController();
  int itemCount = 4;
  List<Article> articles = [];

  void init() async {
    List<Article> articles = await Model.shared.getTestArticles();
    setState(() {
      this.articles = articles;
    });
    print(articles.length);
  }

  void _onPageChanged(int index) {
    //here provide a chance to load next page of articles
    if (index == itemCount - 1) {
      setState(() {
        itemCount = itemCount + 4;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Center(
            child: PageView.builder(
      itemCount: itemCount,
      scrollDirection: Axis.vertical,
      controller: pageController,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        return contentPage(index);
      },
    )));
  }

  Widget contentPage(int index) {
    double width = MediaQuery.of(context).size.width;
    //show image
    //read line
    //TO READ
    if (articles.isEmpty) {
      return Center(
        child: Text('loading'),
      );
    }

    Article article = articles[index];
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              child: CachedNetworkImage(
                imageUrl: article.thumbnail,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(article.title),
            SizedBox(
              height: 10,
            ),
            Text(article.excerpt == null ? '' : article.excerpt),
            SizedBox(
              height: 10,
            ),
            Text(article.author)
          ],
        ),
      ),
    );
  }
}
