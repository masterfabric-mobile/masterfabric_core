import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    if let shortcut = connectionOptions.shortcutItem {
      _ = AuraQuickActions.handle(shortcut)
    }
    for context in connectionOptions.urlContexts {
      AuraBridge.handleDeepLink(context.url)
    }
  }

  override func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    completionHandler(AuraQuickActions.handle(shortcutItem))
  }

  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    for context in URLContexts {
      AuraBridge.handleDeepLink(context.url)
    }
    super.scene(scene, openURLContexts: URLContexts)
  }

  override func scene(
    _ scene: UIScene,
    continue userActivity: NSUserActivity
  ) {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      AuraBridge.handleDeepLink(url)
    }
    super.scene(scene, continue: userActivity)
  }
}
