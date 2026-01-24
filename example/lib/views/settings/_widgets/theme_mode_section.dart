import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';

/// Theme Mode Section Widget
class ThemeModeSection extends StatelessWidget {
  final ThemeCubit viewModel;
  final ThemeState state;

  const ThemeModeSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: [
          RadioListTile<Brightness>(
            dense: true,
            title: Text(example_resources.resources.settings.light),
            value: Brightness.light,
            groupValue: state.brightness,
            onChanged: (value) {
              if (value != null) {
                viewModel.setBrightness(value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<Brightness>(
            dense: true,
            title: Text(example_resources.resources.settings.dark),
            value: Brightness.dark,
            groupValue: state.brightness,
            onChanged: (value) {
              if (value != null) {
                viewModel.setBrightness(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
