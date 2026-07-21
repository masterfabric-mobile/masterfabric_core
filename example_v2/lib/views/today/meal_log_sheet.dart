import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/models/food_entry.dart';
import '../../widgets/aura_ui.dart';

/// Mini onboarding when starting a food log from Today.
abstract final class MealLogSheet {
  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.paddingOf(ctx).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AuraTheme.line,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'What are you logging?',
                style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                      fontFamily: AuraTheme.fontDisplay,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pick the meal moment first — Log opens ready on that filter.',
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                      color: AuraTheme.mute,
                    ),
              ),
              const SizedBox(height: 16),
              ...MealKind.values.map((kind) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: AuraTheme.mist,
                    borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        GoRouter.of(context).go(
                          '${app_routes.AppRoutes.log}?meal=${kind.name}',
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AuraTheme.paper,
                                borderRadius:
                                    BorderRadius.circular(AuraUi.radiusSm),
                                border: Border.all(color: AuraTheme.line),
                              ),
                              child: Icon(
                                _icon(kind),
                                size: 20,
                                color: AuraTheme.ink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _title(kind),
                                    style: const TextStyle(
                                      fontFamily: AuraTheme.fontDisplay,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    _caption(kind),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AuraTheme.mute,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  static IconData _icon(MealKind kind) {
    return switch (kind) {
      MealKind.breakfast => Icons.wb_sunny_outlined,
      MealKind.lunch => Icons.lunch_dining_outlined,
      MealKind.dinner => Icons.dinner_dining_outlined,
      MealKind.snack => Icons.cookie_outlined,
      MealKind.drink => Icons.water_drop_outlined,
    };
  }

  static String _title(MealKind kind) {
    return switch (kind) {
      MealKind.breakfast => 'Breakfast',
      MealKind.lunch => 'Lunch',
      MealKind.dinner => 'Dinner',
      MealKind.snack => 'Snack',
      MealKind.drink => 'Water / drink',
    };
  }

  static String _caption(MealKind kind) {
    return switch (kind) {
      MealKind.breakfast => 'Start the fuel day',
      MealKind.lunch => 'Midday plate',
      MealKind.dinner => 'Evening meal',
      MealKind.snack => 'Small top-up',
      MealKind.drink => 'Hydration log',
    };
  }
}
