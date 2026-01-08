import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// Card skeleton with image and content
class SkeletonCard extends StatelessWidget {
  /// Width of the card
  final double? width;

  /// Height of the image section
  final double imageHeight;

  /// Number of text lines
  final int lines;

  /// Padding inside the content area
  final EdgeInsetsGeometry contentPadding;

  /// Border radius
  final double borderRadius;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Whether to show the image section
  final bool showImage;

  /// Height of each text line
  final double lineHeight;

  /// Spacing between text lines
  final double lineSpacing;

  const SkeletonCard({
    super.key,
    this.width,
    this.imageHeight = 150,
    this.lines = 3,
    this.contentPadding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.config,
    this.showImage = true,
    this.lineHeight = 12,
    this.lineSpacing = 8,
  });

  /// Horizontal card layout
  factory SkeletonCard.horizontal({
    Key? key,
    double? width,
    double imageWidth = 120,
    int lines = 2,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(12),
    double borderRadius = 12,
    SkeletonConfig? config,
  }) {
    return _SkeletonCardHorizontal(
      key: key,
      width: width,
      imageWidth: imageWidth,
      lines: lines,
      contentPadding: contentPadding,
      borderRadius: borderRadius,
      config: config,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showImage)
            SkeletonRectangle(
              width: double.infinity,
              height: imageHeight,
              borderRadius: BorderRadius.zero,
              config: config,
            ),
          Padding(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(lines, (index) {
                final isLast = index == lines - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : lineSpacing),
                  child: FractionallySizedBox(
                    widthFactor: isLast ? 0.6 : 1.0,
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

/// Horizontal card skeleton
class _SkeletonCardHorizontal extends SkeletonCard {
  final double imageWidth;

  const _SkeletonCardHorizontal({
    super.key,
    super.width,
    this.imageWidth = 120,
    super.lines = 2,
    super.contentPadding = const EdgeInsets.all(12),
    super.borderRadius = 12,
    super.config,
  }) : super(showImage: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonRectangle(
            width: imageWidth,
            height: imageWidth,
            borderRadius: BorderRadius.zero,
            config: config,
          ),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(lines, (index) {
                  final isLast = index == lines - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : lineSpacing),
                    child: FractionallySizedBox(
                      widthFactor: isLast ? 0.5 : 0.8,
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
          ),
        ],
      ),
    );
  }
}
