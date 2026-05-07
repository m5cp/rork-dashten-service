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
    var postServiceStatus: PostServiceStatus?

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
        postServiceStatus = nil
    }

    private enum CodingKeys: String, CodingKey {
        case displayName, branch, timeline, separationDate, goals
        case hasCompletedOnboarding, hasAcceptedDisclaimer
        case householdSize, spouseName, notificationsEnabled, createdAt
        case postServiceStatus
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try c.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        branch = try c.decodeIfPresent(MilitaryBranch.self, forKey: .branch)
        timeline = try c.decodeIfPresent(TransitionTimeline.self, forKey: .timeline)
        separationDate = try c.decodeIfPresent(Date.self, forKey: .separationDate)
        goals = try c.decodeIfPresent([TransitionGoal].self, forKey: .goals) ?? []
        hasCompletedOnboarding = try c.decodeIfPresent(Bool.self, forKey: .hasCompletedOnboarding) ?? false
        hasAcceptedDisclaimer = try c.decodeIfPresent(Bool.self, forKey: .hasAcceptedDisclaimer) ?? false
        householdSize = try c.decodeIfPresent(Int.self, forKey: .householdSize) ?? 1
        spouseName = try c.decodeIfPresent(String.self, forKey: .spouseName) ?? ""
        notificationsEnabled = try c.decodeIfPresent(Bool.self, forKey: .notificationsEnabled) ?? false
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        postServiceStatus = try c.decodeIfPresent(PostServiceStatus.self, forKey: .postServiceStatus)
    }
}
