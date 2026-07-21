import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/models/body_profile.dart';
import '../../widgets/aura_ui.dart';
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
        final name =
            profile.displayName.isEmpty ? 'Athlete' : profile.displayName;

        // ~10% shorter peak height; drag below min dismisses the sheet.
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.32,
          maxChildSize: 0.78,
          snap: true,
          snapSizes: const [0.72],
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                MediaQuery.paddingOf(ctx).bottom + 12,
              ),
              children: [
                Center(
                  child: ProfileAvatar(initials: profile.initials, size: 72),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AuraTheme.fontDisplay,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Local AURA profile · gym baseline',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: AuraTheme.fontFamily,
                    color: AuraTheme.mute,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  label: 'Height',
                  value: '${profile.heightCm.round()} cm',
                ),
                _InfoRow(
                  label: 'Weight',
                  value: '${profile.weightKg.toStringAsFixed(1)} kg',
                ),
                _InfoRow(
                  label: 'Age',
                  value: '${profile.age}',
                ),
                _InfoRow(
                  label: 'Sex',
                  value: profile.sex == Sex.female ? 'Woman' : 'Man',
                ),
                _InfoRow(
                  label: 'Body type',
                  value: FitnessCalculator.bodyTypeLabel(profile.bodyType),
                ),
                _InfoRow(
                  label: 'Activity',
                  value: _activityLabel(profile.activity),
                ),
                _InfoRow(
                  label: 'Goal',
                  value: _goalLabel(profile.goal),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      GoRouter.of(context).go(app_routes.AppRoutes.body);
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AuraUi.radiusSm),
                      ),
                    ),
                    child: const Text('Edit in Body'),
                  ),
                ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        GoRouter.of(context)
                            .go(app_routes.AppRoutes.onboarding);
                      },
                      child: const Text('Replay onboarding'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        GoRouter.of(context)
                            .go(app_routes.AppRoutes.permissions);
                      },
                      child: const Text('Review permissions'),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  static String _activityLabel(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => 'Sedentary',
      ActivityLevel.light => 'Light',
      ActivityLevel.moderate => 'Moderate',
      ActivityLevel.active => 'Active',
      ActivityLevel.veryActive => 'Very active',
    };
  }

  static String _goalLabel(FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.lose => 'Cut',
      FitnessGoal.maintain => 'Maintain',
      FitnessGoal.gain => 'Bulk',
      FitnessGoal.recomp => 'Recomp',
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AuraUi.appleCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: AuraTheme.fontFamily,
                fontWeight: FontWeight.w600,
                color: AuraTheme.mute,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontFamily: AuraTheme.fontDisplay,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
