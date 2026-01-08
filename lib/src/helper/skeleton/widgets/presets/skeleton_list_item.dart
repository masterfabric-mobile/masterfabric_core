import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// List item skeleton with avatar and text lines
class SkeletonListItem extends StatelessWidget {
  /// Whether to show the avatar
  final bool showAvatar;

  /// Avatar size
  final double avatarSize;

  /// Number of text lines
  final int lines;

  /// Spacing between avatar and text
  final double spacing;

  /// Height of each text line
  final double lineHeight;

  /// Spacing between text lines
  final double lineSpacing;

  /// Padding inside the list item
  final EdgeInsetsGeometry padding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Width of the first line (0.0 to 1.0)
  final double firstLineWidth;

  /// Width of the last line (0.0 to 1.0)
  final double lastLineWidth;

  const SkeletonListItem({
    super.key,
    this.showAvatar = true,
    this.avatarSize = 48,
    this.lines = 2,
    this.spacing = 12,
    this.lineHeight = 12,
    this.lineSpacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.config,
    this.firstLineWidth = 0.7,
    this.lastLineWidth = 0.5,
  });

  /// Simple list item with one line
  const SkeletonListItem.simple({
    super.key,
    this.showAvatar = true,
    this.avatarSize = 40,
    this.spacing = 12,
    this.lineHeight = 14,
    this.lineSpacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.config,
    this.firstLineWidth = 0.6,
    this.lastLineWidth = 0.6,
  }) : lines = 1;

  /// Dense list item
  const SkeletonListItem.dense({
    super.key,
    this.showAvatar = true,
    this.avatarSize = 36,
    this.spacing = 10,
    this.lineHeight = 10,
    this.lineSpacing = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.config,
    this.firstLineWidth = 0.5,
    this.lastLineWidth = 0.3,
  }) : lines = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            SkeletonAvatar(
              size: avatarSize,
              config: config,
            ),
            SizedBox(width: spacing),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(lines, (index) {
                final isFirst = index == 0;
                final isLast = index == lines - 1;
                double widthFactor = 1.0;
                
                if (lines > 1) {
                  if (isFirst) widthFactor = firstLineWidth;
                  else if (isLast) widthFactor = lastLineWidth;
                }
                
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : lineSpacing),
                  child: FractionallySizedBox(
                    widthFactor: widthFactor,
                    alignment: Alignment.centerLeft,
                    child: SkeletonText(
                      height: lineHeight,
                      config: config,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
