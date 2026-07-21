import 'dart:async';

import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../data/fitness_repository.dart';
import '../../../data/food_catalog.dart';
import '../../../data/models/food_entry.dart';
import 'log_state.dart';

class LogCubit extends BaseViewModelCubit<LogState> {
  LogCubit(this._repo) : super(const LogState()) {
    _sub = _repo.changes.listen((_) => load(silent: true));
  }

  final FitnessRepository _repo;
  StreamSubscription<void>? _sub;

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      stateChanger(state.copyWith(loading: true));
    }
    await _repo.load();
    final day = state.selectedDay ?? DateTime.now();
    final normalized = DateTime(day.year, day.month, day.day);
    final summary = _repo.today(normalized);
    stateChanger(
      state.copyWith(
        loading: false,
        selectedDay: normalized,
        summary: summary,
        foods: summary.entries,
        burns: summary.burns,
        daysWithLogs: _repo.daysWithLogs(),
      ),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<void> selectDay(DateTime day) async {
    final normalized = DateTime(day.year, day.month, day.day);
    stateChanger(state.copyWith(selectedDay: normalized));
    await load(silent: true);
  }

  void setFilter(MealKind kind) {
    stateChanger(state.copyWith(filter: kind));
  }

  DateTime get _logAt {
    final day = state.day;
    final now = DateTime.now();
    final isToday = day.year == now.year &&
        day.month == now.month &&
        day.day == now.day;
    if (isToday) return now;
    return DateTime(day.year, day.month, day.day, 12);
  }

  Future<void> addCatalog(CatalogItem item) async {
    await _repo.addFood(
      name: item.name,
      calories: item.calories,
      kind: item.kind,
      protein: item.protein,
      carbs: item.carbs,
      fat: item.fat,
      ml: item.ml,
      at: _logAt,
    );
    await load();
  }

  Future<void> addCustom({
    required String name,
    required int calories,
    required MealKind kind,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
    int ml = 0,
  }) async {
    await _repo.addFood(
      name: name,
      calories: calories,
      kind: kind,
      protein: protein,
      carbs: carbs,
      fat: fat,
      ml: ml,
      at: _logAt,
    );
    await load();
  }

  Future<void> addBurn(String name, int minutes, int calories) async {
    await _repo.addBurn(
      name: name,
      minutes: minutes,
      calories: calories,
      at: _logAt,
    );
    await load();
  }

  Future<void> removeFood(String id) async {
    await _repo.removeFood(id);
    await load();
  }

  Future<void> removeBurn(String id) async {
    await _repo.removeBurn(id);
    await load();
  }

  Future<void> clearSelectedDay() async {
    await _repo.clearDay(state.day);
    await load();
  }
}
