import Foundation
import Flutter
import flutter_audiostream

class PluginRegistry:NSObject{
    
    var audioPlugin:FlutterAudiostreamPlugin
    
    init(withController controller:FlutterViewController){
        audioPlugin = FlutterAudiostreamPlugin(withController:controller)
    }
}
