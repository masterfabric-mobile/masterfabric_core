import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/models/body_profile.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../widgets/aura_kit.dart';
import '../../widgets/language_section.dart';
import '../../widgets/profile_avatar.dart';

abstract final class ProfileSheet {
  static Future<void> open(BuildContext context, BodyProfile profile) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final t = aura.Translations.of(ctx);
        final name = profile.displayName.isEmpty
            ? t.profile.athlete_fallback
            : profile.displayName;

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.32,
          maxChildSize: 0.88,
          snap: true,
          snapSizes: const [0.78],
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(
                AuraSpace.sheetH,
                0,
                AuraSpace.sheetH,
                MediaQuery.paddingOf(ctx).bottom + AuraSpace.md,
              ),
              children: [
                Center(
                  child: ProfileAvatar(initials: profile.initials, size: 72),
                ),
                AuraSpace.vMd,
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AuraTheme.fontDisplay,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                AuraSpace.vXs,
                Text(
                  t.profile.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: AuraTheme.fontFamily,
                    color: AuraTheme.mute,
                  ),
                ),
                AuraSpace.vLg,
                AuraKit.listRow(
                  title: t.body.height,
                  trailing: Text('${profile.heightCm.round()} ${t.common.cm}'),
                ),
                AuraSpace.vSm,
                AuraKit.listRow(
                  title: t.body.weight,
                  trailing: Text(
                    '${profile.weightKg.toStringAsFixed(1)} ${t.common.kg}',
                  ),
                ),
                AuraSpace.vSm,
                AuraKit.listRow(
                  title: t.body.age,
                  trailing: Text('${profile.age}'),
                ),
                AuraSpace.vSm,
                AuraKit.listRow(
                  title: t.body.sex,
                  trailing: Text(
                    profile.sex == Sex.female ? t.sex.woman : t.sex.man,
                  ),
                ),
                AuraSpace.vSm,
                AuraKit.listRow(
                  title: t.body.body_type,
                  trailing: Text(
                    FitnessCalculator.bodyTypeLabel(profile.bodyType),
                  ),
                ),
                AuraSpace.vSm,
                AuraKit.listRow(
                  title: t.body.activity,
                  trailing: Text(_activityLabel(t, profile.activity)),
                ),
                AuraSpace.vSm,
                AuraKit.listRow(
                  title: t.body.goal,
                  trailing: Text(_goalLabel(t, profile.goal)),
                ),
                AuraSpace.vLg,
                const LanguageSection(),
                AuraSpace.vLg,
                AuraKit.primaryButton(
                  label: t.profile.edit_in_body,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    GoRouter.of(context).go(app_routes.AppRoutes.body);
                  },
                  height: 46,
                ),
                AuraKit.secondaryButton(
                  label: t.profile.replay_onboarding,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    GoRouter.of(context).go(app_routes.AppRoutes.onboarding);
                  },
                ),
                AuraKit.secondaryButton(
                  label: t.profile.review_permissions,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    GoRouter.of(context).go(app_routes.AppRoutes.permissions);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static String _activityLabel(aura.Translations t, ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => t.activity.sedentary,
      ActivityLevel.light => t.activity.light,
      ActivityLevel.moderate => t.activity.moderate,
      ActivityLevel.active => t.activity.active,
      ActivityLevel.veryActive => t.activity.very_active,
    };
  }

  static String _goalLabel(aura.Translations t, FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.lose => t.goals.lose,
      FitnessGoal.maintain => t.goals.maintain,
      FitnessGoal.gain => t.goals.gain,
      FitnessGoal.recomp => t.goals.recomp,
    };
  }
}
