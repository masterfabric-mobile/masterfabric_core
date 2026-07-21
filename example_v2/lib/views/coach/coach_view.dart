import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;

import '../../app/theme/aura_theme.dart';
import '../../data/models/journal_entry.dart';
import '../../data/tip_cards.dart';
import '../../src/resources/resources.g.dart' as aura;
import '../../widgets/aura_kit.dart';
import '../../widgets/aura_sliver_app_bar.dart';
import '../../widgets/aura_ui.dart';
import '../../widgets/tip_cards.dart';
import 'coach_process_sheet.dart';
import 'cubit/coach_cubit.dart';
import 'cubit/coach_state.dart';
import 'llm_coach_sheet.dart';

class CoachView extends MasterViewCubit<CoachCubit, CoachState> {
  CoachView({
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
  Future<void> initialContent(CoachCubit viewModel, BuildContext context) async {
    await viewModel.load();
  }

  @override
  Widget viewContent(
    BuildContext context,
    CoachCubit viewModel,
    CoachState state,
  ) {
    if (state.loading) {
      return AuraKit.loading();
    }

    final theme = Theme.of(context);
    final help = CoachCubit.helpTopics[state.helpIndex];
    final settings = state.settings;
    final tips = [
      ...TipCards.forSection(context, TipSection.coach),
      ...TipCards.forSection(context, TipSection.widget),
      TipCards.all(context).first,
    ];

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        AuraSliverAppBar(
          title: aura.Translations.of(context).coach.title,
          expandedHeight: 200,
          actions: [
            IconButton(
              tooltip: 'How AURA works',
              icon: const Icon(Icons.menu_book_outlined),
              onPressed: () => CoachProcessSheet.open(context),
            ),
            IconButton(
              tooltip: 'Refresh tips',
              icon: const Icon(Icons.refresh),
              onPressed: () => viewModel.refreshTips(),
            ),
          ],
          hero: Material(
            color: AuraTheme.paper,
            child: InkWell(
              onTap: () => CoachProcessSheet.open(context),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AuraArt.coach.asset,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ),
                  Positioned(
                    left: 16,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AuraTheme.mist.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AuraTheme.line),
                      ),
                      child: const Text(
                        'Tap for the full process',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: AuraSpace.pagePadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
        AuraUi.appleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily assist',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rule tips always run. Local activity jobs nudge meals, water, movement, and journal through the day. On a real iPhone, WebLLM adds health and food coaching.',
                style: theme.textTheme.bodyMedium?.copyWith(color: AuraTheme.mute),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Guides',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TipCardStrip(cards: tips),
        const SizedBox(height: 12),
        LlmCoachEntryCard(
          enabled: state.isPhysicalDevice,
          onHealth: () => LlmCoachSheet.open(
            context,
            role: LlmCoachRole.health,
            contextText: state.contextText,
          ),
          onFood: () => LlmCoachSheet.open(
            context,
            role: LlmCoachRole.food,
            contextText: state.contextText,
          ),
        ),
        const SizedBox(height: 12),
        _JournalCard(
          entries: state.journal,
          onAdd: (text) => viewModel.addJournal(text),
          onRemove: (id) => viewModel.removeJournal(id),
        ),
        const SizedBox(height: 12),
        AuraUi.appleCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ...state.tips.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AuraUi.warningRow(t),
                ),
              ),
              const SizedBox(height: 4),
              FilledButton(
                onPressed: () => viewModel.sendCheckIn(),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                  ),
                ),
                child: const Text('Push check-in'),
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
                help.$1,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(help.$2, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => viewModel.nextHelp(),
                child: const Text('Next topic'),
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
                'Alerts & reminders',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _toggle('Local reminders', settings.remindersEnabled,
                  viewModel.toggleReminders),
              _toggle('Warn when over goal', settings.warnOverGoal,
                  viewModel.toggleWarnOver),
              _toggle('Warn when under-fueled', settings.warnUnderGoal,
                  viewModel.toggleWarnUnder),
              _toggle('Warn on low water', settings.warnLowWater,
                  viewModel.toggleWarnWater),
              const SizedBox(height: 8),
              Text(
                'Meal ${settings.mealReminderHour}:00 · water ${settings.waterReminderHour}:00',
                style: theme.textTheme.bodySmall,
              ),
              TextButton(
                onPressed: () {
                  final meal = (settings.mealReminderHour % 20) + 1;
                  final water = (settings.waterReminderHour % 20) + 1;
                  viewModel.updateSettings(
                    settings.copyWith(
                      mealReminderHour: meal < 8 ? 8 : meal,
                      waterReminderHour: water < 10 ? 10 : water,
                    ),
                  );
                },
                child: const Text('Shift reminder hours'),
              ),
            ],
          ),
        ),
        if (state.summary != null && state.summary!.warnings.isNotEmpty) ...[
          const SizedBox(height: 12),
          AuraUi.appleCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active warnings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ...state.summary!.warnings.map(AuraUi.warningRow),
              ],
            ),
          ),
        ],
            ]),
          ),
        ),
      ],
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              value ? 'On' : 'Off',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: value ? AuraTheme.ink : AuraTheme.mute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalCard extends StatefulWidget {
  const _JournalCard({
    required this.entries,
    required this.onAdd,
    required this.onRemove,
  });

  final List<JournalEntry> entries;
  final Future<void> Function(String text) onAdd;
  final Future<void> Function(String id) onRemove;

  @override
  State<_JournalCard> createState() => _JournalCardState();
}

class _JournalCardState extends State<_JournalCard> {
  final _controller = TextEditingController();
  var _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      await widget.onAdd(text);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _stamp(DateTime at) {
    final hh = at.hour.toString().padLeft(2, '0');
    final mm = at.minute.toString().padLeft(2, '0');
    return '${at.day}.${at.month}.${at.year} · $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journal',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Short notes on energy, hunger, and mood. Stays on this device.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AuraTheme.mute),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'How did today feel? What worked?',
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: Text(_saving ? 'Saving…' : 'Add journal note'),
          ),
          if (widget.entries.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...widget.entries.take(8).map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: AuraTheme.paper,
                  borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    onLongPress: () => widget.onRemove(entry.id),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _stamp(entry.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AuraTheme.mute,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.text,
                            style: const TextStyle(fontSize: 15, height: 1.4),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Long-press to delete',
                            style: TextStyle(fontSize: 11, color: AuraTheme.mute),
                          ),
                        ],
                      ),
                    ),
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
