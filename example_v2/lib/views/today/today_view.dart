import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes, Spacer;

import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/models/body_profile.dart';
import '../../data/tip_cards.dart';
import '../../widgets/aura_toast.dart';
import '../../widgets/aura_ui.dart';
import '../../widgets/tip_cards.dart';
import '../../widgets/profile_avatar.dart';
import 'cubit/today_cubit.dart';
import 'cubit/today_state.dart';
import 'notifications_sheet.dart';
import 'profile_sheet.dart';
import 'quick_action_sheets.dart';

class TodayView extends MasterViewCubit<TodayCubit, TodayState> {
  TodayView({
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
  Future<void> initialContent(TodayCubit viewModel, BuildContext context) async {
    await viewModel.load();
  }

  @override
  Widget viewContent(
    BuildContext context,
    TodayCubit viewModel,
    TodayState state,
  ) {
    if (state.loading || state.summary == null) {
      return const Center(child: CircularProgressIndicator(color: AuraTheme.ink));
    }

    final s = state.summary!;
    final topInset = MediaQuery.paddingOf(context).top;

    return RefreshIndicator(
      color: AuraTheme.ink,
      displacement: topInset + 72,
      onRefresh: viewModel.load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AuraTheme.paper,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            expandedHeight: 228,
            toolbarHeight: 56,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final settings = context
                    .dependOnInheritedWidgetOfExactType<
                        FlexibleSpaceBarSettings>();
                final delta =
                    (settings?.maxExtent ?? 228) - (settings?.minExtent ?? 56);
                final t = delta <= 0
                    ? 1.0
                    : (1.0 -
                            (((settings?.currentExtent ?? 56) -
                                    (settings?.minExtent ?? 56)) /
                                delta))
                        .clamp(0.0, 1.0);
                final heroOpacity = (1.0 - t * 1.15).clamp(0.0, 1.0);
                final heroScale = 1.0 - (t * 0.06);
                final logoHeight = 28.0 - (t * 2.0);
                // Match Today apple cards (radiusMd).
                const radius = AuraUi.radiusMd;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AuraTheme.paper),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: topInset + 52,
                      bottom: 10,
                      child: Opacity(
                        opacity: heroOpacity,
                        child: Transform.scale(
                          scale: heroScale,
                          alignment: Alignment.bottomCenter,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AuraTheme.mist,
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(radius),
                              child: AuraUi.illustration(
                                AuraArt.today,
                                height: 160,
                                fit: BoxFit.cover,
                                alignment: const Alignment(0.55, 0),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      top: topInset + 8,
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ProfileAvatar(
                                initials: state.profile.initials,
                                size: 32,
                                onTap: () => ProfileSheet.open(
                                  context,
                                  state.profile,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Semantics(
                                label: 'AURA',
                                image: true,
                                child: Image.asset(
                                  'assets/illustrations/brand/aura_wordmark.png',
                                  height: logoHeight,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48,
                            child: IconButton(
                              tooltip: 'Notifications',
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.notifications_none),
                              onPressed: () =>
                                  NotificationsSheet.open(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TipCardStrip(
                  cards: [
                    ...TipCards.forSection('Today'),
                    ...TipCards.forSection('Widget'),
                  ],
                ),
                const SizedBox(height: 18),
                const _ShortDivider(),
                const SizedBox(height: 14),
                _QuickActionsGrid(
                  onFood: () => FoodQuickSheet.open(context, viewModel),
                  onWater: () => WaterQuickSheet.open(context, viewModel),
                  onCoach: () => CoachQuickSheet.open(context, viewModel, s),
                  onBurn: () => BurnQuickSheet.open(context, viewModel),
                ),
                const SizedBox(height: 14),
                _HeroRingCard(summary: s),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        title: 'Eaten',
                        value: '${s.eaten}',
                        unit: 'kcal',
                        icon: Icons.restaurant_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricTile(
                        title: 'Burned',
                        value: '${s.burned}',
                        unit: 'kcal',
                        icon: Icons.local_fire_department_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricTile(
                        title: 'Water',
                        value: '${s.waterMl}',
                        unit: 'ml',
                        icon: Icons.water_drop_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MacrosCard(summary: s, profile: state.profile),
                const SizedBox(height: 12),
                _AlertsCard(warnings: s.warnings),
                const SizedBox(height: 12),
                _HomeWidgetPreview(summary: s),
                const SizedBox(height: 12),
                _AppleSurfacesCard(viewModel: viewModel),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortDivider extends StatelessWidget {
  const _ShortDivider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 3,
        decoration: BoxDecoration(
          color: AuraTheme.line,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onFood,
    required this.onWater,
    required this.onCoach,
    required this.onBurn,
  });

  final VoidCallback onFood;
  final VoidCallback onWater;
  final VoidCallback onCoach;
  final VoidCallback onBurn;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.restaurant_outlined, onFood, 'Add food'),
      (Icons.water_drop_outlined, onWater, 'Add water'),
      (Icons.chat_bubble_outline, onCoach, 'Open coach'),
      (Icons.local_fire_department_outlined, onBurn, 'Log burn'),
    ];

    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _QuickActionCard(
              icon: actions[i].$1,
              onTap: actions[i].$2,
              tooltip: actions[i].$3,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    // Hit target is only the icon tile — no stretched invisible tap layer.
    return Center(
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: AuraTheme.mist,
          borderRadius: BorderRadius.circular(AuraUi.radiusSm),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AuraUi.radiusSm),
            child: SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: 22, color: AuraTheme.ink),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AuraTheme.ink,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AuraTheme.paper, width: 1.5),
                      ),
                      child: const Text(
                        '+',
                        style: TextStyle(
                          color: AuraTheme.paper,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroRingCard extends StatelessWidget {
  const _HeroRingCard({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = summary.goal == 0 ? 0.0 : summary.eaten / summary.goal;

    return AuraUi.appleCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${summary.remaining}',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.2,
                  ),
                ),
                Text(
                  'kcal remaining · goal ${summary.goal}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AuraTheme.mute,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: AuraUi.progressTrack(progress),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 7,
                  backgroundColor: AuraTheme.line,
                  color: AuraTheme.ink,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${(progress * 100).clamp(0, 999).round()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AuraUi.appleCard(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AuraTheme.mute),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AuraTheme.fontDisplay,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$title · $unit',
            style: const TextStyle(fontSize: 12, color: AuraTheme.mute),
          ),
        ],
      ),
    );
  }
}

/// Expanded Apple Fitness–style macros with targets and bars.
class _MacrosCard extends StatelessWidget {
  const _MacrosCard({
    required this.summary,
    required this.profile,
  });

  final DaySummary summary;
  final BodyProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final proteinTarget = (profile.weightKg * 1.6).round().clamp(60, 220);
    final carbsTarget = ((summary.goal * 0.40) / 4).round().clamp(80, 400);
    final fatTarget = ((summary.goal * 0.30) / 9).round().clamp(35, 120);
    final totalLogged = summary.protein + summary.carbs + summary.fat;
    final totalTarget = proteinTarget + carbsTarget + fatTarget;

    return AuraUi.appleCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
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
                      'Nutrition',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Protein, carbs, and fat vs today’s targets',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AuraTheme.paper,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$totalLogged / $totalTarget g',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MacroMixBar(
            protein: summary.protein,
            carbs: summary.carbs,
            fat: summary.fat,
          ),
          const SizedBox(height: 18),
          _MacroRow(
            label: 'Protein',
            value: summary.protein,
            target: proteinTarget,
            hint: 'Repair & satiety',
            accent: AuraTheme.ink,
          ),
          const SizedBox(height: 14),
          _MacroRow(
            label: 'Carbs',
            value: summary.carbs,
            target: carbsTarget,
            hint: 'Fuel for training',
            accent: const Color(0xFF3A3A3A),
          ),
          const SizedBox(height: 14),
          _MacroRow(
            label: 'Fat',
            value: summary.fat,
            target: fatTarget,
            hint: 'Hormones & flavor',
            accent: const Color(0xFF6B6B6B),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AuraTheme.paper,
              borderRadius: BorderRadius.circular(AuraUi.radiusSm),
            ),
            child: Text(
              _macroCoachLine(
                protein: summary.protein,
                proteinTarget: proteinTarget,
                carbs: summary.carbs,
                fat: summary.fat,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AuraTheme.mute,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _macroCoachLine({
    required int protein,
    required int proteinTarget,
    required int carbs,
    required int fat,
  }) {
    if (protein == 0 && carbs == 0 && fat == 0) {
      return 'No macros logged yet. A protein-forward meal sets the day.';
    }
    if (protein < proteinTarget * 0.5) {
      return 'Protein is light. Add eggs, yogurt, chicken, or a shake next.';
    }
    if (protein >= proteinTarget) {
      return 'Protein target hit. Keep carbs around training windows.';
    }
    return 'Solid pace. ${proteinTarget - protein}g protein left to target.';
  }
}

class _MacroMixBar extends StatelessWidget {
  const _MacroMixBar({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int protein;
  final int carbs;
  final int fat;

  @override
  Widget build(BuildContext context) {
    final total = (protein + carbs + fat).clamp(1, 100000);
    final p = protein / total;
    final c = carbs / total;
    final f = fat / total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                Expanded(
                  flex: (p * 1000).round().clamp(1, 1000),
                  child: const ColoredBox(color: AuraTheme.ink),
                ),
                Expanded(
                  flex: (c * 1000).round().clamp(1, 1000),
                  child: const ColoredBox(color: Color(0xFF5A5A5A)),
                ),
                Expanded(
                  flex: (f * 1000).round().clamp(1, 1000),
                  child: const ColoredBox(color: Color(0xFFB0B0B0)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _legend('Protein', AuraTheme.ink),
            const SizedBox(width: 12),
            _legend('Carbs', const Color(0xFF5A5A5A)),
            const SizedBox(width: 12),
            _legend('Fat', const Color(0xFFB0B0B0)),
          ],
        ),
      ],
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AuraTheme.mute),
        ),
      ],
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.value,
    required this.target,
    required this.hint,
    required this.accent,
  });

  final String label;
  final int value;
  final int target;
  final String hint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final progress = target == 0 ? 0.0 : (value / target).clamp(0.0, 1.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    hint,
                    style: const TextStyle(fontSize: 12, color: AuraTheme.mute),
                  ),
                ],
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(
                fontFamily: AuraTheme.fontDisplay,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              ' / ${target}g',
              style: const TextStyle(fontSize: 13, color: AuraTheme.mute),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                const ColoredBox(
                  color: AuraTheme.paper,
                  child: SizedBox.expand(),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: ColoredBox(color: accent),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                warnings.isEmpty
                    ? Icons.check_circle_outline
                    : Icons.priority_high_rounded,
                size: 20,
                color: AuraTheme.ink,
              ),
              const SizedBox(width: 8),
              Text(
                warnings.isEmpty ? 'All clear' : 'Needs a look',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (warnings.isEmpty)
            Text(
              'No alerts right now. Keep logging to stay honest.',
              style: theme.textTheme.bodyLarge?.copyWith(color: AuraTheme.mute),
            )
          else
            ...warnings.map(
              (w) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: BoxDecoration(
                        color: AuraTheme.ink,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(w, style: theme.textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeWidgetPreview extends StatelessWidget {
  const _HomeWidgetPreview({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuraUi.appleCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home Screen widget',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add “AURA Today” from the widget gallery for a glanceable ring.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AuraTheme.mute),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AuraTheme.paper,
              borderRadius: BorderRadius.circular(AuraUi.radiusMd),
              border: Border.all(color: AuraTheme.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AURA',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.remaining}',
                  style: theme.textTheme.headlineMedium,
                ),
                Text(
                  'kcal left · goal ${summary.goal}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: AuraUi.progressTrack(
                    summary.goal == 0 ? 0 : summary.eaten / summary.goal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppleSurfacesCard extends StatelessWidget {
  const _AppleSurfacesCard({required this.viewModel});

  final TodayCubit viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connected surfaces',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Widget, Live Activity, and Watch share today’s snapshot.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AuraTheme.mute),
          ),
          const SizedBox(height: 14),
          _SurfaceButton(
            icon: Icons.widgets_outlined,
            label: 'Refresh Home Widget',
            onTap: () async {
              await viewModel.pinHomeWidget();
              if (context.mounted) {
                await AuraToast.pulse(
                  context,
                  title: 'Home Widget',
                  loadingMessage: 'Reloading timeline…',
                  doneMessage: 'Widget timeline updated.',
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _SurfaceButton(
            icon: Icons.bubble_chart_outlined,
            label: 'Start Live Activity',
            onTap: () async {
              final ok = await viewModel.startLiveActivity();
              if (context.mounted) {
                await AuraToast.show(
                  context,
                  title: 'Live Activity',
                  message: ok
                      ? 'Started on the Lock Screen.'
                      : 'Unavailable on this device.',
                  tone: ok ? AuraToastTone.success : AuraToastTone.note,
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _SurfaceButton(
            icon: Icons.stop_circle_outlined,
            label: 'End Live Activity',
            onTap: () async {
              await viewModel.endLiveActivity();
              if (context.mounted) {
                await AuraToast.show(
                  context,
                  title: 'Live Activity',
                  message: 'Ended cleanly.',
                  tone: AuraToastTone.success,
                );
              }
            },
          ),
          const SizedBox(height: 8),
          _SurfaceButton(
            icon: Icons.watch_outlined,
            label: 'Sync Apple Watch',
            onTap: () async {
              await viewModel.load();
              if (context.mounted) {
                await AuraToast.pulse(
                  context,
                  title: 'Apple Watch',
                  loadingMessage: 'Syncing snapshot…',
                  doneMessage: 'Watch snapshot updated.',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SurfaceButton extends StatelessWidget {
  const _SurfaceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AuraTheme.paper,
      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AuraTheme.ink),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AuraTheme.mute),
            ],
          ),
        ),
      ),
    );
  }
}
