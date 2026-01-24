import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';

/// Font Size Section Widget
class FontSizeSection extends StatelessWidget {
  final ThemeCubit viewModel;
  final ThemeState state;

  const FontSizeSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scale: ${state.fontScale.toStringAsFixed(1)}x',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextButton(
                onPressed: () => viewModel.updateFontSize(1.0),
                child: Text(example_resources.resources.settings_widgets.reset),
              ),
            ],
          ),
          Slider(
            value: state.fontScale,
            min: 0.8,
            max: 1.5,
            divisions: 14,
            label: '${state.fontScale.toStringAsFixed(1)}x',
            onChanged: (value) => viewModel.updateFontSize(value),
          ),
        ],
      ),
    );
  }
}
