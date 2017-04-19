import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audiostream/flutter_audiostream.dart';

const kUrl = "http://www.rxlabz.com/labz/audio2.mp3";

void main() {
  runApp(new MaterialApp(home: new Scaffold(body: new AudioApp())));
}

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  @override
  _AudioAppState createState() => new _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  Duration duration;
  Duration position;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : null;
  get positionText =>
      position != null ? position.toString().split('.').first : null;

  @override
  void initState() {
    super.initState();
    FlutterAudiostream.setPlaformCallsHandler(_handleAudioPlatformCalls);
  }

  @override
  void dispose() {
    super.dispose();
    FlutterAudiostream.stop();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Material(
            elevation: 2,
            color: Colors.grey[200],
            child: new Container(
                padding: new EdgeInsets.all(16.0),
                child: new Column(mainAxisSize: MainAxisSize.min, children: [
                  new Row(mainAxisSize: MainAxisSize.min, children: [
                    new IconButton(
                        onPressed: isPlaying ? null : () => play(),
                        iconSize: 64.0,
                        icon: new Icon(Icons.play_arrow),
                        color: Colors.cyan),
                    new IconButton(
                        onPressed: isPlaying ? () => pause() : null,
                        iconSize: 64.0,
                        icon: new Icon(Icons.pause),
                        color: Colors.cyan),
                    new IconButton(
                        onPressed: isPlaying || isPaused ? () => stop() : null,
                        iconSize: 64.0,
                        icon: new Icon(Icons.stop),
                        color: Colors.cyan),
                  ]),
                  new Row(mainAxisSize: MainAxisSize.min, children: [
                    new Padding(
                        padding: new EdgeInsets.all(12.0),
                        child: new Stack(children: [
                          new CircularProgressIndicator(
                              value: 1.0,
                              valueColor:
                                  new AlwaysStoppedAnimation(Colors.grey[300])),
                          new CircularProgressIndicator(
                            value: position != null
                                ? position.inMilliseconds /
                                    duration.inMilliseconds
                                : 0.0,
                            valueColor: new AlwaysStoppedAnimation(Colors.cyan),
                          ),
                        ])),
                    new Text(
                        position != null
                            ? "${positionText ?? ''} / ${durationText ?? ''}"
                            : '',
                        style: new TextStyle(fontSize: 24.0))
                  ])
                ]))));
  }

  void play() {
    FlutterAudiostream.play(kUrl).then((String res) {
      print('audio.play -> $res');
      setState(() => playerState = PlayerState.playing);
    });
  }

  void pause() {
    FlutterAudiostream.pause().then((String res) {
      print('audio.pause -> $res');
      setState(() => playerState = PlayerState.paused);
    });
  }

  void stop() {
    FlutterAudiostream.stop().then((String res) {
      print('audio.stop -> $res');
      setState(() {
        playerState = PlayerState.stopped;
        position = null;
      });
    });
  }

  Future<dynamic> _handleAudioPlatformCalls(MethodCall methodCall) async {
    final String method = methodCall.method;

    switch (method) {
      case 'audio.duration':
        setState(() {
          duration = new Duration(milliseconds: methodCall.arguments);
        });
        break;

      case 'audio.onComplete':
        onComplete();
        setState(() {
          position = duration;
        });
        break;

      case 'audio.onCurrentPosition':
        setState(() {
          position = new Duration(milliseconds: methodCall.arguments);
        });
        break;

      default:
        throw new MissingPluginException();
    }
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }
}
