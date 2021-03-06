# flutter audiostream plugin

:warning: this plugin is not working with the last Flutter plugin API update. For now I'm not able to make this works.

Experimental Flutter audio plugin. 
 
## Features
 
- [x] Android & iOS
  - [x] play (remote file)
  - [x] stop
  - [x] pause
  - [x] onComplete
  - [x] onDuration / onCurrentPosition

![screenshot](screenshot.png)

## Usage

[Example](https://github.com/rxlabz/flutter_audio/blob/master/example/lib/main.dart) 

To use this plugin : 

- add the dependency to your [pubspec.yaml](https://github.com/rxlabz/flutter_audio/blob/master/example/pubspec.yaml) file. 
This plugin is not yet published on pub.dartlang,
 so the dependency must be added with a local path.

```yaml
  dependencies:
    flutter:
      sdk: flutter
    audioplayer:
```

- instantiate an AudioPlayer instance

```dart
//...
AudioPlayer audioPlugin = new AudioPlayer();
//...
```

### play, pause , stop

```dart
Future play() async {
  final result = await audioPlayer.play(kUrl);
  if (result == 1) setState(() => playerState = PlayerState.playing);
}
  
Future pause() async {
  final result = await audioPlayer.pause();
  if (result == 1) setState(() => playerState = PlayerState.paused);
}

Future stop() async {
  final result = await audioPlayer.stop();
  if (result == 1)
    setState(() {
    playerState = PlayerState.stopped;
    position = new Duration();
  });
}

```

### duration, position, complete, error (temporary api) 

The dart part of the plugin listen for platform calls :

```dart
//...
audioPlayer.setDurationHandler((d) => setState(() {
  duration = d;
}));

audioPlayer.setPositionHandler((p) => setState(() {
  position = p;
}));

audioPlayer.setCompletionHandler(() {
  onComplete();
  setState(() {
    position = duration;
  });
});

audioPlayer.setErrorHandler((msg) {
  print('audioPlayer error : $msg');
  setState(() {
    playerState = PlayerState.stopped;
    duration = new Duration(seconds: 0);
    position = new Duration(seconds: 0);
  });
});
```

## iOS
   
### :warning: Swift project

To use this plugin your xcode project must be converted to **"Current swift current syntax"** ( Edit/Convert/Current Swift syntax... )

### :warning: iOS App Transport Security

By default iOS forbids loading from non-https url. To cancel this restriction edit your .plist and add :
 
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).