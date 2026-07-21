import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Borderless black-and-white surface language for AURA.
/// Typography uses SF Pro on Apple platforms (system default).
abstract final class AuraTheme {
  static const Color ink = Color(0xFF0A0A0A);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color mist = Color(0xFFF4F4F4);
  static const Color mute = Color(0xFF6B6B6B);
  static const Color line = Color(0xFFE6E6E6);

  /// SF Pro Text / Display via iOS system fonts.
  static const String fontFamily = '.SF Pro Text';
  static const String fontDisplay = '.SF Pro Display';

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: paper,
      colorScheme: const ColorScheme.light(
        primary: ink,
        onPrimary: paper,
        secondary: ink,
        onSecondary: paper,
        surface: paper,
        onSurface: ink,
        error: ink,
        onError: paper,
      ),
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: paper,
        foregroundColor: ink,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: fontDisplay,
          color: ink,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: line,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: paper,
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          color: ink,
          fontSize: 14,
        ),
        actionTextColor: ink,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: line),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: mist,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(fontFamily: fontFamily, color: mute),
        labelStyle: TextStyle(fontFamily: fontFamily, color: mute),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: paper,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontFamily: fontFamily),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ink,
        foregroundColor: paper,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: paper,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontDisplay,
          fontSize: 48,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.6,
          color: ink,
          height: 1.05,
        ),
        displayMedium: TextStyle(
          fontFamily: fontDisplay,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.2,
          color: ink,
          height: 1.1,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontDisplay,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontFamily: fontDisplay,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ink,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ink,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ink,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mute,
          height: 1.35,
          letterSpacing: 0.2,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: mute,
          letterSpacing: 1.4,
        ),
      ),
    );
    return base;
  }
}
