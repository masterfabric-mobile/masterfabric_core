import 'package:equatable/equatable.dart';

/// Account state class
class AccountState extends Equatable {
  final bool isLoading;
  final String? userName;
  final String? userEmail;
  final String? errorMessage;
  final String? navigationTarget;

  const AccountState({
    this.isLoading = false,
    this.userName,
    this.userEmail,
    this.errorMessage,
    this.navigationTarget,
  });

  /// Create a copy of this state with some fields changed.
  ///
  /// Pass [clearUser] / [clearError] / [clearNavigation] to set those fields
  /// back to null (plain `userName: null` cannot clear because of `??`).
  AccountState copyWith({
    bool? isLoading,
    String? userName,
    String? userEmail,
    String? errorMessage,
    String? navigationTarget,
    bool clearUser = false,
    bool clearError = false,
    bool clearNavigation = false,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      userName: clearUser ? null : (userName ?? this.userName),
      userEmail: clearUser ? null : (userEmail ?? this.userEmail),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      navigationTarget:
          clearNavigation ? null : (navigationTarget ?? this.navigationTarget),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        userName,
        userEmail,
        errorMessage,
        navigationTarget,
      ];

  @override
  String toString() {
    return 'AccountState('
        'isLoading: $isLoading, '
        'userName: $userName, '
        'userEmail: $userEmail'
        ')';
  }
}
