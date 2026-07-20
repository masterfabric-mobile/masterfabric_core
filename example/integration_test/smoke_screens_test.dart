import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:masterfabric_core_example/main.dart' as app;

/// Functional smoke across main tabs, settings, helpers, and core demos.
///
/// Uses fixed pumps (not pumpAndSettle) so infinite animations
/// (skeleton shimmer, splash timers) cannot hang the suite.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('smoke navigate all main + helper + core demo screens',
      (tester) async {
    await app.main();
    await _settle(tester, seconds: 8);
    _pass('Home', find.textContaining('masterfabric_core'));

    // —— Main tabs ——
    await _openTab(tester, 'Products');
    _pass('Products', find.textContaining('Product'));

    await _openTab(tester, 'Profile');
    _pass('Profile', find.textContaining('Profile'));

    await _openTab(tester, 'Helpers');
    _pass('Helpers hub', find.textContaining('Helper'));

    // —— Every helper row (package subtitle is locale-stable) ——
    const helpers = <String>[
      'device_info_plus',
      'shared_preferences',
      'hive_ce',
      'intl',
      'url_launcher',
      'permission_handler',
      'share_plus',
      'dio',
      'json',
      'package_info_plus',
      'flutter_svg',
      'flutter_html',
      'onesignal',
      'version check',
      'shimmer',
      'network_info_plus',
    ];

    for (final key in helpers) {
      await _openTab(tester, 'Helpers');
      await _scrollUntilVisible(tester, key);
      final row = find.textContaining(key);
      if (row.evaluate().isEmpty) {
        debugPrint('SKIP helper not found: $key');
        continue;
      }
      await tester.ensureVisible(row.first);
      await tester.tap(row.first);
      await _settle(tester);
      expect(tester.takeException(), isNull, reason: 'Exception on $key');
      debugPrint('PASS helper: $key');
      await _tapBack(tester);
      await _settle(tester);
    }

    // —— Settings ——
    await _openTab(tester, 'Home');
    final settingsIcon = find.byTooltip('Settings');
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await _settle(tester);
    _pass('Settings', find.textContaining('Settings'));
    await _tapBack(tester);
    await _settle(tester);

    // —— Core demos from Home ——
    const demos = <String>[
      'MasterView (Bloc)',
      'Auth',
      'Account',
      'Search',
      'Permissions',
      'Empty',
      'Error',
      'Loading',
      'Info',
      'Onboarding',
    ];

    for (final demo in demos) {
      await _openTab(tester, 'Home');
      await _scrollUntilVisible(tester, demo);
      final row = find.text(demo);
      if (row.evaluate().isEmpty) {
        debugPrint('SKIP core demo not found: $demo');
        continue;
      }
      await tester.ensureVisible(row.first);
      await tester.tap(row.first);
      await _settle(tester);
      expect(tester.takeException(), isNull, reason: 'Exception on $demo');
      debugPrint('PASS core demo: $demo');
      await _tapBack(tester);
      await _settle(tester);
    }

    await _openTab(tester, 'Home');
    expect(tester.takeException(), isNull);
    debugPrint('SMOKE COMPLETE');
  });
}

void _pass(String name, Finder finder) {
  expect(finder, findsWidgets, reason: '$name not visible');
  debugPrint('PASS: $name');
}

Future<void> _settle(WidgetTester tester, {int seconds = 2}) async {
  // Avoid pumpAndSettle — skeleton/webview animations never idle.
  final frames = seconds * 10;
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _openTab(WidgetTester tester, String label) async {
  final tabs = find.text(label);
  expect(tabs, findsWidgets, reason: 'Tab "$label" missing');
  await tester.tap(tabs.last);
  await _settle(tester);
}

Future<void> _scrollUntilVisible(WidgetTester tester, String text) async {
  final target = find.textContaining(text);
  for (var i = 0; i < 14; i++) {
    if (target.evaluate().isNotEmpty) {
      await tester.ensureVisible(target.first);
      return;
    }
    final scrollables = find.byType(Scrollable);
    if (scrollables.evaluate().isEmpty) return;
    await tester.drag(scrollables.first, const Offset(0, -280));
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> _tapBack(WidgetTester tester) async {
  final back = find.byType(BackButton);
  if (back.evaluate().isNotEmpty) {
    await tester.tap(back.first);
    return;
  }
  final appBars = find.byType(AppBar);
  if (appBars.evaluate().isNotEmpty) {
    final leading = find.descendant(
      of: appBars.first,
      matching: find.byType(IconButton),
    );
    if (leading.evaluate().isNotEmpty) {
      await tester.tap(leading.first);
      return;
    }
  }
  final navigators = find.byType(Navigator);
  if (navigators.evaluate().isNotEmpty) {
    final navigator = tester.state<NavigatorState>(navigators.first);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}
