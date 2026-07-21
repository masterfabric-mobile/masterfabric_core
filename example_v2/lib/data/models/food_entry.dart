import 'package:equatable/equatable.dart';

enum MealKind { breakfast, lunch, dinner, snack, drink }

class FoodEntry extends Equatable {
  const FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.kind,
    required this.loggedAt,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.ml = 0,
  });

  final String id;
  final String name;
  final int calories;
  final MealKind kind;
  final DateTime loggedAt;
  final int protein;
  final int carbs;
  final int fat;
  final int ml;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'kind': kind.name,
        'loggedAt': loggedAt.toIso8601String(),
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'ml': ml,
      };

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toInt(),
      kind: MealKind.values.firstWhere(
        (e) => e.name == json['kind'],
        orElse: () => MealKind.snack,
      ),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
      ml: (json['ml'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, calories, kind, loggedAt, protein, carbs, fat, ml];
}
