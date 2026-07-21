import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/fitness_calculator.dart';
import '../../data/food_catalog.dart';
import '../../data/models/food_entry.dart';
import '../../widgets/aura_toast.dart';
import '../../widgets/aura_ui.dart';
import '../../widgets/meal_labels.dart';
import 'cubit/today_cubit.dart';

Future<T?> _openSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AuraTheme.paper,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: builder,
  );
}

/// Fixed-height sheet shell: header + scrollable body (no overflow).
class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.title,
    required this.subtitle,
    required this.child,
    this.heightFactor = 0.72,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final height = media.size.height * heightFactor;

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          media.padding.bottom + 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AuraTheme.line,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: AuraTheme.fontDisplay,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AuraTheme.mute,
                  ),
            ),
            const SizedBox(height: 14),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// Food: pick meal → quick catalog → log on Today (no tab switch).
abstract final class FoodQuickSheet {
  static Future<void> open(BuildContext context, TodayCubit cubit) {
    return _openSheet(
      context: context,
      builder: (ctx) => _FoodQuickBody(cubit: cubit),
    );
  }
}

class _FoodQuickBody extends StatefulWidget {
  const _FoodQuickBody({required this.cubit});

  final TodayCubit cubit;

  @override
  State<_FoodQuickBody> createState() => _FoodQuickBodyState();
}

class _FoodQuickBodyState extends State<_FoodQuickBody> {
  MealKind _kind = MealKind.breakfast;

  List<CatalogItem> get _items =>
      FoodCatalog.foods.where((e) => e.kind == _kind).toList();

  Future<void> _log(CatalogItem item) async {
    await widget.cubit.addCatalog(item);
    if (!mounted) return;
    Navigator.of(context).pop();
    await AuraToast.pulse(
      context,
      title: MealLabels.title(context, item.kind),
      loadingMessage: 'Adding ${item.name}…',
      doneMessage: 'Logged · ${item.calories} kcal',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: 'Log food',
      subtitle: 'Stay on Today — pick a meal, tap a plate.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MealKind.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final kind = MealKind.values[i];
                final selected = kind == _kind;
                return GestureDetector(
                  onTap: () => setState(() => _kind = kind),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AuraTheme.ink : AuraTheme.mist,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      MealLabels.title(context, kind),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? AuraTheme.paper : AuraTheme.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            MealLabels.caption(context, _kind),
            style: const TextStyle(color: AuraTheme.mute, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final item = _items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: AuraTheme.mist,
                    borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                      onTap: () => _log(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(MealLabels.icon(_kind), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontFamily: AuraTheme.fontDisplay,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${item.calories} kcal',
                              style: const TextStyle(color: AuraTheme.mute),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.add, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Water: amount chips logged on Today.
abstract final class WaterQuickSheet {
  static Future<void> open(BuildContext context, TodayCubit cubit) {
    return _openSheet(
      context: context,
      builder: (ctx) {
        const amounts = [250, 500, 750, 1000];
        return _SheetShell(
          title: 'Add water',
          subtitle: 'One tap. Rings and coach update instantly.',
          heightFactor: 0.48,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
            children: amounts.map((ml) {
              return Material(
                color: AuraTheme.mist,
                borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                  onTap: () async {
                    await cubit.addWater(ml);
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    await AuraToast.pulse(
                      context,
                      title: 'Water',
                      loadingMessage: 'Logging $ml ml…',
                      doneMessage: '+$ml ml on the day.',
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.water_drop_outlined, size: 22),
                      const SizedBox(height: 8),
                      Text(
                        '$ml ml',
                        style: const TextStyle(
                          fontFamily: AuraTheme.fontDisplay,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

/// Burn: catalog sessions logged on Today.
abstract final class BurnQuickSheet {
  static Future<void> open(BuildContext context, TodayCubit cubit) {
    return _openSheet(
      context: context,
      builder: (ctx) {
        return _SheetShell(
          title: 'Log burn',
          subtitle: 'Capture movement without leaving Today.',
          heightFactor: 0.68,
          child: ListView.builder(
            itemCount: FoodCatalog.burns.length,
            itemBuilder: (context, i) {
              final b = FoodCatalog.burns[i];
              final name = b.$1;
              final minutes = b.$2;
              final calories = b.$3;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AuraTheme.mist,
                  borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                    onTap: () async {
                      await cubit.addBurn(
                        name: name,
                        minutes: minutes,
                        calories: calories,
                      );
                      if (!ctx.mounted) return;
                      Navigator.of(ctx).pop();
                      await AuraToast.pulse(
                        context,
                        title: 'Burn',
                        loadingMessage: 'Saving $name…',
                        doneMessage: '−$calories kcal · ${minutes}m',
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontFamily: AuraTheme.fontDisplay,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '$minutes min',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AuraTheme.mute,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '−$calories',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Coach lite: tips + journal note without leaving Today.
abstract final class CoachQuickSheet {
  static Future<void> open(
    BuildContext context,
    TodayCubit cubit,
    DaySummary summary,
  ) {
    return _openSheet(
      context: context,
      builder: (ctx) => _CoachQuickBody(cubit: cubit, summary: summary),
    );
  }
}

class _CoachQuickBody extends StatefulWidget {
  const _CoachQuickBody({
    required this.cubit,
    required this.summary,
  });

  final TodayCubit cubit;
  final DaySummary summary;

  @override
  State<_CoachQuickBody> createState() => _CoachQuickBodyState();
}

class _CoachQuickBodyState extends State<_CoachQuickBody> {
  final _note = TextEditingController();
  var _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final text = _note.text.trim();
    if (text.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      await widget.cubit.addJournal(text);
      if (!mounted) return;
      Navigator.of(context).pop();
      await AuraToast.pulse(
        context,
        title: 'Journal',
        loadingMessage: 'Saving note…',
        doneMessage: 'Note kept on this device.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tips = widget.summary.warnings.isEmpty
        ? <String>[
            'Remaining ${widget.summary.remaining} kcal — you’re in range.',
            'Water ${widget.summary.waterMl} ml so far.',
          ]
        : widget.summary.warnings;

    return _SheetShell(
      title: 'Coach pulse',
      subtitle: 'Quick read + one note. Full Coach stays optional.',
      heightFactor: 0.75,
      child: ListView(
        children: [
          ...tips.take(4).map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AuraUi.appleCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.bolt_outlined, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(t, style: const TextStyle(height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 8),
          const Text(
            'Quick journal',
            style: TextStyle(
              fontFamily: AuraTheme.fontDisplay,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'How did training or meals feel?',
            ),
            onSubmitted: (_) => _saveNote(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _saveNote,
              child: Text(_saving ? 'Saving…' : 'Save note'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              GoRouter.of(context).go(app_routes.AppRoutes.coach);
            },
            child: const Text('Open full Coach'),
          ),
        ],
      ),
    );
  }
}
