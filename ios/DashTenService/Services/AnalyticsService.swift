import Foundation

nonisolated enum AnalyticsEvent: String, Sendable {
    case appOpen = "app_open"
    case screenView = "screen_view"
    case onboardingStepViewed = "onboarding_step_viewed"
    case onboardingCompleted = "onboarding_completed"
    case paywallShown = "paywall_shown"
    case paywallDismissed = "paywall_dismissed"
    case paywallConverted = "paywall_converted"
    case featureUsed = "feature_used"
    case subscriptionStarted = "subscription_started"
    case subscriptionRestored = "subscription_restored"
    case crashReported = "crash_reported"
    case taskCompleted = "task_completed"
    case shareTapped = "share_tapped"
    case milestoneReached = "milestone_reached"
}

@MainActor
final class AnalyticsService {
    static let shared = AnalyticsService()

    private let queueKey = "dashten_analytics_queue"
    private let maxQueue = 500

    private init() {}

    func log(_ event: AnalyticsEvent, properties: [String: String] = [:]) {
        var record: [String: String] = [
            "event": event.rawValue,
            "ts": ISO8601DateFormatter().string(from: Date())
        ]
        for (k, v) in properties { record[k] = v }
        #if DEBUG
        print("[Analytics] \(event.rawValue) \(properties)")
        #endif
        var queue = UserDefaults.standard.array(forKey: queueKey) as? [[String: String]] ?? []
        queue.append(record)
        if queue.count > maxQueue { queue.removeFirst(queue.count - maxQueue) }
        UserDefaults.standard.set(queue, forKey: queueKey)
    }

    func recentEvents(limit: Int = 50) -> [[String: String]] {
        let queue = UserDefaults.standard.array(forKey: queueKey) as? [[String: String]] ?? []
        return Array(queue.suffix(limit))
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: queueKey)
    }
}
