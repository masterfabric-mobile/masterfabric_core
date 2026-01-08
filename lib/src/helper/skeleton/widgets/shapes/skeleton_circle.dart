import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../skeleton_base.dart';

/// Circle skeleton widget
class SkeletonCircle extends StatelessWidget {
  /// Size (diameter) of the circle
  final double size;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the skeleton
  final EdgeInsetsGeometry? margin;

  const SkeletonCircle({
    super.key,
    this.size = 48,
    this.config,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      width: size,
      height: size,
      isCircle: true,
      config: config,
      margin: margin,
    );
  }
}
