import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// Social media post skeleton
class SkeletonSocialPost extends StatelessWidget {
  /// Whether to show the image
  final bool showImage;

  /// Height of the image
  final double imageHeight;

  /// Padding around the post
  final EdgeInsetsGeometry padding;

  /// Spacing between sections
  final double spacing;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Number of action buttons
  final int actionCount;

  /// Whether to show comments section
  final bool showComments;

  /// Number of comment previews
  final int commentCount;

  const SkeletonSocialPost({
    super.key,
    this.showImage = true,
    this.imageHeight = 300,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 12,
    this.config,
    this.actionCount = 3,
    this.showComments = false,
    this.commentCount = 2,
  });

  /// Text-only post (no image)
  const SkeletonSocialPost.textOnly({
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 12,
    this.config,
    this.actionCount = 3,
    this.showComments = false,
    this.commentCount = 2,
  })  : showImage = false,
        imageHeight = 0;

  /// Post with comments
  const SkeletonSocialPost.withComments({
    super.key,
    this.showImage = true,
    this.imageHeight = 250,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 12,
    this.config,
    this.actionCount = 3,
    this.commentCount = 2,
  }) : showComments = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (avatar + name + time)
          Row(
            children: [
              SkeletonAvatar(size: 40, config: config),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 120, height: 14, config: config),
                    const SizedBox(height: 4),
                    SkeletonText(width: 80, height: 10, config: config),
                  ],
                ),
              ),
              SkeletonCircle(size: 24, config: config),
            ],
          ),

          SizedBox(height: spacing),

          // Caption
          SkeletonParagraph(
            lines: 2,
            lineHeight: 14,
            spacing: 6,
            lastLineWidth: 0.7,
            config: config,
          ),

          // Image
          if (showImage) ...[
            SizedBox(height: spacing),
            SkeletonRounded(
              width: double.infinity,
              height: imageHeight,
              radius: 8,
              config: config,
            ),
          ],

          SizedBox(height: spacing),

          // Actions row (like, comment, share)
          Row(
            children: List.generate(actionCount, (index) {
              return Padding(
                padding: EdgeInsets.only(right: index < actionCount - 1 ? 24 : 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SkeletonCircle(size: 20, config: config),
                    const SizedBox(width: 6),
                    SkeletonText(width: 30, height: 12, config: config),
                  ],
                ),
              );
            }),
          ),

          // Comments section
          if (showComments) ...[
            SizedBox(height: spacing),
            const Divider(),
            SizedBox(height: spacing / 2),
            ...List.generate(commentCount, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < commentCount - 1 ? spacing : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonAvatar(size: 32, config: config),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SkeletonText(width: 80, height: 12, config: config),
                              const SizedBox(width: 8),
                              SkeletonText(width: 40, height: 10, config: config),
                            ],
                          ),
                          const SizedBox(height: 4),
                          SkeletonText(height: 12, config: config),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

/// Story/reel thumbnail skeleton
class SkeletonStory extends StatelessWidget {
  /// Size of the story circle
  final double size;

  /// Whether to show the label
  final bool showLabel;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  const SkeletonStory({
    super.key,
    this.size = 72,
    this.showLabel = true,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: config?.baseColor ?? const Color(0xFFE0E0E0),
              width: 2,
            ),
          ),
          child: SkeletonCircle(size: size - 6, config: config),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          SkeletonText(width: size * 0.8, height: 10, config: config),
        ],
      ],
    );
  }
}

/// Row of story skeletons
class SkeletonStoryRow extends StatelessWidget {
  /// Number of stories
  final int count;

  /// Size of each story
  final double storySize;

  /// Spacing between stories
  final double spacing;

  /// Padding around the row
  final EdgeInsetsGeometry padding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  const SkeletonStoryRow({
    super.key,
    this.count = 5,
    this.storySize = 72,
    this.spacing = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(count, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index < count - 1 ? spacing : 0),
            child: SkeletonStory(size: storySize, config: config),
          );
        }),
      ),
    );
  }
}
