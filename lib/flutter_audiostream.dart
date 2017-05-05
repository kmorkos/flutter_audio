import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef void TimeChangeHandler(Duration duration);
typedef void ErrorHandler(String message);

class FlutterAudiostream extends ChangeNotifier {
  static const MethodChannel _channel =
      const MethodChannel('flutter.rxla.bz/audio');

  TimeChangeHandler durationHandler;
  TimeChangeHandler positionHandler;
  VoidCallback completionHandler;
  ErrorHandler errorHandler;

  //ValueNotifier<Duration> durationNotifier;

  FlutterAudiostream() {
    _channel.setMethodCallHandler(_platformCallHandler);
    //durationNotifier = new ValueNotifier(new Duration());
  }

  Future<int> play(String url) => _channel.invokeMethod('play', url);

  Future<int> pause() => _channel.invokeMethod('pause');

  Future<int> stop() => _channel.invokeMethod('stop');

  void setDurationHandler(TimeChangeHandler handler) {
    durationHandler = handler;
  }

  void setPositionHandler(TimeChangeHandler handler) {
    positionHandler = handler;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "audio.onDuration":
        final duration = new Duration(milliseconds: call.arguments);
        if (durationHandler != null) {
          durationHandler(duration);
        }
        //durationNotifier.value = duration;
        break;
      case "audio.onCurrentPosition":
        if (positionHandler != null) {
          positionHandler(new Duration(milliseconds: call.arguments));
        }
        break;
      case "audio.onComplete":
        if (completionHandler != null) {
          completionHandler();
        }
        break;
      case "audio.onError":
        if (errorHandler != null) {
          errorHandler(call.arguments);
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }
}
