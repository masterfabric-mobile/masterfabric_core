import UIKit

/// Home Screen quick actions (long-press app icon) → `aura://` deep links.
enum AuraQuickActions {
  static let logMeal = "com.masterfabric.aura.quickaction.logMeal"
  static let addWater = "com.masterfabric.aura.quickaction.addWater"
  static let openBody = "com.masterfabric.aura.quickaction.openBody"
  static let openCoach = "com.masterfabric.aura.quickaction.openCoach"

  /// Install static shortcuts with SF Symbols (works even if Info.plist items exist).
  static func register() {
    UIApplication.shared.shortcutItems = [
      UIApplicationShortcutItem(
        type: logMeal,
        localizedTitle: "Log meal",
        localizedSubtitle: "Open Today food sheet",
        icon: UIApplicationShortcutIcon(systemImageName: "fork.knife"),
        userInfo: ["url": "aura://today?action=food" as NSString]
      ),
      UIApplicationShortcutItem(
        type: addWater,
        localizedTitle: "Add water",
        localizedSubtitle: "Open Today water sheet",
        icon: UIApplicationShortcutIcon(systemImageName: "drop.fill"),
        userInfo: ["url": "aura://today?action=water" as NSString]
      ),
      UIApplicationShortcutItem(
        type: openBody,
        localizedTitle: "Body check-in",
        localizedSubtitle: "Review BMI / TDEE baseline",
        icon: UIApplicationShortcutIcon(systemImageName: "figure.stand"),
        userInfo: ["url": "aura://body" as NSString]
      ),
      UIApplicationShortcutItem(
        type: openCoach,
        localizedTitle: "Ask coach",
        localizedSubtitle: "Open Today coach pulse",
        icon: UIApplicationShortcutIcon(systemImageName: "bubble.left.and.bubble.right.fill"),
        userInfo: ["url": "aura://today?action=coach" as NSString]
      ),
    ]
  }

  @discardableResult
  static func handle(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
    let urlString: String
    if let raw = shortcutItem.userInfo?["url"] as? String, !raw.isEmpty {
      urlString = raw
    } else {
      switch shortcutItem.type {
      case logMeal:
        urlString = "aura://today?action=food"
      case addWater:
        urlString = "aura://today?action=water"
      case openBody:
        urlString = "aura://body"
      case openCoach:
        urlString = "aura://today?action=coach"
      default:
        return false
      }
    }
    guard let url = URL(string: urlString) else { return false }
    AuraBridge.handleDeepLink(url)
    return true
  }
}
