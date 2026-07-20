import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Helper class for local push notifications
class LocalNotificationHelper {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<bool> initialize({
    AndroidInitializationSettings? androidSettings,
    DarwinInitializationSettings? iosSettings,
  }) async {
    final android =
        androidSettings ?? const AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = iosSettings ?? const DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    final result = await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    return result ?? false;
  }

  /// Show a simple notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const android = AndroidNotificationDetails(
      'masterfabric_channel',
      'MasterFabric Notifications',
      channelDescription: 'Notifications for MasterFabric app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    const details = NotificationDetails(android: android, iOS: ios);

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Schedule a notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const android = AndroidNotificationDetails(
      'masterfabric_channel',
      'MasterFabric Notifications',
      channelDescription: 'Notifications for MasterFabric app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    const details = NotificationDetails(android: android, iOS: ios);

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Cancel a notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
  }
}
