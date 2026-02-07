import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Tracking authorization status values matching iOS ATTrackingManager.AuthorizationStatus
///
/// - [notDetermined]: The user has not yet received a tracking authorization request.
/// - [restricted]: Authorization to access tracking data is restricted.
/// - [denied]: The user denies authorization to access tracking data.
/// - [authorized]: The user authorizes access to tracking data.
enum TrackingStatus {
  /// The user has not yet received a tracking authorization request.
  notDetermined,

  /// Authorization to access tracking data is restricted.
  restricted,

  /// The user denies authorization to access tracking data.
  denied,

  /// The user authorizes access to tracking data.
  authorized,
}

/// Helper class for iOS App Tracking Transparency (ATT).
///
/// This helper provides a platform channel bridge to the native iOS
/// ATTrackingManager API without requiring any external packages.
///
/// On non-iOS platforms (Android, Web, etc.), all methods return safe
/// defaults (authorized / true) since ATT is an iOS-only concept.
///
/// Usage:
/// ```dart
/// // Request tracking authorization (shows iOS dialog)
/// final bool isAuthorized = await AppTrackingTransparencyHelper.instance
///     .requestTrackingAuthorization();
///
/// // Check current status without prompting
/// final TrackingStatus status = await AppTrackingTransparencyHelper.instance
///     .getTrackingAuthorizationStatus();
/// ```
class AppTrackingTransparencyHelper {
  static final AppTrackingTransparencyHelper _instance =
      AppTrackingTransparencyHelper._internal();

  static AppTrackingTransparencyHelper get instance => _instance;

  AppTrackingTransparencyHelper._internal();

  /// Factory constructor for easy access
  factory AppTrackingTransparencyHelper() => _instance;

  /// Platform channel name for communication with native iOS code
  static const String _channelName =
      'com.masterfabric.app_tracking_transparency';

  /// Method channel used to invoke native iOS ATT methods
  final MethodChannel _channel = const MethodChannel(_channelName);

  /// Requests the user's authorization to access app-related data
  /// for tracking the user or the device.
  ///
  /// On iOS 14+, this presents the system ATT dialog to the user.
  /// On iOS < 14 or non-iOS platforms, returns `true` immediately.
  ///
  /// Returns `true` if the user authorized tracking, `false` otherwise.
  Future<bool> requestTrackingAuthorization() async {
    // ATT is only relevant on iOS
    if (!Platform.isIOS) {
      debugPrint(
        '🔒 ATT: Skipping tracking authorization request (not iOS platform)',
      );
      return true;
    }

    try {
      final bool? result = await _channel.invokeMethod<bool>('requestTracking');
      final bool authorized = result ?? false;

      debugPrint(
        '🔒 ATT: Tracking authorization ${authorized ? '✅ AUTHORIZED' : '❌ DENIED'}',
      );

      return authorized;
    } on PlatformException catch (e) {
      debugPrint('🔒 ATT: Error requesting tracking authorization: $e');
      return false;
    } on MissingPluginException {
      debugPrint(
        '🔒 ATT: Platform channel not available (missing native implementation)',
      );
      return false;
    }
  }

  /// Returns the current tracking authorization status without
  /// prompting the user.
  ///
  /// On iOS 14+, this queries ATTrackingManager.trackingAuthorizationStatus.
  /// On iOS < 14 or non-iOS platforms, returns [TrackingStatus.authorized].
  Future<TrackingStatus> getTrackingAuthorizationStatus() async {
    // ATT is only relevant on iOS
    if (!Platform.isIOS) {
      debugPrint(
        '🔒 ATT: Returning authorized status (not iOS platform)',
      );
      return TrackingStatus.authorized;
    }

    try {
      final int? statusValue =
          await _channel.invokeMethod<int>('getTrackingStatus');

      final TrackingStatus status = _statusFromInt(statusValue ?? 0);

      debugPrint('🔒 ATT: Current tracking status: ${status.name}');

      return status;
    } on PlatformException catch (e) {
      debugPrint('🔒 ATT: Error getting tracking status: $e');
      return TrackingStatus.notDetermined;
    } on MissingPluginException {
      debugPrint(
        '🔒 ATT: Platform channel not available (missing native implementation)',
      );
      return TrackingStatus.notDetermined;
    }
  }

  /// Converts an integer status value from the native side to a [TrackingStatus] enum.
  ///
  /// Values match iOS ATTrackingManager.AuthorizationStatus:
  /// - 0: notDetermined
  /// - 1: restricted
  /// - 2: denied
  /// - 3: authorized
  TrackingStatus _statusFromInt(int value) {
    switch (value) {
      case 0:
        return TrackingStatus.notDetermined;
      case 1:
        return TrackingStatus.restricted;
      case 2:
        return TrackingStatus.denied;
      case 3:
        return TrackingStatus.authorized;
      default:
        return TrackingStatus.notDetermined;
    }
  }
}
