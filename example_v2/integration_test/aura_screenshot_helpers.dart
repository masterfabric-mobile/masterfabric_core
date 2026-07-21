import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> settle(WidgetTester tester, [int ms = 1000]) async {
  await tester.pumpAndSettle(Duration(milliseconds: ms));
}

Future<void> shot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name,
) async {
  await tester.pump(const Duration(milliseconds: 300));
  await binding.takeScreenshot(name);
}

Future<void> tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  expect(finder, findsWidgets, reason: 'missing text: $text');
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first, warnIfMissed: false);
  await settle(tester);
}

/// Body baseline: tap the Woman [InkWell] card (not just the label).
Future<void> pickWomanBaseline(WidgetTester tester) async {
  final woman = find.text('Woman');
  expect(woman, findsWidgets, reason: 'Woman card missing on Body baseline');
  final ink = find.ancestor(of: woman.first, matching: find.byType(InkWell));
  expect(ink, findsWidgets, reason: 'Woman InkWell missing');
  await tester.ensureVisible(ink.first);
  await tester.tap(ink.first, warnIfMissed: false);
  await settle(tester, 600);

  // Dismiss "Almost there" toast if a prior Continue fired without selection.
  if (find.text('OK').evaluate().isNotEmpty) {
    await tapText(tester, 'OK');
  }
}

Future<void> tapContinue(WidgetTester tester) async {
  if (find.text('Continue').evaluate().isNotEmpty) {
    await tapText(tester, 'Continue');
  } else if (find.text('Enter AURA').evaluate().isNotEmpty) {
    await tapText(tester, 'Enter AURA');
  } else if (find.textContaining('Enter').evaluate().isNotEmpty) {
    await tester.tap(find.textContaining('Enter').first, warnIfMissed: false);
    await settle(tester);
  } else {
    fail('No Continue / Enter button found');
  }
}

bool get onBodyBaseline =>
    find.text('Body baseline').evaluate().isNotEmpty ||
    (find.text('Woman').evaluate().isNotEmpty &&
        find.text('Man').evaluate().isNotEmpty &&
        find.text('Athlete profile').evaluate().isNotEmpty);

bool get onMainShell =>
    find.text('Today').evaluate().isNotEmpty &&
    find.text('Log').evaluate().isNotEmpty;
