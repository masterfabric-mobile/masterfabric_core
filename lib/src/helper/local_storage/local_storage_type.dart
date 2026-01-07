/// LocalStorageType enum for selecting storage backend
enum LocalStorageType {
  /// SharedPreferences storage (default)
  sharedPreferences,

  /// HiveCE storage
  hiveCe;

  /// Convert string to LocalStorageType enum
  static LocalStorageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sharedpreferences':
      case 'shared_preferences':
        return LocalStorageType.sharedPreferences;
      case 'hivece':
      case 'hive_ce':
        return LocalStorageType.hiveCe;
      default:
        return LocalStorageType.sharedPreferences;
    }
  }

  /// Convert LocalStorageType enum to string
  String toJson() {
    switch (this) {
      case LocalStorageType.sharedPreferences:
        return 'sharedPreferences';
      case LocalStorageType.hiveCe:
        return 'hiveCe';
    }
  }
}

