import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'theme_state.dart';

/// Theme Cubit - Manages theme settings with persistence
@injectable
class ThemeCubit extends BaseViewModelHydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  /// Update primary color
  void updatePrimaryColor(Color color) {
    stateChanger(state.copyWith(primaryColor: color));
  }

  /// Update secondary color
  void updateSecondaryColor(Color color) {
    stateChanger(state.copyWith(secondaryColor: color));
  }

  /// Update accent color
  void updateAccentColor(Color color) {
    stateChanger(state.copyWith(accentColor: color));
  }

  /// Update success color
  void updateSuccessColor(Color color) {
    stateChanger(state.copyWith(successColor: color));
  }

  /// Update warning color
  void updateWarningColor(Color color) {
    stateChanger(state.copyWith(warningColor: color));
  }

  /// Update error color
  void updateErrorColor(Color color) {
    stateChanger(state.copyWith(errorColor: color));
  }

  /// Update text muted color
  void updateTextMutedColor(Color color) {
    stateChanger(state.copyWith(textMutedColor: color));
  }

  /// Update border color
  void updateBorderColor(Color color) {
    stateChanger(state.copyWith(borderColor: color));
  }

  /// Update font scale (0.8 - 1.5)
  void updateFontSize(double scale) {
    final clampedScale = scale.clamp(0.8, 1.5);
    stateChanger(state.copyWith(fontScale: clampedScale));
  }

  /// Toggle brightness between light and dark
  void toggleBrightness() {
    stateChanger(
      state.copyWith(
        brightness: state.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  /// Set brightness explicitly
  void setBrightness(Brightness brightness) {
    stateChanger(state.copyWith(brightness: brightness));
  }

  /// Toggle visibility of a specific view
  void toggleViewVisibility(String viewKey, bool visible) {
    final updatedVisibility = Map<String, bool>.from(state.viewVisibility);
    updatedVisibility[viewKey] = visible;
    stateChanger(state.copyWith(viewVisibility: updatedVisibility));
  }

  /// Toggle icon visibility globally
  void toggleIconVisibility(bool visible) {
    stateChanger(state.copyWith(showIcons: visible));
  }

  /// Reset all theme settings to defaults
  void resetToDefaults() {
    stateChanger(const ThemeState());
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson();
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromJson(json);
  }
}
