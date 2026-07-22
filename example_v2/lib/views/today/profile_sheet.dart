import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/injection.dart' as di;
import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/fitness_repository.dart';
import '../../data/models/app_icon_style.dart';
import '../../data/models/body_profile.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../widgets/app_icon_sheet.dart';
import '../../widgets/apple_roller_sheet.dart';
import '../../widgets/aura_kit.dart';
import '../../widgets/language_section.dart';
import '../../widgets/profile_avatar.dart';

abstract final class ProfileSheet {
  static Future<void> open(BuildContext context, BodyProfile profile) {
    final parent = context;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      useSafeArea: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _ProfileSheetBody(parent: parent, profile: profile),
    );
  }
}

class _ProfileSheetBody extends StatefulWidget {
  const _ProfileSheetBody({
    required this.parent,
    required this.profile,
  });

  final BuildContext parent;
  final BodyProfile profile;

  @override
  State<_ProfileSheetBody> createState() => _ProfileSheetBodyState();
}

class _ProfileSheetBodyState extends State<_ProfileSheetBody> {
  late BodyProfile _profile = widget.profile;

  Future<void> _persist(BodyProfile next) async {
    setState(() => _profile = next);
    await di.getIt<FitnessRepository>().saveProfile(next);
  }

  Future<void> _pickHeight() async {
    final t = aura.Translations.of(context);
    final v = await AppleRollerSheet.pickInt(
      context: context,
      title: t.body.height,
      unit: t.common.cm,
      min: 140,
      max: 210,
      value: _profile.heightCm.round(),
    );
    if (v != null) await _persist(_profile.copyWith(heightCm: v.toDouble()));
  }

  Future<void> _pickWeight() async {
    final t = aura.Translations.of(context);
    final v = await AppleRollerSheet.pickDecimal(
      context: context,
      title: t.body.weight,
      unit: t.common.kg,
      min: 40,
      max: 160,
      value: _profile.weightKg,
    );
    if (v != null) await _persist(_profile.copyWith(weightKg: v));
  }

  Future<void> _pickAge() async {
    final t = aura.Translations.of(context);
    final v = await AppleRollerSheet.pickInt(
      context: context,
      title: t.body.age,
      unit: 'yrs',
      min: 14,
      max: 80,
      value: _profile.age,
    );
    if (v != null) await _persist(_profile.copyWith(age: v));
  }

  Future<void> _pickSex() async {
    final t = aura.Translations.of(context);
    final picked = await _pickOption<Sex>(
      title: t.body.sex,
      options: Sex.values,
      labelOf: (s) => s == Sex.female ? t.sex.woman : t.sex.man,
      selected: _profile.sex,
    );
    if (picked != null) await _persist(_profile.copyWith(sex: picked));
  }

  Future<void> _pickBodyType() async {
    final t = aura.Translations.of(context);
    final picked = await _pickOption<BodyType>(
      title: t.body.body_type,
      options: BodyType.values,
      labelOf: FitnessCalculator.bodyTypeLabel,
      captionOf: FitnessCalculator.bodyTypeCaption,
      selected: _profile.bodyType,
    );
    if (picked != null) await _persist(_profile.copyWith(bodyType: picked));
  }

  Future<void> _pickActivity() async {
    final t = aura.Translations.of(context);
    final picked = await _pickOption<ActivityLevel>(
      title: t.body.activity,
      options: ActivityLevel.values,
      labelOf: (l) => _activityLabel(t, l),
      selected: _profile.activity,
    );
    if (picked != null) await _persist(_profile.copyWith(activity: picked));
  }

  Future<void> _pickGoal() async {
    final t = aura.Translations.of(context);
    final picked = await _pickOption<FitnessGoal>(
      title: t.body.goal,
      options: FitnessGoal.values,
      labelOf: (g) => _goalLabel(t, g),
      selected: _profile.goal,
    );
    if (picked != null) await _persist(_profile.copyWith(goal: picked));
  }

  Future<T?> _pickOption<T>({
    required String title,
    required List<T> options,
    required String Function(T) labelOf,
    String Function(T)? captionOf,
    required T selected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AuraTheme.line,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                AuraSpace.vMd,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontFamily: AuraTheme.fontDisplay,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                AuraSpace.vMd,
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final option in options)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: option == selected
                                ? AuraTheme.ink
                                : AuraTheme.mist,
                            borderRadius:
                                BorderRadius.circular(AuraUi.radiusSm),
                            child: InkWell(
                              onTap: () => Navigator.of(ctx).pop(option),
                              borderRadius:
                                  BorderRadius.circular(AuraUi.radiusSm),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            labelOf(option),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: option == selected
                                                  ? AuraTheme.paper
                                                  : AuraTheme.ink,
                                            ),
                                          ),
                                          if (captionOf != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              captionOf(option),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: option == selected
                                                    ? AuraTheme.paper
                                                        .withValues(alpha: 0.7)
                                                    : AuraTheme.mute,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (option == selected)
                                      Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: option == selected
                                            ? AuraTheme.paper
                                            : AuraTheme.ink,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context);
    final name = _profile.displayName.isEmpty
        ? t.profile.athlete_fallback
        : _profile.displayName;
    final sexLabel =
        _profile.sex == Sex.female ? t.sex.woman : t.sex.man;
    final bmi = FitnessCalculator.bmi(_profile);
    final bmr = FitnessCalculator.bmr(_profile).round();
    final tdee = FitnessCalculator.tdee(_profile);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.4,
      maxChildSize: 0.96,
      snap: true,
      snapSizes: const [0.88],
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          children: [
            _ProfileHero(
              name: name,
              subtitle: t.profile.subtitle,
              badge: t.profile.identity_badge,
              localOnly: t.profile.local_only,
              sexLabel: sexLabel,
              initials: _profile.initials,
              appIcon: _profile.appIcon,
              appIconLabel: t.profile.app_icon_label,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AuraSpace.sheetH,
                AuraSpace.lg,
                AuraSpace.sheetH,
                MediaQuery.paddingOf(context).bottom + AuraSpace.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    t.profile.glance,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AuraSpace.vMd,
                  Row(
                    children: [
                      AuraKit.metricTile(
                        value: bmi.toStringAsFixed(1),
                        label: t.body.bmi,
                        unit: FitnessCalculator.bmiLabel(bmi),
                      ),
                      AuraSpace.hSm,
                      AuraKit.metricTile(
                        value: '$bmr',
                        label: t.body.bmr,
                        unit: t.common.kcal,
                      ),
                      AuraSpace.hSm,
                      AuraKit.metricTile(
                        value: '$tdee',
                        label: t.body.tdee,
                        unit: t.common.kcal,
                      ),
                    ],
                  ),
                  AuraSpace.vLg,
                  AuraKit.sectionCard(
                    context: context,
                    title: t.profile.baseline,
                    subtitle: t.profile.baseline_hint,
                    child: Column(
                      children: [
                        _BaselineRow(
                          icon: Icons.height_rounded,
                          title: t.body.height,
                          value: '${_profile.heightCm.round()} ${t.common.cm}',
                          onTap: _pickHeight,
                        ),
                        const _BaselineDivider(),
                        _BaselineRow(
                          icon: Icons.monitor_weight_outlined,
                          title: t.body.weight,
                          value:
                              '${_profile.weightKg.toStringAsFixed(1)} ${t.common.kg}',
                          onTap: _pickWeight,
                        ),
                        const _BaselineDivider(),
                        _BaselineRow(
                          icon: Icons.cake_outlined,
                          title: t.body.age,
                          value: '${_profile.age}',
                          onTap: _pickAge,
                        ),
                        const _BaselineDivider(),
                        _BaselineRow(
                          icon: Icons.wc_outlined,
                          title: t.body.sex,
                          value: sexLabel,
                          onTap: _pickSex,
                        ),
                        const _BaselineDivider(),
                        _BaselineRow(
                          icon: Icons.accessibility_new_outlined,
                          title: t.body.body_type,
                          value: FitnessCalculator.bodyTypeLabel(
                            _profile.bodyType,
                          ),
                          onTap: _pickBodyType,
                        ),
                        const _BaselineDivider(),
                        _BaselineRow(
                          icon: Icons.directions_run_outlined,
                          title: t.body.activity,
                          value: _activityLabel(t, _profile.activity),
                          onTap: _pickActivity,
                        ),
                        const _BaselineDivider(),
                        _BaselineRow(
                          icon: Icons.flag_outlined,
                          title: t.body.goal,
                          value: _goalLabel(t, _profile.goal),
                          onTap: _pickGoal,
                        ),
                      ],
                    ),
                  ),
                  AuraSpace.vMd,
                  AuraKit.primaryButton(
                    label: t.profile.open_body,
                    onPressed: () {
                      Navigator.of(context).pop();
                      GoRouter.of(widget.parent).go(app_routes.AppRoutes.body);
                    },
                    height: 52,
                  ),
                  AuraSpace.vLg,
                  const LanguageSection(),
                  AuraSpace.vLg,
                  Text(
                    t.profile.actions,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AuraSpace.vMd,
                  _ActionCta(
                    icon: Icons.apps_rounded,
                    title: t.profile.change_app_icon,
                    hint: t.profile.change_app_icon_hint,
                    filled: true,
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        _profile.appIcon.assetPath,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      AppIconSheet.open(widget.parent, _profile);
                    },
                  ),
                  AuraSpace.vSm,
                  _ActionCta(
                    icon: Icons.restart_alt_rounded,
                    title: t.profile.replay_onboarding,
                    hint: t.profile.replay_onboarding_hint,
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(widget.parent)
                          .go(app_routes.AppRoutes.onboarding);
                    },
                  ),
                  AuraSpace.vSm,
                  _ActionCta(
                    icon: Icons.shield_outlined,
                    title: t.profile.review_permissions,
                    hint: t.profile.review_permissions_hint,
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(widget.parent)
                          .go(app_routes.AppRoutes.permissions);
                    },
                  ),
                ],
              ),
            ),
          ],
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

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.name,
    required this.subtitle,
    required this.badge,
    required this.localOnly,
    required this.sexLabel,
    required this.initials,
    required this.appIcon,
    required this.appIconLabel,
  });

  final String name;
  final String subtitle;
  final String badge;
  final String localOnly;
  final String sexLabel;
  final String initials;
  final AppIconStyle appIcon;
  final String appIconLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AuraTheme.ink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -36,
            top: -28,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuraTheme.paper.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuraTheme.paper.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AuraTheme.paper.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                AuraSpace.vLg,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AuraTheme.paper.withValues(alpha: 0.35),
                        ),
                      ),
                      child: ProfileAvatar(
                        initials: initials,
                        size: 72,
                      ),
                    ),
                    AuraSpace.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: AuraTheme.fontDisplay,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AuraTheme.paper,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AuraTheme.paper.withValues(alpha: 0.65),
                              height: 1.3,
                            ),
                          ),
                          AuraSpace.vSm,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _HeroChip(label: sexLabel),
                              _HeroChip(label: badge),
                              _HeroChip(label: localOnly),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            appIcon.assetPath,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appIconLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AuraTheme.paper.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AuraTheme.paper.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AuraTheme.paper.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AuraTheme.paper,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

class _BaselineRow extends StatelessWidget {
  const _BaselineRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AuraTheme.mist,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AuraTheme.ink),
          ),
          AuraSpace.hMd,
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AuraTheme.ink,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AuraTheme.fontDisplay,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AuraTheme.mute,
              ),
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: AuraTheme.mute),
          ],
        ],
      ),
    );
    if (onTap == null) return row;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        child: row,
      ),
    );
  }
}

class _BaselineDivider extends StatelessWidget {
  const _BaselineDivider();

  @override
  Widget build(BuildContext context) => AuraUi.rule();
}

class _ActionCta extends StatelessWidget {
  const _ActionCta({
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
    this.filled = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String hint;
  final VoidCallback onTap;
  final bool filled;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = filled ? AuraTheme.paper : AuraTheme.ink;
    final bg = filled ? AuraTheme.ink : AuraTheme.mist;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AuraUi.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: filled
                      ? AuraTheme.paper.withValues(alpha: 0.12)
                      : AuraTheme.paper,
                  borderRadius: BorderRadius.circular(12),
                  border: filled ? null : Border.all(color: AuraTheme.line),
                ),
                child: Icon(icon, size: 20, color: fg),
              ),
              AuraSpace.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: filled
                            ? AuraTheme.paper.withValues(alpha: 0.65)
                            : AuraTheme.mute,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                AuraSpace.hSm,
                trailing!,
              ],
              AuraSpace.hSm,
              Icon(
                Icons.chevron_right_rounded,
                color: filled
                    ? AuraTheme.paper.withValues(alpha: 0.7)
                    : AuraTheme.mute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
