import Foundation

nonisolated struct WeeklySummary: Sendable {
    let missionsCompleted: Int
    let missionsTotal: Int
    let xpGained: Int
    let tasksCompleted: Int
    let journalEntries: Int
    let toolsUsed: Int
    let weekStart: Date
}

nonisolated enum RetentionMilestone: Int, Sendable, CaseIterable {
    case week = 7
    case month = 30
    case quarter = 90

    var title: String {
        switch self {
        case .week: return "7-Day Streak!"
        case .month: return "30-Day Commitment!"
        case .quarter: return "90 Days Strong!"
        }
    }

    var subtitle: String {
        switch self {
        case .week: return "You've shown up every day for a week. The hard part is starting — you're past it."
        case .month: return "A full month of steady progress. This is what readiness looks like."
        case .quarter: return "Three months in. You're not just preparing — you're transformed."
        }
    }

    var icon: String {
        switch self {
        case .week: return "flame.fill"
        case .month: return "star.circle.fill"
        case .quarter: return "trophy.fill"
        }
    }
}

@MainActor
enum RetentionService {
    /// Call when user takes any meaningful action. Updates streak with freeze logic.
    /// Returns the milestone reached (if any) so caller can show celebration.
    @discardableResult
    static func recordActivity(storage: StorageService) -> RetentionMilestone? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let last = storage.lastActiveDate.map({ calendar.startOfDay(for: $0) }) else {
            // First activity ever
            storage.lastActiveDate = today
            storage.currentStreak = 1
            storage.bestStreak = max(storage.bestStreak, 1)
            return checkMilestone(storage: storage)
        }

        if calendar.isDate(last, inSameDayAs: today) {
            return nil // already counted today
        }

        let daysBetween = calendar.dateComponents([.day], from: last, to: today).day ?? 0

        switch daysBetween {
        case 1:
            storage.currentStreak += 1
        case 2 where storage.streakFreezesAvailable > 0:
            // Use a freeze to bridge the missed day
            storage.streakFreezesAvailable -= 1
            storage.currentStreak += 1
        default:
            storage.currentStreak = 1
        }

        storage.lastActiveDate = today
        storage.bestStreak = max(storage.bestStreak, storage.currentStreak)

        // Earn a freeze every 7 days, max 2 stored
        if storage.currentStreak > 0 && storage.currentStreak % 7 == 0 {
            storage.streakFreezesAvailable = min(2, storage.streakFreezesAvailable + 1)
        }

        return checkMilestone(storage: storage)
    }

    private static func checkMilestone(storage: StorageService) -> RetentionMilestone? {
        for m in RetentionMilestone.allCases where storage.currentStreak >= m.rawValue {
            if !storage.celebratedStreakMilestones.contains(m.rawValue) {
                storage.celebratedStreakMilestones.insert(m.rawValue)
                AnalyticsService.shared.log(.milestoneReached, properties: ["streak": String(m.rawValue)])
                return m
            }
        }
        return nil
    }

    // MARK: - Session counting

    /// Bumps session count if a new calendar day. Returns true if feedback prompt should show.
    @discardableResult
    static func recordSession(storage: StorageService) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let last = storage.lastSessionDate.map({ calendar.startOfDay(for: $0) }),
           calendar.isDate(last, inSameDayAs: today) {
            return false
        }
        storage.lastSessionDate = today
        storage.sessionCount += 1
        return storage.sessionCount >= 3 && !storage.feedbackPromptShown
    }

    // MARK: - Weekly summary

    static func weeklySummary(storage: StorageService) -> WeeklySummary {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now

        let missionsCompleted = storage.weeklyChallenges
            .filter { $0.weekStartDate >= weekStart && $0.isCompleted }
            .count
        let missionsTotal = max(storage.weeklyChallenges
            .filter { $0.weekStartDate >= weekStart }
            .count, 3)

        let tasksCompleted = storage.checklistItems.filter { $0.isCompleted }.count
        let journalEntries = storage.journalEntries.filter { $0.date >= weekStart }.count
        let toolsUsed = storage.toolsUsedIds.count

        // Rough XP gained this week = missions completed + journals + tasks (approx)
        let xpGained = (missionsCompleted * 20) + (journalEntries * 10) + (tasksCompleted * 2)

        return WeeklySummary(
            missionsCompleted: missionsCompleted,
            missionsTotal: missionsTotal,
            xpGained: xpGained,
            tasksCompleted: tasksCompleted,
            journalEntries: journalEntries,
            toolsUsed: toolsUsed,
            weekStart: weekStart
        )
    }

    // MARK: - Monthly reassessment

    static func shouldPromptReassessment(storage: StorageService) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let referenceDate = storage.lastAssessment?.dateTaken ?? storage.profile.createdAt
        let days = calendar.dateComponents([.day], from: referenceDate, to: now).day ?? 0
        if days < 30 { return false }
        // Don't pester: only once every 30 days after last dismissal
        if let dismissed = storage.reassessmentPromptDismissedAt {
            let daysSince = calendar.dateComponents([.day], from: dismissed, to: now).day ?? 0
            if daysSince < 30 { return false }
        }
        return true
    }
}
