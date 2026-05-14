import Foundation
import Observation

/// Single source of truth for paywall presentation.
///
/// Every screen that wants to surface the paywall calls `present(source:)`
/// instead of owning its own `@State` + `.sheet`. A single root-level sheet
/// in `ContentView` reads `isPresented` and renders `PaywallView` once.
///
/// This makes analytics consistent (we log the trigger source in one place),
/// prevents double-presentation bugs, and keeps the call sites tiny.
@Observable
@MainActor
final class PaywallCenter {
    var isPresented: Bool = false
    private(set) var lastSource: String = "unknown"

    func present(source: String) {
        lastSource = source
        AnalyticsService.shared.log(.featureUsed, properties: [
            "name": "paywall_trigger",
            "source": source
        ])
        isPresented = true
    }

    func dismiss() {
        isPresented = false
    }
}
