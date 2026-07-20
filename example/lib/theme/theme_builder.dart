import 'package:flutter/material.dart';

import 'app_theme.dart';
import '../views/settings/cubit/theme_state.dart';

/// Builds [ThemeData] from editable [ThemeState].
class ThemeBuilder {
  static ThemeData buildTheme(ThemeState state) {
    final brightness = state.brightness;
    final isLight = brightness == Brightness.light;

    final textPrimary = isLight ? state.primaryColor : Colors.white;
    final textSecondary =
        isLight ? state.secondaryColor : const Color(0xFFCBD5E1);
    final textMuted = isLight ? state.textMutedColor : const Color(0xFF94A3B8);
    final bg = isLight
        ? state.backgroundColor
        : _ensureDark(state.backgroundColor, fallback: const Color(0xFF0B1220));
    final surface = isLight
        ? state.surfaceColor
        : _ensureDark(state.surfaceColor, fallback: const Color(0xFF151E2E));
    final border = isLight
        ? state.borderColor
        : const Color(0xFF243044);

    final onPrimary = isLight ? Colors.white : Colors.black;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      splashFactory: InkSparkle.splashFactory,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: state.accentColor,
        onPrimary: onPrimary,
        secondary: state.secondaryColor,
        onSecondary: onPrimary,
        tertiary: state.accentColor,
        onTertiary: onPrimary,
        error: state.errorColor,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        outline: border,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: (20 * state.fontScale).clamp(16.0, 24.0),
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
        ),
        iconTheme: IconThemeData(color: textPrimary, size: 22),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          side: BorderSide(color: border, width: AppTheme.borderWidth),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppTheme.bg : surface,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: state.accentColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        labelStyle: TextStyle(
          fontSize: (13 * state.fontScale).clamp(11.0, 16.0),
          color: textSecondary,
        ),
        hintStyle: TextStyle(
          fontSize: (13 * state.fontScale).clamp(11.0, 16.0),
          color: textMuted,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: state.accentColor,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
          textStyle: TextStyle(
            fontSize: (14 * state.fontScale).clamp(12.0, 17.0),
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
          side: BorderSide(color: border),
          textStyle: TextStyle(
            fontSize: (14 * state.fontScale).clamp(12.0, 17.0),
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: state.accentColor,
          textStyle: TextStyle(
            fontSize: (14 * state.fontScale).clamp(12.0, 17.0),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isLight ? AppTheme.accentSoft : border,
        labelStyle: TextStyle(
          color: isLight ? state.accentColor : textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        height: 64,
        indicatorColor: state.accentColor.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? state.accentColor : textMuted,
          );
        }),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        iconColor: textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: TextStyle(
          color: isLight ? Colors.white : Colors.black,
          fontSize: (13 * state.fontScale).clamp(11.0, 16.0),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
      ),

      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: (28 * state.fontScale).clamp(22.0, 34.0),
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1.0,
          height: 1.15,
        ),
        headlineSmall: TextStyle(
          fontSize: (22 * state.fontScale).clamp(18.0, 28.0),
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.6,
        ),
        titleLarge: TextStyle(
          fontSize: (18 * state.fontScale).clamp(15.0, 22.0),
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          fontSize: (15 * state.fontScale).clamp(13.0, 18.0),
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: (14 * state.fontScale).clamp(12.0, 17.0),
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: (14 * state.fontScale).clamp(12.0, 17.0),
          color: textPrimary,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          fontSize: (13 * state.fontScale).clamp(11.0, 16.0),
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: (12 * state.fontScale).clamp(10.0, 14.0),
          color: textMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
        labelSmall: TextStyle(
          fontSize: (11 * state.fontScale).clamp(9.0, 13.0),
          color: textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Color _ensureDark(Color color, {required Color fallback}) {
    return color.computeLuminance() > 0.4 ? fallback : color;
  }
}
