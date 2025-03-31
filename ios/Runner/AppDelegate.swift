import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
      _ application: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
      let controller = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "app.channel.shared.data", binaryMessenger: controller.binaryMessenger)
      channel.invokeMethod("onSchemeCalled", arguments: url.absoluteString)
      return true
  }
}

