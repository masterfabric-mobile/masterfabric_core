import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Home-screen app icon themes shipped with AURA.
enum AppIconStyle {
  /// Coral woman athlete.
  woman,

  /// Cyan man athlete.
  man,

  /// Lime crew / group gym.
  crew,

  /// Original B&W woman — default / primary launcher.
  classic,

  /// Violet abstract mark (`abstract` is reserved in Dart).
  mark,
}

extension AppIconStyleX on AppIconStyle {
  /// Asset used in onboarding + profile pickers.
  String get assetPath => switch (this) {
        AppIconStyle.woman => 'assets/icons/app_icon_woman_1024.png',
        AppIconStyle.man => 'assets/icons/app_icon_man_1024.png',
        AppIconStyle.crew => 'assets/icons/app_icon_crew_1024.png',
        AppIconStyle.classic => 'assets/icons/app_icon_classic_1024.png',
        AppIconStyle.mark => 'assets/icons/app_icon_abstract_1024.png',
      };

  /// Native alternate-icon key for [flutter_dynamic_icon_plus].
  ///
  /// `null` restores the primary classic B&W launcher.
  String? get alternateIconName {
    if (this == AppIconStyle.classic) return null;
    if (this == AppIconStyle.mark) {
      // Android activity-alias cannot use the reserved word `abstract`.
      if (!kIsWeb && Platform.isAndroid) return 'icon_abstract';
      return 'abstract';
    }
    return name;
  }

  static AppIconStyle fromName(String? name) {
    if (name == 'abstract' || name == 'icon_abstract' || name == 'mark') {
      return AppIconStyle.mark;
    }
    return AppIconStyle.values.firstWhere(
      (e) => e.name == name,
      orElse: () => AppIconStyle.classic,
    );
  }
}
