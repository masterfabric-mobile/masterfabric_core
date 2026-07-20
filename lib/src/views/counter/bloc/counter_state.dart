import 'package:equatable/equatable.dart';

/// State for the package [CounterBloc].
final class CounterState extends Equatable {
  const CounterState({this.value = 0});

  final int value;

  CounterState copyWith({int? value}) => CounterState(value: value ?? this.value);

  @override
  List<Object?> get props => [value];
}
