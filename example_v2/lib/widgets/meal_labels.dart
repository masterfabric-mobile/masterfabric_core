import 'package:flutter/material.dart';

import '../data/models/food_entry.dart';

abstract final class MealLabels {
  static String title(MealKind kind) {
    return switch (kind) {
      MealKind.breakfast => 'Breakfast',
      MealKind.lunch => 'Lunch',
      MealKind.dinner => 'Dinner',
      MealKind.snack => 'Snack',
      MealKind.drink => 'Drink',
    };
  }

  static String caption(MealKind kind) {
    return switch (kind) {
      MealKind.breakfast => 'Start the fuel day',
      MealKind.lunch => 'Midday plate',
      MealKind.dinner => 'Evening meal',
      MealKind.snack => 'Small top-up',
      MealKind.drink => 'Hydration & sips',
    };
  }

  static IconData icon(MealKind kind) {
    return switch (kind) {
      MealKind.breakfast => Icons.wb_sunny_outlined,
      MealKind.lunch => Icons.lunch_dining_outlined,
      MealKind.dinner => Icons.dinner_dining_outlined,
      MealKind.snack => Icons.cookie_outlined,
      MealKind.drink => Icons.local_cafe_outlined,
    };
  }
}
