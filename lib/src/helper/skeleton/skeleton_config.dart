import 'package:flutter/material.dart';

import 'models/skeleton_models.dart';

/// Configuration for skeleton widgets
class SkeletonConfig {
  /// Animation type for the skeleton
  final SkeletonAnimationType animationType;

  /// Duration of the animation
  final Duration animationDuration;

  /// Base color of the skeleton (background)
  final Color baseColor;

  /// Highlight color for the animation effect
  final Color highlightColor;

  /// Custom gradient (overrides baseColor and highlightColor if provided)
  final Gradient? gradient;

  /// Border radius for rounded shapes
  final BorderRadius? borderRadius;

  /// Whether to enable the animation
  final bool enableAnimation;

  /// Animation curve
  final Curve curve;

  /// Direction of shimmer animation
  final SkeletonDirection direction;

  const SkeletonConfig({
    this.animationType = SkeletonAnimationType.shimmer,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.gradient,
    this.borderRadius,
    this.enableAnimation = true,
    this.curve = Curves.easeInOut,
    this.direction = SkeletonDirection.ltr,
  });

  /// Create a light theme config
  factory SkeletonConfig.light({
    SkeletonAnimationType animationType = SkeletonAnimationType.shimmer,
    Duration? animationDuration,
  }) {
    return SkeletonConfig(
      animationType: animationType,
      animationDuration: animationDuration ?? animationType.defaultDuration,
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
    );
  }

  /// Create a dark theme config
  factory SkeletonConfig.dark({
    SkeletonAnimationType animationType = SkeletonAnimationType.shimmer,
    Duration? animationDuration,
  }) {
    return SkeletonConfig(
      animationType: animationType,
      animationDuration: animationDuration ?? animationType.defaultDuration,
      baseColor: const Color(0xFF424242),
      highlightColor: const Color(0xFF616161),
    );
  }

  /// Create config from theme brightness
  factory SkeletonConfig.fromBrightness(
    Brightness brightness, {
    SkeletonAnimationType animationType = SkeletonAnimationType.shimmer,
  }) {
    return brightness == Brightness.dark
        ? SkeletonConfig.dark(animationType: animationType)
        : SkeletonConfig.light(animationType: animationType);
  }

  /// Get the effective gradient
  Gradient get effectiveGradient {
    if (gradient != null) return gradient!;

    switch (animationType) {
      case SkeletonAnimationType.shimmer:
        return LinearGradient(
          begin: direction.begin,
          end: direction.end,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        );
      case SkeletonAnimationType.wave:
        return RadialGradient(
          colors: [
            highlightColor,
            baseColor,
          ],
        );
      default:
        return LinearGradient(colors: [baseColor, baseColor]);
    }
  }

  /// Copy with modifications
  SkeletonConfig copyWith({
    SkeletonAnimationType? animationType,
    Duration? animationDuration,
    Color? baseColor,
    Color? highlightColor,
    Gradient? gradient,
    BorderRadius? borderRadius,
    bool? enableAnimation,
    Curve? curve,
    SkeletonDirection? direction,
  }) {
    return SkeletonConfig(
      animationType: animationType ?? this.animationType,
      animationDuration: animationDuration ?? this.animationDuration,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      gradient: gradient ?? this.gradient,
      borderRadius: borderRadius ?? this.borderRadius,
      enableAnimation: enableAnimation ?? this.enableAnimation,
      curve: curve ?? this.curve,
      direction: direction ?? this.direction,
    );
  }
}

/// Direction for shimmer animation
enum SkeletonDirection {
  /// Left to right
  ltr,

  /// Right to left
  rtl,

  /// Top to bottom
  ttb,

  /// Bottom to top
  btt,
}

/// Extension for SkeletonDirection
extension SkeletonDirectionExtension on SkeletonDirection {
  /// Get begin alignment
  Alignment get begin {
    switch (this) {
      case SkeletonDirection.ltr:
        return Alignment.centerLeft;
      case SkeletonDirection.rtl:
        return Alignment.centerRight;
      case SkeletonDirection.ttb:
        return Alignment.topCenter;
      case SkeletonDirection.btt:
        return Alignment.bottomCenter;
    }
  }

  /// Get end alignment
  Alignment get end {
    switch (this) {
      case SkeletonDirection.ltr:
        return Alignment.centerRight;
      case SkeletonDirection.rtl:
        return Alignment.centerLeft;
      case SkeletonDirection.ttb:
        return Alignment.bottomCenter;
      case SkeletonDirection.btt:
        return Alignment.topCenter;
    }
  }
}
