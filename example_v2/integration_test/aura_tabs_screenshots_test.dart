import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:example_v2/main.dart' as app;
import 'package:example_v2/widgets/profile_avatar.dart';

import 'aura_screenshot_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AURA tab screenshots 14-18', (tester) async {
    await app.main();
    await tester.pump(const Duration(seconds: 2));
    await settle(tester, 3200);

    // Advance any leftover onboarding — always pick Woman on Body baseline.
    for (var i = 0; i < 50; i++) {
      if (onMainShell) break;

      if (find.text('OK').evaluate().isNotEmpty) {
        await tapText(tester, 'OK');
        continue;
      }

      if (onBodyBaseline) {
        await pickWomanBaseline(tester);
        await tapContinue(tester);
        continue;
      }

      if (find.text('Enter AURA').evaluate().isNotEmpty) {
        await tapText(tester, 'Enter AURA');
        continue;
      }
      if (find.text('Not now').evaluate().isNotEmpty) {
        await tapText(tester, 'Not now');
        continue;
      }
      if (find.text('Continue').evaluate().isNotEmpty) {
        // Name step may need a value before Continue.
        final field = find.byType(TextField);
        if (field.evaluate().isNotEmpty) {
          await tester.enterText(field.first, 'AURA');
          await settle(tester, 400);
        }
        await tapContinue(tester);
        continue;
      }

      await tester.pump(const Duration(milliseconds: 400));
    }

    expect(onMainShell, isTrue, reason: 'did not reach main shell tabs');

    await tapText(tester, 'Today');
    await settle(tester, 800);
    await shot(binding, tester, '14_today');

    await tapText(tester, 'Log');
    await settle(tester, 800);
    await shot(binding, tester, '15_log');

    await tapText(tester, 'Body');
    await settle(tester, 800);
    await shot(binding, tester, '16_body');

    await tapText(tester, 'Coach');
    await settle(tester, 800);
    await shot(binding, tester, '17_coach');

    await tapText(tester, 'Today');
    await settle(tester, 800);

    final avatar = find.byType(ProfileAvatar);
    expect(avatar, findsWidgets, reason: 'ProfileAvatar missing on Today');
    await tester.tap(avatar.first, warnIfMissed: false);
    await settle(tester, 1400);
    await shot(binding, tester, '18_profile_language');
  });
}
