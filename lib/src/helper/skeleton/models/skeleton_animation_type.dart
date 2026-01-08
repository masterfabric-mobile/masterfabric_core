/// Animation types for skeleton loading effects
enum SkeletonAnimationType {
  /// No animation - static skeleton
  none,

  /// Shimmer effect - gradient sweep from left to right
  shimmer,

  /// Pulse effect - fade in/out opacity animation
  pulse,

  /// Wave effect - ripple/wave animation
  wave,

  /// Glow effect - glowing border/shadow animation
  glow,

  /// Slide effect - sliding highlight animation
  slide,

  /// Bounce effect - subtle scale bounce animation
  bounce,

  /// Breathe effect - smooth breathing scale animation
  breathe,

  /// Gradient flow effect - flowing multi-color gradient
  gradientFlow,

  /// Sparkle effect - random sparkle points
  sparkle,
}

/// Extension for SkeletonAnimationType
extension SkeletonAnimationTypeExtension on SkeletonAnimationType {
  /// Convert to JSON string
  String toJson() {
    switch (this) {
      case SkeletonAnimationType.none:
        return 'none';
      case SkeletonAnimationType.shimmer:
        return 'shimmer';
      case SkeletonAnimationType.pulse:
        return 'pulse';
      case SkeletonAnimationType.wave:
        return 'wave';
      case SkeletonAnimationType.glow:
        return 'glow';
      case SkeletonAnimationType.slide:
        return 'slide';
      case SkeletonAnimationType.bounce:
        return 'bounce';
      case SkeletonAnimationType.breathe:
        return 'breathe';
      case SkeletonAnimationType.gradientFlow:
        return 'gradientFlow';
      case SkeletonAnimationType.sparkle:
        return 'sparkle';
    }
  }

  /// Create from JSON string
  static SkeletonAnimationType fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'shimmer':
        return SkeletonAnimationType.shimmer;
      case 'pulse':
        return SkeletonAnimationType.pulse;
      case 'wave':
        return SkeletonAnimationType.wave;
      case 'glow':
        return SkeletonAnimationType.glow;
      case 'slide':
        return SkeletonAnimationType.slide;
      case 'bounce':
        return SkeletonAnimationType.bounce;
      case 'breathe':
        return SkeletonAnimationType.breathe;
      case 'gradientflow':
        return SkeletonAnimationType.gradientFlow;
      case 'sparkle':
        return SkeletonAnimationType.sparkle;
      case 'none':
      default:
        return SkeletonAnimationType.shimmer; // Default to shimmer
    }
  }

  /// Get default duration for this animation type
  Duration get defaultDuration {
    switch (this) {
      case SkeletonAnimationType.none:
        return Duration.zero;
      case SkeletonAnimationType.shimmer:
        return const Duration(milliseconds: 1500);
      case SkeletonAnimationType.pulse:
        return const Duration(milliseconds: 1000);
      case SkeletonAnimationType.wave:
        return const Duration(milliseconds: 2000);
      case SkeletonAnimationType.glow:
        return const Duration(milliseconds: 1200);
      case SkeletonAnimationType.slide:
        return const Duration(milliseconds: 1800);
      case SkeletonAnimationType.bounce:
        return const Duration(milliseconds: 800);
      case SkeletonAnimationType.breathe:
        return const Duration(milliseconds: 2500);
      case SkeletonAnimationType.gradientFlow:
        return const Duration(milliseconds: 3000);
      case SkeletonAnimationType.sparkle:
        return const Duration(milliseconds: 2000);
    }
  }

  /// Get description for this animation type
  String get description {
    switch (this) {
      case SkeletonAnimationType.none:
        return 'No animation';
      case SkeletonAnimationType.shimmer:
        return 'Gradient sweep effect';
      case SkeletonAnimationType.pulse:
        return 'Fade in/out effect';
      case SkeletonAnimationType.wave:
        return 'Ripple wave effect';
      case SkeletonAnimationType.glow:
        return 'Glowing border effect';
      case SkeletonAnimationType.slide:
        return 'Sliding highlight';
      case SkeletonAnimationType.bounce:
        return 'Subtle bounce scale';
      case SkeletonAnimationType.breathe:
        return 'Smooth breathing';
      case SkeletonAnimationType.gradientFlow:
        return 'Flowing gradient';
      case SkeletonAnimationType.sparkle:
        return 'Sparkle points';
    }
  }
}
