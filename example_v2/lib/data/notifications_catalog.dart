import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/app_notification.dart';

abstract final class NotificationsCatalog {
  static const assetPath = 'assets/notifications/notifications.json';

  static Future<List<AppNotification>> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['notifications'] as List<dynamic>? ?? const [];
    return list
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
