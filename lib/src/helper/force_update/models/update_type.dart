/// Defines the type of update required
enum UpdateType {
  /// Force update - user must update to continue using the app
  force,

  /// Recommended update - strongly suggested but can be skipped
  recommended,

  /// Optional update - user can choose to update or skip
  optional,

  /// No update available
  none,
}

/// Extension for UpdateType serialization
extension UpdateTypeExtension on UpdateType {
  /// Convert to JSON string
  String toJson() {
    switch (this) {
      case UpdateType.force:
        return 'force';
      case UpdateType.recommended:
        return 'recommended';
      case UpdateType.optional:
        return 'optional';
      case UpdateType.none:
        return 'none';
    }
  }

  /// Create from JSON string
  static UpdateType fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'force':
        return UpdateType.force;
      case 'recommended':
        return UpdateType.recommended;
      case 'optional':
        return UpdateType.optional;
      default:
        return UpdateType.none;
    }
  }

  /// Check if this update type blocks app usage
  bool get isBlocking => this == UpdateType.force;

  /// Check if this update is dismissible
  bool get isDismissible => this != UpdateType.force;
}
