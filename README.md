# flutter_audio

Flutter audio plugin POC. 
 
Features :
 
- [x] Android
  - [x] play (remote file)
  - [x] stop
  - [x] pause
  - [x] onComplete
  - [x] onCurrentPosition
  
- [x] iOS
  - [x] play (remote file)
  - [x] stop
  - [x] pause
  - [x] onComplete
  - [x] onCurrentPosition

![screenshot](img/audioplayer.png)

## :warning: Http url

If you want to allow file from non https server you need to add this to your info.plist

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
