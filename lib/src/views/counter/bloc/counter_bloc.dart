import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/src/base/base_view_model.dart';
import 'package:masterfabric_core/src/views/counter/bloc/counter_event.dart';
import 'package:masterfabric_core/src/views/counter/bloc/counter_state.dart';

/// Reference [Bloc] wired through GetIt for the [MasterView] path.
@injectable
class CounterBloc extends BaseViewModelBloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterStarted>(_onStarted);
    on<CounterIncremented>(_onIncremented);
    on<CounterDecremented>(_onDecremented);
    on<CounterReset>(_onReset);
  }

  void _onStarted(CounterStarted event, Emitter<CounterState> emit) {
    emit(state);
  }

  void _onIncremented(CounterIncremented event, Emitter<CounterState> emit) {
    emit(state.copyWith(value: state.value + 1));
  }

  void _onDecremented(CounterDecremented event, Emitter<CounterState> emit) {
    emit(state.copyWith(value: state.value - 1));
  }

  void _onReset(CounterReset event, Emitter<CounterState> emit) {
    emit(const CounterState());
  }
}
