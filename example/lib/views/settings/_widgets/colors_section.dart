import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';
import 'color_picker_item.dart';
import 'color_picker_dialog.dart';

/// Colors Section Widget
class ColorsSection extends StatelessWidget {
  final ThemeCubit viewModel;
  final ThemeState state;

  const ColorsSection({
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
          ColorPickerItem(
            label: 'Primary',
            color: state.primaryColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.primaryColor,
              onColorSelected: viewModel.updatePrimaryColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Secondary',
            color: state.secondaryColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.secondaryColor,
              onColorSelected: viewModel.updateSecondaryColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Accent',
            color: state.accentColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.accentColor,
              onColorSelected: viewModel.updateAccentColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Success',
            color: state.successColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.successColor,
              onColorSelected: viewModel.updateSuccessColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Warning',
            color: state.warningColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.warningColor,
              onColorSelected: viewModel.updateWarningColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Error',
            color: state.errorColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.errorColor,
              onColorSelected: viewModel.updateErrorColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Text Muted',
            color: state.textMutedColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.textMutedColor,
              onColorSelected: viewModel.updateTextMutedColor,
            ),
          ),
          const Divider(height: 1),
          ColorPickerItem(
            label: 'Border',
            color: state.borderColor,
            onTap: () => ColorPickerDialog.show(
              context: context,
              currentColor: state.borderColor,
              onColorSelected: viewModel.updateBorderColor,
            ),
          ),
        ],
      ),
    );
  }
}
