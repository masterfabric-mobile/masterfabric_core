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
      child: Column(
        children: [
          _LocaleTile(
            label: t.settings.english,
            selected: current == aura.AppLocale.en,
            onTap: () => _set(aura.AppLocale.en),
          ),
          AuraSpace.vSm,
          _LocaleTile(
            label: t.settings.turkish,
            selected: current == aura.AppLocale.tr,
            onTap: () => _set(aura.AppLocale.tr),
          ),
        ],
      ),
    );
  }
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AuraKit.listRow(
      title: label,
      onTap: onTap,
      trailing: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        size: 20,
        color: selected ? AuraTheme.ink : AuraTheme.mute,
      ),
    );
  }
}
