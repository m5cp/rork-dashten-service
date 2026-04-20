import ActivityKit
import Foundation

nonisolated struct TransitionCountdownAttributes: ActivityAttributes, Sendable {
    public nonisolated struct ContentState: Codable, Hashable, Sendable {
        var daysRemaining: Int
        var phaseLabel: String
        var focusTitle: String
    }

    var branch: String
    var separationDate: Date
}

@MainActor
final class LiveActivityService {
    static let shared = LiveActivityService()

    private init() {}

    var isSupported: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }

    func start(separationDate: Date, branch: String, focusTitle: String, phaseLabel: String) {
        guard isSupported else { return }
        end()
        let days = max(0, Calendar.current.dateComponents([.day], from: Date(), to: separationDate).day ?? 0)
        let attributes = TransitionCountdownAttributes(branch: branch, separationDate: separationDate)
        let state = TransitionCountdownAttributes.ContentState(
            daysRemaining: days,
            phaseLabel: phaseLabel,
            focusTitle: focusTitle
        )
        let content = ActivityContent(state: state, staleDate: Calendar.current.date(byAdding: .hour, value: 12, to: Date()))
        do {
            _ = try Activity<TransitionCountdownAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            #if DEBUG
            print("[LiveActivity] start failed: \(error)")
            #endif
        }
    }

    func update(daysRemaining: Int, phaseLabel: String, focusTitle: String) {
        Task {
            for activity in Activity<TransitionCountdownAttributes>.activities {
                let state = TransitionCountdownAttributes.ContentState(
                    daysRemaining: daysRemaining,
                    phaseLabel: phaseLabel,
                    focusTitle: focusTitle
                )
                await activity.update(ActivityContent(state: state, staleDate: nil))
            }
        }
    }

    func end() {
        Task {
            for activity in Activity<TransitionCountdownAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }

    var isActive: Bool {
        !Activity<TransitionCountdownAttributes>.activities.isEmpty
    }
}
