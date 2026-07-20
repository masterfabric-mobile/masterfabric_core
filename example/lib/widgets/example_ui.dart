import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../theme/theme_helper.dart';

enum ExampleMainTab { home, products, profile, helpers }

/// Shared modern UI primitives for the example app.
class ExampleUi {
  static Widget sectionLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  static Widget iconBadge(
    BuildContext context, {
    required IconData icon,
    Color? color,
    Color? background,
  }) {
    final c = color ?? context.accentColor;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: background ?? c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Icon(icon, size: 20, color: c),
    );
  }

  /// Compact custom tab bar with explicit safe-area padding.
  static Widget mainBottomBar(
    BuildContext context, {
    required ExampleMainTab current,
    required ValueChanged<int> onSelect,
  }) {
    // Prefer platform view padding — Scaffold can zero MediaQuery.padding.
    final viewPadding = MediaQueryData.fromView(View.of(context)).viewPadding;
    var bottom = viewPadding.bottom;
    if (bottom <= 0) {
      bottom = defaultTargetPlatform == TargetPlatform.iOS ? 28.0 : 10.0;
    }
    final surface = Theme.of(context).colorScheme.surface;
    final accent = context.accentColor;
    final muted = context.textMutedColor;
    final selectedIndex = ExampleMainTab.values.indexOf(current);

    final items = <(IconData, String)>[
      (LucideIcons.house, 'Home'),
      (LucideIcons.shoppingBag, 'Products'),
      (LucideIcons.user, 'Profile'),
      (LucideIcons.puzzle, 'Helpers'),
    ];

    // Paint under the home indicator; pad only the tab row.
    return Material(
      color: surface,
      elevation: 8,
      shadowColor: AppTheme.ink.withValues(alpha: 0.08),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surface,
          border: Border(top: BorderSide(color: context.borderColor)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 58,
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _TabItem(
                        icon: items[i].$1,
                        label: items[i].$2,
                        selected: i == selectedIndex,
                        accent: accent,
                        muted: muted,
                        onTap: () => onSelect(i),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: bottom > 0 ? bottom : 10),
          ],
        ),
      ),
    );
  }

  static Widget navTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: Border.all(color: context.borderColor),
            boxShadow: Theme.of(context).brightness == Brightness.light
                ? AppTheme.softShadow
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconBadge(context, icon: icon),
                const Spacer(),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.textMutedColor,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget listRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    bool showChevron = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              iconBadge(context, icon: icon, color: context.accentColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.textMutedColor,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: context.textMutedColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.accent,
    required this.muted,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color accent;
  final Color muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? accent : muted;
    return InkWell(
      onTap: onTap,
      splashColor: accent.withValues(alpha: 0.08),
      highlightColor: accent.withValues(alpha: 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
