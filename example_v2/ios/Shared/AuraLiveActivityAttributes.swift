import ActivityKit
import Foundation

struct AuraLiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var remaining: Int
    var eaten: Int
    var burned: Int
    var waterMl: Int
    var goal: Int
    var warning: String
  }

  var title: String
}
