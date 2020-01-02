import 'dart:async';

import 'package:flutter/material.dart';
import 'package:single_read/model.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerState {
  Stopped,
  Initializing,
  Initialized,
  Playing,
  Paused,
  Buffering,
  Completed,
}

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
  VideoPlayerState _state = VideoPlayerState.Stopped;
  bool _orderToPlay = false;
  VoidCallback _listener;

  _VideoPlayerViewState() {
    _listener = () {
      //print('_controller.value changed');
      if (!mounted) {
        return;
      }
      if (_controller.value.initialized) {
        if (_controller.value.isBuffering) {
          _state = VideoPlayerState.Buffering;
        } else {
          _state = _controller.value.isPlaying
              ? VideoPlayerState.Playing
              : VideoPlayerState.Paused;
        }
      }
      //update current position
      //print('duration: ${_controller.value.duration}');
      //print('current position: ${_controller.value.position}');
      setState(() {});
    };
  }

  void _init() {
    _controller = VideoPlayerController.network(widget.article.video);
    setState(() {
      _state = VideoPlayerState.Initializing;
    });
    _controller.initialize().then((_) {
      debugPrint('video initialized');
      setState(() {
        _state = VideoPlayerState.Initialized;
      });
      if (_orderToPlay) {
        Timer(Duration(milliseconds: 100), () {
          //if user has ordered to play the video
          _controller.play();
        });
      }
    });
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
    print('build widgets, $_orderToPlay, $_state');

    double controlSize = 40;
    Widget progressIndicator = CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    Map<VideoPlayerState, Widget> playControls = {
      VideoPlayerState.Playing: pauseBtn(controlSize),
      VideoPlayerState.Paused: playBtn(controlSize),
      VideoPlayerState.Buffering: progressIndicator,
      VideoPlayerState.Initialized: null,
    };
    if (!_orderToPlay) {
      //if user not clicked play icon
      //not show video, show play icon
      if (_state == VideoPlayerState.Initialized) {
        return Stack(
          children: <Widget>[
            videoPlayerWidget(hide: false),
            Center(child: playBtn(controlSize))
          ],
        );
      }
      return Center(child: playBtn(controlSize));
    } else {
      //if use clicked the play icon
      //1. video is initializing, progress indicator
      //2. video is initialized, show video player
      //3. video is playing, show pause icon
      //4. video is paused, show play icon
      //5. video is buffering, show progress indicator
      //6. video is completed, show cover?
      switch (_state) {
        case VideoPlayerState.Initializing:
          return Center(
            child: progressIndicator,
          );
        case VideoPlayerState.Playing:
        case VideoPlayerState.Paused:
        case VideoPlayerState.Buffering:
        case VideoPlayerState.Initialized:
          return Stack(
            children: <Widget>[
              videoPlayerWidget(),
              Center(
                child: playControls[_state],
              )
            ],
          );
        default:
          break;
      }
    }
    return null;
  }

  Widget playBtn(double size) {
    return InkWell(
      onTap: () {
        if (_state == VideoPlayerState.Initialized) {
          _controller.addListener(_listener);
          _controller.play();
        }
        setState(() {
          _orderToPlay = true;
        });
      },
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: size,
      ),
    );
  }

  Widget pauseBtn(double size) {
    return InkWell(
      onTap: () {
        _controller.pause();
      },
      child: Icon(
        Icons.pause,
        color: Colors.white,
        size: size,
      ),
    );
  }

  Widget videoPlayerWidget({bool hide = false}) {
    return hide
        ? Opacity(
            opacity: 0,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ))
        : Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          );
  }
}
