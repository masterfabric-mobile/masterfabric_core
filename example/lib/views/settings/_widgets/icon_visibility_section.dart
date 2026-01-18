import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';

/// Icon Visibility Section Widget
class IconVisibilitySection extends StatelessWidget {
  final ThemeCubit viewModel;
  final ThemeState state;

  const IconVisibilitySection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      child: SwitchListTile(
        dense: true,
        title: const Text('Show Icons'),
        subtitle: const Text('Toggle icon visibility globally'),
        value: state.showIcons,
        onChanged: (value) => viewModel.toggleIconVisibility(value),
      ),
    );
  }
}
