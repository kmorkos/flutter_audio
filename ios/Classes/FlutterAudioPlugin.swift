import Foundation
import Flutter
import AVKit
import AVFoundation

///
/// Flutter audio player plugin
///
@objc open class FlutterAudiostreamPlugin: NSObject {
    
    var channel: FlutterMethodChannel
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    var duration: CMTime = CMTimeMake(0, 1)
    var position: CMTime = CMTimeMake(0, 1)
    
    var lastUrl: String?
    
    fileprivate var isPlaying: Bool = false
    
    public init(withController controller: FlutterViewController) {
        print("init FlutterAudiostreamPlugin...")
        channel = FlutterMethodChannel(name: "flutter.rxla.bz/audio", binaryMessenger: controller)
        super.init()
        channel.setMethodCallHandler(onMethodCall)
    }
    
    open func onMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        print("onMethodCall \(call.method) \(String(describing: call.arguments))")
        
        switch (call.method) {
        case "play":
            togglePlay(call.arguments as! String)
        case "pause":
            pause()
        case "stop":
            stop()
        default:
            result(FlutterMethodNotImplemented)
        }
        result(1)
    }
    
    fileprivate func togglePlay(_ url: String) {
        
        if player == nil {
            if url != lastUrl {
                playerItem = AVPlayerItem(url: URL(string: url)!)
                lastUrl = url
                
                // soundComplete handler
                NotificationCenter.default.addObserver(
                    forName: Notification.Name.AVPlayerItemDidPlayToEndTime,
                    object: playerItem,
                    queue: nil, using: onSoundComplete)
                
                player = AVPlayer(playerItem: playerItem)
                
                // is sound ready
                player!.currentItem?.addObserver(self, forKeyPath: #keyPath(player.currentItem.status), context: nil)
                
                // stream player position
                player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: nil, using: onTimeInterval)
            }
        }
        
        if isPlaying == true {
            pause()
        } else {
            
            updateDuration()
            player!.play()
            isPlaying = true
        }
    }
    
    func updateDuration(){
        if let d = player?.currentItem!.duration{
            duration = d
            if duration.seconds > 0{
                let mseconds = duration.seconds * 1000
                channel.invokeMethod("audio.onDuration", arguments: Int(mseconds))
            }
        }
    }
    
    func onTimeInterval(time:CMTime){
        let mseconds = time.seconds * 1000
        channel.invokeMethod("audio.onCurrentPosition", arguments: Int(mseconds))
    }
    
    func pause() {
        player!.pause()
        isPlaying = false
    }
    
    func stop() {
        if (isPlaying) {
            player!.pause()
            player!.seek(to: CMTimeMake(0, 1))
            isPlaying = false
            print("stop")
        }
    }
    
    func onSoundComplete(note: Notification) {
        self.isPlaying = false
        self.player!.pause()
        self.player!.seek(to: CMTimeMake(0, 1))
        channel.invokeMethod("audio.onComplete", arguments: nil)
    }
    
    /// player ready observer
    override open func observeValue(
        forKeyPath keyPath: String?, of object: Any?,
        change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == "player.currentItem.status" {
            if (player!.currentItem!.status == AVPlayerItemStatus.readyToPlay) {
                updateDuration()
            } else if (player!.currentItem!.status == AVPlayerItemStatus.failed) {
                channel.invokeMethod("audio.onError", arguments: "AVPlayerItemStatus.failed")
            }
        }
    }
    
    deinit{
        if let p = player{
            p.removeTimeObserver(onTimeInterval)
            p.currentItem?.removeObserver(self, forKeyPath: #keyPath(player.currentItem.status))
            NotificationCenter.default.removeObserver(onSoundComplete)
        }
    }
    
}
