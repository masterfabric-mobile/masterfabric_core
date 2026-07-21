import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';
import 'aura_space.dart';
import 'aura_ui.dart';

export 'aura_space.dart';
export 'aura_ui.dart';

/// Central AURA UI kit — reusable chrome shared by every tab / sheet.
/// Prefer these over ad-hoc [SizedBox], card stacks, and sheet scaffolds.
abstract final class AuraKit {
  // ── Typography blocks ──────────────────────────────────────────────

  static Widget sectionTitle(
    BuildContext context,
    String title, {
    String? subtitle,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                AuraSpace.vXs,
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AuraTheme.mute,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[AuraSpace.hSm, trailing],
      ],
    );
  }

  static Widget sectionCard({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? trailing,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(AuraSpace.lg),
  }) {
    return AuraUi.appleCard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(context, title, subtitle: subtitle, trailing: trailing),
          AuraSpace.vMd,
          child,
        ],
      ),
    );
  }

  // ── Rows / chips / metrics ─────────────────────────────────────────

  static Widget listRow({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  }) {
    final row = AuraUi.appleCard(
      padding: padding,
      child: Row(
        children: [
          if (leading != null) ...[leading, AuraSpace.hMd],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AuraTheme.ink,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AuraTheme.mute,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[AuraSpace.hSm, trailing],
        ],
      ),
    );
    if (onTap == null) return row;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AuraUi.radiusMd),
        onTap: onTap,
        child: row,
      ),
    );
  }

  static Widget metricTile({
    required String value,
    required String label,
    String? unit,
  }) {
    return Expanded(
      child: AuraUi.appleCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontFamily: AuraTheme.fontDisplay,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AuraTheme.ink,
                      letterSpacing: -0.6,
                    ),
                  ),
                  if (unit != null)
                    TextSpan(
                      text: ' $unit',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AuraTheme.mute,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            AuraSpace.vXs,
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AuraTheme.mute),
            ),
          ],
        ),
      ),
    );
  }

  static Widget filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AuraSpace.sm),
      child: Material(
        color: selected ? AuraTheme.ink : AuraTheme.mist,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AuraUi.radiusSm),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AuraTheme.paper : AuraTheme.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget progressRing({
    required double progress,
    required Widget center,
    double size = 120,
    double stroke = 10,
  }) {
    final p = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(progress: p, stroke: stroke),
          ),
          center,
        ],
      ),
    );
  }

  // ── Buttons / empty / loading ──────────────────────────────────────

  static Widget primaryButton({
    required String label,
    required VoidCallback? onPressed,
    double height = 50,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuraUi.radiusSm),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  static Widget secondaryButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(onPressed: onPressed, child: Text(label)),
    );
  }

  static Widget footerActions({
    required String backLabel,
    required String continueLabel,
    required VoidCallback? onBack,
    required VoidCallback? onContinue,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: AuraTheme.line),
              foregroundColor: AuraTheme.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusSm),
              ),
            ),
            child: Text(backLabel),
          ),
        ),
        AuraSpace.hMd,
        Expanded(
          flex: 2,
          child: primaryButton(label: continueLabel, onPressed: onContinue),
        ),
      ],
    );
  }

  static Widget loading() {
    return const Center(
      child: CircularProgressIndicator(color: AuraTheme.ink, strokeWidth: 2.4),
    );
  }

  static Widget emptyState({
    required String title,
    String? body,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AuraSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AuraTheme.ink,
              ),
            ),
            if (body != null) ...[
              AuraSpace.vSm,
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AuraTheme.mute),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget sheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AuraTheme.line,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  static Future<T?> showSheet<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
    bool scrollable = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sheetHandle(),
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
        );
        return Padding(
          padding: AuraSpace.sheetPadding(ctx),
          child: scrollable
              ? SingleChildScrollView(child: content)
              : content,
        );
      },
    );
  }

  static Widget pageSliverPadding({required List<Widget> children}) {
    return SliverPadding(
      padding: AuraSpace.pagePadding,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) AuraSpace.vSection,
            children[i],
          ],
        ]),
      ),
    );
  }

  static Widget stepScaffold({
    required BuildContext context,
    required Widget art,
    required String title,
    required String body,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        art,
        AuraSpace.vXl,
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: AuraTheme.fontDisplay,
                fontWeight: FontWeight.w700,
              ),
        ),
        AuraSpace.vSm,
        Text(
          body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AuraTheme.mute,
              ),
        ),
        AuraSpace.vXl,
        child,
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.stroke});

  final double progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - stroke) / 2;
    final bg = Paint()
      ..color = AuraTheme.mist
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = AuraTheme.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      progress * 6.28318,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.stroke != stroke;
}
