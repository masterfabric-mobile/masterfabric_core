import 'dart:async';

import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../data/fitness_repository.dart';
import '../../../data/food_catalog.dart';
import '../../../data/models/food_entry.dart';
import '../../../platform/aura_platform.dart';
import 'today_state.dart';

class TodayCubit extends BaseViewModelCubit<TodayState> {
  TodayCubit(this._repo) : super(const TodayState()) {
    _sub = _repo.changes.listen((_) => load(silent: true));
  }

  final FitnessRepository _repo;
  StreamSubscription<void>? _sub;

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      stateChanger(state.copyWith(loading: true));
    }
    await _repo.load();
    final summary = _repo.today();
    stateChanger(
      state.copyWith(
        loading: false,
        summary: summary,
        profile: _repo.profile,
      ),
    );
    await AuraPlatform.sync(summary);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<void> quickWater() => addWater(250);

  Future<void> addWater(int ml) async {
    await _repo.addFood(
      name: 'Water $ml ml',
      calories: 0,
      kind: MealKind.drink,
      ml: ml,
    );
    await load(silent: true);
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
    );
    await load(silent: true);
  }

  Future<void> addBurn({
    required String name,
    required int minutes,
    required int calories,
  }) async {
    await _repo.addBurn(
      name: name,
      minutes: minutes,
      calories: calories,
    );
    await load(silent: true);
  }

  Future<void> addJournal(String text) async {
    await _repo.addJournal(text);
    await load(silent: true);
  }

  Future<void> nudge() async {
    final summary = _repo.today();
    final message = summary.warnings.isNotEmpty
        ? summary.warnings.first
        : 'You are on track. Remaining ${summary.remaining} kcal.';
    await _repo.notifyNow(title: 'AURA', body: message);
  }

  Future<bool> startLiveActivity() => AuraPlatform.startLiveActivity();

  Future<void> endLiveActivity() => AuraPlatform.endLiveActivity();

  Future<void> pinHomeWidget() => AuraPlatform.reloadWidgets();
}
