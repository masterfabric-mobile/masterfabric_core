import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../skeleton_base.dart';

/// Text line skeleton widget
class SkeletonText extends StatelessWidget {
  /// Width of the text line (null for full width)
  final double? width;

  /// Height of the text line
  final double height;

  /// Border radius
  final double radius;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the skeleton
  final EdgeInsetsGeometry? margin;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 12,
    this.radius = 4,
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

/// Multi-line text skeleton (paragraph)
class SkeletonParagraph extends StatelessWidget {
  /// Number of lines
  final int lines;

  /// Height of each line
  final double lineHeight;

  /// Spacing between lines
  final double spacing;

  /// Border radius for lines
  final double radius;

  /// Width variation for last line (0.0 to 1.0)
  final double lastLineWidth;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the paragraph
  final EdgeInsetsGeometry? margin;

  const SkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight = 12,
    this.spacing = 8,
    this.radius = 4,
    this.lastLineWidth = 0.6,
    this.config,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(lines, (index) {
          final isLast = index == lines - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
            child: FractionallySizedBox(
              widthFactor: isLast && lastLineWidth < 1.0 ? lastLineWidth : 1.0,
              alignment: Alignment.centerLeft,
              child: SkeletonText(
                height: lineHeight,
                radius: radius,
                config: config,
              ),
            ),
          );
        }),
      ),
    );
  }
}
