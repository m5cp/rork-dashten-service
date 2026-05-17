import Foundation
import SwiftUI

nonisolated enum ThemePreference: String, Codable, CaseIterable, Identifiable, Sendable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: "iphone"
        case .light: "sun.max.fill"
        case .dark: "moon.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

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
    var disabilityRating: Int
    var createdAt: Date
    var postServiceStatus: PostServiceStatus?
    var avatarPhotoData: Data?
    var avatarPresetId: String?
    var themePreference: ThemePreference
    var ninetyDayTemplate: String?
    /// Manual override for the Plan tab's current phase. When `nil`, the phase is auto-detected
    /// from `timeline`, `postServiceStatus`, and `separationDate`.
    var manualPhaseOverride: TimelinePhase?
    /// Tracks whether the one-time "have you already done early items?" check-in has been answered.
    var hasSeenEarlyItemsCheckIn: Bool

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
        disabilityRating = 0
        createdAt = Date()
        postServiceStatus = nil
        avatarPhotoData = nil
        avatarPresetId = nil
        themePreference = .system
        ninetyDayTemplate = nil
        manualPhaseOverride = nil
        hasSeenEarlyItemsCheckIn = false
    }

    private enum CodingKeys: String, CodingKey {
        case displayName, branch, timeline, separationDate, goals
        case hasCompletedOnboarding, hasAcceptedDisclaimer
        case householdSize, spouseName, notificationsEnabled, disabilityRating, createdAt
        case postServiceStatus
        case avatarPhotoData, avatarPresetId
        case themePreference
        case ninetyDayTemplate
        case manualPhaseOverride
        case hasSeenEarlyItemsCheckIn
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
        disabilityRating = try c.decodeIfPresent(Int.self, forKey: .disabilityRating) ?? 0
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        postServiceStatus = try c.decodeIfPresent(PostServiceStatus.self, forKey: .postServiceStatus)
        avatarPhotoData = try c.decodeIfPresent(Data.self, forKey: .avatarPhotoData)
        avatarPresetId = try c.decodeIfPresent(String.self, forKey: .avatarPresetId)
        themePreference = try c.decodeIfPresent(ThemePreference.self, forKey: .themePreference) ?? .system
        ninetyDayTemplate = try c.decodeIfPresent(String.self, forKey: .ninetyDayTemplate)
        manualPhaseOverride = try c.decodeIfPresent(TimelinePhase.self, forKey: .manualPhaseOverride)
        hasSeenEarlyItemsCheckIn = try c.decodeIfPresent(Bool.self, forKey: .hasSeenEarlyItemsCheckIn) ?? false
    }
}
