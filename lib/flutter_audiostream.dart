import 'dart:async';

import 'package:flutter/services.dart';

typedef void DurationHandler(Duration duration);

class FlutterAudiostream {
  static const MethodChannel _channel =
  const MethodChannel('flutter.rxla.bz/audio');


  FlutterAudiostream(){
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  Future<String> play(String url) =>
    _channel.invokeMethod('play', url);

  Future<String> pause() =>
    _channel.invokeMethod('pause');

  Future<String> stop() =>
    _channel.invokeMethod('stop');

  void setPlaformCallsHandler(handler) {
    _channel.setMethodCallHandler(handler);
  }

  DurationHandler durationHandler;
  /*
  DurationHandler durationHandler;*/

  Future _platformCallHandler(MethodCall call) async {
    switch(call.method){
      case "audio.onDuration":
        if(durationHandler != null){
          print('FlutterAudiostream._platformCallHandler... -> onDuration : ${call.arguments.toString()}');
        }
        break;
      case "audio.onCurrentPosition":
        if(durationHandler != null){
          print('FlutterAudiostream._platformCallHandler... -> onCurrentPosition : ${call.arguments.toString()}');
        }
        break;
      case "audio.onComplete":
        if(durationHandler != null){
          print('FlutterAudiostream._platformCallHandler... -> onComplete ');
        }
        break;
      case "audio.onError":
        if(durationHandler != null){
          print('FlutterAudiostream._platformCallHandler... -> onError ');
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }
}
