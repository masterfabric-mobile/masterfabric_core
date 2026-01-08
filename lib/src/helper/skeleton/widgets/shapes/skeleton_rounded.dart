import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../skeleton_base.dart';

/// Rounded rectangle skeleton widget
class SkeletonRounded extends StatelessWidget {
  /// Width of the rectangle
  final double? width;

  /// Height of the rectangle
  final double height;

  /// Corner radius
  final double radius;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the skeleton
  final EdgeInsetsGeometry? margin;

  const SkeletonRounded({
    super.key,
    this.width,
    this.height = 48,
    this.radius = 12,
    this.config,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
      config: config,
      margin: margin,
    );
  }
}
