import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
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
