import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func application(_ application: NSApplication, open urls: [URL]) -> Bool {
    guard let url = urls.first else { return false }
    
    let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "app.channel.shared.data", binaryMessenger: controller.engine.binaryMessenger)
    channel.invokeMethod("onSchemeCalled", arguments: url.absoluteString)
    
    return true
  }
}
