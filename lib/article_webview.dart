import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:single_read/cache_manager.dart';
import 'package:single_read/device_id.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_info.dart';
import 'model.dart';
import 'package:image/image.dart' as Img;

class ArticleWebView extends StatefulWidget {
  final Article article;

  ArticleWebView({@required this.article});

  @override
  _ArticleWebViewState createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  String _url;
  WebViewController _webViewController;
  bool _pageFinished = false;
  bool _showWebView = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build webview');
    if (_url == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return AnimatedOpacity(
      opacity: _showWebView ? 1.0 : 0.0,
      duration: Duration(milliseconds: 50),
      child: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: _navigationDelegate,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onPageStarted: (_) {
          print('pageStarted');
          setState(() {
            _showWebView = true;
          });
        },
        onPageFinished: (_) {
          print('pageFinished');
          _pageFinished = true;
          _renderArticleContent();
        },
      ),
    );
  }

  void _renderArticleContent() {
    Timer(Duration(milliseconds: 100), () {
      if (_pageFinished && widget.article.contentIsReady) {
        String js = '''
          document.getElementById('content').innerHTML = `${widget.article.content}`;
          ''';
        _webViewController.evaluateJavascript(js);
      }
    });
  }

  FutureOr<NavigationDecision> _navigationDelegate(
      NavigationRequest navigation) async {
    //print('navigation: ${navigation.url}');
    String nurl = navigation.url;
    if (nurl == _url) {
      return NavigationDecision.navigate;
    }
    if (nurl.startsWith('http://static.owspace.com/wap/')) {
      //open another article
      //here need parse the article id out and check the article model by api first
    } else {
      //user external browser to open the url
      if (await canLaunch(nurl)) {
        await launch(nurl);
      } else {
        print('can not launch $nurl');
      }
    }
    return NavigationDecision.prevent;
  }

  Future<void> _init() async {
    //if article.data is null or empty
    //load article detail at this time
    bool useLocalHtmlTemplate = true;
    if (useLocalHtmlTemplate) {
      Article article;
      if (widget.article.content == null || widget.article.content.isEmpty) {
        debugPrint('article content not cached, load it');
        final Model model =
            Provider.of<AppModel>(this.context, listen: false).currentModel;
        article = await model.getArticleDetail(widget.article.id);
        widget.article.content = article.content;
        _renderArticleContent();
        model.updateArticleContent(widget.article);
      } else {
        debugPrint('article content already cached');
        article = widget.article;
      }
      String html = await fillHtmlTemplate(article);
      _url = Uri.dataFromString(html,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString();
    } else {
      final String client = Platform.isAndroid ? "android" : "iOS";
      final String deviceId = await DeviceIdProvider.shared.deviceId;
      //here must hard coded as 1.3.0, or it will show thumbnail
      final String version = "1.3.0"; //await AppInfo.shared.version;
      _url =
          '${widget.article.html5}?client=$client&device_id=$deviceId&version=$version';
    }
    setState(() {});
  }

  Future<String> fillHtmlTemplate(Article article) async {
    String thumbnail = "";
    if (article.model == ArticleModel.Text.index) {
      String src = article.thumbnail;
      File file = await CacheManager.shared.getCachedFile(src);
      if (file != null) {
        //flutter webview doesn't support enable local file access for iOS and Android
        //it just doesn't expose the web view settings to dart api
        //here use base64 as workaround
        Map<String, dynamic> params = {
          'file': file,
          'width': MediaQuery.of(this.context).size.width,
          'fileLimitedSize': Platform.isAndroid ? 200000 : 0,
        };
        String encoded = await compute(encodeFileAsBase64Str, params);
        //String encoded = encodeFileAsBase64Str(params);
        String format = extension(file.path);
        format = format.isEmpty ? 'jpg' : format.substring(1);
        debugPrint('format:$format, encoded:${encoded.length}');
        thumbnail = """
          <div class="thumbnail">
            <img src="data:image/${format.toLowerCase()};base64, $encoded"/>
          </div>
        """;
      } else {
        thumbnail = """
          <div class="thumbnail">
            <img src="$src"/>
          </div>
        """;
      }
    }
    String category = ARTICLE_MODEL_TITLES[ArticleModel.values[article.model]];
    final String html = """
  <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, minimal-ui" id="device">
        <style>
            * {
                margin: 0;
                padding: 0;
            }

            body {
                background-color: #F8F7F5;
                /*-webkit-overflow-scrolling: touch;*/
            }

            p {
                font-size: 16px;
                line-height: 28px;
                text-indent: 33px;
                text-align: justify;
                margin-bottom: 19px;
            }

            img {
                width: 100%;
                height: auto;
                max-width: 100%;
                display: block;
                margin: 0;
                padding: 0;
            }

            h5 {
                color: #AC8B51;
                font-size: 13px;
                letter-spacing: 2px;
                line-height: 19px;
                margin-bottom: 23px;
                margin-top: -10px;
            }

            h2 {
              font-weight: 300;
              margin: 35px 0 20px;
              font-size: 18px;
              line-height: 26px;
              color: #1c1c1c;
            }

            strong {
              font-weight: bold;
            }

            p + hr {
              margin-top: 44px;
              margin-bottom: 20px;
            }

            hr + p {
              margin-top: 34px;
            }

            hr {
              margin: 18px 0 24px 0;
              height: 0.5px;
              border: none;
              border-top: 0.5px solid #c0c0c0;
            }

            .content {
                color: #1c1c1c;
                margin-top: 34px;
            }

            .thumbnail {
                border-bottom: 2px solid #AD8A54;
            }

            .article {
                padding: 15px;
                padding-bottom: 35px;
                font-style: normal;
                color: #1C1C1C;
            }

            .articleHead {
                color: #1C1C1C;
            }
            
            .r1 {
                margin: 2px 0px 12px;
                font-size: 13px;
                line-height: 16px;
                display: -webkit-flex;
                display: flex;
                flex-direction: row;
                justify-content: space-between;
            }

            .category {
                color: #AC8B51;
                font-size: 13px;
                letter-spacing: 2px;
            }

            .updateTime {
                font-size: 9px;
                color: #666;
                letter-spacing: 1px;
            }

            .title {
                font-size: 29px;
                line-height: 35px;
                color: #000;
                font-weight: normal;
            }

            .author {
                margin: 29px 0 20px;
                font-size: 14px;
                line-height: 18px;
                font-weight: normal;
                color: #666;
                display: block;
            }

            .lead {
                margin-top: 38px;
                margin-bottom: 34px;
                font-size: 17px;
                line-height: 28px;
                width: 80%;
                font-weight: normal;
                color: #000;
                text-align: justify;
            }

            /* h1, h2, h3, h4, h5, h6, p, figure, form, blockquote {
               margin: 0;
            } */
            

        </style>
    </head>
    <body>
      $thumbnail

      <div class="article">
          <div class="articleHead">
              <div class="r1">
                  <span class="category">$category</span> 
                  <span class="updateDate">${article.updateTime}</span>
              </div>
              <h1 class="title">${article.title}</h1>
              <h6 class="author">${article.author}</h6>
              <h5 class="lead">${article.lead}</h5>
          </div>

          <hr />

          <div id="content">
              
          </div>
      </div>
    </body>
</html>
""";
    return html;
  }
}

String encodeFileAsBase64Str(Map<String, dynamic> params) {
  File file = params['file'];
  double width = params['width'];
  int limitedSize = params['fileLimitedSize'];
  Uint8List origin = file.readAsBytesSync();
  if (limitedSize > 0) {
    if (origin.length > limitedSize) {
      Img.Image image = Img.decodeImage(origin);
      debugPrint('origin.size: ${image.width}, ${image.height}');
      Img.Image thumbnail = Img.copyResize(image,
          width: width.toInt(), interpolation: Img.Interpolation.average);
      List<int> resized = Img.encodeJpg(thumbnail);
      debugPrint('origin: ${origin.length}, resized:${resized.length}');
      return base64Encode(resized);
    }
  }
  return base64Encode(origin);
}
