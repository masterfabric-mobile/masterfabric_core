import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/di/injection.dart' as di;
import '../../app/routes.dart' as app_routes;
import '../../app/theme/aura_theme.dart';
import '../../data/fitness_repository.dart';
import '../../jobs/aura_activity_jobs.dart';
import '../../widgets/aura_toast.dart';
import '../../widgets/aura_ui.dart';

/// Second onboarding queue — system permissions for a more useful AURA day.
class AuraPermissionsView extends StatefulWidget {
  const AuraPermissionsView({super.key});

  @override
  State<AuraPermissionsView> createState() => _AuraPermissionsViewState();
}

enum _PermStep { intro, notifications, location, fitness, ready }

class _AuraPermissionsViewState extends State<AuraPermissionsView> {
  final _page = PageController();
  var _index = 0;
  var _busy = false;

  static const _steps = _PermStep.values;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index >= _steps.length - 1) {
      await _finish();
      return;
    }
    await _page.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _back() async {
    if (_index == 0) return;
    await _page.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final repo = di.getIt<FitnessRepository>();
      await repo.saveProfile(
        repo.profile.copyWith(permissionsComplete: true),
      );
      // Schedule local jobs only after the user has faced the prompt.
      await di.getIt<AuraActivityJobs>().start();
      if (!mounted) return;
      context.go(app_routes.AppRoutes.home);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestNotifications() async {
    setState(() => _busy = true);
    try {
      if (Platform.isIOS) {
        final ios = FlutterLocalNotificationsPlugin()
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        await ios?.requestPermissions(alert: true, badge: true, sound: true);
      }
      final status = await Permission.notification.request();
      if (!mounted) return;
      await AuraToast.pulse(
        context,
        title: 'Notifications',
        loadingMessage: 'Talking to the system…',
        doneMessage: status.isGranted
            ? 'On — meal & water nudges are ready.'
            : 'Skipped — enable later in Settings anytime.',
      );
      if (!mounted) return;
      await _next();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestLocation() async {
    setState(() => _busy = true);
    try {
      final status = await Permission.locationWhenInUse.request();
      if (!mounted) return;
      await AuraToast.pulse(
        context,
        title: 'Location',
        loadingMessage: 'Checking place access…',
        doneMessage: status.isGranted
            ? 'On — outdoor & place context unlocked.'
            : 'Skipped — coaching stays local without GPS.',
      );
      if (!mounted) return;
      await _next();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestFitness() async {
    setState(() => _busy = true);
    try {
      PermissionStatus status;
      if (Platform.isAndroid) {
        status = await Permission.activityRecognition.request();
        // Sensors complement activity on some OEMs.
        await Permission.sensors.request();
      } else {
        status = await Permission.sensors.request();
      }
      if (!mounted) return;
      await AuraToast.pulse(
        context,
        title: 'Motion & fitness',
        loadingMessage: 'Reading motion availability…',
        doneMessage: status.isGranted
            ? 'On — burn estimates can improve.'
            : 'Skipped — log burn manually anytime.',
      );
      if (!mounted) return;
      await _next();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = MediaQuery.paddingOf(context).top;
    final step = _steps[_index];

    return Scaffold(
      backgroundColor: AuraTheme.paper,
      body: Column(
        children: [
          SizedBox(height: top + 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Access',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: AuraTheme.fontDisplay,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_index + 1} / ${_steps.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AuraTheme.mute,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (_index + 1) / _steps.length,
                minHeight: 4,
                backgroundColor: AuraTheme.mist,
                color: AuraTheme.ink,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _page,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _PermScaffold(
                  asset:
                      'assets/illustrations/permissions/perm_intro.png',
                  title: 'Unlock a sharper day',
                  body:
                      'A few device permissions help AURA nudge meals, place outdoor work, and read motion — all stay on this phone.',
                  child: AuraUi.appleCard(
                    child: Text(
                      'You can skip any step. Settings stays available later.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AuraTheme.mute,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
                _PermScaffold(
                  asset:
                      'assets/illustrations/permissions/perm_notifications.png',
                  title: 'Notifications',
                  body:
                      'Local reminders for water, meals, and movement. No cloud push — just this device.',
                  child: _PrimaryAction(
                    label: 'Allow notifications',
                    busy: _busy,
                    onPressed: _requestNotifications,
                    secondaryLabel: 'Not now',
                    onSecondary: _busy ? null : _next,
                  ),
                ),
                _PermScaffold(
                  asset:
                      'assets/illustrations/permissions/perm_location.png',
                  title: 'Location while using',
                  body:
                      'Optional context for outdoor sessions and place-aware coaching tips. AURA does not track you in the background.',
                  child: _PrimaryAction(
                    label: 'Allow location',
                    busy: _busy,
                    onPressed: _requestLocation,
                    secondaryLabel: 'Not now',
                    onSecondary: _busy ? null : _next,
                  ),
                ),
                _PermScaffold(
                  asset:
                      'assets/illustrations/permissions/perm_fitness.png',
                  title: 'Motion & fitness',
                  body:
                      'Read motion and activity signals so burn and daily pace stay honest without manual logging every hour.',
                  child: _PrimaryAction(
                    label: 'Allow motion & fitness',
                    busy: _busy,
                    onPressed: _requestFitness,
                    secondaryLabel: 'Not now',
                    onSecondary: _busy ? null : _next,
                  ),
                ),
                _PermScaffold(
                  asset:
                      'assets/illustrations/permissions/perm_intro.png',
                  title: 'You’re ready',
                  body:
                      'Profile set. Permissions faced. Enter AURA and keep the loop simple — log, glance, one next move.',
                  child: AuraUi.appleCard(
                    child: Text(
                      'Change access anytime in iOS Settings → AURA.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AuraTheme.mute,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  if (_index > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy ? null : _back,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: AuraTheme.line),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AuraUi.radiusMd),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_index > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _busy
                          ? null
                          : () {
                              if (step == _PermStep.notifications ||
                                  step == _PermStep.location ||
                                  step == _PermStep.fitness) {
                                // Primary CTA lives in the step card.
                                _next();
                                return;
                              }
                              _next();
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AuraUi.radiusMd),
                        ),
                      ),
                      child: Text(
                        _busy
                            ? 'Working…'
                            : (step == _PermStep.ready
                                ? 'Enter AURA'
                                : step == _PermStep.intro
                                    ? 'Continue'
                                    : 'Skip'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermScaffold extends StatelessWidget {
  const _PermScaffold({
    required this.asset,
    required this.title,
    required this.body,
    required this.child,
  });

  final String asset;
  final String title;
  final String body;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
      children: [
        // Edge-to-edge width; fitWidth grows height so top/bottom aren't cropped.
        ColoredBox(
          color: AuraTheme.paper,
          child: Image.asset(
            asset,
            width: width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontFamily: AuraTheme.fontDisplay,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AuraTheme.mute,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.busy,
    required this.onPressed,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;
  final String secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: busy ? null : onPressed,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AuraUi.radiusMd),
              ),
            ),
            child: Text(busy ? 'Requesting…' : label),
          ),
        ),
        TextButton(
          onPressed: onSecondary,
          child: Text(secondaryLabel),
        ),
      ],
    );
  }
}
