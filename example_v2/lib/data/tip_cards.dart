import 'package:flutter/widgets.dart';

import '../src/resources/resources.g.dart' as aura;

enum TipSection { today, log, body, coach, widget, water }

class TipCardData {
  const TipCardData({
    required this.section,
    required this.title,
    required this.body,
    required this.tag,
    required this.heroAsset,
    this.accent = TipCardAccent.mist,
  });

  final TipSection section;
  final String title;
  final String body;
  final String tag;
  final String heroAsset;
  final TipCardAccent accent;
}

/// Light surfaces only — no black tip cards.
enum TipCardAccent { mist, paper }

/// Short illustrated tips — copy from slang so locale switches rebuild.
abstract final class TipCards {
  static List<TipCardData> all(BuildContext context) {
    final t = aura.Translations.of(context).tips;
    return [
      TipCardData(
        section: TipSection.today,
        tag: t.today_tag,
        title: t.today_title,
        body: t.today_body,
        heroAsset: 'assets/illustrations/tips/tip_today.webp',
        accent: TipCardAccent.mist,
      ),
      TipCardData(
        section: TipSection.log,
        tag: t.log_tag,
        title: t.log_title,
        body: t.log_body,
        heroAsset: 'assets/illustrations/tips/tip_log.webp',
        accent: TipCardAccent.paper,
      ),
      TipCardData(
        section: TipSection.body,
        tag: t.body_tag,
        title: t.body_title,
        body: t.body_body,
        heroAsset: 'assets/illustrations/tips/tip_body.webp',
        accent: TipCardAccent.mist,
      ),
      TipCardData(
        section: TipSection.coach,
        tag: t.coach_tag,
        title: t.coach_title,
        body: t.coach_body,
        heroAsset: 'assets/illustrations/tips/tip_coach.webp',
        accent: TipCardAccent.paper,
      ),
      TipCardData(
        section: TipSection.widget,
        tag: t.widget_tag,
        title: t.widget_title,
        body: t.widget_body,
        heroAsset: 'assets/illustrations/tips/tip_widget.webp',
        accent: TipCardAccent.mist,
      ),
      TipCardData(
        section: TipSection.water,
        tag: t.water_tag,
        title: t.water_title,
        body: t.water_body,
        heroAsset: 'assets/illustrations/tips/tip_water.webp',
        accent: TipCardAccent.paper,
      ),
    ];
  }

  static List<TipCardData> forSection(BuildContext context, TipSection section) =>
      all(context).where((t) => t.section == section).toList();
}
