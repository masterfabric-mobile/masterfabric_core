import 'package:flutter/material.dart';

import 'skeleton_config.dart';
import 'widgets/shapes/skeleton_shapes.dart';
import 'widgets/presets/skeleton_presets.dart';

/// Skeleton Helper
/// 
/// A comprehensive helper for creating skeleton loading placeholders.
/// Supports multiple shapes, animation styles, and pre-built presets.
/// 
/// Usage:
/// ```dart
/// // Simple shapes
/// SkeletonHelper.rectangle(width: 200, height: 100);
/// SkeletonHelper.circle(size: 48);
/// SkeletonHelper.text(lines: 3);
/// 
/// // With custom animation
/// SkeletonHelper.card(
///   config: SkeletonConfig(
///     animationType: SkeletonAnimationType.pulse,
///     baseColor: Colors.grey[300]!,
///   ),
/// );
/// 
/// // Themed
/// SkeletonTheme(
///   config: SkeletonConfig.dark(),
///   child: SkeletonHelper.listItem(),
/// );
/// ```
class SkeletonHelper {
  SkeletonHelper._();

  // ============================================================
  // SHAPES
  // ============================================================

  /// Create a rectangle skeleton
  static Widget rectangle({
    double? width,
    double height = 16,
    BorderRadius? borderRadius,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonRectangle(
      width: width,
      height: height,
      borderRadius: borderRadius,
      config: config,
      margin: margin,
    );
  }

  /// Create a circle skeleton
  static Widget circle({
    double size = 48,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonCircle(
      size: size,
      config: config,
      margin: margin,
    );
  }

  /// Create a rounded rectangle skeleton
  static Widget rounded({
    double? width,
    double height = 48,
    double radius = 12,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonRounded(
      width: width,
      height: height,
      radius: radius,
      config: config,
      margin: margin,
    );
  }

  /// Create a text line skeleton
  static Widget text({
    double? width,
    double height = 12,
    double radius = 4,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonText(
      width: width,
      height: height,
      radius: radius,
      config: config,
      margin: margin,
    );
  }

  /// Create a paragraph skeleton (multiple lines)
  static Widget paragraph({
    int lines = 3,
    double lineHeight = 12,
    double spacing = 8,
    double lastLineWidth = 0.6,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonParagraph(
      lines: lines,
      lineHeight: lineHeight,
      spacing: spacing,
      lastLineWidth: lastLineWidth,
      config: config,
      margin: margin,
    );
  }

  /// Create an avatar skeleton
  static Widget avatar({
    double size = 48,
    SkeletonAvatarStyle style = SkeletonAvatarStyle.circle,
    double radius = 8,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonAvatar(
      size: size,
      style: style,
      radius: radius,
      config: config,
      margin: margin,
    );
  }

  /// Create a custom shape skeleton
  static Widget custom({
    double? width,
    double? height,
    required CustomClipper<Path> clipper,
    SkeletonConfig? config,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonCustom(
      width: width,
      height: height,
      clipper: clipper,
      config: config,
      margin: margin,
    );
  }

  // ============================================================
  // PRESETS
  // ============================================================

  /// Create a list item skeleton
  static Widget listItem({
    bool showAvatar = true,
    double avatarSize = 48,
    int lines = 2,
    double spacing = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    SkeletonConfig? config,
  }) {
    return SkeletonListItem(
      showAvatar: showAvatar,
      avatarSize: avatarSize,
      lines: lines,
      spacing: spacing,
      padding: padding,
      config: config,
    );
  }

  /// Create a card skeleton
  static Widget card({
    double? width,
    double imageHeight = 150,
    int lines = 3,
    double borderRadius = 12,
    bool showImage = true,
    SkeletonConfig? config,
  }) {
    return SkeletonCard(
      width: width,
      imageHeight: imageHeight,
      lines: lines,
      borderRadius: borderRadius,
      showImage: showImage,
      config: config,
    );
  }

  /// Create a horizontal card skeleton
  static Widget cardHorizontal({
    double? width,
    double imageWidth = 120,
    int lines = 2,
    double borderRadius = 12,
    SkeletonConfig? config,
  }) {
    return SkeletonCard.horizontal(
      width: width,
      imageWidth: imageWidth,
      lines: lines,
      borderRadius: borderRadius,
      config: config,
    );
  }

  /// Create a profile skeleton
  static Widget profile({
    double avatarSize = 80,
    int infoLines = 2,
    bool showStats = false,
    int statsCount = 3,
    SkeletonConfig? config,
  }) {
    return SkeletonProfile(
      avatarSize: avatarSize,
      infoLines: infoLines,
      showStats: showStats,
      statsCount: statsCount,
      config: config,
    );
  }

  /// Create a horizontal profile skeleton
  static Widget profileHorizontal({
    double avatarSize = 56,
    int lines = 2,
    bool showAction = false,
    SkeletonConfig? config,
  }) {
    return SkeletonProfileHorizontal(
      avatarSize: avatarSize,
      lines: lines,
      showAction: showAction,
      config: config,
    );
  }

  /// Create an article skeleton
  static Widget article({
    bool showImage = true,
    double imageHeight = 200,
    int paragraphs = 2,
    int linesPerParagraph = 4,
    bool showMeta = true,
    SkeletonConfig? config,
  }) {
    return SkeletonArticle(
      showImage: showImage,
      imageHeight: imageHeight,
      paragraphs: paragraphs,
      linesPerParagraph: linesPerParagraph,
      showMeta: showMeta,
      config: config,
    );
  }

  /// Create a product card skeleton
  static Widget product({
    double? width,
    double imageHeight = 180,
    double borderRadius = 12,
    bool showRating = true,
    bool showAction = false,
    SkeletonConfig? config,
  }) {
    return SkeletonProduct(
      width: width,
      imageHeight: imageHeight,
      borderRadius: borderRadius,
      showRating: showRating,
      showAction: showAction,
      config: config,
    );
  }

  /// Create a horizontal product skeleton
  static Widget productHorizontal({
    double? height,
    double imageWidth = 100,
    double borderRadius = 12,
    SkeletonConfig? config,
  }) {
    return SkeletonProductHorizontal(
      height: height,
      imageWidth: imageWidth,
      borderRadius: borderRadius,
      config: config,
    );
  }

  /// Create a grid of skeleton items
  static Widget grid({
    int crossAxisCount = 2,
    int itemCount = 6,
    double spacing = 12,
    double childAspectRatio = 1.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double itemBorderRadius = 12,
    SkeletonConfig? config,
    Widget Function(BuildContext, int)? itemBuilder,
  }) {
    return SkeletonGrid(
      crossAxisCount: crossAxisCount,
      itemCount: itemCount,
      spacing: spacing,
      childAspectRatio: childAspectRatio,
      padding: padding,
      itemBorderRadius: itemBorderRadius,
      config: config,
      itemBuilder: itemBuilder,
    );
  }

  /// Create a product grid skeleton
  static Widget productGrid({
    int crossAxisCount = 2,
    int itemCount = 4,
    double spacing = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    SkeletonConfig? config,
  }) {
    return SkeletonGrid.products(
      crossAxisCount: crossAxisCount,
      itemCount: itemCount,
      spacing: spacing,
      padding: padding,
      config: config,
    );
  }

  /// Create a social media post skeleton
  static Widget socialPost({
    bool showImage = true,
    double imageHeight = 300,
    int actionCount = 3,
    bool showComments = false,
    int commentCount = 2,
    SkeletonConfig? config,
  }) {
    return SkeletonSocialPost(
      showImage: showImage,
      imageHeight: imageHeight,
      actionCount: actionCount,
      showComments: showComments,
      commentCount: commentCount,
      config: config,
    );
  }

  /// Create a story thumbnail skeleton
  static Widget story({
    double size = 72,
    bool showLabel = true,
    SkeletonConfig? config,
  }) {
    return SkeletonStory(
      size: size,
      showLabel: showLabel,
      config: config,
    );
  }

  /// Create a row of story skeletons
  static Widget storyRow({
    int count = 5,
    double storySize = 72,
    double spacing = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    SkeletonConfig? config,
  }) {
    return SkeletonStoryRow(
      count: count,
      storySize: storySize,
      spacing: spacing,
      padding: padding,
      config: config,
    );
  }

  // ============================================================
  // UTILITY METHODS
  // ============================================================

  /// Create a list of skeleton items
  static Widget list({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    double spacing = 0,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    bool shrinkWrap = true,
    ScrollPhysics? physics = const NeverScrollableScrollPhysics(),
  }) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }

  /// Create multiple copies of a skeleton widget
  static List<Widget> repeat({
    required int count,
    required Widget child,
    double spacing = 0,
  }) {
    return List.generate(count, (index) {
      if (spacing > 0 && index < count - 1) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            SizedBox(height: spacing),
          ],
        );
      }
      return child;
    });
  }

  /// Wrap content with loading state
  static Widget loadingState({
    required bool isLoading,
    required Widget child,
    required Widget skeleton,
    Duration? animationDuration,
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedSwitcher(
      duration: animationDuration ?? const Duration(milliseconds: 300),
      switchInCurve: curve,
      switchOutCurve: curve,
      child: isLoading ? skeleton : child,
    );
  }
}
