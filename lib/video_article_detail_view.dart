import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'article_webview.dart';
import 'model.dart';
import 'utils.dart';

class VideoArticleDetailView extends StatefulWidget {
  final Article article;
  VideoArticleDetailView({@required this.article});

  @override
  _VideoArticleDetailViewState createState() => _VideoArticleDetailViewState();
}

class _VideoArticleDetailViewState extends State<VideoArticleDetailView> {
  VideoPlayerController _controller;
  VoidCallback _listener;
  bool _fullscreen = false;
  bool _ctrlPanelVisible = false;

  _VideoArticleDetailViewState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _controller = VideoPlayerController.network(widget.article.video);
    _controller.addListener(_listener);
    _controller.initialize().then((_) {
      _controller.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _exitFullscreen();
    _controller.removeListener(_listener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('build, ${_controller.value}');
    double top = MediaQuery.of(context).padding.top;
    //print('top: $top');
    Widget mixed = SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            Container(
              height: top,
              color: Colors.black,
            ),
            buildVideoWidget(),
            Divider(
              color: Colors.red,
              height: 2,
            ),
            Expanded(
              child: ArticleWebView(article: widget.article),
            )
          ],
        ));

    return Scaffold(body: _fullscreen ? buildVideoWidget() : mixed);
  }

  Widget imgCoverWidget() {
    return Image.network(
      widget.article.thumbnail,
      fit: BoxFit.cover,
    );
  }

  Widget buildVideoWidget() {
    double width, height;
    if (!_fullscreen) {
      width = MediaQuery.of(context).size.width;
      height = width * 9 / 16;
    }
    //print('$width, $height');
    Stack child;
    if (_controller.value.initialized) {
      child = Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller)),
            _controller.value.isBuffering
                ? loadingIndicator()
                : buildControlPanel()
          ]);
    } else {
      child = Stack(fit: StackFit.expand, children: <Widget>[
        imgCoverWidget(),
        loadingIndicator(),
      ]);
    }

    return InkWell(
      onTap: () {
        //print('onTap');
        setState(() {
          _ctrlPanelVisible = !_ctrlPanelVisible;
        });
      },
      child: Container(
          width: width, height: height, color: Colors.black, child: child),
    );
  }

  Widget buildControlPanel() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: _ctrlPanelVisible ? 1.0 : 0.0,
      child: Container(
          color: Colors.black.withAlpha(150),
          child: Stack(
            alignment: Alignment.topLeft,
            fit: StackFit.loose,
            children: <Widget>[
              //nav bar, add top padding in the full screen mode
              Padding(
                padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: _fullscreen ? MediaQuery.of(context).padding.top : 5),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 30,
                        )),
                  ],
                ),
              ),
              playPauseWidget(play: !_controller.value.isPlaying),
              Align(
                alignment: Alignment.bottomCenter,
                child: videoProgressIndicator(),
              ),
            ],
          )),
    );
  }

  Widget playPauseWidget({@required bool play}) {
    return Center(
      child: InkWell(
        onTap: () {
          if (play) {
            _controller.play();
            _ctrlPanelVisible = false;
          } else {
            _controller.pause();
            _ctrlPanelVisible = true;
          }
        },
        child: Icon(
          play ? Icons.play_arrow : Icons.pause,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget loadingIndicator() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
  }

  Widget videoProgressIndicator() {
    //current position / duration
    //progress indicator
    TextStyle textStyle = GoogleFonts.roboto(
        textStyle: TextStyle(color: Colors.white, fontSize: 14));
    Text currentPosWidget = Text(
      '${formatDuration(_controller.value.position)}',
      style: textStyle,
    );
    Text totalDurWidget = Text(
      '${formatDuration(_controller.value.duration)}',
      style: textStyle,
    );
    Widget fullscreenCtrl = InkWell(
      onTap: _fullscreen ? _exitFullscreen : _enterFullscreen,
      child: _fullscreen
          ? Icon(Icons.fullscreen_exit, color: Colors.white, size: 24)
          : Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 24,
            ),
    );
    Widget videoProgressIndicator = VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
      padding: EdgeInsets.zero,
    );

    return !_fullscreen
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    currentPosWidget,
                    Spacer(),
                    totalDurWidget,
                    SizedBox(
                      width: 5,
                    ),
                    fullscreenCtrl,
                  ],
                ),
              ),
              videoProgressIndicator,
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                currentPosWidget,
                SizedBox(
                  width: 10,
                ),
                Expanded(child: videoProgressIndicator),
                SizedBox(
                  width: 10,
                ),
                totalDurWidget,
                SizedBox(
                  width: 5,
                ),
                fullscreenCtrl
              ],
            ),
          );
  }

  void _enterFullscreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _fullscreen = true;
  }

  void _exitFullscreen() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _fullscreen = false;
  }
}
