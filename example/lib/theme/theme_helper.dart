import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../views/settings/cubit/theme_cubit.dart';
import '../views/settings/cubit/theme_state.dart';
import 'app_theme.dart';

/// Extension on BuildContext to access ThemeCubit and theme state
extension ThemeHelper on BuildContext {
  /// Get ThemeCubit instance from GetIt
  ThemeCubit get themeCubit => GetIt.instance<ThemeCubit>();

  /// Get current ThemeState
  ThemeState get themeState => themeCubit.state;

  /// Check if a specific view should be visible
  bool isViewVisible(String viewKey) {
    return themeState.viewVisibility[viewKey] ?? true;
  }

  /// Check if icons should be shown
  bool shouldShowIcons() {
    return themeState.showIcons;
  }

  /// Get success color from theme state
  Color get successColor => themeState.successColor;
  
  /// Get warning color from theme state
  Color get warningColor => themeState.warningColor;
  
  /// Get accent color from theme state
  Color get accentColor => themeState.accentColor;
  
  /// Get text muted color from theme state
  Color get textMutedColor => themeState.textMutedColor;
  
  /// Get border color from theme state
  Color get borderColor => themeState.borderColor;
  
  /// Get card decoration using theme colors
  BoxDecoration get cardDecoration => BoxDecoration(
    color: Theme.of(this).colorScheme.surface,
    borderRadius: BorderRadius.circular(AppTheme.radius),
    border: Border.all(color: borderColor, width: AppTheme.borderWidth),
  );
  
  /// Get code block decoration using theme colors
  BoxDecoration get codeBlockDecoration => BoxDecoration(
    color: Theme.of(this).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(AppTheme.radius),
    border: Border.all(color: borderColor, width: AppTheme.borderWidth),
  );
  
  /// Get background color from theme
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  
  /// Get font scale from theme state
  double get fontScale => themeState.fontScale;
  
  /// Apply font scale to a base font size
  double scaledFontSize(double baseSize) {
    return (baseSize * fontScale).clamp(baseSize * 0.8, baseSize * 1.5);
  }
}

/// Conditional Icon Widget - Renders icon only if showIcons is true
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

/// Conditional Widget - Renders widget only if view is visible
class ConditionalWidget extends StatelessWidget {
  final String viewKey;
  final Widget child;
  final Widget? fallback;

  const ConditionalWidget({
    super.key,
    required this.viewKey,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isViewVisible(viewKey)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}
