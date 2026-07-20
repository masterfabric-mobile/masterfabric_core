import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

/// 🔐 **Permissions State**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// State management for Permissions Cubit
///
/// {@category States}
/// {@subCategory PermissionsState}

/// 🔐 Permissions state class
class PermissionsState extends Equatable {
  final Map<Permission, bool> permissionStatuses;
  final bool isLoading;

  const PermissionsState({
    this.permissionStatuses = const {},
    this.isLoading = false,
  });

  /// Create a copy of this state with some fields changed
  PermissionsState copyWith({
    Map<Permission, bool>? permissionStatuses,
    bool? isLoading,
  }) {
    return PermissionsState(
      permissionStatuses: permissionStatuses ?? this.permissionStatuses,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [permissionStatuses, isLoading];

  @override
  String toString() {
    return 'PermissionsState('
        'isLoading: $isLoading, '
        'permissionCount: ${permissionStatuses.length}'
        ')';
  }
}
