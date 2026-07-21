import Flutter
import Foundation
import ActivityKit
import WidgetKit

/// Flutter ↔ Widget / Live Activity / Watch snapshot bridge.
enum AuraBridge {
  static let channelName = "aura/platform"
  private static var channel: FlutterMethodChannel?
  private static var pendingDeepLink: String?

  static func register(messenger: FlutterBinaryMessenger) {
    let ch = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel = ch
    ch.setMethodCallHandler(handle)
    if let pending = pendingDeepLink {
      pendingDeepLink = nil
      ch.invokeMethod("deepLink", arguments: pending)
    }
  }

  /// Called from AppDelegate / SceneDelegate when `aura://…` opens.
  static func handleDeepLink(_ url: URL) {
    let value = url.absoluteString
    if let channel {
      channel.invokeMethod("deepLink", arguments: value)
    } else {
      pendingDeepLink = value
    }
  }

  private static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "updateSnapshot":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad_args", message: "Expected map", details: nil))
        return
      }
      let snap = AuraSnapshot(
        remaining: int(args, "remaining"),
        goal: int(args, "goal"),
        eaten: int(args, "eaten"),
        burned: int(args, "burned"),
        waterMl: int(args, "waterMl"),
        protein: int(args, "protein"),
        carbs: int(args, "carbs"),
        fat: int(args, "fat"),
        warning: (args["warning"] as? String) ?? "",
        updatedAt: Date().timeIntervalSince1970
      )
      snap.save()
      WidgetCenter.shared.reloadAllTimelines()
      AuraWatchSync.shared.push(snap)
      if #available(iOS 16.2, *) {
        Task { await updateLiveActivity(with: snap) }
      }
      result(true)

    case "startLiveActivity":
      guard #available(iOS 16.2, *) else {
        result(FlutterError(code: "unsupported", message: "Need iOS 16.2+", details: nil))
        return
      }
      guard ActivityAuthorizationInfo().areActivitiesEnabled else {
        result(FlutterError(code: "disabled", message: "Live Activities disabled", details: nil))
        return
      }
      let snap = AuraSnapshot.load()
      let attributes = AuraLiveActivityAttributes(title: "AURA Today")
      let state = AuraLiveActivityAttributes.ContentState(
        remaining: snap.remaining,
        eaten: snap.eaten,
        burned: snap.burned,
        waterMl: snap.waterMl,
        goal: snap.goal,
        warning: snap.warning
      )
      do {
        for activity in Activity<AuraLiveActivityAttributes>.activities {
          Task { await activity.end(nil, dismissalPolicy: .immediate) }
        }
        _ = try Activity.request(
          attributes: attributes,
          content: .init(state: state, staleDate: Calendar.current.date(byAdding: .hour, value: 8, to: Date())),
          pushType: nil
        )
        result(true)
      } catch {
        result(FlutterError(code: "start_failed", message: error.localizedDescription, details: nil))
      }

    case "endLiveActivity":
      guard #available(iOS 16.2, *) else {
        result(true)
        return
      }
      for activity in Activity<AuraLiveActivityAttributes>.activities {
        Task { await activity.end(nil, dismissalPolicy: .immediate) }
      }
      result(true)

    case "reloadWidgets":
      WidgetCenter.shared.reloadAllTimelines()
      result(true)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @available(iOS 16.2, *)
  private static func updateLiveActivity(with snap: AuraSnapshot) async {
    let state = AuraLiveActivityAttributes.ContentState(
      remaining: snap.remaining,
      eaten: snap.eaten,
      burned: snap.burned,
      waterMl: snap.waterMl,
      goal: snap.goal,
      warning: snap.warning
    )
    for activity in Activity<AuraLiveActivityAttributes>.activities {
      await activity.update(.init(state: state, staleDate: nil))
    }
  }

  private static func int(_ args: [String: Any], _ key: String) -> Int {
    if let v = args[key] as? Int { return v }
    if let v = args[key] as? NSNumber { return v.intValue }
    return 0
  }
}
