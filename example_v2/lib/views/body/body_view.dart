import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes, Spacer;

import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/models/body_profile.dart';
import '../../data/models/weight_entry.dart';
import '../../data/tip_cards.dart';
import '../../widgets/apple_roller_sheet.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../widgets/aura_kit.dart';
import '../../widgets/aura_sliver_app_bar.dart';
import '../../widgets/aura_ui.dart';
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
    final p = state.profile;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        AuraSliverAppBar(title: aura.Translations.of(context).body.title),
        SliverPadding(
          padding: AuraSpace.pagePadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
        AuraUi.appleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                p.displayName.isEmpty ? 'Athlete' : p.displayName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: AuraTheme.fontDisplay,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${p.sex == Sex.female ? 'Woman' : 'Man'} · '
                '${FitnessCalculator.bodyTypeLabel(p.bodyType)} · '
                '${p.goal.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AuraTheme.mute,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${p.heightCm.round()} cm · ${p.weightKg.toStringAsFixed(1)} kg · age ${p.age}',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body mass index',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.bmi.toStringAsFixed(1),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontFamily: AuraTheme.fontDisplay,
                      ),
                    ),
                    Text(
                      FitnessCalculator.bmiLabel(state.bmi),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AuraTheme.mute,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: (state.bmi / 40).clamp(0.0, 1.0),
                      strokeWidth: 7,
                      backgroundColor: AuraTheme.line,
                      color: AuraTheme.ink,
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Text(
                        FitnessCalculator.bmiLabel(state.bmi).substring(0, 1),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatPill(
                label: 'BMR',
                value: '${state.bmr.round()}',
                unit: 'kcal',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatPill(
                label: 'TDEE',
                value: '${state.tdee}',
                unit: 'kcal',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatPill(
                label: 'Goal',
                value: '${state.goal}',
                unit: 'kcal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TipCardStrip(cards: TipCards.forSection(context, TipSection.body)),
        const SizedBox(height: 12),
        _WeightChangeCard(
          weights: state.weights,
          currentKg: p.weightKg,
          deltaKg: state.deltaKg,
          onAdd: (kg, at) => viewModel.logWeight(kg, at: at),
          onRemove: viewModel.removeWeight,
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  'Body type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...BodyType.values.map((type) {
                final selected = p.bodyType == type;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    onTap: () => viewModel.save(p.copyWith(bodyType: type)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FitnessCalculator.bodyTypeLabel(type),
                                  style: TextStyle(
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  FitnessCalculator.bodyTypeCaption(type),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AuraTheme.mute,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            const Icon(Icons.check_circle, size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Measurements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _measurementTile(
                label: 'Height',
                valueLabel: '${p.heightCm.round()} cm',
                onTap: () async {
                  final v = await AppleRollerSheet.pickInt(
                    context: context,
                    title: 'Height',
                    unit: 'cm',
                    min: 140,
                    max: 210,
                    value: p.heightCm.round(),
                  );
                  if (v != null) {
                    await viewModel.save(p.copyWith(heightCm: v.toDouble()));
                  }
                },
              ),
              _measurementTile(
                label: 'Weight',
                valueLabel: '${p.weightKg.toStringAsFixed(1)} kg',
                onTap: () async {
                  final v = await AppleRollerSheet.pickDecimal(
                    context: context,
                    title: 'Weight',
                    unit: 'kg',
                    min: 40,
                    max: 160,
                    value: p.weightKg,
                  );
                  if (v != null) {
                    await viewModel.save(p.copyWith(weightKg: v));
                  }
                },
              ),
              _measurementTile(
                label: 'Age',
                valueLabel: '${p.age}',
                onTap: () async {
                  final v = await AppleRollerSheet.pickInt(
                    context: context,
                    title: 'Age',
                    unit: 'yrs',
                    min: 14,
                    max: 80,
                    value: p.age,
                  );
                  if (v != null) {
                    await viewModel.save(p.copyWith(age: v));
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sex',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: Sex.values.map((sex) {
                  final selected = p.sex == sex;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: sex == Sex.female ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => viewModel.save(p.copyWith(sex: sex)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selected ? AuraTheme.ink : AuraTheme.paper,
                            borderRadius:
                                BorderRadius.circular(AuraUi.radiusSm),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            sex.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected ? AuraTheme.paper : AuraTheme.ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  'Activity',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...ActivityLevel.values.map((level) {
                final selected = p.activity == level;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    onTap: () => viewModel.save(p.copyWith(activity: level)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(_activityLabel(level))),
                          if (selected)
                            const Icon(Icons.check_circle, size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Goals',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                p.goalCalories == null
                    ? 'Using calculated TDEE as goal.'
                    : 'Custom goal locked at ${p.goalCalories} kcal.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AuraTheme.mute,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  if (p.goalCalories == null) {
                    viewModel.setGoal(state.tdee - 300);
                  } else {
                    viewModel.setGoal(null);
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                  ),
                ),
                child: Text(
                  p.goalCalories == null
                      ? 'Set custom goal (−300)'
                      : 'Reset to TDEE',
                ),
              ),
              TextButton(
                onPressed: () => viewModel.save(
                  p.copyWith(
                    waterGoalMl: p.waterGoalMl + 250 > 4000
                        ? 1500
                        : p.waterGoalMl + 250,
                  ),
                ),
                child: Text('Water goal ${p.waterGoalMl} ml · +250'),
              ),
            ],
          ),
        ),
            ]),
          ),
        ),
      ],
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
    return AuraUi.appleCard(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AuraTheme.mute),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AuraTheme.fontDisplay,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(unit, style: const TextStyle(fontSize: 11, color: AuraTheme.mute)),
        ],
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
    final delta = widget.deltaKg;
    final deltaLabel = delta == null
        ? 'Need 2+ check-ins'
        : '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg overall';

    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body change',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track weight by date — gain/loss shows on the chart.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AuraTheme.mute),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: _WeightChart(weights: widget.weights),
          ),
          const SizedBox(height: 10),
          Text(
            deltaLabel,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: delta == null
                  ? AuraTheme.mute
                  : (delta <= 0 ? AuraTheme.ink : AuraTheme.mute),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _kgCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(hintText: 'Weight kg'),
                ),
              ),
              const SizedBox(width: 8),
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
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: const Text('Add check-in'),
          ),
          if (widget.weights.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...widget.weights.reversed.take(6).map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${DateFormat('d MMM y').format(e.loggedAt)} · ${e.weightKg.toStringAsFixed(1)} kg',
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      onPressed: () => widget.onRemove(e.id),
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ],
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
    if (weights.length < 2) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AuraTheme.paper,
          borderRadius: BorderRadius.circular(AuraUi.radiusSm),
          border: Border.all(color: AuraTheme.line),
        ),
        child: const Center(
          child: Text(
            'Chart appears after 2 check-ins',
            style: TextStyle(color: AuraTheme.mute, fontSize: 13),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuraTheme.paper,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        border: Border.all(color: AuraTheme.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
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

    final path = Path();
    for (var i = 0; i < weights.length; i++) {
      final x = size.width * (i / (weights.length - 1));
      final y = size.height -
          ((weights[i].weightKg - minW) / span) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final line = Paint()
      ..color = AuraTheme.ink
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, line);

    final dot = Paint()..color = AuraTheme.ink;
    for (var i = 0; i < weights.length; i++) {
      final x = size.width * (i / (weights.length - 1));
      final y = size.height -
          ((weights[i].weightKg - minW) / span) * size.height;
      canvas.drawCircle(Offset(x, y), 3.2, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) =>
      oldDelegate.weights != weights;
}
