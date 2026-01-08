import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'svg_state.dart';

/// Cubit for SVG helper demo
@injectable
class SvgCubit extends BaseViewModelCubit<SvgState> {
  SvgCubit() : super(const SvgState());

  /// Change selected color
  void changeColor(Color color) {
    emit(state.copyWith(selectedColor: color));
  }

  /// Change selected size
  void changeSize(double size) {
    emit(state.copyWith(selectedSize: size));
  }

  /// Update SVG string
  void updateSvgString(String svgString) {
    emit(state.copyWith(svgString: svgString));
  }

  /// Update network URL
  void updateNetworkUrl(String url) {
    emit(state.copyWith(networkUrl: url));
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  /// Set error message
  void setError(String? message) {
    emit(state.copyWith(errorMessage: message));
  }

  /// Available colors for demo
  static const List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  /// Available sizes for demo
  static const List<double> availableSizes = [24, 32, 48, 64, 96];
}
