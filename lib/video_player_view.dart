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

  Future<void> _init() async {
    _controller = VideoPlayerController.network(widget.article.video);
    await _controller.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container();
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
