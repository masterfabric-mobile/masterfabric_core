import 'package:flutter/material.dart';

import 'skeleton_config.dart';

/// Theme widget for providing consistent skeleton configuration to descendants
class SkeletonTheme extends InheritedWidget {
  /// Skeleton configuration
  final SkeletonConfig config;

  const SkeletonTheme({
    super.key,
    required this.config,
    required super.child,
  });

  /// Get the nearest SkeletonTheme from context
  static SkeletonTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkeletonTheme>();
  }

  /// Get the nearest SkeletonTheme from context (throws if not found)
  static SkeletonTheme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(theme != null, 'No SkeletonTheme found in context');
    return theme!;
  }

  /// Get config from context or return default
  static SkeletonConfig configOf(BuildContext context) {
    return maybeOf(context)?.config ?? _defaultConfig(context);
  }

  /// Create default config based on theme brightness
  static SkeletonConfig _defaultConfig(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SkeletonConfig.fromBrightness(brightness);
  }

  @override
  bool updateShouldNotify(SkeletonTheme oldWidget) {
    return config != oldWidget.config;
  }
}

/// Extension to easily get skeleton config from BuildContext
extension SkeletonThemeExtension on BuildContext {
  /// Get skeleton config from nearest SkeletonTheme or default
  SkeletonConfig get skeletonConfig => SkeletonTheme.configOf(this);

  /// Get skeleton theme if available
  SkeletonTheme? get skeletonTheme => SkeletonTheme.maybeOf(this);
}
