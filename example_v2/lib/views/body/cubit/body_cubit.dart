import 'dart:async';

import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../data/fitness_calculator.dart';
import '../../../data/fitness_repository.dart';
import '../../../data/models/body_profile.dart';
import 'body_state.dart';

class BodyCubit extends BaseViewModelCubit<BodyState> {
  BodyCubit(this._repo) : super(const BodyState()) {
    _sub = _repo.changes.listen((_) => load(silent: true));
  }

  final FitnessRepository _repo;
  StreamSubscription<void>? _sub;

  Future<void> load({bool silent = false}) async {
    if (!silent) stateChanger(state.copyWith(loading: true));
    await _repo.load();
    _emitFrom(_repo.profile);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  void preview(BodyProfile profile) {
    _emitFrom(profile);
  }

  Future<void> save(BodyProfile profile) async {
    await _repo.saveProfile(profile);
    await load(silent: true);
  }

  Future<void> setGoal(int? goalCalories) async {
    final next = _repo.profile.copyWith(
      goalCalories: goalCalories,
      clearGoalCalories: goalCalories == null,
    );
    await save(next);
  }

  Future<void> logWeight(double weightKg, {DateTime? at}) async {
    await _repo.addWeight(weightKg, at: at);
    await load(silent: true);
  }

  Future<void> removeWeight(String id) async {
    await _repo.removeWeight(id);
    await load(silent: true);
  }

  void _emitFrom(BodyProfile profile) {
    stateChanger(
      state.copyWith(
        loading: false,
        profile: profile,
        bmi: FitnessCalculator.bmi(profile),
        bmr: FitnessCalculator.bmr(profile),
        tdee: FitnessCalculator.tdee(profile),
        goal: FitnessCalculator.suggestedGoal(profile),
        weights: _repo.weights,
      ),
    );
  }
}
