import 'models/food_entry.dart';

class CatalogItem {
  const CatalogItem({
    required this.name,
    required this.calories,
    required this.kind,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.ml = 0,
  });

  final String name;
  final int calories;
  final MealKind kind;
  final int protein;
  final int carbs;
  final int fat;
  final int ml;
}

abstract final class FoodCatalog {
  static const foods = <CatalogItem>[
    CatalogItem(
      name: 'Oats + milk',
      calories: 320,
      kind: MealKind.breakfast,
      protein: 14,
      carbs: 48,
      fat: 8,
    ),
    CatalogItem(
      name: 'Eggs (2) + toast',
      calories: 360,
      kind: MealKind.breakfast,
      protein: 22,
      carbs: 28,
      fat: 18,
    ),
    CatalogItem(
      name: 'Greek yogurt',
      calories: 180,
      kind: MealKind.breakfast,
      protein: 17,
      carbs: 12,
      fat: 6,
    ),
    CatalogItem(
      name: 'Chicken rice bowl',
      calories: 520,
      kind: MealKind.lunch,
      protein: 42,
      carbs: 55,
      fat: 12,
    ),
    CatalogItem(
      name: 'Salad + tuna',
      calories: 380,
      kind: MealKind.lunch,
      protein: 34,
      carbs: 18,
      fat: 16,
    ),
    CatalogItem(
      name: 'Wrap + hummus',
      calories: 450,
      kind: MealKind.lunch,
      protein: 18,
      carbs: 52,
      fat: 18,
    ),
    CatalogItem(
      name: 'Salmon + veg',
      calories: 540,
      kind: MealKind.dinner,
      protein: 40,
      carbs: 22,
      fat: 28,
    ),
    CatalogItem(
      name: 'Pasta tomato',
      calories: 480,
      kind: MealKind.dinner,
      protein: 16,
      carbs: 72,
      fat: 12,
    ),
    CatalogItem(
      name: 'Steak + salad',
      calories: 610,
      kind: MealKind.dinner,
      protein: 46,
      carbs: 10,
      fat: 40,
    ),
    CatalogItem(
      name: 'Apple',
      calories: 95,
      kind: MealKind.snack,
      protein: 0,
      carbs: 25,
      fat: 0,
    ),
    CatalogItem(
      name: 'Protein bar',
      calories: 210,
      kind: MealKind.snack,
      protein: 20,
      carbs: 22,
      fat: 7,
    ),
    CatalogItem(
      name: 'Nuts handful',
      calories: 180,
      kind: MealKind.snack,
      protein: 6,
      carbs: 6,
      fat: 16,
    ),
    CatalogItem(
      name: 'Water 250 ml',
      calories: 0,
      kind: MealKind.drink,
      ml: 250,
    ),
    CatalogItem(
      name: 'Black coffee',
      calories: 5,
      kind: MealKind.drink,
      ml: 200,
    ),
    CatalogItem(
      name: 'Milk latte',
      calories: 140,
      kind: MealKind.drink,
      protein: 8,
      carbs: 12,
      fat: 6,
      ml: 300,
    ),
    CatalogItem(
      name: 'Smoothie',
      calories: 260,
      kind: MealKind.drink,
      protein: 10,
      carbs: 42,
      fat: 4,
      ml: 350,
    ),
  ];

  static const burns = <(String, int, int)>[
    ('Brisk walk', 20, 100),
    ('Easy run', 25, 240),
    ('Strength', 40, 220),
    ('Cycling', 30, 250),
    ('Yoga', 30, 120),
    ('HIIT', 20, 280),
  ];
}
