import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State for SVG helper demo
class SvgState extends Equatable {
  /// Currently selected color for tinting
  final Color selectedColor;

  /// Currently selected size
  final double selectedSize;

  /// SVG string for dynamic rendering
  final String? svgString;

  /// Network URL for testing
  final String networkUrl;

  /// Whether network SVG is loading
  final bool isLoading;

  /// Error message if any
  final String? errorMessage;

  const SvgState({
    this.selectedColor = Colors.blue,
    this.selectedSize = 48,
    this.svgString,
    this.networkUrl = 'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/ruby.svg',
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        selectedColor,
        selectedSize,
        svgString,
        networkUrl,
        isLoading,
        errorMessage,
      ];

  SvgState copyWith({
    Color? selectedColor,
    double? selectedSize,
    String? svgString,
    String? networkUrl,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SvgState(
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      svgString: svgString ?? this.svgString,
      networkUrl: networkUrl ?? this.networkUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
