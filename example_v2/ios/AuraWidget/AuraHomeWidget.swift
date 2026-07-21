import WidgetKit
import SwiftUI

struct AuraHomeEntry: TimelineEntry {
  let date: Date
  let snapshot: AuraSnapshot
}

struct AuraHomeProvider: TimelineProvider {
  func placeholder(in context: Context) -> AuraHomeEntry {
    AuraHomeEntry(date: Date(), snapshot: .empty)
  }

  func getSnapshot(in context: Context, completion: @escaping (AuraHomeEntry) -> Void) {
    completion(AuraHomeEntry(date: Date(), snapshot: AuraSnapshot.load()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<AuraHomeEntry>) -> Void) {
    let entry = AuraHomeEntry(date: Date(), snapshot: AuraSnapshot.load())
    let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
    completion(Timeline(entries: [entry], policy: .after(next)))
  }
}

struct AuraHomeWidgetView: View {
  var entry: AuraHomeEntry
  @Environment(\.widgetFamily) var family

  var body: some View {
    let s = entry.snapshot
    VStack(alignment: .leading, spacing: 8) {
      Text("AURA")
        .font(.system(size: 11, weight: .semibold, design: .rounded))
        .foregroundStyle(.secondary)
      Text("\(s.remaining)")
        .font(.system(size: family == .systemSmall ? 28 : 36, weight: .bold, design: .rounded))
        .minimumScaleFactor(0.6)
      Text("kcal left · goal \(s.goal)")
        .font(.system(size: 12, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
      ProgressView(value: s.progress)
        .tint(.primary)
      if family != .systemSmall {
        HStack {
          label("In", "\(s.eaten)")
          Spacer()
          label("Out", "\(s.burned)")
          Spacer()
          label("Water", "\(s.waterMl)")
        }
        .padding(.top, 4)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding()
    .background(Color.white)
  }

  private func label(_ title: String, _ value: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title.uppercased())
        .font(.system(size: 9, weight: .semibold))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.system(size: 14, weight: .semibold, design: .rounded))
    }
  }
}

struct AuraHomeWidget: Widget {
  let kind = "AuraHomeWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: AuraHomeProvider()) { entry in
      AuraHomeWidgetView(entry: entry)
    }
    .configurationDisplayName("AURA Today")
    .description("Remaining calories, burn, and water at a glance.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
