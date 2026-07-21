import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/injection.dart' as di;
import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/fitness_repository.dart';
import '../../data/models/body_profile.dart';
import '../../widgets/apple_roller_sheet.dart';
import '../../widgets/aura_toast.dart';
import '../../widgets/aura_ui.dart';

class AuraOnboardingView extends StatefulWidget {
  const AuraOnboardingView({super.key});

  @override
  State<AuraOnboardingView> createState() => _AuraOnboardingViewState();
}

class _AuraOnboardingViewState extends State<AuraOnboardingView> {
  final _page = PageController();
  final _nameCtrl = TextEditingController();
  var _index = 0;
  var _saving = false;
  var _sexPicked = false;

  BodyProfile _draft = const BodyProfile();

  static const _steps = 6;

  @override
  void initState() {
    super.initState();
    final existing = di.getIt<FitnessRepository>().profile;
    _draft = existing;
    _nameCtrl.text = existing.displayName;
    _sexPicked = existing.onboardingComplete || existing.displayName.isNotEmpty;
  }

  @override
  void dispose() {
    _page.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  String get _firstName {
    final t = _nameCtrl.text.trim();
    if (t.isEmpty) {
      return _draft.sex == Sex.female ? 'athlete' : 'athlete';
    }
    return t.split(RegExp(r'\s+')).first;
  }

  /// Sex-specific onboarding art: `onboard_{base}_f|m.webp`.
  String _art(String base) {
    final suffix = _draft.sex == Sex.female ? 'f' : 'm';
    return 'assets/illustrations/onboarding/onboard_${base}_$suffix.webp';
  }

  Future<void> _next() async {
    if (_index == 1 && !_sexPicked) {
      await AuraToast.show(
        context,
        title: 'Almost there',
        message: 'Choose Woman or Man to continue.',
        tone: AuraToastTone.note,
        actionLabel: 'OK',
      );
      return;
    }
    if (_index == 2 && _nameCtrl.text.trim().isEmpty) {
      await AuraToast.show(
        context,
        title: 'Name needed',
        message: 'Add your name to continue.',
        tone: AuraToastTone.note,
        actionLabel: 'OK',
      );
      return;
    }
    if (_index == 2) {
      setState(() {
        _draft = _draft.copyWith(displayName: _nameCtrl.text.trim());
      });
    }
    if (_index >= _steps - 1) {
      await _finish();
      return;
    }
    await _page.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _back() async {
    if (_index == 0) return;
    await _page.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _pickSex(Sex sex) {
    setState(() {
      _sexPicked = true;
      // Sensible gym baselines by sex — user can still fine-tune next.
      _draft = _draft.copyWith(
        sex: sex,
        heightCm: sex == Sex.female ? 165 : 178,
        weightKg: sex == Sex.female ? 62 : 78,
        waterGoalMl: sex == Sex.female ? 2000 : 2500,
      );
    });
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = di.getIt<FitnessRepository>();
      final profile = _draft.copyWith(
        displayName: _nameCtrl.text.trim().isEmpty
            ? _draft.displayName
            : _nameCtrl.text.trim(),
        onboardingComplete: true,
        clearGoalCalories: true,
      );
      await repo.saveProfile(profile);
      if (!mounted) return;
      // Second queue: notifications / location / fitness access.
      context.go(app_routes.AppRoutes.permissions);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AuraTheme.paper,
      body: Column(
        children: [
          SizedBox(height: top + 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'AURA',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: AuraTheme.fontDisplay,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_index + 1}/$_steps',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (_index + 1) / _steps,
                minHeight: 4,
                backgroundColor: AuraTheme.mist,
                color: AuraTheme.ink,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _page,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _StepScaffold(
                  asset: 'assets/illustrations/onboarding/onboard_welcome.webp',
                  title: 'Train with clarity',
                  body:
                      'AURA keeps calories, water, burn, and coaching on this device. One glance. One next action.',
                  child: AuraUi.appleCard(
                    child: Text(
                      'First we set your gym baseline — who you train as — then your personal numbers.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AuraTheme.mute,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
                _SexStep(
                  selected: _sexPicked ? _draft.sex : null,
                  onSelect: _pickSex,
                ),
                _StepScaffold(
                  asset: _art('name'),
                  title: _draft.sex == Sex.female
                      ? 'Woman athlete details'
                      : 'Man athlete details',
                  body: _draft.sex == Sex.female
                      ? 'Name, height, weight, and age for your woman athlete profile. These feed BMR, TDEE, and water.'
                      : 'Name, height, weight, and age for your man athlete profile. These feed BMR, TDEE, and water.',
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontFamily: AuraTheme.fontDisplay,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Your name',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _measurementTile(
                        label: 'Height',
                        valueLabel: '${_draft.heightCm.round()} cm',
                        onTap: () async {
                          final v = await AppleRollerSheet.pickInt(
                            context: context,
                            title: 'Height',
                            unit: 'cm',
                            min: 140,
                            max: 210,
                            value: _draft.heightCm.round(),
                          );
                          if (v != null) {
                            setState(
                              () => _draft =
                                  _draft.copyWith(heightCm: v.toDouble()),
                            );
                          }
                        },
                      ),
                      _measurementTile(
                        label: 'Weight',
                        valueLabel:
                            '${_draft.weightKg.toStringAsFixed(1)} kg',
                        onTap: () async {
                          final v = await AppleRollerSheet.pickDecimal(
                            context: context,
                            title: 'Weight',
                            unit: 'kg',
                            min: 40,
                            max: 160,
                            value: _draft.weightKg,
                          );
                          if (v != null) {
                            setState(
                              () => _draft = _draft.copyWith(weightKg: v),
                            );
                          }
                        },
                      ),
                      _measurementTile(
                        label: 'Age',
                        valueLabel: '${_draft.age}',
                        onTap: () async {
                          final v = await AppleRollerSheet.pickInt(
                            context: context,
                            title: 'Age',
                            unit: 'yrs',
                            min: 14,
                            max: 80,
                            value: _draft.age,
                          );
                          if (v != null) {
                            setState(
                              () => _draft = _draft.copyWith(age: v),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                _StepScaffold(
                  asset: _art('body'),
                  title: 'Body type',
                  body:
                      'Somatotype-style frame used to tune TDEE. Pick the closest match — you can change it later in Body.',
                  child: Column(
                    children: [
                      ...BodyType.values.map((type) {
                        final selected = _draft.bodyType == type;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ChoiceChip(
                            label:
                                '${FitnessCalculator.bodyTypeLabel(type)} · ${FitnessCalculator.bodyTypeCaption(type)}',
                            selected: selected,
                            onTap: () => setState(
                              () => _draft = _draft.copyWith(bodyType: type),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                _StepScaffold(
                  asset: _art('activity'),
                  title: 'Training & goal',
                  body:
                      'Activity sets TDEE. Goal softens the daily calorie target for your week in the gym.',
                  child: Column(
                    children: [
                      ...ActivityLevel.values.map((level) {
                        final selected = _draft.activity == level;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ChoiceChip(
                            label: _activityLabel(level),
                            selected: selected,
                            onTap: () => setState(
                              () =>
                                  _draft = _draft.copyWith(activity: level),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: FitnessGoal.values.map((goal) {
                          final selected = _draft.goal == goal;
                          return SizedBox(
                            width: (MediaQuery.sizeOf(context).width - 56) / 2,
                            child: _ChoiceChip(
                              label: _goalLabel(goal),
                              selected: selected,
                              onTap: () => setState(
                                () => _draft = _draft.copyWith(goal: goal),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                _StepScaffold(
                  asset: _art('ready'),
                  title: 'You’re set, $_firstName',
                  body:
                      'Log food fast. Watch the ring. Ask Coach for one next move. Local reminders keep the day alive.',
                  child: AuraUi.appleCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile snapshot',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_draft.sex == Sex.female ? 'Woman' : 'Man'} athlete',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_draft.heightCm.round()} cm · ${_draft.weightKg.toStringAsFixed(1)} kg · ${_draft.age}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          FitnessCalculator.bodyTypeLabel(_draft.bodyType),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_activityLabel(_draft.activity)} · ${_goalLabel(_draft.goal)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AuraTheme.mute,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  if (_index > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _back,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: AuraTheme.line),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AuraUi.radiusMd),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_index > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _saving ? null : _next,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                        ),
                      ),
                      child: Text(
                        _saving
                            ? 'Saving…'
                            : (_index >= _steps - 1
                                ? 'Enter AURA'
                                : 'Continue'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _measurementTile({
    required String label,
    required String valueLabel,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AuraTheme.fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                valueLabel,
                style: const TextStyle(
                  fontFamily: AuraTheme.fontDisplay,
                  fontWeight: FontWeight.w600,
                  color: AuraTheme.mute,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AuraTheme.mute,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _activityLabel(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => 'Sedentary · desk day',
      ActivityLevel.light => 'Light · 1–3 workouts',
      ActivityLevel.moderate => 'Moderate · 3–5 workouts',
      ActivityLevel.active => 'Active · hard training',
      ActivityLevel.veryActive => 'Very active · athlete',
    };
  }

  String _goalLabel(FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.lose => 'Cut',
      FitnessGoal.maintain => 'Maintain',
      FitnessGoal.gain => 'Bulk',
      FitnessGoal.recomp => 'Recomp',
    };
  }
}

class _SexStep extends StatelessWidget {
  const _SexStep({
    required this.selected,
    required this.onSelect,
  });

  final Sex? selected;
  final ValueChanged<Sex> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      children: [
        Text(
          'Body baseline',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: AuraTheme.fontDisplay,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pick who you train as. This sets BMR math and starting body numbers — you refine them next.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AuraTheme.mute,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _SexCard(
                label: 'Woman',
                caption: 'Athlete profile',
                asset:
                    'assets/illustrations/onboarding/onboard_sex_female.webp',
                selected: selected == Sex.female,
                onTap: () => onSelect(Sex.female),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SexCard(
                label: 'Man',
                caption: 'Athlete profile',
                asset: 'assets/illustrations/onboarding/onboard_sex_male.webp',
                selected: selected == Sex.male,
                onTap: () => onSelect(Sex.male),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SexCard extends StatelessWidget {
  const _SexCard({
    required this.label,
    required this.caption,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String caption;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AuraTheme.mist : AuraTheme.paper,
      borderRadius: BorderRadius.circular(AuraUi.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AuraUi.radiusLg),
            border: Border.all(
              color: selected ? AuraTheme.ink : AuraTheme.line,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                  child: ColoredBox(
                    color: AuraTheme.paper,
                    child: Image.asset(
                      asset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AuraTheme.fontDisplay,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                caption,
                style: const TextStyle(
                  fontSize: 12,
                  color: AuraTheme.mute,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.asset,
    required this.title,
    required this.body,
    required this.child,
  });

  final String asset;
  final String title;
  final String body;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AuraUi.radiusLg),
          child: ColoredBox(
            color: AuraTheme.paper,
            child: Image.asset(
              asset,
              height: 170,
              width: double.infinity,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: AuraTheme.fontDisplay,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AuraTheme.mute,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        child,
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AuraTheme.ink : AuraTheme.mist,
      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AuraTheme.fontFamily,
              fontWeight: FontWeight.w600,
              color: selected ? AuraTheme.paper : AuraTheme.ink,
            ),
          ),
        ),
      ),
    );
  }
}
