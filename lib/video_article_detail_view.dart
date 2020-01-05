import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'article_webview.dart';
import 'model.dart';
import 'utils.dart';
//import 'video_player_view.dart';

class VideoArticleDetailView extends StatefulWidget {
  final Article article;
  VideoArticleDetailView({@required this.article});

  @override
  _VideoArticleDetailViewState createState() => _VideoArticleDetailViewState();
}

class _VideoArticleDetailViewState extends State<VideoArticleDetailView> {
  VideoPlayerController _controller;
  VoidCallback _listener;
  bool _orderToPlay = false;
  bool _fullscreen = false;

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
    _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_listener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build, $_fullscreen');
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

  Widget buildNavBarWidget(
      {double height = 40, bool transparentBackground = true}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
      decoration: transparentBackground
          ? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  Colors.black.withAlpha((255 * 0.5).toInt()),
                  Colors.black.withAlpha((255 * 0.05).toInt())
                ]))
          : BoxDecoration(color: Colors.black),
    );
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
    if (!_orderToPlay) {
      child = Stack(fit: StackFit.expand, children: <Widget>[
        imgCoverWidget(),
        if (_controller.value.initialized) videoPlayerWidget(hide: true),
        playPauseWidget(play: true),
      ]);
    } else {
      if (_controller.value.initialized) {
        child = Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              videoPlayerWidget(hide: false),
              _controller.value.isBuffering
                  ? loadingIndicator()
                  : playPauseWidget(play: !_controller.value.isPlaying),
              Align(
                alignment: Alignment.bottomCenter,
                child: videoProgressIndicator(),
              )
            ]);
      } else {
        child = Stack(fit: StackFit.expand, children: <Widget>[
          loadingIndicator(),
        ]);
      }
    }

    if (!_fullscreen) {
      child.children.add(
        Align(
            alignment: Alignment.topLeft,
            child: buildNavBarWidget(height: 58, transparentBackground: true)),
      );
    }

    return !_fullscreen
        ? Container(
            width: width, height: height, color: Colors.black, child: child)
        : child;
  }

  Widget videoPlayerWidget({@required bool hide}) {
    Widget content = Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
    return hide ? Opacity(opacity: 0.0, child: content) : content;
  }

  Widget playPauseWidget({@required bool play}) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: () {
            if (play) {
              _orderToPlay = true;
              _controller.play();
            } else {
              _controller.pause();
            }
          },
          child: Icon(
            play ? Icons.play_arrow : Icons.pause,
            size: 40,
            color: Colors.white,
          ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Text(
                '${formatDuration(_controller.value.position)}',
                style: textStyle,
              ),
              Spacer(),
              Text(
                '${formatDuration(_controller.value.duration)}',
                style: textStyle,
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: _fullscreen ? _exitFullscreen : _enterFullscreen,
                child: _fullscreen
                    ? Icon(Icons.fullscreen_exit, color: Colors.white, size: 24)
                    : Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
            ],
          ),
        ),
        VideoProgressIndicator(_controller, allowScrubbing: true)
      ],
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
