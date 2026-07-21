import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:example_v2/main.dart' as app;

import 'aura_screenshot_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AURA full-flow screenshots', (tester) async {
    await app.main();
    await tester.pump(const Duration(seconds: 2));
    await settle(tester, 2800);
    await shot(binding, tester, '01_launch');

    for (var i = 0; i < 25; i++) {
      if (find.textContaining('Train with clarity').evaluate().isNotEmpty ||
          onMainShell) {
        break;
      }
      await tester.pump(const Duration(milliseconds: 400));
    }

    if (find.textContaining('Train with clarity').evaluate().isNotEmpty) {
      await shot(binding, tester, '02_onboarding_welcome');
      await tapContinue(tester);

      await shot(binding, tester, '03_onboarding_sex');
      await pickWomanBaseline(tester);
      await shot(binding, tester, '04_onboarding_sex_selected');
      await tapContinue(tester);

      await shot(binding, tester, '05_onboarding_body_metrics');
      final field = find.byType(TextField);
      if (field.evaluate().isNotEmpty) {
        await tester.enterText(field.first, 'AURA');
        await settle(tester, 500);
      }
      await tapContinue(tester);

      await shot(binding, tester, '06_onboarding_body_type');
      await tapContinue(tester);

      await shot(binding, tester, '07_onboarding_training_goal');
      await tapContinue(tester);

      await shot(binding, tester, '08_onboarding_ready');
      await tapContinue(tester);

      await settle(tester, 1400);
      await shot(binding, tester, '09_permissions_intro');
      await tapContinue(tester);

      await shot(binding, tester, '10_permissions_notifications');
      await tapText(tester, 'Not now');

      await shot(binding, tester, '11_permissions_location');
      await tapText(tester, 'Not now');

      await shot(binding, tester, '12_permissions_fitness');
      await tapText(tester, 'Not now');

      await shot(binding, tester, '13_permissions_ready');
      await tapContinue(tester);
    }

    await settle(tester, 1600);
    await shot(binding, tester, '14_today');

    if (find.text('Log').evaluate().isNotEmpty) {
      await tapText(tester, 'Log');
      await shot(binding, tester, '15_log');
    }
    if (find.text('Body').evaluate().isNotEmpty) {
      await tapText(tester, 'Body');
      await shot(binding, tester, '16_body');
    }
    if (find.text('Coach').evaluate().isNotEmpty) {
      await tapText(tester, 'Coach');
      await shot(binding, tester, '17_coach');
    }
    if (find.text('Today').evaluate().isNotEmpty) {
      await tapText(tester, 'Today');
      await settle(tester);
    }

    final avatars = find.byType(CircleAvatar);
    if (avatars.evaluate().isNotEmpty) {
      await tester.tap(avatars.first, warnIfMissed: false);
      await settle(tester, 1200);
      await shot(binding, tester, '18_profile_language');
    }
  });
}
