import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// Product card skeleton
class SkeletonProduct extends StatelessWidget {
  /// Width of the product card
  final double? width;

  /// Height of the product image
  final double imageHeight;

  /// Border radius
  final double borderRadius;

  /// Content padding
  final EdgeInsetsGeometry contentPadding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Whether to show rating
  final bool showRating;

  /// Whether to show action button
  final bool showAction;

  const SkeletonProduct({
    super.key,
    this.width,
    this.imageHeight = 180,
    this.borderRadius = 12,
    this.contentPadding = const EdgeInsets.all(12),
    this.config,
    this.showRating = true,
    this.showAction = false,
  });

  /// Grid-optimized product skeleton
  const SkeletonProduct.grid({
    super.key,
    this.width,
    this.imageHeight = 140,
    this.borderRadius = 8,
    this.contentPadding = const EdgeInsets.all(8),
    this.config,
    this.showRating = false,
    this.showAction = false,
  });

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
          // Product image
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
              children: [
                // Product name
                SkeletonText(
                  height: 14,
                  config: config,
                ),
                const SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  alignment: Alignment.centerLeft,
                  child: SkeletonText(
                    height: 12,
                    config: config,
                  ),
                ),
                const SizedBox(height: 10),

                // Rating
                if (showRating) ...[
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: SkeletonCircle(
                            size: 14,
                            config: config,
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      SkeletonText(
                        width: 30,
                        height: 12,
                        config: config,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                // Price row
                Row(
                  children: [
                    SkeletonText(
                      width: 70,
                      height: 18,
                      config: config,
                    ),
                    const Spacer(),
                    if (showAction)
                      SkeletonRounded(
                        width: 36,
                        height: 36,
                        radius: 8,
                        config: config,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal product skeleton
class SkeletonProductHorizontal extends StatelessWidget {
  /// Height of the product card
  final double? height;

  /// Width of the product image
  final double imageWidth;

  /// Border radius
  final double borderRadius;

  /// Content padding
  final EdgeInsetsGeometry contentPadding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  const SkeletonProductHorizontal({
    super.key,
    this.height,
    this.imageWidth = 100,
    this.borderRadius = 12,
    this.contentPadding = const EdgeInsets.all(12),
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SkeletonRectangle(
            width: imageWidth,
            height: double.infinity,
            borderRadius: BorderRadius.zero,
            config: config,
          ),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonText(height: 14, config: config),
                  const SizedBox(height: 6),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    alignment: Alignment.centerLeft,
                    child: SkeletonText(height: 12, config: config),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SkeletonText(width: 60, height: 16, config: config),
                      const Spacer(),
                      SkeletonRounded(
                        width: 32,
                        height: 32,
                        radius: 8,
                        config: config,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
