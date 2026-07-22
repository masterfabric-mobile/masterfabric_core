import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes, Spacer;

import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/models/body_profile.dart';
import '../../data/tip_cards.dart';
import '../../widgets/aura_toast.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../widgets/aura_kit.dart';
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
    this.initialAction,
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

  /// Home-screen quick action / deep-link payload (`water`, …).
  final String? initialAction;

  @override
  Future<void> initialContent(TodayCubit viewModel, BuildContext context) async {
    await viewModel.load();
    final action = initialAction?.toLowerCase();
    if (action == null || action.isEmpty) return;
    // Wait a frame so the shell / Today tree is mounted before sheets.
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!context.mounted) return;
    switch (action) {
      case 'water':
        await WaterQuickSheet.open(context, viewModel);
      case 'food':
        await FoodQuickSheet.open(context, viewModel);
      case 'burn':
        await BurnQuickSheet.open(context, viewModel);
      case 'coach':
        if (viewModel.state.summary != null) {
          await CoachQuickSheet.open(
            context,
            viewModel,
            viewModel.state.summary!,
          );
        }
      default:
        break;
    }
  }

  @override
  Widget viewContent(
    BuildContext context,
    TodayCubit viewModel,
    TodayState state,
  ) {
    if (state.loading || state.summary == null) {
      return AuraKit.loading();
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
                const _TodayHomeGuideSection(),
                TipCardStrip(
                  cards: [
                    ...TipCards.forSection(context, TipSection.today),
                    ...TipCards.forSection(context, TipSection.widget),
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
                Builder(
                  builder: (context) {
                    final tt = aura.Translations.of(context);
                    return Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            title: tt.today.eaten,
                            value: '${s.eaten}',
                            unit: tt.common.kcal,
                            icon: Icons.restaurant_outlined,
                          ),
                        ),
                        AuraSpace.hMd,
                        Expanded(
                          child: _MetricTile(
                            title: tt.today.burned,
                            value: '${s.burned}',
                            unit: tt.common.kcal,
                            icon: Icons.local_fire_department_outlined,
                          ),
                        ),
                        AuraSpace.hMd,
                        Expanded(
                          child: _MetricTile(
                            title: tt.today.water,
                            value: '${s.waterMl}',
                            unit: tt.common.ml,
                            icon: Icons.water_drop_outlined,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                _MacrosCard(summary: s, profile: state.profile),
                const SizedBox(height: 12),
                _AlertsCard(warnings: s.warnings),
                const SizedBox(height: 12),
                _HomeWidgetPreview(summary: s, viewModel: viewModel),
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

/// Explains the Today home surface — dismissible, persisted locally.
class _TodayHomeGuideSection extends StatefulWidget {
  const _TodayHomeGuideSection();

  static const storageKey = 'aura_today_home_guide_dismissed';

  @override
  State<_TodayHomeGuideSection> createState() => _TodayHomeGuideSectionState();
}

class _TodayHomeGuideSectionState extends State<_TodayHomeGuideSection>
    with TickerProviderStateMixin {
  bool _ready = false;
  bool _mountedInTree = false;
  bool _dismissing = false;
  late final AnimationController _shimmer;
  late final AnimationController _dismissCtrl;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _dismissCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _loadDismissed();
  }

  Future<void> _loadDismissed() async {
    await LocalStorageHelper.init();
    final dismissed =
        LocalStorageHelper.getBool(_TodayHomeGuideSection.storageKey) ?? false;
    if (!mounted) return;
    setState(() {
      _ready = true;
      _mountedInTree = !dismissed;
    });
    if (dismissed) {
      _shimmer.stop();
    }
  }

  Future<void> _dismiss() async {
    if (!_mountedInTree || _dismissing) return;
    _dismissing = true;
    _shimmer.stop();
    await _dismissCtrl.forward();
    await LocalStorageHelper.setBool(
      _TodayHomeGuideSection.storageKey,
      true,
    );
    if (!mounted) return;
    setState(() => _mountedInTree = false);
  }

  @override
  void dispose() {
    _shimmer.dispose();
    _dismissCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || !_mountedInTree) {
      return const SizedBox.shrink();
    }

    final t = aura.Translations.of(context).today;
    final theme = Theme.of(context);
    final steps = <(IconData, String, String)>[
      (
        Icons.donut_large_outlined,
        t.home_guide_ring_title,
        t.home_guide_ring_body
      ),
      (
        Icons.touch_app_outlined,
        t.home_guide_actions_title,
        t.home_guide_actions_body
      ),
      (
        Icons.insights_outlined,
        t.home_guide_metrics_title,
        t.home_guide_metrics_body
      ),
      (
        Icons.widgets_outlined,
        t.home_guide_surfaces_title,
        t.home_guide_surfaces_body
      ),
    ];

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(AuraUi.radiusMd),
      child: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(color: AuraTheme.mist),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _shimmer,
              builder: (context, _) {
                final tAnim = _shimmer.value;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1.4 + tAnim * 2.8, -0.3),
                      end: Alignment(-0.4 + tAnim * 2.8, 0.3),
                      colors: [
                        AuraTheme.mist,
                        AuraTheme.paper.withValues(alpha: 0.72),
                        AuraTheme.line.withValues(alpha: 0.55),
                        AuraTheme.paper.withValues(alpha: 0.72),
                        AuraTheme.mist,
                      ],
                      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.home_guide_title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AuraSpace.vXs,
                            Text(
                              t.home_guide_body,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AuraTheme.mute,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: aura.Translations.of(context).common.close,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _dismissing ? null : _dismiss,
                    ),
                  ],
                ),
                AuraSpace.vMd,
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) AuraSpace.vMd,
                  _TodayHomeGuideStep(
                    index: i + 1,
                    icon: steps[i].$1,
                    title: steps[i].$2,
                    body: steps[i].$3,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: _dismissCtrl,
      builder: (context, child) {
        final p = Curves.easeInOutCubic.transform(_dismissCtrl.value);
        final heightFactor = (1.0 - p).clamp(0.0, 1.0);
        final opacity = (1.0 - p * 1.05).clamp(0.0, 1.0);
        final blur = 12.0 * p;
        final slideUp = -36.0 * p;
        final bottomPad = 14.0 * heightFactor;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: heightFactor,
              child: Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, slideUp),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                      tileMode: TileMode.decal,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: card,
    );
  }
}

class _TodayHomeGuideStep extends StatelessWidget {
  const _TodayHomeGuideStep({
    required this.index,
    required this.icon,
    required this.title,
    required this.body,
  });

  final int index;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AuraTheme.paper.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(AuraUi.radiusSm),
          ),
          child: Icon(icon, size: 20, color: AuraTheme.ink),
        ),
        AuraSpace.hMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index.toString().padLeft(2, '0')} · $title',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AuraTheme.mute,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
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
    final t = aura.Translations.of(context).today;
    final actions = [
      (Icons.restaurant_outlined, onFood, t.add_food),
      (Icons.water_drop_outlined, onWater, t.add_water),
      (Icons.chat_bubble_outline, onCoach, t.open_coach),
      (Icons.local_fire_department_outlined, onBurn, t.log_burn),
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
  const _HomeWidgetPreview({
    required this.summary,
    required this.viewModel,
  });

  final DaySummary summary;
  final TodayCubit viewModel;

  static const _widgetArt = 'assets/illustrations/tips/tip_widget.webp';

  /// iOS cannot pin widgets from the app — sync snapshot, then show gallery steps.
  Future<void> _showPinGuide(BuildContext context) async {
    final t = aura.Translations.of(context).today;
    await viewModel.prepareHomeWidget();
    if (!context.mounted) return;
    await AuraKit.showSheet<void>(
      context: context,
      title: t.add_home_title,
      subtitle: t.add_home_subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AddHomeStep(index: 1, text: t.add_home_step_1),
          AuraSpace.vMd,
          _AddHomeStep(index: 2, text: t.add_home_step_2),
          AuraSpace.vMd,
          _AddHomeStep(index: 3, text: t.add_home_step_3),
          AuraSpace.vLg,
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: Text(t.add_home_done),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context).today;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AuraUi.radiusMd),
      child: ColoredBox(
        color: AuraTheme.mist,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 168,
              child: Stack(
                children: [
                  Positioned(
                    right: -28,
                    top: -12,
                    bottom: -12,
                    width: 220,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.92,
                        child: Image.asset(
                          _widgetArt,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.35, 0),
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 120,
                    top: 0,
                    bottom: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AuraTheme.mist,
                            AuraTheme.mist.withValues(alpha: 0.92),
                            AuraTheme.mist.withValues(alpha: 0.35),
                            AuraTheme.mist.withValues(alpha: 0),
                          ],
                          stops: const [0.0, 0.45, 0.78, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.home_widget,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            t.widget_hint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AuraTheme.mute,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.widget_types_title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 168,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _WidgetTypePreview(
                          width: 132,
                          label: t.widget_type_small,
                          caption: t.widget_type_small_caption,
                          child: _SmallWidgetMock(summary: summary),
                        ),
                        const SizedBox(width: 10),
                        _WidgetTypePreview(
                          width: 220,
                          label: t.widget_type_medium,
                          caption: t.widget_type_medium_caption,
                          child: _MediumWidgetMock(summary: summary),
                        ),
                        const SizedBox(width: 10),
                        _WidgetTypePreview(
                          width: 240,
                          label: t.widget_type_large,
                          caption: t.widget_type_large_caption,
                          child: _LargeTipWidgetMock(summary: summary),
                        ),
                        const SizedBox(width: 10),
                        _WidgetTypePreview(
                          width: 200,
                          label: t.widget_type_quick,
                          caption: t.widget_type_quick_caption,
                          child: _QuickActionWidgetMock(summary: summary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showPinGuide(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AuraTheme.ink,
                        side: const BorderSide(color: AuraTheme.line),
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AuraUi.radiusSm),
                        ),
                      ),
                      child: Text(t.add_home_button),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WidgetTypePreview extends StatelessWidget {
  const _WidgetTypePreview({
    required this.width,
    required this.label,
    required this.caption,
    required this.child,
  });

  final double width;
  final String label;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AuraTheme.paper,
                borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                border: Border.all(color: AuraTheme.line),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: child,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: AuraTheme.mute),
          ),
        ],
      ),
    );
  }
}

class _AuraWordmarkMark extends StatelessWidget {
  const _AuraWordmarkMark({this.height = 12});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AURA',
      image: true,
      child: Image.asset(
        'assets/illustrations/brand/aura_wordmark.png',
        height: height,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _SmallWidgetMock extends StatelessWidget {
  const _SmallWidgetMock({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AuraWordmarkMark(height: 11),
        const Spacer(),
        Text('${summary.remaining}', style: theme.textTheme.headlineSmall),
        Text(
          'kcal left',
          style: theme.textTheme.bodySmall?.copyWith(color: AuraTheme.mute),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: AuraUi.progressTrack(
            summary.goal == 0 ? 0 : summary.eaten / summary.goal,
          ),
        ),
      ],
    );
  }
}

class _MediumWidgetMock extends StatelessWidget {
  const _MediumWidgetMock({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context).today;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AuraWordmarkMark(height: 12),
        Text('${summary.remaining}', style: theme.textTheme.headlineSmall),
        Text(
          t.widget_kcal_left(goal: summary.goal),
          style: theme.textTheme.bodySmall?.copyWith(color: AuraTheme.mute),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: AuraUi.progressTrack(
            summary.goal == 0 ? 0 : summary.eaten / summary.goal,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            _MiniStat(label: 'In', value: '${summary.eaten}'),
            const Spacer(),
            _MiniStat(label: 'Out', value: '${summary.burned}'),
            const Spacer(),
            _MiniStat(label: 'Water', value: '${summary.waterMl}'),
          ],
        ),
      ],
    );
  }
}

class _LargeTipWidgetMock extends StatelessWidget {
  const _LargeTipWidgetMock({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context).today;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AuraWordmarkMark(height: 13),
        Text('${summary.remaining}', style: theme.textTheme.titleLarge),
        Text(
          t.widget_kcal_left(goal: summary.goal),
          style: theme.textTheme.bodySmall?.copyWith(color: AuraTheme.mute),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            t.widget_tip_line,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AuraTheme.mute,
              height: 1.3,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: AuraUi.progressTrack(
            summary.goal == 0 ? 0 : summary.eaten / summary.goal,
          ),
        ),
      ],
    );
  }
}

class _QuickActionWidgetMock extends StatelessWidget {
  const _QuickActionWidgetMock({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context).today;
    final actions = [
      (Icons.restaurant_outlined, t.add_food),
      (Icons.water_drop_outlined, t.add_water),
      (Icons.local_fire_department_outlined, t.log_burn),
      (Icons.chat_bubble_outline, t.open_coach),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AuraWordmarkMark(height: 12),
        Text(
          '${summary.remaining} kcal',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.55,
            children: [
              for (final a in actions)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AuraTheme.mist,
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a.$1, size: 16, color: AuraTheme.ink),
                      const SizedBox(height: 2),
                      Text(
                        a.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AuraTheme.mute,
            letterSpacing: 0.4,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _AddHomeStep extends StatelessWidget {
  const _AddHomeStep({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AuraTheme.mist,
            borderRadius: BorderRadius.circular(AuraUi.radiusSm),
          ),
          child: Text(
            '$index',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        AuraSpace.hMd,
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AuraTheme.mute,
              height: 1.4,
            ),
          ),
        ),
      ],
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
