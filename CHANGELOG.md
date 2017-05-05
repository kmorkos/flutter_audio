# Changelog

## 0.0.2

- new API : 
  - new typedef 
  
```dart
typedef void TimeChangeHandler(Duration duration);
typedef void ErrorHandler(String message);
```
  - setDurationHandler(TimeChangeHandler handler)
  - setPositionHandler(TimeChangeHandler handler)
  - setCompletionHandler(VoidCallback callback)
  - setErrorHandler(ErrorHandler handler)

## 0.0.1

- first POC :
  - methods : play, pause, stop
  - a globalHandler : play, pause, stop