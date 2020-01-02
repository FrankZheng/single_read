import 'package:flutter/material.dart';
import 'package:single_read/model.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final Article article;
  final double coverWidth;
  final double coverHeight;
  VideoPlayerView({this.article, this.coverWidth, this.coverHeight});

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController _controller;
  VoidCallback _listener;
  bool _orderToPlay = false;

  _VideoPlayerViewState() {
    _listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  Future<void> _init() async {
    _controller = VideoPlayerController.network(widget.article.video);
    _controller.addListener(_listener);
    _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_listener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build widget, $_orderToPlay, ${_controller.value.initialized}');

    if (!_orderToPlay) {
      if (_controller.value.initialized) {
        return Stack(children: <Widget>[
          Opacity(
            opacity: 0.0,
            child: Container(
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ),
          Center(
            child: InkWell(
                onTap: () {
                  _controller.play();
                  setState(() {
                    _orderToPlay = true;
                  });
                },
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                )),
          ),
        ]);
      }
    } else {
      return Stack(children: <Widget>[
        Container(
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        Center(
          child: InkWell(
              onTap: () {
                _controller.pause();
              },
              child: Icon(
                Icons.pause,
                color: Colors.white,
                size: 40,
              )),
        ),
      ]);
    }

    if (_controller.value.initialized) {
      return Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Center(
            child: InkWell(
                onTap: () {
                  _controller.play();
                },
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                )),
          ),
        ],
      );
    } else {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    }
  }
}
