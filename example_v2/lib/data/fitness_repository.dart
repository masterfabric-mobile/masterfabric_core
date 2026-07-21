import 'dart:async';
import 'dart:convert';

import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:uuid/uuid.dart';

import 'fitness_calculator.dart';
import 'models/body_profile.dart';
import 'models/burn_entry.dart';
import 'models/coach_settings.dart';
import 'models/food_entry.dart';
import 'models/journal_entry.dart';
import 'models/weight_entry.dart';

/// Local-only persistence via masterfabric_core [LocalStorageHelper].
class FitnessRepository {
  FitnessRepository();

  static const _profileKey = 'aura_body_profile';
  static const _foodsKey = 'aura_food_entries';
  static const _burnsKey = 'aura_burn_entries';
  static const _settingsKey = 'aura_coach_settings';
  static const _journalKey = 'aura_journal_entries';
  static const _weightsKey = 'aura_weight_entries';
  static const _uuid = Uuid();

  final _changes = StreamController<void>.broadcast();
  Stream<void> get changes => _changes.stream;

  BodyProfile _profile = const BodyProfile();
  List<FoodEntry> _foods = [];
  List<BurnEntry> _burns = [];
  List<JournalEntry> _journal = [];
  List<WeightEntry> _weights = [];
  CoachSettings _settings = const CoachSettings();
  bool _loaded = false;

  BodyProfile get profile => _profile;
  List<FoodEntry> get foods => List.unmodifiable(_foods);
  List<BurnEntry> get burns => List.unmodifiable(_burns);
  List<JournalEntry> get journal => List.unmodifiable(_journal);
  List<WeightEntry> get weights => List.unmodifiable(_weights);
  CoachSettings get settings => _settings;

  Future<void> load() async {
    if (_loaded) return;
    await LocalStorageHelper.init();

    final profileRaw = LocalStorageHelper.getString(_profileKey);
    if (profileRaw != null && profileRaw.isNotEmpty) {
      _profile = BodyProfile.fromJson(
        jsonDecode(profileRaw) as Map<String, dynamic>,
      );
    }

    final foodsRaw = LocalStorageHelper.getString(_foodsKey);
    if (foodsRaw != null && foodsRaw.isNotEmpty) {
      final list = jsonDecode(foodsRaw) as List<dynamic>;
      _foods = list
          .map((e) => FoodEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final burnsRaw = LocalStorageHelper.getString(_burnsKey);
    if (burnsRaw != null && burnsRaw.isNotEmpty) {
      final list = jsonDecode(burnsRaw) as List<dynamic>;
      _burns = list
          .map((e) => BurnEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final settingsRaw = LocalStorageHelper.getString(_settingsKey);
    if (settingsRaw != null && settingsRaw.isNotEmpty) {
      _settings = CoachSettings.fromJson(
        jsonDecode(settingsRaw) as Map<String, dynamic>,
      );
    }

    final journalRaw = LocalStorageHelper.getString(_journalKey);
    if (journalRaw != null && journalRaw.isNotEmpty) {
      final list = jsonDecode(journalRaw) as List<dynamic>;
      _journal = list
          .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final weightsRaw = LocalStorageHelper.getString(_weightsKey);
    if (weightsRaw != null && weightsRaw.isNotEmpty) {
      final list = jsonDecode(weightsRaw) as List<dynamic>;
      _weights = list
          .map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    }

    _loaded = true;
  }

  DaySummary today([DateTime? day]) {
    return FitnessCalculator.summarize(
      profile: _profile,
      foods: _foods,
      burns: _burns,
      settings: _settings,
      day: day ?? DateTime.now(),
    );
  }

  /// Calendar days (local midnight) that have at least one food or burn entry.
  Set<DateTime> daysWithLogs({int lookbackDays = 42}) {
    final keys = <String>{};
    void mark(DateTime at) {
      keys.add('${at.year}-${at.month}-${at.day}');
    }

    for (final e in _foods) {
      mark(e.loggedAt);
    }
    for (final e in _burns) {
      mark(e.loggedAt);
    }

    final out = <DateTime>{};
    final now = DateTime.now();
    for (var i = 0; i < lookbackDays; i++) {
      final d = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final key = '${d.year}-${d.month}-${d.day}';
      if (keys.contains(key)) out.add(d);
    }
    return out;
  }

  Future<void> clearDay(DateTime day) async {
    _foods = _foods
        .where(
          (e) =>
              !(e.loggedAt.year == day.year &&
                  e.loggedAt.month == day.month &&
                  e.loggedAt.day == day.day),
        )
        .toList();
    _burns = _burns
        .where(
          (e) =>
              !(e.loggedAt.year == day.year &&
                  e.loggedAt.month == day.month &&
                  e.loggedAt.day == day.day),
        )
        .toList();
    await _persistFoods();
    await _persistBurns();
    _notify();
  }

  Future<void> saveProfile(BodyProfile profile) async {
    final previous = _profile.weightKg;
    _profile = profile;
    await LocalStorageHelper.setString(
      _profileKey,
      jsonEncode(profile.toJson()),
    );
    if ((profile.weightKg - previous).abs() >= 0.05) {
      await addWeight(profile.weightKg, at: DateTime.now());
      return;
    }
    _notify();
  }

  Future<WeightEntry> addWeight(
    double weightKg, {
    DateTime? at,
    String note = '',
  }) async {
    final entry = WeightEntry(
      id: _uuid.v4(),
      weightKg: weightKg,
      loggedAt: at ?? DateTime.now(),
      note: note,
    );
    _weights = [..._weights, entry]
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    // Keep profile weight in sync with latest check-in.
    if (_weights.isNotEmpty) {
      final latest = _weights.last;
      if ((_profile.weightKg - latest.weightKg).abs() >= 0.01) {
        _profile = _profile.copyWith(weightKg: latest.weightKg);
        await LocalStorageHelper.setString(
          _profileKey,
          jsonEncode(_profile.toJson()),
        );
      }
    }
    await LocalStorageHelper.setString(
      _weightsKey,
      jsonEncode(_weights.map((e) => e.toJson()).toList()),
    );
    _notify();
    return entry;
  }

  Future<void> removeWeight(String id) async {
    _weights = _weights.where((e) => e.id != id).toList();
    await LocalStorageHelper.setString(
      _weightsKey,
      jsonEncode(_weights.map((e) => e.toJson()).toList()),
    );
    _notify();
  }

  Future<void> saveSettings(CoachSettings settings) async {
    _settings = settings;
    await LocalStorageHelper.setString(
      _settingsKey,
      jsonEncode(settings.toJson()),
    );
    _notify();
  }

  Future<FoodEntry> addFood({
    required String name,
    required int calories,
    required MealKind kind,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
    int ml = 0,
    DateTime? at,
  }) async {
    final entry = FoodEntry(
      id: _uuid.v4(),
      name: name,
      calories: calories,
      kind: kind,
      loggedAt: at ?? DateTime.now(),
      protein: protein,
      carbs: carbs,
      fat: fat,
      ml: ml,
    );
    _foods = [..._foods, entry];
    await _persistFoods();
    _notify();
    return entry;
  }

  Future<void> removeFood(String id) async {
    _foods = _foods.where((e) => e.id != id).toList();
    await _persistFoods();
    _notify();
  }

  Future<BurnEntry> addBurn({
    required String name,
    required int calories,
    required int minutes,
    DateTime? at,
  }) async {
    final entry = BurnEntry(
      id: _uuid.v4(),
      name: name,
      calories: calories,
      minutes: minutes,
      loggedAt: at ?? DateTime.now(),
    );
    _burns = [..._burns, entry];
    await _persistBurns();
    _notify();
    return entry;
  }

  Future<void> removeBurn(String id) async {
    _burns = _burns.where((e) => e.id != id).toList();
    await _persistBurns();
    _notify();
  }

  Future<JournalEntry> addJournal(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Journal text is empty');
    }
    final entry = JournalEntry(
      id: _uuid.v4(),
      text: trimmed,
      createdAt: DateTime.now(),
    );
    _journal = [entry, ..._journal];
    await _persistJournal();
    _notify();
    return entry;
  }

  Future<void> removeJournal(String id) async {
    _journal = _journal.where((e) => e.id != id).toList();
    await _persistJournal();
    _notify();
  }

  Future<void> clearToday() async {
    await clearDay(DateTime.now());
  }

  Future<void> notifyNow({
    required String title,
    required String body,
  }) async {
    await LocalNotificationHelper.showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: title,
      body: body,
    );
  }

  /// Legacy entry-point — activity cadence is owned by [AuraActivityJobs].
  Future<void> scheduleCoachReminders() async {
    // Kept for CoachCubit callers; real scheduling happens in AuraActivityJobs
    // via repository change stream + app start.
  }

  Future<void> _persistFoods() async {
    await LocalStorageHelper.setString(
      _foodsKey,
      jsonEncode(_foods.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _persistBurns() async {
    await LocalStorageHelper.setString(
      _burnsKey,
      jsonEncode(_burns.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _persistJournal() async {
    await LocalStorageHelper.setString(
      _journalKey,
      jsonEncode(_journal.map((e) => e.toJson()).toList()),
    );
  }

  void _notify() {
    if (!_changes.isClosed) {
      _changes.add(null);
    }
  }
}
