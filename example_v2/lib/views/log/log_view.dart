import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;

import '../../app/theme/aura_theme.dart';
import '../../data/food_catalog.dart';
import '../../data/models/food_entry.dart';
import '../../data/tip_cards.dart';
import '../../widgets/aura_sliver_app_bar.dart';
import '../../widgets/aura_toast.dart';
import '../../widgets/aura_ui.dart';
import '../../widgets/log_hero_rotator.dart';
import '../../widgets/meal_labels.dart';
import '../../widgets/tip_cards.dart';
import 'cubit/log_cubit.dart';
import 'cubit/log_state.dart';
import 'custom_food_sheet.dart';

class LogView extends MasterViewCubit<LogCubit, LogState> {
  LogView({
    super.key,
    required Function(String) goRoute,
    this.initialMeal,
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

  final String? initialMeal;

  @override
  Future<void> initialContent(LogCubit viewModel, BuildContext context) async {
    if (initialMeal != null) {
      final match = MealKind.values.where((e) => e.name == initialMeal);
      if (match.isNotEmpty) viewModel.setFilter(match.first);
    }
    await viewModel.load();
  }

  @override
  Widget viewContent(
    BuildContext context,
    LogCubit viewModel,
    LogState state,
  ) {
    if (state.loading || state.summary == null) {
      return const Center(child: CircularProgressIndicator(color: AuraTheme.ink));
    }

    final theme = Theme.of(context);
    final s = state.summary!;
    final day = state.day;
    final quick =
        FoodCatalog.foods.where((e) => e.kind == state.filter).toList();
    final dayLabel = DateFormat('EEEE, d MMM').format(day);
    final isToday = _isSameDay(day, DateTime.now());

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        AuraSliverAppBar(
          title: 'Log',
          expandedHeight: 220,
          actions: [
            IconButton(
              tooltip: 'Clear selected day',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => viewModel.clearSelectedDay(),
            ),
          ],
          hero: const LogHeroRotator(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          sliver: SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final fade = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                );
                return FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.03, 0),
                      end: Offset.zero,
                    ).animate(fade),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey('${day.year}-${day.month}-${day.day}'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                isToday ? 'Today' : dayLabel,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: AuraTheme.fontDisplay,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isToday
                    ? 'Log meals and burns for today — past days stay in the strip.'
                    : 'Viewing a past day. New adds land on this date.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AuraTheme.mute,
                ),
              ),
              const SizedBox(height: 12),
              _DayCalendarStrip(
                selected: day,
                daysWithLogs: state.daysWithLogs,
                onSelect: viewModel.selectDay,
              ),
              const SizedBox(height: 12),
              TipCardStrip(
                cards: [
                  ...TipCards.forSection('Log'),
                  ...TipCards.forSection('Water'),
                ],
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
                            isToday ? 'Today balance' : 'Day balance',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${s.eaten} in · ${s.burned} out',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontFamily: AuraTheme.fontDisplay,
                            ),
                          ),
                          Text(
                            'Net ${s.eaten - s.burned} kcal',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AuraTheme.mute,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AuraTheme.paper,
                        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                        border: Border.all(color: AuraTheme.line),
                      ),
                      child: Text(
                        '${s.entries.length + s.burns.length} items',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MealKind.values.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final kind = MealKind.values[i];
                    final selected = state.filter == kind;
                    return GestureDetector(
                      onTap: () => viewModel.setFilter(kind),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AuraTheme.ink : AuraTheme.mist,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          MealLabels.title(kind),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                selected ? AuraTheme.paper : AuraTheme.ink,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              AuraUi.appleCard(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Quick add',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _PlusAction(
                            label: 'Custom',
                            onTap: () => CustomFoodSheet.open(
                              context,
                              cubit: viewModel,
                              kind: state.filter,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...quick.map(
                      (item) => _RowTile(
                        title: item.name,
                        trailing: '${item.calories} kcal',
                        leading: Icons.add,
                        onTap: () => viewModel.addCatalog(item),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AuraUi.appleCard(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Text(
                        'Burn',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...FoodCatalog.burns.map(
                      (b) => _RowTile(
                        title: '${b.$1} · ${b.$2} min',
                        trailing: '${b.$3} kcal',
                        leading: Icons.local_fire_department_outlined,
                        onTap: () => viewModel.addBurn(b.$1, b.$2, b.$3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AuraUi.appleCard(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Text(
                        isToday ? 'Logged today' : 'Logged this day',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (state.foods.isEmpty && state.burns.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Nothing yet. Tap + on a quick add above.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AuraTheme.mute,
                          ),
                        ),
                      ),
                    ...state.foods.map(
                      (e) => _RowTile(
                        title: e.name,
                        trailing:
                            '${e.calories} · ${MealLabels.title(e.kind)}',
                        subtitle: 'Tap to confirm remove',
                        onTap: () => _confirmRemove(
                          context,
                          title: e.name,
                          onConfirm: () => viewModel.removeFood(e.id),
                        ),
                      ),
                    ),
                    ...state.burns.map(
                      (e) => _RowTile(
                        title: e.name,
                        trailing: '-${e.calories} · ${e.minutes}m',
                        subtitle: 'Tap to confirm remove',
                        onTap: () => _confirmRemove(
                          context,
                          title: e.name,
                          onConfirm: () => viewModel.removeBurn(e.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _confirmRemove(
    BuildContext context, {
    required String title,
    required Future<void> Function() onConfirm,
  }) async {
    await AuraToast.show(
      context,
      title: 'Remove entry?',
      message: title,
      tone: AuraToastTone.note,
      actionLabel: 'Remove',
      onAction: () async {
        await onConfirm();
      },
      duration: const Duration(seconds: 4),
    );
  }
}

class _DayCalendarStrip extends StatefulWidget {
  const _DayCalendarStrip({
    required this.selected,
    required this.daysWithLogs,
    required this.onSelect,
  });

  final DateTime selected;
  final Set<DateTime> daysWithLogs;
  final ValueChanged<DateTime> onSelect;

  @override
  State<_DayCalendarStrip> createState() => _DayCalendarStripState();
}

class _DayCalendarStripState extends State<_DayCalendarStrip> {
  final _controller = ScrollController();

  bool _hasLog(DateTime day) {
    return widget.daysWithLogs.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(
      21,
      (i) => DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 20 - i)),
    );

    return SizedBox(
      height: 78,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day.year == widget.selected.year &&
              day.month == widget.selected.month &&
              day.day == widget.selected.day;
          final logged = _hasLog(day);
          final weekday = DateFormat('E').format(day);

          return GestureDetector(
            onTap: () => widget.onSelect(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: 52,
              decoration: BoxDecoration(
                color: isSelected ? AuraTheme.ink : AuraTheme.mist,
                borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                border: Border.all(
                  color: isSelected
                      ? AuraTheme.ink
                      : (logged ? AuraTheme.ink : AuraTheme.line),
                  width: logged && !isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AuraTheme.paper : AuraTheme.mute,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontFamily: AuraTheme.fontDisplay,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AuraTheme.paper : AuraTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: logged
                          ? (isSelected ? AuraTheme.paper : AuraTheme.ink)
                          : Colors.transparent,
                      border: logged
                          ? null
                          : Border.all(
                              color: isSelected
                                  ? AuraTheme.paper.withValues(alpha: 0.25)
                                  : AuraTheme.line,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlusAction extends StatelessWidget {
  const _PlusAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AuraTheme.paper,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AuraTheme.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AuraTheme.ink,
                  borderRadius: BorderRadius.circular(6),
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
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({
    required this.title,
    required this.trailing,
    required this.onTap,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String trailing;
  final VoidCallback onTap;
  final String? subtitle;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              if (leading != null) ...[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AuraTheme.paper,
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    border: Border.all(color: AuraTheme.line),
                  ),
                  child: Icon(leading, size: 18, color: AuraTheme.ink),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AuraTheme.mute,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 13,
                  color: AuraTheme.mute,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
