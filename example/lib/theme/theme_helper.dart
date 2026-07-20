import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../views/settings/cubit/theme_cubit.dart';
import '../views/settings/cubit/theme_state.dart';
import 'app_theme.dart';

/// BuildContext helpers for theme + visibility.
extension ThemeHelper on BuildContext {
  ThemeCubit get themeCubit => GetIt.instance<ThemeCubit>();

  ThemeState get themeState => themeCubit.state;

  bool isViewVisible(String viewKey) {
    return themeState.viewVisibility[viewKey] ?? true;
  }

  bool shouldShowIcons() => themeState.showIcons;

  Color get successColor => themeState.successColor;
  Color get warningColor => themeState.warningColor;
  Color get accentColor => themeState.accentColor;
  Color get textMutedColor => themeState.textMutedColor;
  Color get borderColor => themeState.borderColor;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  double get fontScale => themeState.fontScale;

  double scaledFontSize(double baseSize) {
    return (baseSize * fontScale).clamp(baseSize * 0.8, baseSize * 1.5);
  }

  BoxDecoration get cardDecoration => BoxDecoration(
        color: Theme.of(this).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: borderColor, width: AppTheme.borderWidth),
        boxShadow: Theme.of(this).brightness == Brightness.light
            ? AppTheme.softShadow
            : null,
      );

  BoxDecoration get codeBlockDecoration => BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: borderColor, width: AppTheme.borderWidth),
      );
}

/// Renders [icon] only when icons are enabled in theme settings.
class ConditionalIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final BuildContext context;

  const ConditionalIcon({
    super.key,
    required this.context,
    required this.icon,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (context.shouldShowIcons()) {
      return Icon(icon, size: size, color: color);
    }
    return const SizedBox.shrink();
  }
}
