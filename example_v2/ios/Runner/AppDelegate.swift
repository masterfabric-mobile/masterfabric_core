import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AuraWatchSync.shared.activate()
    AuraQuickActions.register()
    if let url = launchOptions?[.url] as? URL {
      AuraBridge.handleDeepLink(url)
    }
    if let shortcut = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
      // Defer until Flutter channel is ready via AuraBridge pending queue.
      _ = AuraQuickActions.handle(shortcut)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    completionHandler(AuraQuickActions.handle(shortcutItem))
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AuraBridge") {
      AuraBridge.register(messenger: registrar.messenger())
    }
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    AuraBridge.handleDeepLink(url)
    return super.application(app, open: url, options: options)
  }
}
