/// Shape types for skeleton widgets
enum SkeletonShapeType {
  /// Rectangle shape
  rectangle,

  /// Circle shape
  circle,

  /// Rounded rectangle shape
  rounded,

  /// Stadium shape (pill)
  stadium,

  /// Custom shape using ClipPath
  custom,
}

/// Extension for SkeletonShapeType
extension SkeletonShapeTypeExtension on SkeletonShapeType {
  /// Convert to JSON string
  String toJson() {
    switch (this) {
      case SkeletonShapeType.rectangle:
        return 'rectangle';
      case SkeletonShapeType.circle:
        return 'circle';
      case SkeletonShapeType.rounded:
        return 'rounded';
      case SkeletonShapeType.stadium:
        return 'stadium';
      case SkeletonShapeType.custom:
        return 'custom';
    }
  }

  /// Create from JSON string
  static SkeletonShapeType fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'rectangle':
        return SkeletonShapeType.rectangle;
      case 'circle':
        return SkeletonShapeType.circle;
      case 'rounded':
        return SkeletonShapeType.rounded;
      case 'stadium':
        return SkeletonShapeType.stadium;
      case 'custom':
        return SkeletonShapeType.custom;
      default:
        return SkeletonShapeType.rectangle;
    }
  }
}
