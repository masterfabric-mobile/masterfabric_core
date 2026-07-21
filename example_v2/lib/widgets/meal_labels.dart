import 'package:flutter/material.dart';

import '../data/models/food_entry.dart';
import '../src/resources/resources.g.dart' as aura;

abstract final class MealLabels {
  static String title(BuildContext context, MealKind kind) {
    final m = aura.Translations.of(context).meals;
    return switch (kind) {
      MealKind.breakfast => m.breakfast,
      MealKind.lunch => m.lunch,
      MealKind.dinner => m.dinner,
      MealKind.snack => m.snack,
      MealKind.drink => m.drink,
    };
  }

  static String caption(BuildContext context, MealKind kind) {
    final m = aura.Translations.of(context).meals;
    return switch (kind) {
      MealKind.breakfast => m.breakfast_caption,
      MealKind.lunch => m.lunch_caption,
      MealKind.dinner => m.dinner_caption,
      MealKind.snack => m.snack_caption,
      MealKind.drink => m.drink_caption,
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
