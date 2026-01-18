import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
          title: const Text('Reset to Defaults'),
          content: const Text(
            'This will reset all theme settings to their default values. This action cannot be undone.',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                viewModel.resetToDefaults();
                Navigator.pop(ctx);
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Reset to Defaults'),
          content: const Text(
            'This will reset all theme settings to their default values. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viewModel.resetToDefaults();
                Navigator.pop(ctx);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Reset'),
            ),
          ],
        ),
      );
    }
  }
}
