import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';
import 'aura_space.dart';

enum AuraArt {
  today('assets/illustrations/hero.webp'),
  log('assets/illustrations/food.webp'),
  body('assets/illustrations/body.webp'),
  coach('assets/illustrations/coach.webp');

  const AuraArt(this.asset);
  final String asset;
}

abstract final class AuraUi {
  static Widget label(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AuraTheme.mute,
        letterSpacing: 1.4,
      ),
    );
  }

  static Widget rule() {
    return const ColoredBox(
      color: AuraTheme.line,
      child: SizedBox(height: 1, width: double.infinity),
    );
  }

  static Widget inkButton({
    required String label,
    required VoidCallback onTap,
    bool filled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? FilledButton(onPressed: onTap, child: Text(label))
          : TextButton(onPressed: onTap, child: Text(label)),
    );
  }

  static Widget metric({
    required String value,
    required String unit,
    required String caption,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontFamily: AuraTheme.fontDisplay,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AuraTheme.ink,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 13,
                  color: AuraTheme.mute,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          caption,
          style: const TextStyle(color: AuraTheme.mute, fontSize: 12),
        ),
      ],
    );
  }

  static Widget progressTrack(double progress) {
    final p = progress.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 6,
              width: constraints.maxWidth,
              color: AuraTheme.mist,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              height: 6,
              width: constraints.maxWidth * p,
              color: AuraTheme.ink,
            ),
          ],
        );
      },
    );
  }

  static Widget warningRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            color: AuraTheme.ink,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AuraTheme.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Notion-style comic art on pure white — contain so nothing clips.
  static Widget illustration(
    AuraArt art, {
    double height = 168,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 4,
      vertical: 4,
    ),
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ColoredBox(
        color: AuraTheme.paper,
        child: Padding(
          padding: padding,
          child: Image.asset(
            art.asset,
            fit: fit,
            alignment: alignment,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stack) => const Center(
              child: Text(
                'AURA',
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 22;

  static Widget appleCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color? color,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? AuraTheme.mist,
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      child: Padding(padding: padding, child: child),
    );
  }

  /// Prefer [AuraKit.showSheet] for new call sites.
  static Future<void> showSheet({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: AuraSpace.sheetPadding(ctx),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AuraTheme.line,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                AuraSpace.vLg,
                Text(
                  title,
                  style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                        fontFamily: AuraTheme.fontDisplay,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (subtitle != null) ...[
                  AuraSpace.vXs,
                  Text(
                    subtitle,
                    style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                          color: AuraTheme.mute,
                        ),
                  ),
                ],
                AuraSpace.vLg,
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
