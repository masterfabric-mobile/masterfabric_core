import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.time,
    this.unread = false,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final String time;
  final bool unread;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String? ?? 'AURA',
      time: json['time'] as String? ?? '',
      unread: json['unread'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, title, body, category, time, unread];
}
