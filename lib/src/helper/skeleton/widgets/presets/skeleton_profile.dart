import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// Profile header skeleton
class SkeletonProfile extends StatelessWidget {
  /// Avatar size
  final double avatarSize;

  /// Number of info lines
  final int infoLines;

  /// Spacing between avatar and info
  final double spacing;

  /// Padding around the profile
  final EdgeInsetsGeometry padding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Whether to show stats row
  final bool showStats;

  /// Number of stat items
  final int statsCount;

  const SkeletonProfile({
    super.key,
    this.avatarSize = 80,
    this.infoLines = 2,
    this.spacing = 16,
    this.padding = const EdgeInsets.all(16),
    this.config,
    this.showStats = false,
    this.statsCount = 3,
  });

  /// Profile with centered layout
  const SkeletonProfile.centered({
    super.key,
    this.avatarSize = 100,
    this.infoLines = 2,
    this.spacing = 16,
    this.padding = const EdgeInsets.all(24),
    this.config,
    this.showStats = true,
    this.statsCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          SkeletonAvatar(
            size: avatarSize,
            config: config,
          ),
          SizedBox(height: spacing),
          
          // Name and info
          SkeletonText(
            width: 150,
            height: 18,
            config: config,
          ),
          const SizedBox(height: 8),
          ...List.generate(infoLines - 1, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: SkeletonText(
                width: 100 + (index * 20),
                height: 12,
                config: config,
              ),
            );
          }),

          // Stats row
          if (showStats) ...[
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(statsCount, (index) {
                return Column(
                  children: [
                    SkeletonText(
                      width: 40,
                      height: 20,
                      config: config,
                    ),
                    const SizedBox(height: 4),
                    SkeletonText(
                      width: 60,
                      height: 12,
                      config: config,
                    ),
                  ],
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

/// Horizontal profile skeleton (for list items)
class SkeletonProfileHorizontal extends StatelessWidget {
  /// Avatar size
  final double avatarSize;

  /// Number of text lines
  final int lines;

  /// Spacing between avatar and text
  final double spacing;

  /// Padding around the profile
  final EdgeInsetsGeometry padding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Whether to show action button
  final bool showAction;

  const SkeletonProfileHorizontal({
    super.key,
    this.avatarSize = 56,
    this.lines = 2,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(12),
    this.config,
    this.showAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          SkeletonAvatar(
            size: avatarSize,
            config: config,
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(lines, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index < lines - 1 ? 6 : 0),
                  child: SkeletonText(
                    width: index == 0 ? 120 : 80,
                    height: index == 0 ? 14 : 12,
                    config: config,
                  ),
                );
              }),
            ),
          ),
          if (showAction)
            SkeletonRounded(
              width: 80,
              height: 36,
              radius: 18,
              config: config,
            ),
        ],
      ),
    );
  }
}
