import 'dart:async';

import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';
import 'aura_ui.dart';

enum AuraToastTone { idle, loading, success, note }

/// Light framed AURA toast — replaces harsh black SnackBars.
abstract final class AuraToast {
  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    AuraToastTone tone = AuraToastTone.success,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();

    final completer = Completer<void>();
    late final OverlayEntry entry;
    var dismissed = false;

    void dismiss() {
      if (dismissed) return;
      dismissed = true;
      entry.remove();
      if (!completer.isCompleted) completer.complete();
    }

    entry = OverlayEntry(
      builder: (ctx) => _AuraToastCard(
        title: title,
        message: message,
        actionLabel: actionLabel,
        tone: tone,
        duration: duration,
        onAction: onAction == null
            ? null
            : () {
                dismiss();
                onAction();
              },
        onDismiss: dismiss,
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(entry);
    return completer.future;
  }

  /// Centered spinner for ~1s, then success mark + done copy.
  static Future<void> pulse(
    BuildContext context, {
    required String loadingMessage,
    required String doneMessage,
    String? title,
  }) {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();

    final completer = Completer<void>();
    late final OverlayEntry entry;
    var dismissed = false;

    void dismiss() {
      if (dismissed) return;
      dismissed = true;
      entry.remove();
      if (!completer.isCompleted) completer.complete();
    }

    entry = OverlayEntry(
      builder: (ctx) => _AuraPulseToast(
        title: title,
        loadingMessage: loadingMessage,
        doneMessage: doneMessage,
        onDismiss: dismiss,
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(entry);
    return completer.future;
  }
}

class _AuraPulseToast extends StatefulWidget {
  const _AuraPulseToast({
    required this.loadingMessage,
    required this.doneMessage,
    required this.onDismiss,
    this.title,
  });

  final String loadingMessage;
  final String doneMessage;
  final String? title;
  final VoidCallback onDismiss;

  @override
  State<_AuraPulseToast> createState() => _AuraPulseToastState();
}

class _AuraPulseToastState extends State<_AuraPulseToast> {
  var _loading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 950), () {
      if (!mounted) return;
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AuraToastCard(
      title: widget.title,
      message: _loading ? widget.loadingMessage : widget.doneMessage,
      tone: _loading ? AuraToastTone.loading : AuraToastTone.success,
      duration: _loading
          ? const Duration(days: 1)
          : const Duration(milliseconds: 1500),
      autoDismiss: !_loading,
      onDismiss: widget.onDismiss,
    );
  }
}

class _AuraToastCard extends StatefulWidget {
  const _AuraToastCard({
    required this.message,
    required this.tone,
    required this.duration,
    required this.onDismiss,
    this.title,
    this.actionLabel,
    this.onAction,
    this.autoDismiss = true,
  });

  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AuraToastTone tone;
  final Duration duration;
  final VoidCallback onDismiss;
  final bool autoDismiss;

  @override
  State<_AuraToastCard> createState() => _AuraToastCardState();
}

class _AuraToastCardState extends State<_AuraToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..forward();
    _armTimer();
  }

  @override
  void didUpdateWidget(covariant _AuraToastCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoDismiss != widget.autoDismiss ||
        oldWidget.duration != widget.duration) {
      _armTimer();
    }
  }

  void _armTimer() {
    _timer?.cancel();
    if (!widget.autoDismiss) return;
    _timer = Timer(widget.duration, () async {
      if (!mounted) return;
      await _anim.reverse();
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Soft dim — tap outside dismisses.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await _anim.reverse();
                if (mounted) widget.onDismiss();
              },
              child: const ColoredBox(color: Color(0x0A0A0A0A)),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 12),
                child: FadeTransition(
                  opacity: _anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.12),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _anim,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AuraTheme.paper,
                          borderRadius:
                              BorderRadius.circular(AuraUi.radiusMd),
                          border: Border.all(
                            color: AuraTheme.line,
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x140A0A0A),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ToneMark(tone: widget.tone),
                              if (widget.title != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  widget.title!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: AuraTheme.fontDisplay,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: AuraTheme.ink,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              Text(
                                widget.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: AuraTheme.fontFamily,
                                  fontSize: 14,
                                  height: 1.4,
                                  color: AuraTheme.mute,
                                ),
                              ),
                              if (widget.actionLabel != null) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed:
                                        widget.onAction ?? widget.onDismiss,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AuraTheme.ink,
                                      side: const BorderSide(
                                        color: AuraTheme.ink,
                                      ),
                                      minimumSize: const Size.fromHeight(42),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AuraUi.radiusSm,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      widget.actionLabel!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToneMark extends StatelessWidget {
  const _ToneMark({required this.tone});

  final AuraToastTone tone;

  @override
  Widget build(BuildContext context) {
    return switch (tone) {
      AuraToastTone.loading => const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: AuraTheme.ink,
          ),
        ),
      AuraToastTone.success => Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AuraTheme.ink, width: 1.4),
          ),
          child: const Icon(Icons.check, size: 16, color: AuraTheme.ink),
        ),
      AuraToastTone.note => Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AuraTheme.mist,
            border: Border.all(color: AuraTheme.line),
          ),
          child:
              const Icon(Icons.info_outline, size: 16, color: AuraTheme.ink),
        ),
      AuraToastTone.idle => const SizedBox(height: 4),
    };
  }
}
