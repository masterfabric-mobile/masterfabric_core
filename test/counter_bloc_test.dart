import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

void main() {
  group('CounterBloc', () {
    late CounterBloc bloc;

    setUp(() {
      bloc = CounterBloc();
    });

    tearDown(() async {
      await bloc.close();
    });

    test('initial state is 0', () {
      expect(bloc.state.value, 0);
    });

    test('increment / decrement / reset', () async {
      bloc.add(const CounterIncremented());
      await expectLater(
        bloc.stream,
        emits(predicate<CounterState>((s) => s.value == 1)),
      );

      bloc.add(const CounterIncremented());
      await expectLater(
        bloc.stream,
        emits(predicate<CounterState>((s) => s.value == 2)),
      );

      bloc.add(const CounterDecremented());
      await expectLater(
        bloc.stream,
        emits(predicate<CounterState>((s) => s.value == 1)),
      );

      bloc.add(const CounterReset());
      await expectLater(
        bloc.stream,
        emits(predicate<CounterState>((s) => s.value == 0)),
      );
    });
  });
}
