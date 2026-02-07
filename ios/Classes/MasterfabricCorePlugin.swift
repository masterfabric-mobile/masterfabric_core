import Flutter
import UIKit
import AppTrackingTransparency

/// Native iOS plugin for masterfabric_core.
///
/// Handles App Tracking Transparency (ATT) requests via a
/// FlutterMethodChannel so the Dart side can show the iOS ATT dialog
/// and read the current authorization status without any third-party package.
public class MasterfabricCorePlugin: NSObject, FlutterPlugin {

  // MARK: - Plugin Registration

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.masterfabric.app_tracking_transparency",
      binaryMessenger: registrar.messenger()
    )
    let instance = MasterfabricCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // MARK: - Method Call Handler

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

    case "requestTracking":
      requestTrackingAuthorization(result: result)

    case "getTrackingStatus":
      getTrackingAuthorizationStatus(result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - ATT Methods

  /// Presents the App Tracking Transparency authorization dialog.
  /// Returns `true` when the user taps "Allow", `false` otherwise.
  private func requestTrackingAuthorization(result: @escaping FlutterResult) {
    if #available(iOS 14, *) {
      // ATT dialog must be presented after the app is in the foreground.
      // A small delay ensures the app is fully active before the system
      // dialog appears, which prevents it from being silently dismissed.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        ATTrackingManager.requestTrackingAuthorization { status in
          DispatchQueue.main.async {
            result(status == .authorized)
          }
        }
      }
    } else {
      // Pre-iOS 14: ATT framework does not exist; tracking is allowed.
      result(true)
    }
  }

  /// Returns the current tracking authorization status as an integer.
  ///
  /// Values match `ATTrackingManager.AuthorizationStatus`:
  /// - 0: notDetermined
  /// - 1: restricted
  /// - 2: denied
  /// - 3: authorized
  private func getTrackingAuthorizationStatus(result: @escaping FlutterResult) {
    if #available(iOS 14, *) {
      result(Int(ATTrackingManager.trackingAuthorizationStatus.rawValue))
    } else {
      // Pre-iOS 14: considered authorized (no ATT framework).
      result(3)
    }
  }
}
