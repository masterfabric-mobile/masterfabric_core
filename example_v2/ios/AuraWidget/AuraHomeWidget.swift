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
    Group {
      switch family {
      case .systemSmall:
        smallView(s)
      case .systemMedium:
        mediumView(s)
      case .systemLarge:
        largeTipView(s)
      default:
        mediumView(s)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .modifier(AuraWidgetBackground())
  }

  private func smallView(_ s: AuraSnapshot) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      AuraWordmark(height: 11)
      Text("\(s.remaining)")
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .minimumScaleFactor(0.6)
      Text("kcal left")
        .font(.system(size: 12, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
      Spacer(minLength: 0)
      ProgressView(value: s.progress)
        .tint(.primary)
    }
    .padding(14)
  }

  private func mediumView(_ s: AuraSnapshot) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      AuraWordmark(height: 12)
      Text("\(s.remaining)")
        .font(.system(size: 32, weight: .bold, design: .rounded))
        .minimumScaleFactor(0.6)
      Text("kcal left · goal \(s.goal)")
        .font(.system(size: 12, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
      ProgressView(value: s.progress)
        .tint(.primary)
      HStack {
        label("In", "\(s.eaten)")
        Spacer()
        label("Out", "\(s.burned)")
        Spacer()
        label("Water", "\(s.waterMl)")
      }
      .padding(.top, 2)
    }
    .padding(16)
  }

  /// Large tip surface — glance tip + remaining + quick-action chips.
  private func largeTipView(_ s: AuraSnapshot) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 4) {
          AuraWordmark(height: 13)
          Text("\(s.remaining)")
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .minimumScaleFactor(0.6)
          Text("kcal left · goal \(s.goal)")
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
        }
        Spacer(minLength: 8)
        Image(systemName: "circle.dotted")
          .font(.system(size: 36, weight: .light))
          .foregroundStyle(.secondary.opacity(0.45))
      }
      ProgressView(value: s.progress)
        .tint(.primary)

      Text("One glance, then move — log the next meal in under 20 seconds.")
        .font(.system(size: 14, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)

      HStack(spacing: 8) {
        chip("Food", systemImage: "fork.knife")
        chip("Water", systemImage: "drop")
        chip("Burn", systemImage: "flame")
      }
      .padding(.top, 2)

      HStack {
        label("In", "\(s.eaten)")
        Spacer()
        label("Out", "\(s.burned)")
        Spacer()
        label("Water", "\(s.waterMl)")
      }
    }
    .padding(18)
  }

  private func chip(_ title: String, systemImage: String) -> some View {
    HStack(spacing: 6) {
      Image(systemName: systemImage)
        .font(.system(size: 12, weight: .semibold))
      Text(title)
        .font(.system(size: 12, weight: .semibold, design: .rounded))
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity)
    .background(Color(white: 0.96))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
    .description("Remaining calories, tip glance, and quick actions.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}

/// Shared AURA wordmark for WidgetKit surfaces.
struct AuraWordmark: View {
  var height: CGFloat = 12

  var body: some View {
    Image("AuraWordmark")
      .resizable()
      .scaledToFit()
      .frame(height: height)
      .accessibilityLabel("AURA")
  }
}

private struct AuraWidgetBackground: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 17.0, *) {
      content.containerBackground(for: .widget) { Color.white }
    } else {
      content.background(Color.white)
    }
  }
}
