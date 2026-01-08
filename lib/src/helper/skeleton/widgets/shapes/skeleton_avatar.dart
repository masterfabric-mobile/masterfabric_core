import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import 'skeleton_circle.dart';
import 'skeleton_rounded.dart';

/// Avatar style for skeleton
enum SkeletonAvatarStyle {
  /// Circular avatar
  circle,

  /// Rounded square avatar
  rounded,
}

/// Avatar skeleton widget
class SkeletonAvatar extends StatelessWidget {
  /// Size of the avatar
  final double size;

  /// Avatar style (circle or rounded)
  final SkeletonAvatarStyle style;

  /// Corner radius (for rounded style)
  final double radius;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the avatar
  final EdgeInsetsGeometry? margin;

  const SkeletonAvatar({
    super.key,
    this.size = 48,
    this.style = SkeletonAvatarStyle.circle,
    this.radius = 8,
    this.config,
    this.margin,
  });

  /// Small avatar (32px)
  const SkeletonAvatar.small({
    super.key,
    this.style = SkeletonAvatarStyle.circle,
    this.radius = 6,
    this.config,
    this.margin,
  }) : size = 32;

  /// Medium avatar (48px)
  const SkeletonAvatar.medium({
    super.key,
    this.style = SkeletonAvatarStyle.circle,
    this.radius = 8,
    this.config,
    this.margin,
  }) : size = 48;

  /// Large avatar (64px)
  const SkeletonAvatar.large({
    super.key,
    this.style = SkeletonAvatarStyle.circle,
    this.radius = 12,
    this.config,
    this.margin,
  }) : size = 64;

  /// Extra large avatar (96px)
  const SkeletonAvatar.extraLarge({
    super.key,
    this.style = SkeletonAvatarStyle.circle,
    this.radius = 16,
    this.config,
    this.margin,
  }) : size = 96;

  @override
  Widget build(BuildContext context) {
    if (style == SkeletonAvatarStyle.circle) {
      return SkeletonCircle(
        size: size,
        config: config,
        margin: margin,
      );
    }

    return SkeletonRounded(
      width: size,
      height: size,
      radius: radius,
      config: config,
      margin: margin,
    );
  }
}
