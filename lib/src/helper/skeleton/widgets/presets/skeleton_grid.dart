import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../shapes/skeleton_shapes.dart';

/// Grid of skeleton items
class SkeletonGrid extends StatelessWidget {
  /// Number of columns
  final int crossAxisCount;

  /// Number of items
  final int itemCount;

  /// Spacing between items
  final double spacing;

  /// Aspect ratio of each item
  final double childAspectRatio;

  /// Padding around the grid
  final EdgeInsetsGeometry padding;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Border radius for items
  final double itemBorderRadius;

  /// Custom item builder
  final Widget Function(BuildContext, int)? itemBuilder;

  const SkeletonGrid({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.spacing = 12,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(16),
    this.config,
    this.itemBorderRadius = 12,
    this.itemBuilder,
  });

  /// Grid for images/photos
  const SkeletonGrid.images({
    super.key,
    this.crossAxisCount = 3,
    this.itemCount = 9,
    this.spacing = 4,
    this.childAspectRatio = 1.0,
    this.padding = EdgeInsets.zero,
    this.config,
    this.itemBorderRadius = 0,
    this.itemBuilder,
  });

  /// Grid for product cards
  factory SkeletonGrid.products({
    Key? key,
    int crossAxisCount = 2,
    int itemCount = 4,
    double spacing = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    SkeletonConfig? config,
  }) {
    return SkeletonGrid(
      key: key,
      crossAxisCount: crossAxisCount,
      itemCount: itemCount,
      spacing: spacing,
      childAspectRatio: 0.7,
      padding: padding,
      config: config,
      itemBuilder: (context, index) {
        return _ProductGridItem(config: config);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder ?? (context, index) {
          return SkeletonRounded(
            radius: itemBorderRadius,
            config: config,
          );
        },
      ),
    );
  }
}

/// Product item for grid
class _ProductGridItem extends StatelessWidget {
  final SkeletonConfig? config;

  const _ProductGridItem({this.config});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SkeletonRounded(
            radius: 8,
            config: config,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(height: 12, config: config),
              const SizedBox(height: 4),
              SkeletonText(width: 60, height: 14, config: config),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sliver grid for use in CustomScrollView
class SliverSkeletonGrid extends StatelessWidget {
  /// Number of columns
  final int crossAxisCount;

  /// Number of items
  final int itemCount;

  /// Spacing between items
  final double spacing;

  /// Aspect ratio of each item
  final double childAspectRatio;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Border radius for items
  final double itemBorderRadius;

  /// Custom item builder
  final Widget Function(BuildContext, int)? itemBuilder;

  const SliverSkeletonGrid({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.spacing = 12,
    this.childAspectRatio = 1.0,
    this.config,
    this.itemBorderRadius = 12,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        itemBuilder ?? (context, index) {
          return SkeletonRounded(
            radius: itemBorderRadius,
            config: config,
          );
        },
        childCount: itemCount,
      ),
    );
  }
}
