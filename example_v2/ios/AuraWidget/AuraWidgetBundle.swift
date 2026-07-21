import WidgetKit
import SwiftUI

@main
struct AuraWidgetBundle: WidgetBundle {
  var body: some Widget {
    AuraHomeWidget()
    if #available(iOS 16.2, *) {
      AuraLiveActivityWidget()
    }
  }
}
