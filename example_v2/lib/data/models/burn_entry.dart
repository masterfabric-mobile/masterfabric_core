import 'package:equatable/equatable.dart';

class BurnEntry extends Equatable {
  const BurnEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.minutes,
    required this.loggedAt,
  });

  final String id;
  final String name;
  final int calories;
  final int minutes;
  final DateTime loggedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'minutes': minutes,
        'loggedAt': loggedAt.toIso8601String(),
      };

  factory BurnEntry.fromJson(Map<String, dynamic> json) {
    return BurnEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toInt(),
      minutes: (json['minutes'] as num).toInt(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, calories, minutes, loggedAt];
}
