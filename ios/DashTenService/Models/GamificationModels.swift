import Foundation

nonisolated struct AchievementBadge: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let category: BadgeCategory
    let requirement: BadgeRequirement
    var isUnlocked: Bool
    var unlockedDate: Date?

    init(id: String, title: String, subtitle: String, icon: String, category: BadgeCategory, requirement: BadgeRequirement) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.category = category
        self.requirement = requirement
        self.isUnlocked = false
        self.unlockedDate = nil
    }
}

nonisolated enum BadgeCategory: String, Codable, CaseIterable, Sendable {
    case getting_started = "Getting Started"
    case financial = "Financial"
    case career = "Career"
    case wellness = "Wellness"
    case milestones = "Milestones"
    case streak = "Streak"
}

nonisolated enum BadgeRequirement: Codable, Sendable {
    case firstToolUsed
    case completedOnboarding
    case firstChecklistComplete
    case resumeStarted
    case budgetBuilt
    case emergencyFundCalculated
    case compensationCompared
    case interviewPrepDone
    case networkingStarted
    case tenContactsReached
    case journalStreak3
    case journalStreak7
    case journalStreak30
    case weeklyCheckIn3
    case allDocsCollected
    case readiness25
    case readiness50
    case readiness75
    case readiness100
    case fiveToolsUsed
    case tenToolsUsed
    case goalCompleted
    case threeGoalsCompleted
    case pitchCrafted
    case offerCompared
    case brandAudited
    case ninetyDayPlanCreated
    case decisionMade
    case challengeCompleted
}

nonisolated struct TransitionLevel: Codable, Sendable {
    var currentXP: Int
    var totalXPEarned: Int

    init() {
        self.currentXP = 0
        self.totalXPEarned = 0
    }

    var level: Int {
        let thresholds = [0, 50, 150, 300, 500, 800, 1200, 1700, 2400, 3200]
        for (index, threshold) in thresholds.enumerated().reversed() {
            if totalXPEarned >= threshold { return index + 1 }
        }
        return 1
    }

    var levelTitle: String {
        switch level {
        case 1: return "Recruit"
        case 2: return "Explorer"
        case 3: return "Planner"
        case 4: return "Strategist"
        case 5: return "Executor"
        case 6: return "Trailblazer"
        case 7: return "Pathfinder"
        case 8: return "Navigator"
        case 9: return "Commander"
        case 10: return "Launched"
        default: return "Launched"
        }
    }

    var xpForCurrentLevel: Int {
        let thresholds = [0, 50, 150, 300, 500, 800, 1200, 1700, 2400, 3200]
        let idx = min(level - 1, thresholds.count - 1)
        return thresholds[idx]
    }

    var xpForNextLevel: Int {
        let thresholds = [0, 50, 150, 300, 500, 800, 1200, 1700, 2400, 3200]
        let idx = min(level, thresholds.count - 1)
        return thresholds[idx]
    }

    var progressToNextLevel: Double {
        if level >= 10 { return 1.0 }
        let current = totalXPEarned - xpForCurrentLevel
        let needed = xpForNextLevel - xpForCurrentLevel
        guard needed > 0 else { return 1.0 }
        return Double(current) / Double(needed)
    }
}

nonisolated struct WeeklyChallenge: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let xpReward: Int
    let requirement: ChallengeRequirement
    var isCompleted: Bool
    let weekStartDate: Date

    init(title: String, description: String, icon: String, xpReward: Int, requirement: ChallengeRequirement, weekStartDate: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.icon = icon
        self.xpReward = xpReward
        self.requirement = requirement
        self.isCompleted = false
        self.weekStartDate = weekStartDate
    }
}

nonisolated enum ChallengeRequirement: Codable, Sendable {
    case completeChecklist(count: Int)
    case journalEntries(count: Int)
    case useTools(count: Int)
    case networkContacts(count: Int)
    case weeklyCheckIn
    case practiceInterview
    case updateBudget
}

nonisolated struct DailyPowerUp: Codable, Sendable {
    let quote: String
    let author: String
    let actionTitle: String
    let actionRoute: String
}

nonisolated struct ElevatorPitch: Codable, Identifiable, Sendable {
    let id: String
    var background: String
    var targetRole: String
    var valueProps: [String]
    var pitch30: String
    var pitch60: String
    var pitch90: String
    var lastEdited: Date

    init() {
        self.id = UUID().uuidString
        self.background = ""
        self.targetRole = ""
        self.valueProps = []
        self.pitch30 = ""
        self.pitch60 = ""
        self.pitch90 = ""
        self.lastEdited = Date()
    }
}

nonisolated struct JobOffer: Codable, Identifiable, Sendable {
    let id: String
    var companyName: String
    var roleTitle: String
    var baseSalary: Double
    var signingBonus: Double
    var annualBonus: Double
    var retirementMatch: Double
    var ptoWeeks: Double
    var healthInsuranceCost: Double
    var commuteMinutes: Int
    var remotePercentage: Int
    var growthRating: Int
    var overallNotes: String

    init() {
        self.id = UUID().uuidString
        self.companyName = ""
        self.roleTitle = ""
        self.baseSalary = 0
        self.signingBonus = 0
        self.annualBonus = 0
        self.retirementMatch = 0
        self.ptoWeeks = 2
        self.healthInsuranceCost = 0
        self.commuteMinutes = 0
        self.remotePercentage = 0
        self.growthRating = 3
        self.overallNotes = ""
    }

    var totalCompensation: Double {
        baseSalary + annualBonus + (retirementMatch / 100.0 * baseSalary) - (healthInsuranceCost * 12)
    }
}

nonisolated struct DecisionOption: Codable, Identifiable, Sendable {
    let id: String
    var name: String
    var scores: [Double]

    init(name: String, criteriaCount: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.scores = Array(repeating: 5.0, count: criteriaCount)
    }
}

nonisolated struct DecisionMatrix: Codable, Identifiable, Sendable {
    let id: String
    var title: String
    var criteria: [String]
    var weights: [Double]
    var options: [DecisionOption]
    var createdAt: Date

    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
        self.criteria = ["Cost", "Location", "Growth"]
        self.weights = [1.0, 1.0, 1.0]
        self.options = []
        self.createdAt = Date()
    }
}

nonisolated struct NinetyDayPlan: Codable, Identifiable, Sendable {
    let id: String
    var weeks: [NinetyDayWeek]
    var createdAt: Date

    init() {
        self.id = UUID().uuidString
        self.weeks = (1...12).map { NinetyDayWeek(weekNumber: $0) }
        self.createdAt = Date()
    }
}

nonisolated struct NinetyDayWeek: Codable, Identifiable, Sendable {
    let id: String
    let weekNumber: Int
    var goals: [String]
    var peopleToMeet: [String]
    var wins: [String]

    init(weekNumber: Int) {
        self.id = UUID().uuidString
        self.weekNumber = weekNumber
        self.goals = []
        self.peopleToMeet = []
        self.wins = []
    }
}

nonisolated struct BrandAuditResult: Codable, Sendable {
    var linkedInComplete: Bool
    var resumeReady: Bool
    var onlinePresenceClean: Bool
    var networkingActive: Bool
    var elevatorPitchReady: Bool
    var professionalEmail: Bool
    var portfolioExists: Bool
    var endorsementsCollected: Bool

    init() {
        self.linkedInComplete = false
        self.resumeReady = false
        self.onlinePresenceClean = false
        self.networkingActive = false
        self.elevatorPitchReady = false
        self.professionalEmail = false
        self.portfolioExists = false
        self.endorsementsCollected = false
    }

    var score: Int {
        let items: [Bool] = [linkedInComplete, resumeReady, onlinePresenceClean, networkingActive, elevatorPitchReady, professionalEmail, portfolioExists, endorsementsCollected]
        return items.filter { $0 }.count
    }

    var totalItems: Int { 8 }

    var percentage: Int {
        Int(Double(score) / Double(totalItems) * 100)
    }
}

nonisolated struct BenefitDeadline: Codable, Identifiable, Sendable {
    let id: String
    var title: String
    var deadline: Date
    var notes: String
    var isCompleted: Bool

    init(title: String, deadline: Date, notes: String = "") {
        self.id = UUID().uuidString
        self.title = title
        self.deadline = deadline
        self.notes = notes
        self.isCompleted = false
    }
}

nonisolated struct NetworkingEvent: Codable, Identifiable, Sendable {
    let id: String
    var eventName: String
    var eventDate: Date
    var pitch: String
    var questionsToAsk: [String]
    var contactsLogged: [String]
    var followUpActions: [String]
    var isCompleted: Bool

    init(eventName: String, eventDate: Date) {
        self.id = UUID().uuidString
        self.eventName = eventName
        self.eventDate = eventDate
        self.pitch = ""
        self.questionsToAsk = []
        self.contactsLogged = []
        self.followUpActions = []
        self.isCompleted = false
    }
}
