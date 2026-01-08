/// Skeleton Helper Module
/// 
/// A comprehensive skeleton loading helper with multiple shapes,
/// animation styles, and pre-built presets.
/// 
/// Usage:
/// ```dart
/// // Simple shapes
/// SkeletonHelper.rectangle(width: 200, height: 100);
/// SkeletonHelper.circle(size: 48);
/// SkeletonHelper.text(lines: 3);
/// 
/// // With animation
/// SkeletonHelper.card(
///   config: SkeletonConfig(
///     animationType: SkeletonAnimationType.shimmer,
///   ),
/// );
/// 
/// // Themed
/// SkeletonTheme(
///   config: SkeletonConfig(
///     animationType: SkeletonAnimationType.wave,
///   ),
///   child: Column(
///     children: [
///       SkeletonHelper.listItem(),
///       SkeletonHelper.listItem(),
///     ],
///   ),
/// );
/// ```

export 'models/skeleton_models.dart';
export 'skeleton_config.dart';
export 'skeleton_theme.dart';
export 'skeleton_helper.dart';
export 'animations/skeleton_animation.dart';
export 'widgets/skeleton_base.dart';
export 'widgets/shapes/skeleton_shapes.dart';
export 'widgets/presets/skeleton_presets.dart';
