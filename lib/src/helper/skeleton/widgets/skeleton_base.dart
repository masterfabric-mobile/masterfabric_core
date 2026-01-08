import 'package:flutter/material.dart';

import '../skeleton_config.dart';
import '../skeleton_theme.dart';
import '../animations/skeleton_animation.dart';

/// Base skeleton widget that all skeleton shapes extend from
class SkeletonBase extends StatelessWidget {
  /// Width of the skeleton
  final double? width;

  /// Height of the skeleton
  final double? height;

  /// Custom skeleton configuration (overrides theme)
  final SkeletonConfig? config;

  /// Border radius for the skeleton
  final BorderRadius? borderRadius;

  /// Custom shape clipper
  final CustomClipper<Path>? clipper;

  /// Whether to use a circle shape
  final bool isCircle;

  /// Margin around the skeleton
  final EdgeInsetsGeometry? margin;

  /// Padding inside the skeleton
  final EdgeInsetsGeometry? padding;

  const SkeletonBase({
    super.key,
    this.width,
    this.height,
    this.config,
    this.borderRadius,
    this.clipper,
    this.isCircle = false,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? SkeletonTheme.configOf(context);
    final effectiveBorderRadius = borderRadius ?? effectiveConfig.borderRadius;

    Widget skeleton = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveConfig.baseColor,
        borderRadius: isCircle ? null : effectiveBorderRadius,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );

    // Apply custom clipper if provided
    if (clipper != null) {
      skeleton = ClipPath(
        clipper: clipper,
        child: skeleton,
      );
    }

    // Wrap in RepaintBoundary for performance
    skeleton = RepaintBoundary(child: skeleton);

    // Apply animation
    return SkeletonAnimation.fromType(
      config: effectiveConfig,
      child: skeleton,
    );
  }
}
