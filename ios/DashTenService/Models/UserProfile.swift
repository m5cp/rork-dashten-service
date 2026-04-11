import Foundation

nonisolated struct UserProfile: Codable, Sendable {
    var displayName: String
    var branch: MilitaryBranch?
    var timeline: TransitionTimeline?
    var separationDate: Date?
    var goals: [TransitionGoal]
    var hasCompletedOnboarding: Bool
    var hasAcceptedDisclaimer: Bool
    var householdSize: Int
    var spouseName: String
    var notificationsEnabled: Bool
    var createdAt: Date

    init() {
        displayName = ""
        branch = nil
        timeline = nil
        separationDate = nil
        goals = []
        hasCompletedOnboarding = false
        hasAcceptedDisclaimer = false
        householdSize = 1
        spouseName = ""
        notificationsEnabled = false
        createdAt = Date()
    }
}
