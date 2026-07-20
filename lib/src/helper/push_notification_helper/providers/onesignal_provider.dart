import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:masterfabric_core/src/helper/push_notification_helper/abstract/push_notification_provider_base.dart';
import 'package:masterfabric_core/src/helper/push_notification_helper/models/push_notification_models.dart';

/// OneSignal Push Notification Provider
///
/// Implementation of [PushNotificationProviderBase] using OneSignal SDK.
/// Supports push notifications, in-app messages, and user targeting.
///
/// **Configuration Example (in app_config.json):**
/// ```json
/// "providers": {
///   "onesignal": {
///     "enabled": true,
///     "appId": "YOUR_ONESIGNAL_APP_ID"
///   }
/// }
/// ```
///
/// **Usage Example:**
/// ```dart
/// final provider = OneSignalProvider();
/// await provider.initialize(config);
///
/// // Subscribe to notification events
/// provider.onNotificationReceived.listen((notification) {
///   print('Received: ${notification.title}');
/// });
///
/// // Set user ID after login
/// await provider.setExternalUserId('user_123');
/// ```
class OneSignalProvider extends PushNotificationProviderBase {
  /// Stream controllers for notification events
  final StreamController<PushNotificationData> _notificationReceivedController =
      StreamController<PushNotificationData>.broadcast();

  final StreamController<NotificationActionResult> _notificationOpenedController =
      StreamController<NotificationActionResult>.broadcast();

  /// Initialization state
  bool _isInitialized = false;

  /// OneSignal App ID
  String? _appId;

  @override
  PushNotificationProviderType get providerType => PushNotificationProviderType.onesignal;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Stream<PushNotificationData> get onNotificationReceived =>
      _notificationReceivedController.stream;

  @override
  Stream<NotificationActionResult> get onNotificationOpened =>
      _notificationOpenedController.stream;

  @override
  Future<bool> initialize(ProviderConfig config) async {
    if (_isInitialized) {
      debugPrint('🔔 OneSignal: Already initialized');
      return true;
    }

    try {
      _appId = config.settings['appId'] as String?;
      
      if (_appId == null || _appId!.isEmpty) {
        debugPrint('❌ OneSignal: App ID is required');
        return false;
      }

      // Keep release logs quiet (avoid leaking push/debug metadata).
      OneSignal.Debug.setLogLevel(
        kReleaseMode ? OSLogLevel.none : OSLogLevel.warn,
      );
      OneSignal.initialize(_appId!);

      // Setup notification handlers
      _setupNotificationHandlers();

      _isInitialized = true;
      debugPrint('✅ OneSignal: Initialized successfully with App ID: ${_appId!.substring(0, 8)}...');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Initialization failed: $e');
      return false;
    }
  }

  /// Setup notification event handlers
  void _setupNotificationHandlers() {
    // Handle notification received in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint('🔔 OneSignal: Notification received in foreground');
      
      final notification = _convertToNotificationData(
        event.notification,
        isInForeground: true,
      );
      _notificationReceivedController.add(notification);

      // Display the notification
      event.preventDefault();
      event.notification.display();
    });

    // Handle notification clicked/opened
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('🔔 OneSignal: Notification clicked');
      
      final notification = _convertToNotificationData(
        event.notification,
        isInForeground: false,
      );
      
      final result = NotificationActionResult(
        notification: notification,
        actionId: event.result.actionId,
        isDismissed: false,
      );
      _notificationOpenedController.add(result);
    });

    // Handle permission changes
    OneSignal.Notifications.addPermissionObserver((permission) {
      debugPrint('🔔 OneSignal: Permission changed to: $permission');
    });
  }

  /// Convert OneSignal notification to common format
  PushNotificationData _convertToNotificationData(
    OSNotification osNotification, {
    required bool isInForeground,
  }) {
    return PushNotificationData(
      title: osNotification.title,
      body: osNotification.body,
      additionalData: osNotification.additionalData,
      source: PushNotificationProviderType.onesignal,
      notificationId: osNotification.notificationId,
      imageUrl: osNotification.bigPicture,
      actionUrl: osNotification.launchUrl,
      isInForeground: isInForeground,
      rawPayload: osNotification.rawPayload,
      receivedAt: DateTime.now(),
    );
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    try {
      final granted = await OneSignal.Notifications.requestPermission(true);
      
      if (granted) {
        return NotificationPermissionStatus.authorized;
      } else {
        return NotificationPermissionStatus.denied;
      }
    } catch (e) {
      debugPrint('❌ OneSignal: Permission request failed: $e');
      return NotificationPermissionStatus.unknown;
    }
  }

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async {
    try {
      final hasPermission = OneSignal.Notifications.permission;
      
      if (hasPermission) {
        return NotificationPermissionStatus.authorized;
      } else {
        return NotificationPermissionStatus.denied;
      }
    } catch (e) {
      debugPrint('❌ OneSignal: Get permission status failed: $e');
      return NotificationPermissionStatus.unknown;
    }
  }

  @override
  Future<bool> subscribeToTopic(String topic) async {
    try {
      // OneSignal uses tags for topic-like functionality
      await OneSignal.User.addTagWithKey(topic, 'subscribed');
      debugPrint('✅ OneSignal: Subscribed to topic: $topic');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Subscribe to topic failed: $e');
      return false;
    }
  }

  @override
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await OneSignal.User.removeTag(topic);
      debugPrint('✅ OneSignal: Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Unsubscribe from topic failed: $e');
      return false;
    }
  }

  @override
  Future<bool> setExternalUserId(String userId) async {
    try {
      OneSignal.login(userId);
      debugPrint('✅ OneSignal: External user ID set: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Set external user ID failed: $e');
      return false;
    }
  }

  @override
  Future<bool> removeExternalUserId() async {
    try {
      OneSignal.logout();
      debugPrint('✅ OneSignal: External user ID removed');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Remove external user ID failed: $e');
      return false;
    }
  }

  @override
  Future<String?> getDeviceToken() async {
    try {
      final pushSubscription = OneSignal.User.pushSubscription;
      return pushSubscription.token;
    } catch (e) {
      debugPrint('❌ OneSignal: Get device token failed: $e');
      return null;
    }
  }

  @override
  Future<bool> setTags(Map<String, dynamic> tags) async {
    try {
      final stringTags = tags.map((key, value) => MapEntry(key, value.toString()));
      await OneSignal.User.addTags(stringTags);
      debugPrint('✅ OneSignal: Tags set: ${tags.keys.join(', ')}');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Set tags failed: $e');
      return false;
    }
  }

  @override
  Future<bool> removeTags(List<String> keys) async {
    try {
      await OneSignal.User.removeTags(keys);
      debugPrint('✅ OneSignal: Tags removed: ${keys.join(', ')}');
      return true;
    } catch (e) {
      debugPrint('❌ OneSignal: Remove tags failed: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getTags() async {
    try {
      final tags = await OneSignal.User.getTags();
      return Map<String, dynamic>.from(tags);
    } catch (e) {
      debugPrint('❌ OneSignal: Get tags failed: $e');
      return {};
    }
  }

  @override
  Future<void> optIn() async {
    try {
      OneSignal.User.pushSubscription.optIn();
      debugPrint('✅ OneSignal: User opted in');
    } catch (e) {
      debugPrint('❌ OneSignal: Opt in failed: $e');
    }
  }

  @override
  Future<void> optOut() async {
    try {
      OneSignal.User.pushSubscription.optOut();
      debugPrint('✅ OneSignal: User opted out');
    } catch (e) {
      debugPrint('❌ OneSignal: Opt out failed: $e');
    }
  }

  @override
  Future<bool> isOptedIn() async {
    try {
      return OneSignal.User.pushSubscription.optedIn ?? false;
    } catch (e) {
      debugPrint('❌ OneSignal: Check opted in failed: $e');
      return false;
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      OneSignal.logout();
      debugPrint('✅ OneSignal: All data cleared');
    } catch (e) {
      debugPrint('❌ OneSignal: Clear all data failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    await _notificationReceivedController.close();
    await _notificationOpenedController.close();
    _isInitialized = false;
    debugPrint('🔔 OneSignal: Disposed');
  }
}
