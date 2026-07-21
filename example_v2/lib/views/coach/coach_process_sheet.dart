import 'package:flutter/material.dart';

import '../../app/theme/aura_theme.dart';
import '../../widgets/aura_ui.dart';

/// Full process guide for people who do not yet understand AURA’s loop.
abstract final class CoachProcessSheet {
  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.88,
          minChildSize: 0.55,
          maxChildSize: 0.94,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
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
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AuraUi.radiusLg),
                  child: AuraUi.illustration(AuraArt.coach, height: 140),
                ),
                const SizedBox(height: 16),
                Text(
                  'How AURA works',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'A short map for first-time users. Follow these steps once — then the app stays quiet and useful.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AuraTheme.mute,
                      ),
                ),
                const SizedBox(height: 20),
                ..._steps.map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: AuraUi.appleCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.$1,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AuraTheme.mute,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            step.$2,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            step.$3,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.45,
                              color: AuraTheme.mute,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AuraUi.appleCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily rhythm',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _rhythm,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: AuraTheme.mute,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                    ),
                  ),
                  child: const Text('Got it — start with Body'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static const _steps = <(String, String, String)>[
    (
      '01 · Body',
      'Set your numbers once',
      'Open Body. Enter height, weight, age, sex, and activity. AURA calculates BMR, TDEE, and a daily calorie goal. Update weight about once a week — not every hour.',
    ),
    (
      '02 · Log',
      'Capture food and burn quickly',
      'Use quick-add presets for meals and drinks. Log water in +250 ml taps. Add a burn when you train. Perfect grams are optional; empty days are the real problem.',
    ),
    (
      '03 · Today',
      'Read the ring, then act',
      'Today shows remaining calories, macros, water, and warnings. If the ring is calm, keep living. If a warning appears, fix one thing — usually a meal or water.',
    ),
    (
      '04 · Coach',
      'Ask for the next action',
      'Rule tips always work. On a real iPhone, Health Coach and Food Coach (WebLLM / MLC) can suggest one walk or one meal from today’s summary. Use the journal below to note how you felt.',
    ),
    (
      '05 · Surfaces',
      'Keep the glance outside the app',
      'Pin the AURA widget and start a Live Activity before a busy lunch. The point is to answer “how much left?” without opening the whole app.',
    ),
  ];

  static const _rhythm =
      'Morning: glance Today.\n'
      'Meals: Log in under 20 seconds.\n'
      'Afternoon: water + one check-in tip.\n'
      'Evening: short journal note — energy, hunger, mood.\n'
      'Weekly: Body weight update.\n\n'
      'Everything stays on this device. No account. No cloud coach.';
}
