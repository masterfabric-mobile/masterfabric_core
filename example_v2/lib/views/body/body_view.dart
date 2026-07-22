import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes, Spacer;

import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/models/body_profile.dart';
import '../../data/models/weight_entry.dart';
import '../../data/tip_cards.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../views/today/profile_sheet.dart';
import '../../widgets/aura_kit.dart';
import '../../widgets/aura_sliver_app_bar.dart';
import '../../widgets/tip_cards.dart';
import 'cubit/body_cubit.dart';
import 'cubit/body_state.dart';

class BodyView extends MasterViewCubit<BodyCubit, BodyState> {
  BodyView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          backgroundColor: AuraTheme.paper,
          extendBody: false,
          extendBodyBehindAppBar: true,
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          useSafeArea: false,
        );

  @override
  Future<void> initialContent(BodyCubit viewModel, BuildContext context) async {
    await viewModel.load();
  }

  @override
  Widget viewContent(
    BuildContext context,
    BodyCubit viewModel,
    BodyState state,
  ) {
    if (state.loading) {
      return AuraKit.loading();
    }

    final theme = Theme.of(context);
    final t = aura.Translations.of(context);
    final p = state.profile;
    final name = p.displayName.isEmpty ? t.profile.athlete_fallback : p.displayName;
    final sexLabel = p.sex == Sex.female ? t.sex.woman : t.sex.man;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        AuraSliverAppBar(title: t.body.title),
        SliverPadding(
          padding: AuraSpace.pagePadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _EnergyHero(
                bmi: state.bmi,
                bmr: state.bmr.round(),
                tdee: state.tdee,
                goal: state.goal,
              ),
              AuraSpace.vMd,
              TipCardStrip(cards: TipCards.forSection(context, TipSection.body)),
              AuraSpace.vMd,
              _WeightChangeCard(
                weights: state.weights,
                currentKg: p.weightKg,
                deltaKg: state.deltaKg,
                onAdd: (kg, at) => viewModel.logWeight(kg, at: at),
                onRemove: viewModel.removeWeight,
              ),
              AuraSpace.vMd,
              _EnergyTargetsCard(
                profile: p,
                tdee: state.tdee,
                onToggleGoal: () {
                  if (p.goalCalories == null) {
                    viewModel.setGoal(state.tdee - 300);
                  } else {
                    viewModel.setGoal(null);
                  }
                },
                onBumpWater: () => viewModel.save(
                  p.copyWith(
                    waterGoalMl: p.waterGoalMl + 250 > 4000
                        ? 1500
                        : p.waterGoalMl + 250,
                  ),
                ),
              ),
              AuraSpace.vMd,
              AuraUi.appleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.body.baseline_snapshot,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AuraSpace.vXs,
                    Text(
                      t.body.baseline_snapshot_hint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AuraTheme.mute,
                        height: 1.35,
                      ),
                    ),
                    AuraSpace.vMd,
                    Text(
                      name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontFamily: AuraTheme.fontDisplay,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AuraSpace.vSm,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SnapshotChip(label: sexLabel),
                        _SnapshotChip(
                          label: FitnessCalculator.bodyTypeLabel(p.bodyType),
                        ),
                        _SnapshotChip(label: _goalLabel(t, p.goal)),
                        _SnapshotChip(
                          label:
                              '${p.heightCm.round()} ${t.common.cm} · ${p.weightKg.toStringAsFixed(1)} ${t.common.kg}',
                        ),
                        _SnapshotChip(label: _activityLabel(t, p.activity)),
                      ],
                    ),
                    AuraSpace.vMd,
                    Material(
                      color: AuraTheme.mist,
                      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                      child: InkWell(
                        onTap: () => ProfileSheet.open(context, p),
                        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AuraTheme.paper,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AuraTheme.line),
                                ),
                                child: const Icon(
                                  Icons.person_outline_rounded,
                                  size: 18,
                                ),
                              ),
                              AuraSpace.hMd,
                              Expanded(
                                child: Text(
                                  t.body.edit_in_profile,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AuraTheme.mute,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AuraSpace.vXl,
            ]),
          ),
        ),
      ],
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

class _EnergyHero extends StatelessWidget {
  const _EnergyHero({
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.goal,
  });

  final double bmi;
  final int bmr;
  final int tdee;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context);
    final label = FitnessCalculator.bmiLabel(bmi);

    return AuraUi.appleCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: (bmi / 40).clamp(0.0, 1.0),
                      strokeWidth: 8,
                      backgroundColor: AuraTheme.mist,
                      color: AuraTheme.ink,
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bmi.toStringAsFixed(1),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: AuraTheme.fontDisplay,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.6,
                            ),
                          ),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AuraTheme.mute,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AuraSpace.hLg,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.body.bmi,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AuraSpace.vXs,
                    Text(
                      t.body.energy_hint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AuraTheme.mute,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AuraSpace.vLg,
          Row(
            children: [
              _StatPill(label: t.body.bmr, value: '$bmr', unit: t.common.kcal),
              AuraSpace.hSm,
              _StatPill(label: t.body.tdee, value: '$tdee', unit: t.common.kcal),
              AuraSpace.hSm,
              _StatPill(label: t.body.goal, value: '$goal', unit: t.body.kcal_day),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: AuraTheme.mist,
          borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AuraTheme.mute,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: AuraTheme.fontDisplay,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 11, color: AuraTheme.mute),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnergyTargetsCard extends StatelessWidget {
  const _EnergyTargetsCard({
    required this.profile,
    required this.tdee,
    required this.onToggleGoal,
    required this.onBumpWater,
  });

  final BodyProfile profile;
  final int tdee;
  final VoidCallback onToggleGoal;
  final VoidCallback onBumpWater;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context);
    final custom = profile.goalCalories != null;

    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.body.energy_title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AuraSpace.vXs,
          Text(
            custom
                ? t.body.custom_goal_locked(kcal: profile.goalCalories!)
                : t.body.using_tdee,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AuraTheme.mute,
              height: 1.35,
            ),
          ),
          AuraSpace.vMd,
          Row(
            children: [
              Expanded(
                child: _TargetTile(
                  icon: Icons.local_fire_department_outlined,
                  title: t.body.goal,
                  value: '${custom ? profile.goalCalories : tdee}',
                  unit: t.common.kcal,
                ),
              ),
              AuraSpace.hSm,
              Expanded(
                child: _TargetTile(
                  icon: Icons.water_drop_outlined,
                  title: t.body.water_goal,
                  value: '${profile.waterGoalMl}',
                  unit: t.common.ml,
                ),
              ),
            ],
          ),
          AuraSpace.vMd,
          FilledButton(
            onPressed: onToggleGoal,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: Text(
              custom ? t.body.reset_tdee : t.body.set_custom_goal,
            ),
          ),
          AuraSpace.vSm,
          OutlinedButton(
            onPressed: onBumpWater,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: AuraTheme.line),
              foregroundColor: AuraTheme.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: Text(
              '${t.body.water_goal} ${profile.waterGoalMl} ${t.common.ml} · ${t.body.water_bump}',
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetTile extends StatelessWidget {
  const _TargetTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String title;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AuraTheme.mist,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AuraTheme.ink),
          AuraSpace.vSm,
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AuraTheme.mute,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AuraTheme.fontDisplay,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 11, color: AuraTheme.mute),
          ),
        ],
      ),
    );
  }
}

class _SnapshotChip extends StatelessWidget {
  const _SnapshotChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AuraTheme.mist,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AuraTheme.ink,
        ),
      ),
    );
  }
}

class _WeightChangeCard extends StatefulWidget {
  const _WeightChangeCard({
    required this.weights,
    required this.currentKg,
    required this.deltaKg,
    required this.onAdd,
    required this.onRemove,
  });

  final List<WeightEntry> weights;
  final double currentKg;
  final double? deltaKg;
  final Future<void> Function(double kg, DateTime at) onAdd;
  final Future<void> Function(String id) onRemove;

  @override
  State<_WeightChangeCard> createState() => _WeightChangeCardState();
}

class _WeightChangeCardState extends State<_WeightChangeCard> {
  late final TextEditingController _kgCtrl;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _kgCtrl = TextEditingController(
      text: widget.currentKg.toStringAsFixed(1),
    );
  }

  @override
  void didUpdateWidget(covariant _WeightChangeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentKg != widget.currentKg &&
        (double.tryParse(_kgCtrl.text) == null ||
            (double.tryParse(_kgCtrl.text)! - widget.currentKg).abs() < 0.05)) {
      _kgCtrl.text = widget.currentKg.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _kgCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final kg = double.tryParse(_kgCtrl.text.replaceAll(',', '.'));
    if (kg == null || kg < 30 || kg > 250) return;
    await widget.onAdd(kg, _date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context);
    final delta = widget.deltaKg;
    final deltaLabel = delta == null
        ? t.body.need_checkins
        : '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} ${t.common.kg} · ${t.body.overall}';
    final latest = widget.weights.isEmpty
        ? widget.currentKg
        : widget.weights.last.weightKg;

    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.body.body_change,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AuraSpace.vXs,
                    Text(
                      t.body.body_change_hint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AuraTheme.mute,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AuraTheme.ink,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      t.body.latest,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AuraTheme.paper.withValues(alpha: 0.65),
                      ),
                    ),
                    Text(
                      '${latest.toStringAsFixed(1)} ${t.common.kg}',
                      style: const TextStyle(
                        fontFamily: AuraTheme.fontDisplay,
                        fontWeight: FontWeight.w700,
                        color: AuraTheme.paper,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AuraSpace.vMd,
          SizedBox(
            height: 140,
            width: double.infinity,
            child: _WeightChart(weights: widget.weights),
          ),
          AuraSpace.vMd,
          Text(
            deltaLabel,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: delta == null ? AuraTheme.mute : AuraTheme.ink,
            ),
          ),
          AuraSpace.vMd,
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _kgCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(hintText: t.body.weight),
                ),
              ),
              AuraSpace.hSm,
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickDate,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AuraTheme.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    ),
                  ),
                  child: Text(DateFormat('d MMM y').format(_date)),
                ),
              ),
            ],
          ),
          AuraSpace.vSm,
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: Text(t.body.add_checkin),
          ),
          if (widget.weights.isNotEmpty) ...[
            AuraSpace.vMd,
            ...widget.weights.reversed.take(5).map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AuraTheme.mist,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${DateFormat('d MMM y').format(e.loggedAt)} · ${e.weightKg.toStringAsFixed(1)} ${t.common.kg}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        tooltip: t.common.remove,
                        onPressed: () => widget.onRemove(e.id),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart({required this.weights});

  final List<WeightEntry> weights;

  @override
  Widget build(BuildContext context) {
    final t = aura.Translations.of(context);
    if (weights.length < 2) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AuraTheme.mist,
          borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        ),
        child: Center(
          child: Text(
            t.body.chart_hint,
            style: const TextStyle(color: AuraTheme.mute, fontSize: 13),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuraTheme.mist,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: CustomPaint(
          painter: _WeightChartPainter(weights),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter(this.weights);

  final List<WeightEntry> weights;

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;
    final minW =
        weights.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    final maxW =
        weights.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);
    final span = (maxW - minW).abs() < 0.2 ? 1.0 : (maxW - minW);

    final fill = Path();
    final line = Path();
    for (var i = 0; i < weights.length; i++) {
      final x = size.width * (i / (weights.length - 1));
      final y = size.height -
          ((weights[i].weightKg - minW) / span) * size.height;
      if (i == 0) {
        line.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        line.lineTo(x, y);
        fill.lineTo(x, y);
      }
    }
    fill
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()..color = AuraTheme.ink.withValues(alpha: 0.06),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = AuraTheme.ink
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final dot = Paint()..color = AuraTheme.ink;
    for (var i = 0; i < weights.length; i++) {
      final x = size.width * (i / (weights.length - 1));
      final y = size.height -
          ((weights[i].weightKg - minW) / span) * size.height;
      canvas.drawCircle(Offset(x, y), 3.4, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) =>
      oldDelegate.weights != weights;
}
