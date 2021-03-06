import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model.dart';
import 'utils.dart';

enum PlayerState {
  Stopped,
  Preparing, //buffering, call player.play(), but not play really
  Playing,
  Paused,
  Completed,
  Failed, //some error happened
}

const Map<AudioPlayerState, PlayerState> StateMapping = {
  AudioPlayerState.STOPPED: PlayerState.Stopped,
  AudioPlayerState.PLAYING: PlayerState.Playing,
  AudioPlayerState.PAUSED: PlayerState.Paused,
  AudioPlayerState.COMPLETED: PlayerState.Completed,
};

class AudioPlayerCoverView extends StatefulWidget {
  final Article article;
  final double coverWidth;
  final double coverHeight;
  AudioPlayerCoverView({this.article, this.coverWidth, this.coverHeight});

  @override
  _AudioPlayerCoverViewState createState() => _AudioPlayerCoverViewState();
}

class _AudioPlayerCoverViewState extends State<AudioPlayerCoverView> {
  final AudioPlayer audioPlayer = new AudioPlayer();
  Duration audioDuration;
  Duration currentPosition;
  PlayerState state = PlayerState.Stopped;

  StreamSubscription durationSubscription;
  StreamSubscription audioPositionSubscription;
  StreamSubscription playerStateSubscription;
  //TODO: handle error subscription

  @override
  void initState() {
    //prepare audio
    audioPlayer.setUrl(widget.article.fm);

    durationSubscription = audioPlayer.onDurationChanged.listen((Duration dur) {
      //debugPrint('duration is $dur');
      if (audioDuration == null) {
        durationSubscription.cancel();
        durationSubscription = null;
        setState(() => audioDuration = dur);
      }
    });

    audioPositionSubscription =
        audioPlayer.onAudioPositionChanged.listen((Duration pos) {
      //debugPrint('postion update:$pos');
      if (currentPosition?.inSeconds == pos.inSeconds) {
        //remove unnessary updates
        return;
      }
      setState(() {
        if (state == PlayerState.Preparing) {
          state = PlayerState.Playing;
        }
        currentPosition = pos;
      });
    });

    playerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      setState(() {
        if (s == AudioPlayerState.PLAYING && currentPosition == null) {
          state = PlayerState.Preparing;
        } else {
          state = StateMapping[s];
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    durationSubscription?.cancel();
    audioPositionSubscription?.cancel();
    playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showCover = state == PlayerState.Stopped ||
        state == PlayerState.Preparing ||
        state == PlayerState.Completed;
    return Stack(
      children: <Widget>[
        showCover
            ? coverWidget()
            : Positioned(
                child: playControlsBar(widget.coverWidth),
                bottom: 0,
              ),
      ],
    );
  }

  Widget coverWidget() {
    return Center(
      child: state == PlayerState.Stopped || state == PlayerState.Completed
          ? InkWell(
              onTap: () {
                if (state == PlayerState.Completed) {
                  audioPlayer.play(widget.article.fm);
                } else {
                  audioPlayer.resume();
                }
              },
              child: Container(
                  width: 60,
                  height: 60,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  child: Icon(Icons.music_note, color: Colors.white, size: 40)),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
    );
  }

  Widget playControlsBar(double width) {
    return Container(
        width: width,
        height: 50,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () async {
                if (state == PlayerState.Playing) {
                  await audioPlayer.pause();
                } else if (state == PlayerState.Completed) {
                  await audioPlayer.play(widget.article.fm);
                } else {
                  await audioPlayer.resume();
                }
              },
              child: Icon(
                state == PlayerState.Playing ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
                '${formatDuration(currentPosition)} / ${formatDuration(audioDuration)}',
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal))),
            Expanded(
              child: Slider(
                activeColor: Colors.red,
                inactiveColor: Colors.white,
                min: 0,
                max: audioDuration.inMilliseconds.toDouble(),
                value: currentPosition.inMilliseconds.toDouble(),
                onChangeStart: (value) {
                  //debugPrint('slider value start change: $value');
                  audioPositionSubscription.pause();
                },
                onChangeEnd: (value) async {
                  //debugPrint('slider value end change: $value');
                  await audioPlayer.seek(Duration(milliseconds: value.toInt()));
                  Timer(Duration(seconds: 1), () {
                    audioPositionSubscription.resume();
                  });
                },
                onChanged: (value) {
                  //debugPrint('slider value changed: $value');
                  setState(() {
                    currentPosition = Duration(milliseconds: value.toInt());
                  });
                },
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.black.withAlpha((255 * 0.3).toInt()),
              Colors.black.withAlpha((255 * 0.5).toInt())
            ])));
  }
}
