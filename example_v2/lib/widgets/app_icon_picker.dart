import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';
import '../data/models/app_icon_style.dart';
import '../src/resources/resources.g.dart' as aura;
import 'aura_kit.dart';

/// Shared app icon chooser used by onboarding + profile sheet.
class AppIconPicker extends StatelessWidget {
  const AppIconPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.compact = false,
  });

  final AppIconStyle selected;
  final ValueChanged<AppIconStyle> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = aura.Translations.of(context);
    final gap = compact ? 8.0 : 10.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 340 ? 2 : 3;
        final tileWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final style in AppIconStyle.values)
              SizedBox(
                width: tileWidth,
                child: _IconOption(
                  style: style,
                  label: _label(t, style),
                  caption: _caption(t, style),
                  selected: selected == style,
                  compact: compact,
                  onTap: () => onSelected(style),
                ),
              ),
          ],
        );
      },
    );
  }

  static String _label(aura.Translations t, AppIconStyle style) {
    return switch (style) {
      AppIconStyle.woman => t.app_icon.woman,
      AppIconStyle.man => t.app_icon.man,
      AppIconStyle.crew => t.app_icon.crew,
      AppIconStyle.classic => t.app_icon.classic,
      AppIconStyle.mark => t.app_icon.abstract,
    };
  }

  static String _caption(aura.Translations t, AppIconStyle style) {
    return switch (style) {
      AppIconStyle.woman => t.app_icon.woman_caption,
      AppIconStyle.man => t.app_icon.man_caption,
      AppIconStyle.crew => t.app_icon.crew_caption,
      AppIconStyle.classic => t.app_icon.classic_caption,
      AppIconStyle.mark => t.app_icon.abstract_caption,
    };
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.style,
    required this.label,
    required this.caption,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final AppIconStyle style;
  final String label;
  final String caption;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(AuraUi.radiusMd);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(
            compact ? 8 : 10,
            compact ? 10 : 12,
            compact ? 8 : 10,
            compact ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: selected ? AuraTheme.ink : AuraTheme.mist,
            borderRadius: radius,
            border: Border.all(
              color: selected ? AuraTheme.ink : AuraTheme.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    style.assetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: compact ? 8 : 10),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? AuraTheme.paper : AuraTheme.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                caption,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  height: 1.25,
                  color: selected
                      ? AuraTheme.paper.withValues(alpha: 0.72)
                      : AuraTheme.mute,
                ),
              ),
              if (selected) ...[
                const SizedBox(height: 6),
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AuraTheme.paper.withValues(alpha: 0.9),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
