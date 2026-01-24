import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import '../cubit/theme_cubit.dart';

/// Reset Dialog Widget - Platform-adaptive reset confirmation dialog
class ResetDialog {
  /// Show reset confirmation dialog
  static void show({
    required BuildContext context,
    required ThemeCubit viewModel,
  }) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    
    if (isIOS) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(example_resources.resources.settings_widgets.reset_dialog_title),
          content: Text(
            example_resources.resources.settings_widgets.reset_dialog_content,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: Text(example_resources.resources.common.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                viewModel.resetToDefaults();
                Navigator.pop(ctx);
              },
              child: Text(example_resources.resources.settings_widgets.reset),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(example_resources.resources.settings_widgets.reset_dialog_title),
          content: Text(
            example_resources.resources.settings_widgets.reset_dialog_content,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(example_resources.resources.common.cancel),
            ),
            TextButton(
              onPressed: () {
                viewModel.resetToDefaults();
                Navigator.pop(ctx);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(example_resources.resources.settings_widgets.reset),
            ),
          ],
        ),
      );
    }
  }
}
