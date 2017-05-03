import UIKit
import AVFoundation
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var plugins: PluginRegistry?
    
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        
        guard let flutterController = self.window.rootViewController as? Flutter.FlutterViewController else {
            print("no FlutterViewController")
            return true
        }
        
        plugins = PluginRegistry(withController: flutterController)
        
        return true
    }
}
