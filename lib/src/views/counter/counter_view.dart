import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/src/base/master_view/master_view.dart';
import 'package:masterfabric_core/src/base/widgets/master_scaffold_widget.dart';
import 'package:masterfabric_core/src/views/counter/bloc/counter_bloc.dart';
import 'package:masterfabric_core/src/views/counter/bloc/counter_event.dart';
import 'package:masterfabric_core/src/views/counter/bloc/counter_state.dart';

/// Official [MasterView] (Bloc) sample — event-driven counter.
///
/// Proves the Bloc path is first-class alongside [MasterViewCubit].
class CounterView extends MasterView<CounterBloc, CounterEvent, CounterState> {
  CounterView({
    super.key,
    required super.goRoute,
    super.arguments = const {},
  }) : super(
          currentView: MasterViewTypes.content,
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          extendBodyBehindAppBar: false,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('MasterView (Bloc)'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  void initialContent(CounterBloc viewModel, BuildContext context) {
    viewModel.add(const CounterStarted());
  }

  @override
  Widget viewContent(
    BuildContext context,
    CounterBloc viewModel,
    CounterState state,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Event-driven MasterView',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'CounterBloc · BaseViewModelBloc',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '${state.value}',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () => viewModel.add(const CounterDecremented()),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => viewModel.add(const CounterIncremented()),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => viewModel.add(const CounterReset()),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
