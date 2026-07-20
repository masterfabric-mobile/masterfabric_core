import 'package:equatable/equatable.dart';

/// 🔍 **Search State**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// State management for Search Cubit
///
/// {@category States}
/// {@subCategory SearchState}

/// 🔍 Search state class
class SearchState extends Equatable {
  final String query;
  final List<dynamic> results;
  final bool isLoading;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  /// Create a copy of this state with some fields changed
  SearchState copyWith({
    String? query,
    List<dynamic>? results,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [query, results, isLoading, errorMessage];

  @override
  String toString() {
    return 'SearchState('
        'query: $query, '
        'resultsCount: ${results.length}, '
        'isLoading: $isLoading'
        ')';
  }
}
