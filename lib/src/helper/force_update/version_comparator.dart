/// Utility for comparing semantic versions
class VersionComparator {
  /// Parse a version string into components
  static VersionComponents parse(String version) {
    // Remove 'v' prefix if present
    final cleanVersion = version.toLowerCase().startsWith('v')
        ? version.substring(1)
        : version;

    // Split by '+' for build metadata
    final parts = cleanVersion.split('+');
    final versionPart = parts[0];
    final buildNumber = parts.length > 1 ? int.tryParse(parts[1]) : null;

    // Split by '-' for pre-release
    final preReleaseParts = versionPart.split('-');
    final mainVersion = preReleaseParts[0];
    final preRelease = preReleaseParts.length > 1 ? preReleaseParts[1] : null;

    // Parse major.minor.patch
    final versionNumbers = mainVersion.split('.');
    final major = int.tryParse(versionNumbers.isNotEmpty ? versionNumbers[0] : '0') ?? 0;
    final minor = int.tryParse(versionNumbers.length > 1 ? versionNumbers[1] : '0') ?? 0;
    final patch = int.tryParse(versionNumbers.length > 2 ? versionNumbers[2] : '0') ?? 0;

    return VersionComponents(
      major: major,
      minor: minor,
      patch: patch,
      preRelease: preRelease,
      buildNumber: buildNumber,
      original: version,
    );
  }

  /// Compare two version strings
  /// Returns:
  ///   - negative if v1 < v2
  ///   - zero if v1 == v2
  ///   - positive if v1 > v2
  static int compare(String v1, String v2) {
    final version1 = parse(v1);
    final version2 = parse(v2);
    return version1.compareTo(version2);
  }

  /// Check if v1 is older than v2
  static bool isOlderThan(String v1, String v2) {
    return compare(v1, v2) < 0;
  }

  /// Check if v1 is newer than v2
  static bool isNewerThan(String v1, String v2) {
    return compare(v1, v2) > 0;
  }

  /// Check if v1 equals v2
  static bool isEqual(String v1, String v2) {
    return compare(v1, v2) == 0;
  }

  /// Check if v1 is newer or equal to v2
  static bool isNewerOrEqual(String v1, String v2) {
    return compare(v1, v2) >= 0;
  }

  /// Check if v1 is older or equal to v2
  static bool isOlderOrEqual(String v1, String v2) {
    return compare(v1, v2) <= 0;
  }
}

/// Parsed version components
class VersionComponents implements Comparable<VersionComponents> {
  final int major;
  final int minor;
  final int patch;
  final String? preRelease;
  final int? buildNumber;
  final String original;

  const VersionComponents({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease,
    this.buildNumber,
    required this.original,
  });

  @override
  int compareTo(VersionComponents other) {
    // Compare major
    if (major != other.major) {
      return major.compareTo(other.major);
    }

    // Compare minor
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }

    // Compare patch
    if (patch != other.patch) {
      return patch.compareTo(other.patch);
    }

    // Pre-release versions are lower than release
    // e.g., 1.0.0-alpha < 1.0.0
    if (preRelease != null && other.preRelease == null) {
      return -1;
    }
    if (preRelease == null && other.preRelease != null) {
      return 1;
    }
    if (preRelease != null && other.preRelease != null) {
      final preReleaseComparison = preRelease!.compareTo(other.preRelease!);
      if (preReleaseComparison != 0) {
        return preReleaseComparison;
      }
    }

    // Compare build number if both present
    if (buildNumber != null && other.buildNumber != null) {
      return buildNumber!.compareTo(other.buildNumber!);
    }

    // If only one has build number, the one with build number is newer
    if (buildNumber != null && other.buildNumber == null) {
      return 1;
    }
    if (buildNumber == null && other.buildNumber != null) {
      return -1;
    }

    return 0;
  }

  @override
  String toString() {
    var result = '$major.$minor.$patch';
    if (preRelease != null) {
      result += '-$preRelease';
    }
    if (buildNumber != null) {
      result += '+$buildNumber';
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VersionComponents && compareTo(other) == 0;
  }

  @override
  int get hashCode => Object.hash(major, minor, patch, preRelease, buildNumber);
}
