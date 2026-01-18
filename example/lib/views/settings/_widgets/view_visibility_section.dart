import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';

/// View Visibility Section Widget
class ViewVisibilitySection extends StatelessWidget {
  final ThemeCubit viewModel;
  final ThemeState state;

  const ViewVisibilitySection({
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
          _buildVisibilityToggle(
            context,
            'Home View',
            'home',
            state.viewVisibility['home'] ?? true,
            viewModel,
          ),
          const Divider(height: 1),
          _buildVisibilityToggle(
            context,
            'Profile View',
            'profile',
            state.viewVisibility['profile'] ?? true,
            viewModel,
          ),
          const Divider(height: 1),
          _buildVisibilityToggle(
            context,
            'Products View',
            'products',
            state.viewVisibility['products'] ?? true,
            viewModel,
          ),
          const Divider(height: 1),
          _buildVisibilityToggle(
            context,
            'Helpers Hub',
            'helpersHub',
            state.viewVisibility['helpersHub'] ?? true,
            viewModel,
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityToggle(
    BuildContext context,
    String label,
    String viewKey,
    bool isVisible,
    ThemeCubit viewModel,
  ) {
    return SwitchListTile(
      dense: true,
      title: Text(label),
      value: isVisible,
      onChanged: (value) => viewModel.toggleViewVisibility(viewKey, value),
    );
  }
}
