import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

import '../data/fitness_calculator.dart';
import '../data/fitness_repository.dart';
import '../data/models/coach_settings.dart';

class ActivityJob {
  const ActivityJob({
    required this.id,
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    required this.when,
    this.payload,
  });

  final int id;
  final int hour;
  final int minute;
  final String title;
  final String body;
  final String when;
  final String? payload;

  factory ActivityJob.fromJson(Map<String, dynamic> json) {
    return ActivityJob(
      id: (json['id'] as num).toInt(),
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      body: json['body'] as String,
      when: json['when'] as String? ?? 'always',
      payload: json['payload'] as String?,
    );
  }
}

/// Local notification “background jobs” for keeping the person active.
///
/// iOS/Android fire these while the app is backgrounded via
/// [LocalNotificationHelper.scheduleNotification]. Jobs + copy live in
/// `assets/notifications/activity_jobs.json` and are rescheduled from
/// day state (water, meals, under-fueled, etc.).
class AuraActivityJobs {
  AuraActivityJobs(this._repo);

  static const assetPath = 'assets/notifications/activity_jobs.json';
  static const _jobIdMin = 200;
  static const _jobIdMax = 299;

  final FitnessRepository _repo;
  StreamSubscription<void>? _sub;
  var _ready = false;
  var _scheduling = false;
  Timer? _debounce;

  Future<void> start() async {
    if (_ready) {
      await reschedule();
      return;
    }

    tz_data.initializeTimeZones();

    // Permission prompts live in AuraPermissionsView — do not re-prompt here.
    await LocalNotificationHelper.initialize(
      iosSettings: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _repo.load();
    _sub = _repo.changes.listen((_) => _debounceReschedule());
    _ready = true;
    await reschedule();
  }

  void _debounceReschedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      unawaited(reschedule());
    });
  }

  Future<void> dispose() async {
    _debounce?.cancel();
    await _sub?.cancel();
  }

  Future<List<ActivityJob>> loadJobs() async {
    final raw = await rootBundle.loadString(assetPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['jobs'] as List<dynamic>? ?? const [];
    return list
        .map((e) => ActivityJob.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> reschedule() async {
    if (!_ready || _scheduling) return;
    _scheduling = true;
    try {
      await _repo.load();
      final settings = _repo.settings;
      if (!settings.remindersEnabled) {
        await _cancelJobRange();
        return;
      }

      final summary = _repo.today();
      final jobs = await loadJobs();
      final now = DateTime.now();

      await _cancelJobRange();

      for (final job in jobs) {
        if (!_matches(job.when, summary, settings)) continue;
        final when = _nextOccurrence(now, job.hour, job.minute);
        await LocalNotificationHelper.scheduleNotification(
          id: job.id,
          title: job.title,
          body: _personalize(job.body, summary),
          scheduledDate: when,
          payload: job.payload,
        );
      }

      // Settings-driven anchors (meal / water hours from Coach toggles).
      await _scheduleAnchor(
        id: 101,
        hour: settings.mealReminderHour,
        minute: 0,
        title: 'AURA · Meal check',
        body: 'Log a meal or snack — your coach needs real data.',
        payload: 'aura://log',
        now: now,
      );
      await _scheduleAnchor(
        id: 102,
        hour: settings.waterReminderHour,
        minute: 0,
        title: 'AURA · Water',
        body: summary.waterMl < (_repo.profile.waterGoalMl * 0.6).round()
            ? 'Water is behind. Tap +250 ml before the evening fades.'
            : 'Keep the water rhythm going — one more +250 ml helps.',
        payload: 'aura://log',
        now: now,
      );
    } catch (_) {
      // Scheduling can fail without timezone / permission; app still works.
    } finally {
      _scheduling = false;
    }
  }

  Future<void> _scheduleAnchor({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String payload,
    required DateTime now,
  }) async {
    final when = _nextOccurrence(now, hour, minute);
    await LocalNotificationHelper.scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      payload: payload,
    );
  }

  Future<void> _cancelJobRange() async {
    for (var id = _jobIdMin; id <= _jobIdMax; id++) {
      await LocalNotificationHelper.cancelNotification(id);
    }
    await LocalNotificationHelper.cancelNotification(101);
    await LocalNotificationHelper.cancelNotification(102);
  }

  bool _matches(String when, DaySummary summary, CoachSettings settings) {
    return switch (when) {
      'always' => true,
      'water_low' =>
        settings.warnLowWater &&
            summary.waterMl < (_repo.profile.waterGoalMl * 0.55).round(),
      'no_meals' => summary.entries.isEmpty,
      'under_fueled' =>
        settings.warnUnderGoal &&
            summary.eaten < (summary.goal * 0.45).round() &&
            DateTime.now().hour >= 14,
      'no_burn' => summary.burns.isEmpty && DateTime.now().hour >= 15,
      _ => true,
    };
  }

  String _personalize(String body, DaySummary summary) {
    return body
        .replaceAll('{remaining}', '${summary.remaining}')
        .replaceAll('{water}', '${summary.waterMl}')
        .replaceAll('{eaten}', '${summary.eaten}');
  }

  DateTime _nextOccurrence(DateTime now, int hour, int minute) {
    var target = DateTime(now.year, now.month, now.day, hour, minute);
    if (!target.isAfter(now.add(const Duration(minutes: 1)))) {
      target = target.add(const Duration(days: 1));
    }
    return target;
  }
}
