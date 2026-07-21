import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide Spacer;

/// AURA spacing tokens — wraps masterfabric_core [CoreSpacer] / size scale
/// so screens never invent one-off gaps.
abstract final class AuraSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double section = 12;
  static const double pageH = 16;
  static const double sheetH = 20;
  static const double pageBottom = 28;

  static Widget get vXs => const SizedBox(height: xs);
  static Widget get vSm => const SizedBox(height: sm);
  static Widget get vMd => const SizedBox(height: md);
  static Widget get vLg => const SizedBox(height: lg);
  static Widget get vXl => const SizedBox(height: xl);
  static Widget get vXxl => const SizedBox(height: xxl);
  static Widget get vSection => const SizedBox(height: section);

  static Widget get hXs => const SizedBox(width: xs);
  static Widget get hSm => const SizedBox(width: sm);
  static Widget get hMd => const SizedBox(width: md);
  static Widget get hLg => const SizedBox(width: lg);

  /// Core semantic spacers (dev-mode tint via [globalDevModeSpacer]).
  static Widget get coreContent => const CoreSpacer(CoreSpacerType.content);
  static Widget get coreSection => const CoreSpacer(CoreSpacerType.section);
  static Widget get coreVertical => const CoreSpacer(CoreSpacerType.vertical);

  static EdgeInsets get pagePadding =>
      const EdgeInsets.fromLTRB(pageH, md, pageH, pageBottom);

  static EdgeInsets sheetPadding(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return EdgeInsets.fromLTRB(sheetH, 10, sheetH, bottom + sheetH);
  }
}
