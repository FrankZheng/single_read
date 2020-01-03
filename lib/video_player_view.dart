import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:single_read/model.dart';
import 'package:single_read/utils.dart';
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
    print('build widget, $_orderToPlay, ${_controller.value}');

    if (!_orderToPlay) {
      if (_controller.value.initialized) {
        return Stack(children: <Widget>[
          videoPlayerWidget(hide: true),
          playPauseWidget(play: true)
        ]);
      } else {
        return playPauseWidget(play: true);
      }
    } else {
      if (_controller.value.initialized) {
        return Stack(children: <Widget>[
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
        return loadingIndicator();
      }
    }
  }

  Widget videoPlayerWidget({bool hide}) {
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

  Widget playPauseWidget({bool play}) {
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
    TextStyle textStyle =
        GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white));
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
            ],
          ),
        ),
        VideoProgressIndicator(_controller, allowScrubbing: true)
      ],
    );
  }
}
