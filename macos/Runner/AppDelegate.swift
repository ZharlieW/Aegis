import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func application(_ application: NSApplication, open urls: [URL]) {
    guard let url = urls.first else { return }
    
    let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "app.channel.shared.data", binaryMessenger: controller.engine.binaryMessenger)
    channel.invokeMethod("onSchemeCalled", arguments: url.absoluteString)
  }
  
  // Handle application activation (when clicking on dock icon)
  override func applicationDidBecomeActive(_ notification: Notification) {
    super.applicationDidBecomeActive(notification)
    
    // Show the main window if it's hidden
    if let window = mainFlutterWindow, !window.isVisible {
      window.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
    }
  }
  
  // Handle window close button click
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      // If no windows are visible, show the main window
      mainFlutterWindow?.makeKeyAndOrderFront(nil)
    }
    return true
  }
}
