import SwiftUI

@main
struct AuraWatchApp: App {
  var body: some Scene {
    WindowGroup {
      AuraWatchRoot()
    }
  }
}

struct AuraWatchRoot: View {
  @State private var snapshot = AuraSnapshot.load()
  @State private var timer: Timer?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 10) {
        Text("AURA")
          .font(.system(.caption2, design: .rounded).weight(.semibold))
          .foregroundStyle(.secondary)
        Text("\(snapshot.remaining)")
          .font(.system(size: 40, weight: .bold, design: .rounded))
        Text("kcal left")
          .font(.system(.caption, design: .rounded))
          .foregroundStyle(.secondary)
        ProgressView(value: snapshot.progress)
          .tint(.primary)
        HStack {
          metric("In", "\(snapshot.eaten)")
          Spacer()
          metric("Out", "\(snapshot.burned)")
          Spacer()
          metric("H2O", "\(snapshot.waterMl)")
        }
        .padding(.top, 6)
        if !snapshot.warning.isEmpty {
          Text(snapshot.warning)
            .font(.system(.caption2, design: .rounded))
            .foregroundStyle(.secondary)
            .padding(.top, 4)
        }
      }
      .padding()
    }
    .background(Color.white)
    .onAppear {
      AuraWatchReceiver.shared.activate()
      AuraWatchReceiver.shared.onUpdate = { snapshot = $0 }
      snapshot = AuraSnapshot.load()
      timer?.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
        snapshot = AuraSnapshot.load()
      }
    }
    .onDisappear { timer?.invalidate() }
  }

  private func metric(_ title: String, _ value: String) -> some View {
    VStack(spacing: 2) {
      Text(title)
        .font(.system(size: 10, weight: .semibold))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.system(.caption, design: .rounded).weight(.semibold))
    }
  }
}
