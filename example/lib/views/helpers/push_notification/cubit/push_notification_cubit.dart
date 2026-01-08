import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'push_notification_state.dart';

/// Push Notification Demo Cubit
@injectable
class PushNotificationCubit extends BaseViewModelCubit<PushNotificationDemoState> {
  final PushNotificationHelper _helper = PushNotificationHelper.instance;
  
  StreamSubscription<PushNotificationData>? _notificationSubscription;
  StreamSubscription<NotificationActionResult>? _actionSubscription;

  PushNotificationCubit() : super(const PushNotificationDemoState.initial());

  /// Initialize the push notification system
  Future<void> initialize() async {
    stateChanger(state.copyWith(isLoading: true, clearError: true));

    try {
      // Load config from AssetConfigHelper
      final configHelper = AssetConfigHelper();
      await configHelper.loadConfig('assets/app_config.json');
      
      final pushConfigJson = configHelper.getAllConfig()?['pushNotificationConfiguration'];
      
      if (pushConfigJson == null) {
        stateChanger(state.copyWith(
          isLoading: false,
          errorMessage: 'Push notification configuration not found in app_config.json',
        ));
        return;
      }

      final config = PushNotificationConfig.fromJson(
        Map<String, dynamic>.from(pushConfigJson),
      );

      // Initialize the helper
      final success = await _helper.initialize(config);

      if (success) {
        // Setup notification listeners
        _setupListeners();

        // Get active providers
        final activeProviders = _helper.providers.keys.toList();

        // Fetch initial data
        final permissionStatuses = await _helper.requestPermissionAll();
        final deviceTokens = await _helper.getDeviceTokenAll();

        stateChanger(state.copyWith(
          isInitialized: true,
          isLoading: false,
          config: config,
          activeProviders: activeProviders,
          permissionStatuses: permissionStatuses,
          deviceTokens: deviceTokens,
          statusMessage: 'Initialized with ${activeProviders.length} provider(s)',
        ));
      } else {
        stateChanger(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to initialize push notifications. Check your configuration.',
        ));
      }
    } catch (e) {
      debugPrint('Error initializing push notifications: $e');
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error: $e',
      ));
    }
  }

  /// Setup notification event listeners
  void _setupListeners() {
    _notificationSubscription = _helper.onNotificationReceived.listen((notification) {
      debugPrint('Notification received: ${notification.title}');
      final updatedNotifications = [notification, ...state.recentNotifications];
      // Keep only last 10 notifications
      final trimmed = updatedNotifications.take(10).toList();
      stateChanger(state.copyWith(
        recentNotifications: trimmed,
        statusMessage: 'New notification: ${notification.title}',
      ));
    });

    _actionSubscription = _helper.onNotificationOpened.listen((result) {
      debugPrint('Notification opened: ${result.notification.title}');
      stateChanger(state.copyWith(
        statusMessage: 'Notification tapped: ${result.notification.title}',
      ));
    });
  }

  /// Request permissions from all providers
  Future<void> requestPermissions() async {
    stateChanger(state.copyWith(isLoading: true));
    
    try {
      final permissionStatuses = await _helper.requestPermissionAll();
      stateChanger(state.copyWith(
        isLoading: false,
        permissionStatuses: permissionStatuses,
        statusMessage: 'Permissions updated',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error requesting permissions: $e',
      ));
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    if (topic.isEmpty) return;

    stateChanger(state.copyWith(isLoading: true));
    
    try {
      await _helper.subscribeToTopicAll(topic);
      final updatedTopics = [...state.subscribedTopics, topic];
      stateChanger(state.copyWith(
        isLoading: false,
        subscribedTopics: updatedTopics,
        statusMessage: 'Subscribed to "$topic"',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error subscribing to topic: $e',
      ));
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    stateChanger(state.copyWith(isLoading: true));
    
    try {
      await _helper.unsubscribeFromTopicAll(topic);
      final updatedTopics = state.subscribedTopics.where((t) => t != topic).toList();
      stateChanger(state.copyWith(
        isLoading: false,
        subscribedTopics: updatedTopics,
        statusMessage: 'Unsubscribed from "$topic"',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error unsubscribing from topic: $e',
      ));
    }
  }

  /// Set external user ID
  Future<void> setUserId(String userId) async {
    if (userId.isEmpty) return;

    stateChanger(state.copyWith(isLoading: true));
    
    try {
      await _helper.setExternalUserIdAll(userId);
      stateChanger(state.copyWith(
        isLoading: false,
        statusMessage: 'User ID set: $userId',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error setting user ID: $e',
      ));
    }
  }

  /// Remove external user ID (logout)
  Future<void> removeUserId() async {
    stateChanger(state.copyWith(isLoading: true));
    
    try {
      await _helper.removeExternalUserIdAll();
      stateChanger(state.copyWith(
        isLoading: false,
        statusMessage: 'User ID removed',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error removing user ID: $e',
      ));
    }
  }

  /// Refresh device tokens
  Future<void> refreshTokens() async {
    stateChanger(state.copyWith(isLoading: true));
    
    try {
      final deviceTokens = await _helper.getDeviceTokenAll();
      stateChanger(state.copyWith(
        isLoading: false,
        deviceTokens: deviceTokens,
        statusMessage: 'Tokens refreshed',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error refreshing tokens: $e',
      ));
    }
  }

  /// Opt in to notifications
  Future<void> optIn() async {
    try {
      await _helper.optInAll();
      stateChanger(state.copyWith(statusMessage: 'Opted in to notifications'));
    } catch (e) {
      stateChanger(state.copyWith(errorMessage: 'Error opting in: $e'));
    }
  }

  /// Opt out of notifications
  Future<void> optOut() async {
    try {
      await _helper.optOutAll();
      stateChanger(state.copyWith(statusMessage: 'Opted out of notifications'));
    } catch (e) {
      stateChanger(state.copyWith(errorMessage: 'Error opting out: $e'));
    }
  }

  /// Clear all notification data
  Future<void> clearAllData() async {
    try {
      await _helper.clearAllData();
      stateChanger(state.copyWith(
        recentNotifications: [],
        subscribedTopics: [],
        statusMessage: 'All data cleared',
      ));
    } catch (e) {
      stateChanger(state.copyWith(errorMessage: 'Error clearing data: $e'));
    }
  }

  /// Clear status/error messages
  void clearMessages() {
    stateChanger(state.copyWith(clearError: true, clearStatus: true));
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _actionSubscription?.cancel();
    return super.close();
  }
}
