import Foundation

@Observable
@MainActor
class StorageService {
    private let userDefaultsKey = "dashten_data"

    var profile: UserProfile {
        didSet { save() }
    }
    var checklistItems: [ChecklistItem] {
        didSet { save() }
    }
    var documents: [DocumentItem] {
        didSet { save() }
    }
    var benefitCategories: [BenefitCategory] {
        didSet { save() }
    }
    var mentors: [MentorContact] {
        didSet { save() }
    }
    var lastAssessment: AssessmentResult? {
        didSet { save() }
    }
    var journalEntries: [JournalEntry] {
        didSet { save() }
    }
    var goals: [GoalItem] {
        didSet { save() }
    }
    var weeklyCheckIns: [WeeklyCheckInEntry] {
        didSet { save() }
    }
    var networkingWeeks: [NetworkingWeek] {
        didSet { save() }
    }
    var practicedQuestions: Set<String> {
        didSet { save() }
    }
    var badges: [AchievementBadge] {
        didSet { save() }
    }
    var transitionLevel: TransitionLevel {
        didSet { save() }
    }
    var weeklyChallenges: [WeeklyChallenge] {
        didSet { save() }
    }
    var toolsUsedIds: Set<String> {
        didSet { save() }
    }
    var elevatorPitch: ElevatorPitch? {
        didSet { save() }
    }
    var jobOffers: [JobOffer] {
        didSet { save() }
    }
    var decisionMatrices: [DecisionMatrix] {
        didSet { save() }
    }
    var ninetyDayPlan: NinetyDayPlan? {
        didSet { save() }
    }
    var brandAudit: BrandAuditResult {
        didSet { save() }
    }
    var benefitDeadlines: [BenefitDeadline] {
        didSet { save() }
    }
    var networkingEvents: [NetworkingEvent] {
        didSet { save() }
    }
    var lastDailyPowerUpDate: Date? {
        didSet { save() }
    }
    var lastActiveDate: Date? {
        didSet { save() }
    }
    var currentStreak: Int {
        didSet { save() }
    }
    var bestStreak: Int {
        didSet { save() }
    }
    var streakFreezesAvailable: Int {
        didSet { save() }
    }
    var celebratedStreakMilestones: Set<Int> {
        didSet { save() }
    }
    var sessionCount: Int {
        didSet { save() }
    }
    var lastSessionDate: Date? {
        didSet { save() }
    }
    var feedbackPromptShown: Bool {
        didSet { save() }
    }
    var reassessmentPromptDismissedAt: Date? {
        didSet { save() }
    }

    // Transient queue of badge IDs that were just unlocked and are waiting to be celebrated.
    // Not persisted — consumed by the celebration overlay.
    var pendingBadgeIds: [String] = []

    init() {
        let stored = StorageService.loadFromDisk()
        self.profile = stored.profile
        self.checklistItems = StorageService.migratedChecklist(stored.checklist)
        self.documents = stored.documents
        self.benefitCategories = stored.benefits
        self.mentors = stored.mentors
        self.lastAssessment = stored.lastAssessment
        self.journalEntries = stored.journalEntries ?? []
        self.goals = stored.goals ?? []
        self.weeklyCheckIns = stored.weeklyCheckIns ?? []
        self.networkingWeeks = stored.networkingWeeks ?? []
        self.practicedQuestions = Set(stored.practicedQuestions ?? [])
        // Merge stored badges with the canonical list — drops retired badges (e.g. challenge_done)
        // and adds any newly-introduced badges with their default locked state.
        let canonical = GamificationService.defaultBadges()
        let storedMap = Dictionary(uniqueKeysWithValues: (stored.badges ?? []).map { ($0.id, $0) })
        self.badges = canonical.map { def in
            if let existing = storedMap[def.id] {
                var merged = def
                merged.isUnlocked = existing.isUnlocked
                merged.unlockedDate = existing.unlockedDate
                return merged
            }
            return def
        }
        self.transitionLevel = stored.transitionLevel ?? TransitionLevel()
        self.weeklyChallenges = stored.weeklyChallenges ?? []
        self.toolsUsedIds = Set(stored.toolsUsedIds ?? [])
        self.elevatorPitch = stored.elevatorPitch
        self.jobOffers = stored.jobOffers ?? []
        self.decisionMatrices = stored.decisionMatrices ?? []
        self.ninetyDayPlan = stored.ninetyDayPlan
        self.brandAudit = stored.brandAudit ?? BrandAuditResult()
        self.benefitDeadlines = stored.benefitDeadlines ?? []
        self.networkingEvents = stored.networkingEvents ?? []
        self.lastDailyPowerUpDate = stored.lastDailyPowerUpDate
        self.lastActiveDate = stored.lastActiveDate
        self.currentStreak = stored.currentStreak ?? 0
        self.bestStreak = stored.bestStreak ?? 0
        self.streakFreezesAvailable = stored.streakFreezesAvailable ?? 1
        self.celebratedStreakMilestones = Set(stored.celebratedStreakMilestones ?? [])
        self.sessionCount = stored.sessionCount ?? 0
        self.lastSessionDate = stored.lastSessionDate
        self.feedbackPromptShown = stored.feedbackPromptShown ?? false
        self.reassessmentPromptDismissedAt = stored.reassessmentPromptDismissedAt
    }

    func toggleChecklistItem(_ id: String) {
        guard let index = checklistItems.firstIndex(where: { $0.id == id }) else { return }
        checklistItems[index].isCompleted.toggle()
        if checklistItems[index].isCompleted {
            _ = RetentionService.recordActivity(storage: self)
        }
        recomputeBadges()
    }

    func updateDocumentStatus(_ id: String, status: DocumentStatus) {
        guard let index = documents.firstIndex(where: { $0.id == id }) else { return }
        documents[index].status = status
        documents[index].dateUpdated = Date()
        recomputeBadges()
    }

    func toggleBenefitAction(categoryId: String, actionId: String) {
        guard let catIndex = benefitCategories.firstIndex(where: { $0.id == categoryId }),
              let actIndex = benefitCategories[catIndex].actionItems.firstIndex(where: { $0.id == actionId }) else { return }
        benefitCategories[catIndex].actionItems[actIndex].isCompleted.toggle()
        // Auto-start the benefit category whenever any action is checked
        if benefitCategories[catIndex].actionItems.contains(where: { $0.isCompleted }) {
            benefitCategories[catIndex].isStarted = true
        }
        if benefitCategories[catIndex].actionItems[actIndex].isCompleted {
            recomputeBadges()
        }
    }

    func toggleBenefitSaved(_ categoryId: String) {
        guard let index = benefitCategories.firstIndex(where: { $0.id == categoryId }) else { return }
        benefitCategories[index].isSaved.toggle()
    }

    func markBenefitStarted(_ categoryId: String) {
        guard let index = benefitCategories.firstIndex(where: { $0.id == categoryId }) else { return }
        benefitCategories[index].isStarted = true
    }

    func applyPostServiceStatus(_ status: PostServiceStatus) {
        profile.postServiceStatus = status
        let retireeIds = Set(TransitionDataService.retireeExtraItems().map { $0.id })
        let separatedIds = Set(TransitionDataService.separatedExtraItems().map { $0.id })
        // Remove items belonging to the other status to avoid stale entries
        switch status {
        case .retired:
            checklistItems.removeAll { separatedIds.contains($0.id) }
            let existing = Set(checklistItems.map { $0.id })
            for item in TransitionDataService.retireeExtraItems() where !existing.contains(item.id) {
                checklistItems.append(item)
            }
        case .separated:
            checklistItems.removeAll { retireeIds.contains($0.id) }
            let existing = Set(checklistItems.map { $0.id })
            for item in TransitionDataService.separatedExtraItems() where !existing.contains(item.id) {
                checklistItems.append(item)
            }
        }
        // Already separated/retired: auto-complete all pre-separation items so the
        // roadmap doesn't pretend they still have 24 months of pre-sep work ahead.
        // Users can uncheck anything they didn't actually finish.
        bulkMarkPreSeparationComplete()
    }

    func bulkMarkPreSeparationComplete() {
        let preSepPhases: Set<TimelinePhase> = Set(TimelinePhase.preSeparationPhases)
        for index in checklistItems.indices where preSepPhases.contains(checklistItems[index].phase) {
            if !checklistItems[index].isCompleted {
                checklistItems[index].isCompleted = true
            }
        }
    }

    func addCustomChecklistItem(title: String, phase: TimelinePhase, category: ReadinessCategory) {
        let item = ChecklistItem(title: title, subtitle: "", phase: phase, readinessCategory: category, isCustom: true)
        checklistItems.append(item)
    }

    func removeChecklistItem(_ id: String) {
        checklistItems.removeAll { $0.id == id && $0.isCustom }
    }

    func addMentor(_ mentor: MentorContact) {
        mentors.append(mentor)
    }

    func removeMentor(_ id: String) {
        mentors.removeAll { $0.id == id }
    }

    func updateMentorLastContact(_ id: String) {
        guard let index = mentors.firstIndex(where: { $0.id == id }) else { return }
        mentors[index].lastContactDate = Date()
    }

    func saveAssessment(_ result: AssessmentResult) {
        lastAssessment = result
    }

    func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.insert(entry, at: 0)
        _ = RetentionService.recordActivity(storage: self)
        recomputeBadges()
    }

    func addGoal(_ goal: GoalItem) {
        goals.append(goal)
    }

    func updateGoalProgress(_ id: String, progress: Double) {
        guard let index = goals.firstIndex(where: { $0.id == id }) else { return }
        goals[index].progress = min(max(progress, 0), 1.0)
        goals[index].isCompleted = progress >= 1.0
        if goals[index].isCompleted { recomputeBadges() }
    }

    func removeGoal(_ id: String) {
        goals.removeAll { $0.id == id }
    }

    func addCheckIn(_ entry: WeeklyCheckInEntry) {
        weeklyCheckIns.insert(entry, at: 0)
        _ = RetentionService.recordActivity(storage: self)
        recomputeBadges()
    }

    func addNetworkingWeek(_ week: NetworkingWeek) {
        networkingWeeks.insert(week, at: 0)
    }

    func updateNetworkingWeek(_ id: String, contacts: Int, followUps: Int, interviews: Int) {
        guard let index = networkingWeeks.firstIndex(where: { $0.id == id }) else { return }
        networkingWeeks[index].newContacts = contacts
        networkingWeeks[index].followUpsSent = followUps
        networkingWeeks[index].informationalInterviews = interviews
    }

    func togglePracticedQuestion(_ id: String) {
        if practicedQuestions.contains(id) {
            practicedQuestions.remove(id)
        } else {
            practicedQuestions.insert(id)
        }
    }

    func trackToolUsed(_ toolId: String) {
        toolsUsedIds.insert(toolId)
        _ = RetentionService.recordActivity(storage: self)
        recomputeBadges()
    }

    /// Legacy XP function — retained as a no-op for backward compatibility.
    /// XP and levels were removed; badges are now the sole reward system.
    func awardXP(_ amount: Int) { /* no-op */ }

    func unlockBadge(_ badgeId: String) {
        guard let index = badges.firstIndex(where: { $0.id == badgeId && !$0.isUnlocked }) else { return }
        badges[index].isUnlocked = true
        badges[index].unlockedDate = Date()
        pendingBadgeIds.append(badgeId)
    }

    /// Re-evaluate every badge against current state and unlock any whose requirement is now met.
    /// Newly unlocked badges are pushed onto `pendingBadgeIds` so the celebration overlay can show them.
    func recomputeBadges() {
        let readinessPct = ReadinessCalculator.calculate(
            checklist: checklistItems,
            documents: documents,
            benefits: benefitCategories
        ).overallPercent
        let journalStreak = journalConsecutiveDayCount()

        var unlocked: [String] = []
        for index in badges.indices where !badges[index].isUnlocked {
            if isRequirementMet(badges[index].requirement, readinessPct: readinessPct, journalStreak: journalStreak) {
                badges[index].isUnlocked = true
                badges[index].unlockedDate = Date()
                unlocked.append(badges[index].id)
            }
        }
        if !unlocked.isEmpty {
            pendingBadgeIds.append(contentsOf: unlocked)
        }
    }

    private func isRequirementMet(_ requirement: BadgeRequirement, readinessPct: Int, journalStreak: Int) -> Bool {
        switch requirement {
        case .firstToolUsed: return !toolsUsedIds.isEmpty
        case .completedOnboarding: return profile.hasCompletedOnboarding
        case .firstChecklistComplete: return checklistItems.contains(where: \.isCompleted)
        case .resumeStarted: return toolsUsedIds.contains("resume_translator")
        case .budgetBuilt: return toolsUsedIds.contains("civilian_budget")
        case .emergencyFundCalculated: return toolsUsedIds.contains("emergency_fund")
        case .compensationCompared: return toolsUsedIds.contains("military_comp")
        case .interviewPrepDone: return !practicedQuestions.isEmpty
        case .networkingStarted: return !mentors.isEmpty || !networkingWeeks.isEmpty
        case .tenContactsReached: return mentors.count >= 10
        case .journalStreak3: return journalStreak >= 3
        case .journalStreak7: return journalStreak >= 7
        case .journalStreak30: return journalStreak >= 30
        case .weeklyCheckIn3: return weeklyCheckIns.count >= 3
        case .allDocsCollected:
            return !documents.isEmpty && documents.allSatisfy { $0.status == .verified || $0.status == .received }
        case .readiness25: return readinessPct >= 25
        case .readiness50: return readinessPct >= 50
        case .readiness75: return readinessPct >= 75
        case .readiness100: return readinessPct >= 100
        case .fiveToolsUsed: return toolsUsedIds.count >= 5
        case .tenToolsUsed: return toolsUsedIds.count >= 10
        case .goalCompleted: return goals.contains(where: \.isCompleted)
        case .threeGoalsCompleted: return goals.filter(\.isCompleted).count >= 3
        case .pitchCrafted:
            guard let pitch = elevatorPitch else { return false }
            return !pitch.pitch30.isEmpty || !pitch.pitch60.isEmpty || !pitch.pitch90.isEmpty
        case .offerCompared: return jobOffers.count >= 2
        case .brandAudited: return brandAudit.score > 0
        case .ninetyDayPlanCreated: return ninetyDayPlan != nil
        case .decisionMade: return !decisionMatrices.isEmpty
        case .challengeCompleted: return false // retired
        }
    }

    private func journalConsecutiveDayCount() -> Int {
        guard !journalEntries.isEmpty else { return 0 }
        let calendar = Calendar.current
        let days = Set(journalEntries.map { calendar.startOfDay(for: $0.date) })
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var cursor = today
        // If the user hasn't journaled today, start from yesterday — same-day streak still counts if any entry exists.
        if !days.contains(cursor), let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) {
            cursor = yesterday
        }
        while days.contains(cursor) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return streak
    }

    func resetOnboarding() {
        profile = UserProfile()
        checklistItems = TransitionDataService.defaultChecklist()
        documents = TransitionDataService.defaultDocuments()
        benefitCategories = TransitionDataService.defaultBenefits()
        mentors = []
        lastAssessment = nil
        journalEntries = []
        goals = []
        weeklyCheckIns = []
        networkingWeeks = []
        practicedQuestions = []
        badges = GamificationService.defaultBadges()
        transitionLevel = TransitionLevel()
        weeklyChallenges = []
        toolsUsedIds = []
        elevatorPitch = nil
        jobOffers = []
        decisionMatrices = []
        ninetyDayPlan = nil
        brandAudit = BrandAuditResult()
        benefitDeadlines = []
        networkingEvents = []
        lastDailyPowerUpDate = nil
        lastActiveDate = nil
        currentStreak = 0
        bestStreak = 0
        streakFreezesAvailable = 1
        celebratedStreakMilestones = []
        sessionCount = 0
        lastSessionDate = nil
        feedbackPromptShown = false
        reassessmentPromptDismissedAt = nil
    }

    private func save() {
        let container = StorageContainer(
            profile: profile, checklist: checklistItems, documents: documents,
            benefits: benefitCategories, mentors: mentors, lastAssessment: lastAssessment,
            journalEntries: journalEntries, goals: goals, weeklyCheckIns: weeklyCheckIns,
            networkingWeeks: networkingWeeks, practicedQuestions: Array(practicedQuestions),
            badges: badges, transitionLevel: transitionLevel, weeklyChallenges: weeklyChallenges,
            toolsUsedIds: Array(toolsUsedIds), elevatorPitch: elevatorPitch, jobOffers: jobOffers,
            decisionMatrices: decisionMatrices, ninetyDayPlan: ninetyDayPlan, brandAudit: brandAudit,
            benefitDeadlines: benefitDeadlines, networkingEvents: networkingEvents,
            lastDailyPowerUpDate: lastDailyPowerUpDate,
            lastActiveDate: lastActiveDate,
            currentStreak: currentStreak,
            bestStreak: bestStreak,
            streakFreezesAvailable: streakFreezesAvailable,
            celebratedStreakMilestones: Array(celebratedStreakMilestones),
            sessionCount: sessionCount,
            lastSessionDate: lastSessionDate,
            feedbackPromptShown: feedbackPromptShown,
            reassessmentPromptDismissedAt: reassessmentPromptDismissedAt
        )
        guard let data = try? JSONEncoder().encode(container) else { return }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }

    private static func migratedChecklist(_ existing: [ChecklistItem]) -> [ChecklistItem] {
        var items = existing
        let existingIds = Set(items.map { $0.id })
        let postServiceSeeds: [ChecklistItem] =
            TransitionDataService.postServiceFirstThirtyItems()
            + TransitionDataService.postServiceFirstNinetyItems()
            + TransitionDataService.postServiceFirstYearItems()
            + TransitionDataService.postServiceYearTwoPlusItems()
        for seed in postServiceSeeds where !existingIds.contains(seed.id) {
            items.append(seed)
        }
        return items
    }

    private static func loadFromDisk() -> StorageContainer {
        guard let data = UserDefaults.standard.data(forKey: "dashten_data"),
              let container = try? JSONDecoder().decode(StorageContainer.self, from: data) else {
            return StorageContainer(
                profile: UserProfile(),
                checklist: TransitionDataService.defaultChecklist(),
                documents: TransitionDataService.defaultDocuments(),
                benefits: TransitionDataService.defaultBenefits(),
                mentors: [],
                lastAssessment: nil
            )
        }
        return container
    }
}

private nonisolated struct StorageContainer: Codable, Sendable {
    let profile: UserProfile
    let checklist: [ChecklistItem]
    let documents: [DocumentItem]
    let benefits: [BenefitCategory]
    let mentors: [MentorContact]
    let lastAssessment: AssessmentResult?
    let journalEntries: [JournalEntry]?
    let goals: [GoalItem]?
    let weeklyCheckIns: [WeeklyCheckInEntry]?
    let networkingWeeks: [NetworkingWeek]?
    let practicedQuestions: [String]?
    let badges: [AchievementBadge]?
    let transitionLevel: TransitionLevel?
    let weeklyChallenges: [WeeklyChallenge]?
    let toolsUsedIds: [String]?
    let elevatorPitch: ElevatorPitch?
    let jobOffers: [JobOffer]?
    let decisionMatrices: [DecisionMatrix]?
    let ninetyDayPlan: NinetyDayPlan?
    let brandAudit: BrandAuditResult?
    let benefitDeadlines: [BenefitDeadline]?
    let networkingEvents: [NetworkingEvent]?
    let lastDailyPowerUpDate: Date?
    let lastActiveDate: Date?
    let currentStreak: Int?
    let bestStreak: Int?
    let streakFreezesAvailable: Int?
    let celebratedStreakMilestones: [Int]?
    let sessionCount: Int?
    let lastSessionDate: Date?
    let feedbackPromptShown: Bool?
    let reassessmentPromptDismissedAt: Date?

    init(profile: UserProfile, checklist: [ChecklistItem], documents: [DocumentItem], benefits: [BenefitCategory], mentors: [MentorContact] = [], lastAssessment: AssessmentResult? = nil, journalEntries: [JournalEntry]? = nil, goals: [GoalItem]? = nil, weeklyCheckIns: [WeeklyCheckInEntry]? = nil, networkingWeeks: [NetworkingWeek]? = nil, practicedQuestions: [String]? = nil, badges: [AchievementBadge]? = nil, transitionLevel: TransitionLevel? = nil, weeklyChallenges: [WeeklyChallenge]? = nil, toolsUsedIds: [String]? = nil, elevatorPitch: ElevatorPitch? = nil, jobOffers: [JobOffer]? = nil, decisionMatrices: [DecisionMatrix]? = nil, ninetyDayPlan: NinetyDayPlan? = nil, brandAudit: BrandAuditResult? = nil, benefitDeadlines: [BenefitDeadline]? = nil, networkingEvents: [NetworkingEvent]? = nil, lastDailyPowerUpDate: Date? = nil, lastActiveDate: Date? = nil, currentStreak: Int? = nil, bestStreak: Int? = nil, streakFreezesAvailable: Int? = nil, celebratedStreakMilestones: [Int]? = nil, sessionCount: Int? = nil, lastSessionDate: Date? = nil, feedbackPromptShown: Bool? = nil, reassessmentPromptDismissedAt: Date? = nil) {
        self.profile = profile
        self.checklist = checklist
        self.documents = documents
        self.benefits = benefits
        self.mentors = mentors
        self.lastAssessment = lastAssessment
        self.journalEntries = journalEntries
        self.goals = goals
        self.weeklyCheckIns = weeklyCheckIns
        self.networkingWeeks = networkingWeeks
        self.practicedQuestions = practicedQuestions
        self.badges = badges
        self.transitionLevel = transitionLevel
        self.weeklyChallenges = weeklyChallenges
        self.toolsUsedIds = toolsUsedIds
        self.elevatorPitch = elevatorPitch
        self.jobOffers = jobOffers
        self.decisionMatrices = decisionMatrices
        self.ninetyDayPlan = ninetyDayPlan
        self.brandAudit = brandAudit
        self.benefitDeadlines = benefitDeadlines
        self.networkingEvents = networkingEvents
        self.lastDailyPowerUpDate = lastDailyPowerUpDate
        self.lastActiveDate = lastActiveDate
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.streakFreezesAvailable = streakFreezesAvailable
        self.celebratedStreakMilestones = celebratedStreakMilestones
        self.sessionCount = sessionCount
        self.lastSessionDate = lastSessionDate
        self.feedbackPromptShown = feedbackPromptShown
        self.reassessmentPromptDismissedAt = reassessmentPromptDismissedAt
    }
}
