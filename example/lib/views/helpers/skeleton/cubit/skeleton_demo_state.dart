import 'package:equatable/equatable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

/// State for skeleton demo
class SkeletonDemoState extends Equatable {
  /// Whether the view is loading
  final bool isLoading;

  /// Error message
  final String? errorMessage;

  /// Current animation type
  final SkeletonAnimationType animationType;

  /// Current tab index
  final int tabIndex;

  /// Whether dark theme is enabled
  final bool isDarkTheme;

  /// Custom base color
  final int baseColorIndex;

  /// Custom highlight color
  final int highlightColorIndex;

  /// Animation speed multiplier
  final double speedMultiplier;

  const SkeletonDemoState({
    this.isLoading = false,
    this.errorMessage,
    this.animationType = SkeletonAnimationType.shimmer,
    this.tabIndex = 0,
    this.isDarkTheme = false,
    this.baseColorIndex = 0,
    this.highlightColorIndex = 0,
    this.speedMultiplier = 1.0,
  });

  /// Initial state
  const SkeletonDemoState.initial() : this();

  SkeletonDemoState copyWith({
    bool? isLoading,
    String? errorMessage,
    SkeletonAnimationType? animationType,
    int? tabIndex,
    bool? isDarkTheme,
    int? baseColorIndex,
    int? highlightColorIndex,
    double? speedMultiplier,
  }) {
    return SkeletonDemoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      animationType: animationType ?? this.animationType,
      tabIndex: tabIndex ?? this.tabIndex,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      baseColorIndex: baseColorIndex ?? this.baseColorIndex,
      highlightColorIndex: highlightColorIndex ?? this.highlightColorIndex,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        animationType,
        tabIndex,
        isDarkTheme,
        baseColorIndex,
        highlightColorIndex,
        speedMultiplier,
      ];
}
