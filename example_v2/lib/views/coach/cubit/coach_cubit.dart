import 'dart:async';

import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../app/di/injection.dart' as di;
import '../../../data/fitness_calculator.dart';
import '../../../data/fitness_repository.dart';
import '../../../data/models/body_profile.dart';
import '../../../data/models/coach_settings.dart';
import '../../../jobs/aura_activity_jobs.dart';
import 'coach_state.dart';

class CoachCubit extends BaseViewModelCubit<CoachState> {
  CoachCubit(this._repo) : super(const CoachState()) {
    _sub = _repo.changes.listen((_) => load(silent: true));
  }

  final FitnessRepository _repo;
  StreamSubscription<void>? _sub;

  static const helpTopics = <(String, String)>[
    (
      'Calorie goal',
      'BMR × activity becomes TDEE. That is your daily goal unless Body locks a custom number.',
    ),
    (
      'Food vs drink',
      'Meals carry macros. Drinks can add ml for water. Log water often so warnings stay useful.',
    ),
    (
      'On-device AI',
      'Health and Food coaches use WebLLM (MLC) only on a physical iPhone. Simulator stays rule-based.',
    ),
    (
      'Privacy',
      'Logs and chats stay on device via masterfabric_core storage. No account, no cloud coach.',
    ),
  ];

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      stateChanger(state.copyWith(loading: true));
    }
    await _repo.load();
    final summary = _repo.today();
    final profile = _repo.profile;
    final physical =
        await DeviceInfoHelper.instance.platformDevicePhysical();
    final contextText = _buildContext(summary, profile);
    stateChanger(
      state.copyWith(
        loading: false,
        summary: summary,
        settings: _repo.settings,
        tips: FitnessCalculator.coachTips(
          profile: profile,
          today: summary,
        ),
        isPhysicalDevice: physical,
        contextText: contextText,
        journal: _repo.journal,
      ),
    );
  }

  Future<void> addJournal(String text) async {
    await _repo.addJournal(text);
    await load(silent: true);
  }

  Future<void> removeJournal(String id) async {
    await _repo.removeJournal(id);
    await load(silent: true);
  }

  String _buildContext(DaySummary s, BodyProfile profile) {
    return [
      'Remaining ${s.remaining} kcal (goal ${s.goal}).',
      'Eaten ${s.eaten}, burned ${s.burned}, water ${s.waterMl} ml.',
      'Macros P ${s.protein}g / C ${s.carbs}g / F ${s.fat}g.',
      if (s.warnings.isNotEmpty) 'Alerts: ${s.warnings.join(' | ')}',
      'Body: ${profile.heightCm.round()} cm, ${profile.weightKg.toStringAsFixed(1)} kg, age ${profile.age}.',
    ].join(' ');
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  void nextHelp() {
    final next = (state.helpIndex + 1) % helpTopics.length;
    stateChanger(state.copyWith(helpIndex: next));
  }

  Future<void> updateSettings(CoachSettings settings) async {
    await _repo.saveSettings(settings);
    await di.getIt<AuraActivityJobs>().reschedule();
    await load();
  }

  Future<void> toggleReminders(bool value) async {
    await updateSettings(state.settings.copyWith(remindersEnabled: value));
  }

  Future<void> toggleWarnOver(bool value) async {
    await updateSettings(state.settings.copyWith(warnOverGoal: value));
  }

  Future<void> toggleWarnUnder(bool value) async {
    await updateSettings(state.settings.copyWith(warnUnderGoal: value));
  }

  Future<void> toggleWarnWater(bool value) async {
    await updateSettings(state.settings.copyWith(warnLowWater: value));
  }

  Future<void> sendCheckIn() async {
    final tip = state.tips.isNotEmpty
        ? state.tips.first
        : 'Log something small. Coaching starts with data.';
    await _repo.notifyNow(title: 'AURA Coach', body: tip);
  }

  Future<void> refreshTips() async {
    await load();
  }
}
