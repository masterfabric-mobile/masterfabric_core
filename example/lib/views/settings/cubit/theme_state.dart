import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Theme State - Manages theme settings for the app
class ThemeState extends Equatable {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color surfaceColor;
  final Color backgroundColor;
  final Color textMutedColor;
  final Color borderColor;
  final double fontScale;
  final Brightness brightness;
  final Map<String, bool> viewVisibility;
  final bool showIcons;

  const ThemeState({
    this.primaryColor = AppTheme.ink,
    this.secondaryColor = AppTheme.textSecondary,
    this.accentColor = AppTheme.accent,
    this.successColor = AppTheme.success,
    this.warningColor = AppTheme.warning,
    this.errorColor = AppTheme.error,
    this.surfaceColor = AppTheme.surface,
    this.backgroundColor = AppTheme.bg,
    this.textMutedColor = AppTheme.textMuted,
    this.borderColor = AppTheme.border,
    this.fontScale = 1.0,
    this.brightness = Brightness.light,
    Map<String, bool>? viewVisibility,
    this.showIcons = true,
  }) : viewVisibility = viewVisibility ??
            const {
              'home': true,
              'profile': true,
              'products': true,
              'settings': true,
              'helpersHub': true,
            };

  ThemeState copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? surfaceColor,
    Color? backgroundColor,
    Color? textMutedColor,
    Color? borderColor,
    double? fontScale,
    Brightness? brightness,
    Map<String, bool>? viewVisibility,
    bool? showIcons,
  }) {
    return ThemeState(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textMutedColor: textMutedColor ?? this.textMutedColor,
      borderColor: borderColor ?? this.borderColor,
      fontScale: fontScale ?? this.fontScale,
      brightness: brightness ?? this.brightness,
      viewVisibility: viewVisibility ?? this.viewVisibility,
      showIcons: showIcons ?? this.showIcons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.toARGB32(),
      'secondaryColor': secondaryColor.toARGB32(),
      'accentColor': accentColor.toARGB32(),
      'successColor': successColor.toARGB32(),
      'warningColor': warningColor.toARGB32(),
      'errorColor': errorColor.toARGB32(),
      'surfaceColor': surfaceColor.toARGB32(),
      'backgroundColor': backgroundColor.toARGB32(),
      'textMutedColor': textMutedColor.toARGB32(),
      'borderColor': borderColor.toARGB32(),
      'fontScale': fontScale,
      'brightness': brightness == Brightness.light ? 'light' : 'dark',
      'viewVisibility': viewVisibility,
      'showIcons': showIcons,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      primaryColor: Color(json['primaryColor'] as int? ?? AppTheme.textPrimary.toARGB32()),
      secondaryColor: Color(json['secondaryColor'] as int? ?? AppTheme.textSecondary.toARGB32()),
      accentColor: Color(json['accentColor'] as int? ?? AppTheme.accent.toARGB32()),
      successColor: Color(json['successColor'] as int? ?? AppTheme.success.toARGB32()),
      warningColor: Color(json['warningColor'] as int? ?? AppTheme.warning.toARGB32()),
      errorColor: Color(json['errorColor'] as int? ?? AppTheme.error.toARGB32()),
      surfaceColor: Color(json['surfaceColor'] as int? ?? AppTheme.white.toARGB32()),
      backgroundColor: Color(json['backgroundColor'] as int? ?? AppTheme.bg.toARGB32()),
      textMutedColor: Color(json['textMutedColor'] as int? ?? AppTheme.textMuted.toARGB32()),
      borderColor: Color(json['borderColor'] as int? ?? AppTheme.border.toARGB32()),
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      brightness: json['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
      viewVisibility: Map<String, bool>.from(json['viewVisibility'] as Map? ?? {}),
      showIcons: json['showIcons'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
        primaryColor,
        secondaryColor,
        accentColor,
        successColor,
        warningColor,
        errorColor,
        surfaceColor,
        backgroundColor,
        textMutedColor,
        borderColor,
        fontScale,
        brightness,
        viewVisibility,
        showIcons,
      ];
}
