import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../app/theme/aura_theme.dart';
import '../../widgets/aura_ui.dart';

enum LlmCoachRole { health, food }

/// On-device WebLLM (MLC) coach — intended for physical iPhones only.
class LlmCoachSheet extends StatefulWidget {
  const LlmCoachSheet({
    super.key,
    required this.role,
    required this.contextText,
  });

  final LlmCoachRole role;
  final String contextText;

  static Future<void> open(
    BuildContext context, {
    required LlmCoachRole role,
    required String contextText,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.88,
        child: LlmCoachSheet(role: role, contextText: contextText),
      ),
    );
  }

  @override
  State<LlmCoachSheet> createState() => _LlmCoachSheetState();
}

class _LlmCoachSheetState extends State<LlmCoachSheet> {
  InAppWebViewController? _controller;
  var _ready = false;
  var _status = 'Loading WebLLM…';

  @override
  Widget build(BuildContext context) {
    final title = widget.role == LlmCoachRole.food
        ? 'Food coach'
        : 'Health coach';

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AuraTheme.line,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      _ready ? 'On-device · WebLLM (MLC)' : _status,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AuraTheme.mute,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: InAppWebView(
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              transparentBackground: true,
              isInspectable: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
            ),
            onWebViewCreated: (controller) async {
              _controller = controller;
              controller.addJavaScriptHandler(
                handlerName: 'auraCoach',
                callback: (args) {
                  if (!mounted) return null;
                  setState(() {
                    _ready = true;
                    _status = 'Ready';
                  });
                  _pushConfig();
                  return null;
                },
              );
              final html = await rootBundle.loadString('assets/webllm/coach.html');
              await controller.loadData(
                data: html,
                mimeType: 'text/html',
                encoding: 'utf-8',
                baseUrl: WebUri('https://local.aura/'),
              );
            },
            shouldOverrideUrlLoading: (controller, action) async {
              final url = action.request.url;
              if (url == null) return NavigationActionPolicy.ALLOW;
              final host = url.host;
              final allowed = host.isEmpty ||
                  host.contains('jsdelivr') ||
                  host.contains('esm.run') ||
                  host.contains('huggingface') ||
                  host.contains('mlc') ||
                  host == 'local.aura';
              return allowed
                  ? NavigationActionPolicy.ALLOW
                  : NavigationActionPolicy.CANCEL;
            },
            onLoadStop: (controller, url) => _pushConfig(),
            onConsoleMessage: (controller, msg) {
              debugPrint('WebLLM: ${msg.message}');
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              'Runs only on a physical iPhone. First launch downloads a small local model — keep the sheet open.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pushConfig() async {
    final controller = _controller;
    if (controller == null) return;
    final payload = jsonEncode({
      'role': widget.role == LlmCoachRole.food ? 'food' : 'health',
      'context': widget.contextText,
    });
    await controller.evaluateJavascript(
      source: "window.auraConfigure && window.auraConfigure($payload);",
    );
  }
}

/// Compact entry card shown on Coach when LLM is available.
class LlmCoachEntryCard extends StatelessWidget {
  const LlmCoachEntryCard({
    super.key,
    required this.enabled,
    required this.onHealth,
    required this.onFood,
  });

  final bool enabled;
  final VoidCallback onHealth;
  final VoidCallback onFood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuraUi.appleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'On-device AI coach',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            enabled
                ? 'WebLLM (MLC) can act as a health or food coach using today’s snapshot. No cloud chat.'
                : 'Simulator detected. Open AURA on a real iPhone to enable WebLLM coaching.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AuraTheme.mute),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: enabled ? onHealth : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    ),
                  ),
                  child: const Text('Health coach'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: enabled ? onFood : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AuraTheme.paper,
                    foregroundColor: AuraTheme.ink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    ),
                  ),
                  child: const Text('Food coach'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
