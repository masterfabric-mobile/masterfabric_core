import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/theme_helper.dart';
import '../cubit/theme_cubit.dart';
import 'reset_dialog.dart';

/// Reset Section Widget
class ResetSection extends StatelessWidget {
  final ThemeCubit viewModel;

  const ResetSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      child: ListTile(
        dense: true,
        leading: ConditionalIcon(
          context: context,
          icon: LucideIcons.rotateCcw,
          size: 18,
        ),
        title: const Text('Reset to Defaults'),
        subtitle: const Text('Restore all theme settings'),
        onTap: () => ResetDialog.show(context: context, viewModel: viewModel),
      ),
    );
  }
}
