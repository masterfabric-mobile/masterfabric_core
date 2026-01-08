import 'package:flutter/material.dart';

import '../models/force_update_models.dart';

/// Bottom sheet for displaying update prompts
class UpdateBottomSheet extends StatelessWidget {
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

  const UpdateBottomSheet({
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
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                if (info.isDismissible)
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                // Icon
                Icon(
                  isForceUpdate
                      ? Icons.warning_amber_rounded
                      : Icons.system_update_rounded,
                  size: 64,
                  color: isForceUpdate
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  isForceUpdate
                      ? strings.forceUpdateTitle
                      : strings.updateAvailableTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Version badge
                Center(child: _buildVersionBadge(context)),
                const SizedBox(height: 16),

                // Custom message
                if (info.customMessage != null) ...[
                  Text(
                    info.customMessage!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],

                // Features or release notes
                if (info.features != null && info.features!.isNotEmpty) ...[
                  Text(
                    strings.whatsNewTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...info.features!.take(4).map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 14,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (info.features!.length > 4)
                    Text(
                      '+${info.features!.length - 4} more',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ] else if (info.releaseNotes != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      info.releaseNotes!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Update button
                FilledButton.icon(
                  onPressed: onUpdate,
                  icon: const Icon(Icons.download),
                  label: Text(strings.updateNowButton),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                // Secondary buttons
                if (onLater != null || onSkip != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (onSkip != null)
                        TextButton(
                          onPressed: onSkip,
                          child: Text(strings.skipButton),
                        ),
                      if (onSkip != null && onLater != null)
                        const SizedBox(width: 16),
                      if (onLater != null)
                        TextButton(
                          onPressed: onLater,
                          child: Text(strings.laterButton),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionBadge(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            info.currentVersion,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.arrow_forward,
              size: 16,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            info.latestVersion,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
