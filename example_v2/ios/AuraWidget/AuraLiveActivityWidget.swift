import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 16.2, *)
struct AuraLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: AuraLiveActivityAttributes.self) { context in
      LockScreenBanner(context: context)
        .widgetURL(AuraDeepLink.today)
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded — tap island to open this rich summary
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .leading, spacing: 2) {
            AuraWordmark(height: 10)
            Text(statusLine(context.state))
              .font(.system(size: 10, weight: .semibold, design: .rounded))
              .foregroundStyle(.primary.opacity(0.8))
              .lineLimit(1)
          }
          .padding(.leading, 2)
        }

        DynamicIslandExpandedRegion(.trailing) {
          Link(destination: AuraDeepLink.today) {
            ZStack {
              Circle()
                .fill(Color.primary)
                .frame(width: 36, height: 36)
              Image(systemName: "arrow.up.forward.app.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(uiColor: .systemBackground))
            }
          }
          .accessibilityLabel("Open AURA")
        }

        DynamicIslandExpandedRegion(.center) {
          VStack(spacing: 4) {
            Text("\(context.state.remaining)")
              .font(.system(size: 28, weight: .bold, design: .rounded))
              .monospacedDigit()
              .minimumScaleFactor(0.7)
            Text("kcal remaining · goal \(context.state.goal)")
              .font(.system(size: 11, weight: .medium, design: .rounded))
              .foregroundStyle(.secondary)
            ProgressView(value: progress(context.state))
              .tint(.primary)
              .padding(.horizontal, 8)
          }
          .padding(.vertical, 2)
        }

        DynamicIslandExpandedRegion(.bottom) {
          VStack(spacing: 10) {
            HStack(spacing: 0) {
              summaryChip(title: "IN", value: "\(context.state.eaten)")
              Spacer()
              summaryChip(title: "OUT", value: "\(context.state.burned)")
              Spacer()
              summaryChip(title: "H₂O", value: "\(context.state.waterMl)")
            }

            if !context.state.warning.isEmpty {
              Text(context.state.warning)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 8) {
              deepLinkButton(
                title: "Today",
                systemImage: "sun.max.fill",
                url: AuraDeepLink.today
              )
              deepLinkButton(
                title: "Log",
                systemImage: "square.and.pencil",
                url: AuraDeepLink.log
              )
              deepLinkButton(
                title: "Coach",
                systemImage: "bubble.left.fill",
                url: AuraDeepLink.coach
              )
            }
          }
          .padding(.top, 2)
        }
      } compactLeading: {
        // Compact left — brand mark
        Image(systemName: "flame.fill")
          .font(.system(size: 12, weight: .bold))
          .foregroundStyle(.primary)
      } compactTrailing: {
        // Compact right — remaining kcal
        Text(compactRemaining(context.state.remaining))
          .font(.system(size: 12, weight: .bold, design: .rounded))
          .monospacedDigit()
          .foregroundStyle(.primary)
      } minimal: {
        Image(systemName: "flame.fill")
          .font(.system(size: 11, weight: .bold))
      }
      .widgetURL(AuraDeepLink.today)
    }
  }

  private func progress(_ state: AuraLiveActivityAttributes.ContentState) -> Double {
    guard state.goal > 0 else { return 0 }
    return min(1, Double(state.eaten) / Double(state.goal))
  }

  private func statusLine(_ state: AuraLiveActivityAttributes.ContentState) -> String {
    if !state.warning.isEmpty { return "Needs attention" }
    let p = progress(state)
    if p < 0.35 { return "Fuel up" }
    if p > 1.0 { return "Over goal" }
    return "On track"
  }

  private func compactRemaining(_ value: Int) -> String {
    if value >= 1000 { return "\(value / 1000)k" }
    return "\(max(0, value))"
  }

  private func summaryChip(title: String, value: String) -> some View {
    VStack(spacing: 2) {
      Text(title)
        .font(.system(size: 9, weight: .bold, design: .rounded))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.system(size: 14, weight: .semibold, design: .rounded))
        .monospacedDigit()
    }
    .frame(minWidth: 52)
  }

  private func deepLinkButton(title: String, systemImage: String, url: URL) -> some View {
    Link(destination: url) {
      HStack(spacing: 5) {
        Image(systemName: systemImage)
          .font(.system(size: 11, weight: .semibold))
        Text(title)
          .font(.system(size: 12, weight: .semibold, design: .rounded))
      }
      .foregroundStyle(.primary)
      .padding(.horizontal, 10)
      .padding(.vertical, 7)
      .background(
        Capsule(style: .continuous)
          .fill(Color.primary.opacity(0.12))
      )
    }
  }
}

@available(iOS 16.2, *)
private struct LockScreenBanner: View {
  let context: ActivityViewContext<AuraLiveActivityAttributes>

  var body: some View {
    HStack(spacing: 14) {
      VStack(alignment: .leading, spacing: 4) {
        AuraWordmark(height: 12)
        Text("\(context.state.remaining) kcal left")
          .font(.system(size: 22, weight: .bold, design: .rounded))
          .monospacedDigit()
        Text("In \(context.state.eaten) · Out \(context.state.burned) · \(context.state.waterMl) ml")
          .font(.system(size: 12, weight: .medium, design: .rounded))
          .foregroundStyle(.secondary)
        if !context.state.warning.isEmpty {
          Text(context.state.warning)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }
      }
      Spacer(minLength: 8)
      VStack(spacing: 8) {
        ProgressView(
          value: context.state.goal > 0
            ? min(1, Double(context.state.eaten) / Double(context.state.goal))
            : 0
        )
        .progressViewStyle(.circular)
        .tint(.primary)
        .frame(width: 34, height: 34)

        Link(destination: AuraDeepLink.today) {
          Image(systemName: "arrow.up.forward.app.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color(uiColor: .systemBackground))
            .frame(width: 34, height: 34)
            .background(Circle().fill(Color.primary))
        }
        .accessibilityLabel("Open AURA for details")
      }
    }
    .padding(16)
    .activityBackgroundTint(Color.white)
    .activitySystemActionForegroundColor(Color.black)
  }
}

enum AuraDeepLink {
  static let today = URL(string: "aura://today")!
  static let log = URL(string: "aura://log")!
  static let coach = URL(string: "aura://coach")!
}
