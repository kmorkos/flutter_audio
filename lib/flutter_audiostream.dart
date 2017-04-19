import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAudiostream {
  static const MethodChannel _channel =
  const MethodChannel('flutter_audio');

  static Future<String> get platformVersion =>
    _channel.invokeMethod('getPlatformVersion');

  static Future<String> play(String url) =>
    _channel.invokeMethod('play', url);

  static Future<String> pause() =>
    _channel.invokeMethod('pause');

  static Future<String> stop() =>
    _channel.invokeMethod('stop');

  static void setPlaformCallsHandler(handler) {
    _channel.setMethodCallHandler(handler);
  }
}
