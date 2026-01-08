import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// Article skeleton with title, image, and paragraphs
class SkeletonArticle extends StatelessWidget {
  /// Whether to show the featured image
  final bool showImage;

  /// Height of the featured image
  final double imageHeight;

  /// Number of paragraph sections
  final int paragraphs;

  /// Lines per paragraph
  final int linesPerParagraph;

  /// Padding around the article
  final EdgeInsetsGeometry padding;

  /// Spacing between sections
  final double sectionSpacing;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Whether to show meta info (date, author)
  final bool showMeta;

  const SkeletonArticle({
    super.key,
    this.showImage = true,
    this.imageHeight = 200,
    this.paragraphs = 2,
    this.linesPerParagraph = 4,
    this.padding = const EdgeInsets.all(16),
    this.sectionSpacing = 20,
    this.config,
    this.showMeta = true,
  });

  /// Compact article skeleton
  const SkeletonArticle.compact({
    super.key,
    this.showImage = true,
    this.imageHeight = 150,
    this.paragraphs = 1,
    this.linesPerParagraph = 3,
    this.padding = const EdgeInsets.all(12),
    this.sectionSpacing = 16,
    this.config,
    this.showMeta = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Featured image
          if (showImage) ...[
            SkeletonRounded(
              width: double.infinity,
              height: imageHeight,
              radius: 12,
              config: config,
            ),
            SizedBox(height: sectionSpacing),
          ],

          // Title
          SkeletonText(
            height: 24,
            config: config,
          ),
          const SizedBox(height: 8),
          FractionallySizedBox(
            widthFactor: 0.7,
            alignment: Alignment.centerLeft,
            child: SkeletonText(
              height: 24,
              config: config,
            ),
          ),

          // Meta info
          if (showMeta) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                SkeletonCircle(size: 24, config: config),
                const SizedBox(width: 8),
                SkeletonText(width: 80, height: 12, config: config),
                const SizedBox(width: 16),
                SkeletonText(width: 60, height: 12, config: config),
              ],
            ),
          ],

          SizedBox(height: sectionSpacing),

          // Paragraphs
          ...List.generate(paragraphs, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < paragraphs - 1 ? sectionSpacing : 0,
              ),
              child: SkeletonParagraph(
                lines: linesPerParagraph,
                lineHeight: 14,
                spacing: 8,
                lastLineWidth: 0.6,
                config: config,
              ),
            );
          }),
        ],
      ),
    );
  }
}
