import Foundation
import WatchConnectivity

#if os(iOS)
/// Pushes AuraSnapshot to the paired Apple Watch via WatchConnectivity.
final class AuraWatchSync: NSObject, WCSessionDelegate {
  static let shared = AuraWatchSync()

  func activate() {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  func push(_ snap: AuraSnapshot) {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    guard session.activationState == .activated else { return }
    guard let data = try? JSONEncoder().encode(snap) else { return }
    try? session.updateApplicationContext(["aura_snapshot": data])
    if session.isReachable {
      session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
    }
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {}

  func sessionDidBecomeInactive(_ session: WCSession) {}
  func sessionDidDeactivate(_ session: WCSession) {
    session.activate()
  }
}
#endif

#if os(watchOS)
final class AuraWatchReceiver: NSObject, WCSessionDelegate {
  static let shared = AuraWatchReceiver()
  var onUpdate: ((AuraSnapshot) -> Void)?

  func activate() {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    if let data = session.receivedApplicationContext["aura_snapshot"] as? Data,
       let snap = try? JSONDecoder().decode(AuraSnapshot.self, from: data) {
      snap.save()
      onUpdate?(snap)
    }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
    if let data = applicationContext["aura_snapshot"] as? Data,
       let snap = try? JSONDecoder().decode(AuraSnapshot.self, from: data) {
      snap.save()
      DispatchQueue.main.async { self.onUpdate?(snap) }
    }
  }

  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    if let snap = try? JSONDecoder().decode(AuraSnapshot.self, from: messageData) {
      snap.save()
      DispatchQueue.main.async { self.onUpdate?(snap) }
    }
  }
}
#endif
