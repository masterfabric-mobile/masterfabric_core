import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../skeleton_base.dart';

/// Rectangle skeleton widget
class SkeletonRectangle extends StatelessWidget {
  /// Width of the rectangle
  final double? width;

  /// Height of the rectangle
  final double height;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the skeleton
  final EdgeInsetsGeometry? margin;

  const SkeletonRectangle({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.config,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      config: config,
      margin: margin,
    );
  }
}
