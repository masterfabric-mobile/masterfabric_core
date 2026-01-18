import 'package:flutter/material.dart';

import 'app_theme.dart';
import '../views/settings/cubit/theme_state.dart';

/// Theme Builder - Converts ThemeState to ThemeData
class ThemeBuilder {
  /// Build ThemeData from ThemeState
  static ThemeData buildTheme(ThemeState state) {
    final brightness = state.brightness;
    final isLight = brightness == Brightness.light;

    // Calculate colors based on brightness
    // For dark mode, ensure proper contrast and readability
    final textPrimary = isLight 
        ? state.primaryColor 
        : Colors.white; // Always white text in dark mode for readability
    
    final textSecondary = isLight 
        ? state.secondaryColor 
        : Colors.grey[300]!; // Lighter grey for dark mode
    
    // Use theme state colors, adjust for dark mode if needed
    final textMuted = isLight 
        ? state.textMutedColor 
        : Colors.grey[500]!; // Lighter muted text for dark mode
    
    // Background colors - ensure proper dark mode backgrounds
    final bg = isLight 
        ? state.backgroundColor 
        : (state.backgroundColor.computeLuminance() > 0.5 
            ? const Color(0xFF1A1A1A) // Dark background
            : _darkenColor(state.backgroundColor));
    
    final surface = isLight 
        ? state.surfaceColor 
        : (state.surfaceColor.computeLuminance() > 0.5 
            ? const Color(0xFF2A2A2A) // Dark surface
            : _darkenColor(state.surfaceColor, amount: 0.2));
    
    // Border color - ensure visibility in dark mode
    final border = isLight 
        ? state.borderColor 
        : (state.borderColor.computeLuminance() > 0.3 
            ? Colors.grey[800]! // Dark border
            : state.borderColor);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      fontFamily: 'SF Pro Text',

      colorScheme: isLight
          ? ColorScheme.light(
              primary: state.primaryColor,
              onPrimary: Colors.white,
              secondary: state.secondaryColor,
              onSecondary: Colors.white,
              tertiary: state.accentColor,
              onTertiary: Colors.white,
              error: state.errorColor,
              onError: Colors.white,
              surface: surface,
              onSurface: textPrimary,
              outline: border,
            )
          : ColorScheme.dark(
              primary: state.primaryColor,
              onPrimary: Colors.black,
              secondary: state.secondaryColor,
              onSecondary: Colors.black,
              tertiary: state.accentColor,
              onTertiary: Colors.black,
              error: state.errorColor,
              onError: Colors.white,
              surface: surface,
              onSurface: textPrimary,
              outline: border,
            ),

      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: (16 * state.fontScale).clamp(12.0, 20.0),
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textPrimary, size: 20),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          side: BorderSide(color: border, width: AppTheme.borderWidth),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: border, width: AppTheme.borderWidth),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border, width: AppTheme.borderWidth),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: state.accentColor, width: AppTheme.borderWidth),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: state.errorColor, width: AppTheme.borderWidth),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        labelStyle: TextStyle(
          fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
          color: textSecondary,
        ),
        hintStyle: TextStyle(
          fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
          color: textMuted,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: state.primaryColor,
          foregroundColor: isLight ? Colors.white : Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(0, 36),
          textStyle: TextStyle(
            fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(0, 36),
          textStyle: TextStyle(
            fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide(color: border, width: AppTheme.borderWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: state.accentColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(
            fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textSecondary,
          iconSize: 18,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: AppTheme.borderWidth,
        space: 0,
      ),

      listTileTheme: const ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        visualDensity: VisualDensity.compact,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: TextStyle(
          color: isLight ? Colors.white : Colors.black,
          fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
      ),

      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: (18 * state.fontScale).clamp(14.0, 24.0),
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: (14 * state.fontScale).clamp(11.0, 18.0),
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        titleSmall: TextStyle(
          fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: (13 * state.fontScale).clamp(10.0, 16.0),
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: (12 * state.fontScale).clamp(9.0, 15.0),
          color: textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: (11 * state.fontScale).clamp(8.0, 14.0),
          color: textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Darken a color for dark mode
  /// Ensures colors are appropriate for dark theme backgrounds
  static Color _darkenColor(Color color, {double amount = 0.2}) {
    final luminance = color.computeLuminance();
    
    // For very light colors (like white backgrounds), make them dark
    if (luminance > 0.8) {
      // Very light color (like white), convert to dark grey
      return const Color(0xFF1A1A1A);
    } else if (luminance > 0.5) {
      // Medium-light color, darken significantly
      return Color.fromRGBO(
        (color.red * (1 - amount * 2)).round().clamp(0, 255),
        (color.green * (1 - amount * 2)).round().clamp(0, 255),
        (color.blue * (1 - amount * 2)).round().clamp(0, 255),
        1.0,
      );
    } else if (luminance > 0.2) {
      // Medium color, darken moderately
      return Color.fromRGBO(
        (color.red * (1 - amount)).round().clamp(0, 255),
        (color.green * (1 - amount)).round().clamp(0, 255),
        (color.blue * (1 - amount)).round().clamp(0, 255),
        1.0,
      );
    } else {
      // Already dark, keep it dark but ensure minimum contrast
      return Color.fromRGBO(
        color.red.clamp(20, 60),
        color.green.clamp(20, 60),
        color.blue.clamp(20, 60),
        1.0,
      );
    }
  }
}
