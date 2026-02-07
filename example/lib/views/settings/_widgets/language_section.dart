import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;

/// Language Selection Section Widget
class LanguageSection extends StatelessWidget {
  const LanguageSection({
    super.key,
  });

  Future<void> _changeLanguage(BuildContext context, example_resources.AppLocale locale) async {
    final currentLocale = example_resources.LocaleSettings.currentLocale;
    if (currentLocale != locale) {
      await example_resources.LocaleSettings.setLocale(locale);
      // TranslationProvider will automatically rebuild the widget tree
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = example_resources.LocaleSettings.currentLocale;

    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: [
          RadioListTile<example_resources.AppLocale>(
            dense: true,
            title: Text(example_resources.resources.settings.english),
            value: example_resources.AppLocale.en,
            groupValue: currentLocale,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(context, value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<example_resources.AppLocale>(
            dense: true,
            title: Text(example_resources.resources.settings.turkish),
            value: example_resources.AppLocale.tr,
            groupValue: currentLocale,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(context, value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<example_resources.AppLocale>(
            dense: true,
            title: Text(example_resources.resources.settings.spanish),
            value: example_resources.AppLocale.es,
            groupValue: currentLocale,
            onChanged: (value) {
              if (value != null) {
                _changeLanguage(context, value);
              }
            },
          ),
        ],
      ),
    );
  }
}
