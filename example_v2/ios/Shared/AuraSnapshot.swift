import Foundation

/// Shared calorie snapshot for Home Widget, Live Activity, and Watch.
struct AuraSnapshot: Codable, Hashable {
  var remaining: Int
  var goal: Int
  var eaten: Int
  var burned: Int
  var waterMl: Int
  var protein: Int
  var carbs: Int
  var fat: Int
  var warning: String
  var updatedAt: TimeInterval

  static let appGroupId = "group.com.masterfabric.aura"
  static let defaultsKey = "aura_snapshot_json"

  static var empty: AuraSnapshot {
    AuraSnapshot(
      remaining: 0,
      goal: 2000,
      eaten: 0,
      burned: 0,
      waterMl: 0,
      protein: 0,
      carbs: 0,
      fat: 0,
      warning: "",
      updatedAt: Date().timeIntervalSince1970
    )
  }

  var progress: Double {
    guard goal > 0 else { return 0 }
    return min(1.0, Double(eaten) / Double(goal))
  }

  static func load() -> AuraSnapshot {
    guard
      let defaults = UserDefaults(suiteName: appGroupId),
      let data = defaults.data(forKey: defaultsKey),
      let decoded = try? JSONDecoder().decode(AuraSnapshot.self, from: data)
    else {
      return .empty
    }
    return decoded
  }

  func save() {
    guard let defaults = UserDefaults(suiteName: Self.appGroupId) else { return }
    if let data = try? JSONEncoder().encode(self) {
      defaults.set(data, forKey: Self.defaultsKey)
    }
  }
}
