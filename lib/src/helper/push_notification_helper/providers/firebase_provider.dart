import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:masterfabric_core/src/helper/push_notification_helper/abstract/push_notification_provider_base.dart';
import 'package:masterfabric_core/src/helper/push_notification_helper/models/push_notification_models.dart';

/// Background message handler for Firebase
///
/// Must be a top-level function (not a class method).
/// This handles messages when the app is in background or terminated.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already done
  await Firebase.initializeApp();
  debugPrint('🔔 Firebase: Background message received: ${message.messageId}');
}

/// Firebase Cloud Messaging (FCM) Provider
///
/// Implementation of [PushNotificationProviderBase] using Firebase Cloud Messaging.
/// Supports push notifications, topic subscriptions, and user targeting.
///
/// **Configuration Example (in app_config.json):**
/// ```json
/// "providers": {
///   "firebase": {
///     "enabled": true,
///     "vapidKey": "YOUR_VAPID_KEY" // Optional, for web
///   }
/// }
/// ```
///
/// **Requirements:**
/// - Firebase must be configured in your app (google-services.json / GoogleService-Info.plist)
/// - Firebase.initializeApp() should be called before using this provider
///
/// **Usage Example:**
/// ```dart
/// final provider = FirebaseProvider();
/// await provider.initialize(config);
///
/// // Subscribe to notification events
/// provider.onNotificationReceived.listen((notification) {
///   print('Received: ${notification.title}');
/// });
///
/// // Subscribe to topic
/// await provider.subscribeToTopic('news');
/// ```
class FirebaseProvider extends PushNotificationProviderBase {
  /// Firebase Messaging instance
  late FirebaseMessaging _messaging;

  /// Stream controllers for notification events
  final StreamController<PushNotificationData> _notificationReceivedController =
      StreamController<PushNotificationData>.broadcast();

  final StreamController<NotificationActionResult> _notificationOpenedController =
      StreamController<NotificationActionResult>.broadcast();

  /// Initialization state
  bool _isInitialized = false;

  /// VAPID key for web (optional)
  String? _vapidKey;

  /// Subscriptions for cleanup
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _backgroundOpenedSubscription;

  @override
  PushNotificationProviderType get providerType => PushNotificationProviderType.firebase;

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
      debugPrint('🔔 Firebase: Already initialized');
      return true;
    }

    try {
      // Initialize Firebase if not already done
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      _messaging = FirebaseMessaging.instance;
      _vapidKey = config.settings['vapidKey'] as String?;

      // Setup background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Setup notification handlers
      await _setupNotificationHandlers();

      // Check for initial message (app opened from terminated state via notification)
      await _checkInitialMessage();

      _isInitialized = true;
      debugPrint('✅ Firebase: Initialized successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase: Initialization failed: $e');
      return false;
    }
  }

  /// Setup notification event handlers
  Future<void> _setupNotificationHandlers() async {
    // Handle foreground messages
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      debugPrint('🔔 Firebase: Foreground message received: ${message.messageId}');
      
      final notification = _convertToNotificationData(message, isInForeground: true);
      _notificationReceivedController.add(notification);
    });

    // Handle notification opened (app in background)
    _backgroundOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('🔔 Firebase: Notification opened from background: ${message.messageId}');
      
      final notification = _convertToNotificationData(message, isInForeground: false);
      final result = NotificationActionResult(
        notification: notification,
        actionId: message.data['action'] as String?,
        isDismissed: false,
      );
      _notificationOpenedController.add(result);
    });
  }

  /// Check for initial message when app opened from terminated state
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    
    if (initialMessage != null) {
      debugPrint('🔔 Firebase: Initial message found: ${initialMessage.messageId}');
      
      final notification = _convertToNotificationData(initialMessage, isInForeground: false);
      final result = NotificationActionResult(
        notification: notification,
        actionId: initialMessage.data['action'] as String?,
        isDismissed: false,
      );
      _notificationOpenedController.add(result);
    }
  }

  /// Convert Firebase message to common format
  PushNotificationData _convertToNotificationData(
    RemoteMessage message, {
    required bool isInForeground,
  }) {
    return PushNotificationData(
      title: message.notification?.title,
      body: message.notification?.body,
      additionalData: message.data,
      source: PushNotificationProviderType.firebase,
      notificationId: message.messageId,
      imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      actionUrl: message.data['url'] as String?,
      isInForeground: isInForeground,
      rawPayload: message.toMap(),
      receivedAt: message.sentTime ?? DateTime.now(),
    );
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return _convertAuthorizationStatus(settings.authorizationStatus);
    } catch (e) {
      debugPrint('❌ Firebase: Permission request failed: $e');
      return NotificationPermissionStatus.unknown;
    }
  }

  @override
  Future<NotificationPermissionStatus> getPermissionStatus() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return _convertAuthorizationStatus(settings.authorizationStatus);
    } catch (e) {
      debugPrint('❌ Firebase: Get permission status failed: $e');
      return NotificationPermissionStatus.unknown;
    }
  }

  /// Convert Firebase authorization status to common format
  NotificationPermissionStatus _convertAuthorizationStatus(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.authorized:
        return NotificationPermissionStatus.authorized;
      case AuthorizationStatus.denied:
        return NotificationPermissionStatus.denied;
      case AuthorizationStatus.notDetermined:
        return NotificationPermissionStatus.notDetermined;
      case AuthorizationStatus.provisional:
        return NotificationPermissionStatus.provisional;
    }
  }

  @override
  Future<bool> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ Firebase: Subscribed to topic: $topic');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase: Subscribe to topic failed: $e');
      return false;
    }
  }

  @override
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Firebase: Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      debugPrint('❌ Firebase: Unsubscribe from topic failed: $e');
      return false;
    }
  }

  @override
  Future<bool> setExternalUserId(String userId) async {
    // Firebase doesn't have a direct equivalent to external user ID
    // This would typically be handled by your backend when sending notifications
    debugPrint('⚠️ Firebase: setExternalUserId should be handled by backend. User ID: $userId');
    return true;
  }

  @override
  Future<bool> removeExternalUserId() async {
    // Firebase doesn't have a direct equivalent
    debugPrint('⚠️ Firebase: removeExternalUserId should be handled by backend');
    return true;
  }

  @override
  Future<String?> getDeviceToken() async {
    try {
      if (kIsWeb && _vapidKey != null) {
        return await _messaging.getToken(vapidKey: _vapidKey);
      }
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('❌ Firebase: Get device token failed: $e');
      return null;
    }
  }

  @override
  Future<bool> setTags(Map<String, dynamic> tags) async {
    // Firebase doesn't have native tag support
    // This would typically be stored in Firestore or your backend
    debugPrint('⚠️ Firebase: Tags should be stored in your backend. Tags: ${tags.keys.join(', ')}');
    return true;
  }

  @override
  Future<bool> removeTags(List<String> keys) async {
    // Firebase doesn't have native tag support
    debugPrint('⚠️ Firebase: Tags should be removed from your backend. Keys: ${keys.join(', ')}');
    return true;
  }

  @override
  Future<Map<String, dynamic>> getTags() async {
    // Firebase doesn't have native tag support
    debugPrint('⚠️ Firebase: Tags should be fetched from your backend');
    return {};
  }

  @override
  Future<void> optIn() async {
    try {
      // Re-enable auto-init
      await _messaging.setAutoInitEnabled(true);
      debugPrint('✅ Firebase: User opted in');
    } catch (e) {
      debugPrint('❌ Firebase: Opt in failed: $e');
    }
  }

  @override
  Future<void> optOut() async {
    try {
      // Disable auto-init
      await _messaging.setAutoInitEnabled(false);
      // Delete token to stop receiving messages
      await _messaging.deleteToken();
      debugPrint('✅ Firebase: User opted out');
    } catch (e) {
      debugPrint('❌ Firebase: Opt out failed: $e');
    }
  }

  @override
  Future<bool> isOptedIn() async {
    try {
      final token = await _messaging.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Firebase: Check opted in failed: $e');
      return false;
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await _messaging.deleteToken();
      debugPrint('✅ Firebase: All data cleared');
    } catch (e) {
      debugPrint('❌ Firebase: Clear all data failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _backgroundOpenedSubscription?.cancel();
    await _notificationReceivedController.close();
    await _notificationOpenedController.close();
    _isInitialized = false;
    debugPrint('🔔 Firebase: Disposed');
  }
}
