import 'package:equatable/equatable.dart';

/// HiveCE Storage State
class HiveCeStorageState extends Equatable {
  final String? storedString;
  final int? storedInt;
  final bool? storedBool;
  final double? storedDouble;
  final List<String>? storedStringList;
  final Map<String, dynamic>? allItems;
  final dynamic retrievedValue;
  final String? retrievedKey;

  const HiveCeStorageState({
    this.storedString,
    this.storedInt,
    this.storedBool,
    this.storedDouble,
    this.storedStringList,
    this.allItems,
    this.retrievedValue,
    this.retrievedKey,
  });

  const HiveCeStorageState.initial()
      : storedString = null,
        storedInt = null,
        storedBool = null,
        storedDouble = null,
        storedStringList = null,
        allItems = null,
        retrievedValue = null,
        retrievedKey = null;

  HiveCeStorageState copyWith({
    String? storedString,
    int? storedInt,
    bool? storedBool,
    double? storedDouble,
    List<String>? storedStringList,
    Map<String, dynamic>? allItems,
    dynamic retrievedValue,
    String? retrievedKey,
  }) {
    return HiveCeStorageState(
      storedString: storedString ?? this.storedString,
      storedInt: storedInt ?? this.storedInt,
      storedBool: storedBool ?? this.storedBool,
      storedDouble: storedDouble ?? this.storedDouble,
      storedStringList: storedStringList ?? this.storedStringList,
      allItems: allItems ?? this.allItems,
      retrievedValue: retrievedValue ?? this.retrievedValue,
      retrievedKey: retrievedKey ?? this.retrievedKey,
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
        retrievedValue,
        retrievedKey,
      ];
}

