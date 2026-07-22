import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';
import '../src/resources/resources.g.dart' as aura;
import 'aura_kit.dart';

/// Language switcher backed by slang [LocaleSettings] (en / tr).
class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  Future<void> _set(aura.AppLocale locale) async {
    if (aura.LocaleSettings.currentLocale != locale) {
      await aura.LocaleSettings.setLocale(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = aura.Translations.of(context);
    final current = aura.LocaleSettings.currentLocale;

    return AuraKit.sectionCard(
      context: context,
      title: t.settings.language,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AuraTheme.mist,
          borderRadius: BorderRadius.circular(AuraUi.radiusSm),
        ),
        child: Row(
          children: [
            Expanded(
              child: _LocaleSegment(
                label: t.settings.english,
                selected: current == aura.AppLocale.en,
                onTap: () => _set(aura.AppLocale.en),
              ),
            ),
            Expanded(
              child: _LocaleSegment(
                label: t.settings.turkish,
                selected: current == aura.AppLocale.tr,
                onTap: () => _set(aura.AppLocale.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocaleSegment extends StatelessWidget {
  const _LocaleSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AuraTheme.ink : Colors.transparent,
      borderRadius: BorderRadius.circular(AuraUi.radiusSm - 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AuraUi.radiusSm - 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: selected ? AuraTheme.paper : AuraTheme.mute,
            ),
          ),
        ),
      ),
    );
  }
}
