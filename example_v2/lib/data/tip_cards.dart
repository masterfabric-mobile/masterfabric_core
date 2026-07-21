class TipCardData {
  const TipCardData({
    required this.title,
    required this.body,
    required this.tag,
    required this.heroAsset,
    this.accent = TipCardAccent.mist,
  });

  final String title;
  final String body;
  final String tag;
  final String heroAsset;
  final TipCardAccent accent;
}

/// Light surfaces only — no black tip cards.
enum TipCardAccent { mist, paper }

/// Short illustrated “blog” tips for efficient daily use.
abstract final class TipCards {
  static const all = <TipCardData>[
    TipCardData(
      tag: 'Today',
      title: 'One glance, then move',
      body:
          'Check remaining kcal and the ring first. If warnings are empty, skip deep menus and log the next meal in under 20 seconds.',
      heroAsset: 'assets/illustrations/tips/tip_today.webp',
      accent: TipCardAccent.mist,
    ),
    TipCardData(
      tag: 'Log',
      title: 'Presets beat perfect grams',
      body:
          'Tap a quick-add before you hunt labels. Honest estimates beat empty days — you can refine custom entries later.',
      heroAsset: 'assets/illustrations/tips/tip_log.webp',
      accent: TipCardAccent.paper,
    ),
    TipCardData(
      tag: 'Body',
      title: 'Set the body once a week',
      body:
          'Height, weight, and activity drive BMR/TDEE. Update weight weekly; daily noise makes goals jittery.',
      heroAsset: 'assets/illustrations/tips/tip_body.webp',
      accent: TipCardAccent.mist,
    ),
    TipCardData(
      tag: 'Coach',
      title: 'Ask for the next action',
      body:
          'On a real iPhone, open Health or Food coach. Give today’s summary and ask for one meal or one walk — not a full diet overhaul.',
      heroAsset: 'assets/illustrations/tips/tip_coach.webp',
      accent: TipCardAccent.paper,
    ),
    TipCardData(
      tag: 'Widget',
      title: 'Pin the glance surface',
      body:
          'Add the AURA Today widget and start a Live Activity before lunch. The island should answer “how much left?” without opening the app.',
      heroAsset: 'assets/illustrations/tips/tip_widget.webp',
      accent: TipCardAccent.mist,
    ),
    TipCardData(
      tag: 'Water',
      title: 'Stack water with habits',
      body:
          'Log +250 ml when you sit down to work or finish a set. Water goals unlock cleaner coach warnings by late afternoon.',
      heroAsset: 'assets/illustrations/tips/tip_water.webp',
      accent: TipCardAccent.paper,
    ),
  ];

  static List<TipCardData> forSection(String tag) =>
      all.where((t) => t.tag.toLowerCase() == tag.toLowerCase()).toList();
}
