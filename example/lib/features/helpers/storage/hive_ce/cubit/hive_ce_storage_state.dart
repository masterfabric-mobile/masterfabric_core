import 'package:equatable/equatable.dart';

/// HiveCE Storage State
class HiveCeStorageState extends Equatable {
  final String? storedString;
  final int? storedInt;
  final bool? storedBool;
  final double? storedDouble;
  final List<String>? storedStringList;
  final Map<String, dynamic>? allItems;

  const HiveCeStorageState({
    this.storedString,
    this.storedInt,
    this.storedBool,
    this.storedDouble,
    this.storedStringList,
    this.allItems,
  });

  const HiveCeStorageState.initial()
      : storedString = null,
        storedInt = null,
        storedBool = null,
        storedDouble = null,
        storedStringList = null,
        allItems = null;

  HiveCeStorageState copyWith({
    String? storedString,
    int? storedInt,
    bool? storedBool,
    double? storedDouble,
    List<String>? storedStringList,
    Map<String, dynamic>? allItems,
  }) {
    return HiveCeStorageState(
      storedString: storedString ?? this.storedString,
      storedInt: storedInt ?? this.storedInt,
      storedBool: storedBool ?? this.storedBool,
      storedDouble: storedDouble ?? this.storedDouble,
      storedStringList: storedStringList ?? this.storedStringList,
      allItems: allItems ?? this.allItems,
    );
  }

  @override
  List<Object?> get props => [
        storedString,
        storedInt,
        storedBool,
        storedDouble,
        storedStringList,
        allItems,
      ];
}

