import 'package:flutter/material.dart';

import '../models/force_update_models.dart';

/// Alert dialog for displaying update prompts
class UpdateAlertDialog extends StatelessWidget {
  /// Update information
  final UpdateInfo info;

  /// Localized strings
  final ForceUpdateStrings strings;

  /// Callback when update button is pressed
  final VoidCallback onUpdate;

  /// Callback when later button is pressed (null hides the button)
  final VoidCallback? onLater;

  /// Callback when skip button is pressed (null hides the button)
  final VoidCallback? onSkip;

  const UpdateAlertDialog({
    super.key,
    required this.info,
    required this.strings,
    required this.onUpdate,
    this.onLater,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isForceUpdate = info.updateType == UpdateType.force;

    return PopScope(
      canPop: info.isDismissible,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              isForceUpdate ? Icons.warning_amber_rounded : Icons.system_update,
              color: isForceUpdate
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isForceUpdate
                    ? strings.forceUpdateTitle
                    : strings.updateAvailableTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Version info
              _buildVersionChip(context),
              const SizedBox(height: 16),

              // Custom message
              if (info.customMessage != null) ...[
                Text(
                  info.customMessage!,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ],

              // Release notes
              if (info.releaseNotes != null) ...[
                Text(
                  strings.whatsNewTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  info.releaseNotes!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                  ),
                ),
              ],

              // Features list
              if (info.features != null && info.features!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  strings.whatsNewTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...info.features!.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          // Skip button
          if (onSkip != null)
            TextButton(
              onPressed: onSkip,
              child: Text(strings.skipButton),
            ),

          // Later button
          if (onLater != null)
            TextButton(
              onPressed: onLater,
              child: Text(strings.laterButton),
            ),

          // Update button
          FilledButton.icon(
            onPressed: onUpdate,
            icon: const Icon(Icons.download, size: 18),
            label: Text(strings.updateNowButton),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionChip(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${strings.versionLabel}: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
          Text(
            info.currentVersion,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            info.latestVersion,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
