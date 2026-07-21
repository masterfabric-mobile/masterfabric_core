import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart' as app_routes;
import '../../data/models/food_entry.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../widgets/aura_kit.dart';
import '../../widgets/meal_labels.dart';

/// Mini onboarding when starting a food log from Today.
abstract final class MealLogSheet {
  static Future<void> open(BuildContext context) {
    return AuraKit.showSheet(
      context: context,
      title: aura.Translations.of(context).sheets.what_logging,
      subtitle: aura.Translations.of(context).log.subtitle_today,
      child: Column(
        children: [
          for (final kind in MealKind.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AuraSpace.sm),
              child: AuraKit.listRow(
                title: MealLabels.title(context, kind),
                subtitle: MealLabels.caption(context, kind),
                leading: Icon(MealLabels.icon(kind), size: 20),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () {
                  Navigator.of(context).pop();
                  GoRouter.of(context).go(
                    '${app_routes.AppRoutes.log}?meal=${kind.name}',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
