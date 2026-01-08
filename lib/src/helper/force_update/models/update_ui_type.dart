/// Defines the UI style for displaying update prompts
enum UpdateUIType {
  /// Alert dialog style
  dialog,

  /// Bottom sheet modal style
  bottomSheet,

  /// Full screen blocking page
  fullScreen,
}

/// Extension for UpdateUIType
extension UpdateUITypeExtension on UpdateUIType {
  /// Convert to JSON string
  String toJson() {
    switch (this) {
      case UpdateUIType.dialog:
        return 'dialog';
      case UpdateUIType.bottomSheet:
        return 'bottomSheet';
      case UpdateUIType.fullScreen:
        return 'fullScreen';
    }
  }

  /// Create from JSON string
  static UpdateUIType fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'dialog':
        return UpdateUIType.dialog;
      case 'bottomsheet':
        return UpdateUIType.bottomSheet;
      case 'fullscreen':
        return UpdateUIType.fullScreen;
      default:
        return UpdateUIType.dialog;
    }
  }
}
