import Foundation

enum GamificationService {
    static func defaultBadges() -> [AchievementBadge] {
        [
            AchievementBadge(id: "first_tool", title: "First Steps", subtitle: "Used your first tool", icon: "wrench.and.screwdriver.fill", category: .getting_started, requirement: .firstToolUsed),
            AchievementBadge(id: "onboarding_done", title: "Mission Briefing", subtitle: "Completed onboarding", icon: "checkmark.circle.fill", category: .getting_started, requirement: .completedOnboarding),
            AchievementBadge(id: "first_checklist", title: "First Win", subtitle: "Completed first checklist item", icon: "checkmark.seal.fill", category: .getting_started, requirement: .firstChecklistComplete),
            AchievementBadge(id: "resume_started", title: "Resume Ready", subtitle: "Started the Resume Translator", icon: "doc.text.fill", category: .career, requirement: .resumeStarted),
            AchievementBadge(id: "budget_built", title: "Budget Master", subtitle: "Built your civilian budget", icon: "creditcard.fill", category: .financial, requirement: .budgetBuilt),
            AchievementBadge(id: "emergency_calc", title: "Safety Net", subtitle: "Calculated your emergency fund", icon: "shield.lefthalf.filled", category: .financial, requirement: .emergencyFundCalculated),
            AchievementBadge(id: "comp_compared", title: "Pay Intel", subtitle: "Compared compensation packages", icon: "equal.circle.fill", category: .financial, requirement: .compensationCompared),
            AchievementBadge(id: "interview_prep", title: "Interview Sharp", subtitle: "Practiced interview questions", icon: "person.fill.questionmark", category: .career, requirement: .interviewPrepDone),
            AchievementBadge(id: "networking_start", title: "Network Builder", subtitle: "Started networking tracking", icon: "person.3.fill", category: .career, requirement: .networkingStarted),
            AchievementBadge(id: "ten_contacts", title: "Connected", subtitle: "Logged 10+ networking contacts", icon: "person.3.sequence.fill", category: .career, requirement: .tenContactsReached),
            AchievementBadge(id: "journal_3", title: "Reflector", subtitle: "3-day journal streak", icon: "book.fill", category: .streak, requirement: .journalStreak3),
            AchievementBadge(id: "journal_7", title: "Deep Thinker", subtitle: "7-day journal streak", icon: "brain.fill", category: .streak, requirement: .journalStreak7),
            AchievementBadge(id: "journal_30", title: "Chronicler", subtitle: "30-day journal streak", icon: "flame.fill", category: .streak, requirement: .journalStreak30),
            AchievementBadge(id: "checkin_3", title: "Self-Aware", subtitle: "3 weekly check-ins", icon: "chart.xyaxis.line", category: .wellness, requirement: .weeklyCheckIn3),
            AchievementBadge(id: "docs_done", title: "Paper Trail", subtitle: "All documents collected", icon: "doc.on.doc.fill", category: .milestones, requirement: .allDocsCollected),
            AchievementBadge(id: "ready_25", title: "Quarter Ready", subtitle: "25% transition readiness", icon: "circle.lefthalf.filled", category: .milestones, requirement: .readiness25),
            AchievementBadge(id: "ready_50", title: "Halfway There", subtitle: "50% transition readiness", icon: "circle.bottomhalf.filled", category: .milestones, requirement: .readiness50),
            AchievementBadge(id: "ready_75", title: "Almost There", subtitle: "75% transition readiness", icon: "circle.dashed.inset.filled", category: .milestones, requirement: .readiness75),
            AchievementBadge(id: "ready_100", title: "Fully Prepared", subtitle: "100% transition readiness", icon: "checkmark.circle.fill", category: .milestones, requirement: .readiness100),
            AchievementBadge(id: "five_tools", title: "Toolsmith", subtitle: "Used 5 different tools", icon: "hammer.fill", category: .getting_started, requirement: .fiveToolsUsed),
            AchievementBadge(id: "ten_tools", title: "Power User", subtitle: "Used 10 different tools", icon: "gearshape.2.fill", category: .getting_started, requirement: .tenToolsUsed),
            AchievementBadge(id: "goal_done", title: "Goal Getter", subtitle: "Completed a goal", icon: "target", category: .milestones, requirement: .goalCompleted),
            AchievementBadge(id: "three_goals", title: "Achiever", subtitle: "Completed 3 goals", icon: "trophy.fill", category: .milestones, requirement: .threeGoalsCompleted),
            AchievementBadge(id: "pitch_crafted", title: "Pitch Perfect", subtitle: "Crafted your elevator pitch", icon: "mic.fill", category: .career, requirement: .pitchCrafted),
            AchievementBadge(id: "offer_compared", title: "Smart Shopper", subtitle: "Compared job offers", icon: "scalemass.fill", category: .career, requirement: .offerCompared),
            AchievementBadge(id: "brand_audited", title: "Brand Builder", subtitle: "Completed personal brand audit", icon: "person.crop.circle.badge.checkmark", category: .career, requirement: .brandAudited),
            AchievementBadge(id: "ninety_plan", title: "Strategist", subtitle: "Created your 90-day plan", icon: "calendar.badge.clock", category: .milestones, requirement: .ninetyDayPlanCreated),
            AchievementBadge(id: "decision_made", title: "Decisive", subtitle: "Used the Decision Matrix", icon: "square.grid.3x3.fill", category: .getting_started, requirement: .decisionMade),
            AchievementBadge(id: "challenge_done", title: "Challenger", subtitle: "Completed a weekly challenge", icon: "bolt.fill", category: .streak, requirement: .challengeCompleted),
        ]
    }

    static func dailyPowerUps() -> [DailyPowerUp] {
        [
            DailyPowerUp(quote: "The secret of getting ahead is getting started.", author: "Mark Twain", actionTitle: "Check your tasks", actionRoute: "plan"),
            DailyPowerUp(quote: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", actionTitle: "Journal today", actionRoute: "journal"),
            DailyPowerUp(quote: "Your network is your net worth.", author: "Porter Gale", actionTitle: "Add a contact", actionRoute: "networking"),
            DailyPowerUp(quote: "A goal without a plan is just a wish.", author: "Antoine de Saint-Exupery", actionTitle: "Review your goals", actionRoute: "goals"),
            DailyPowerUp(quote: "The only way to do great work is to love what you do.", author: "Steve Jobs", actionTitle: "Update your pitch", actionRoute: "pitch"),
            DailyPowerUp(quote: "It always seems impossible until it's done.", author: "Nelson Mandela", actionTitle: "Complete a task", actionRoute: "plan"),
            DailyPowerUp(quote: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson", actionTitle: "Check in", actionRoute: "checkin"),
            DailyPowerUp(quote: "The best time to plant a tree was 20 years ago. The second best time is now.", author: "Chinese Proverb", actionTitle: "Start planning", actionRoute: "plan"),
            DailyPowerUp(quote: "Preparation is the key to success.", author: "Alexander Graham Bell", actionTitle: "Review documents", actionRoute: "documents"),
            DailyPowerUp(quote: "Every expert was once a beginner.", author: "Helen Hayes", actionTitle: "Build your skills", actionRoute: "skills"),
        ]
    }

    static func generateWeeklyChallenges(weekStart: Date) -> [WeeklyChallenge] {
        let allChallenges = [
            WeeklyChallenge(title: "Task Crusher", description: "Complete 3 checklist items", icon: "checkmark.circle.fill", xpReward: 30, requirement: .completeChecklist(count: 3), weekStartDate: weekStart),
            WeeklyChallenge(title: "Journal Keeper", description: "Write 3 journal entries", icon: "book.fill", xpReward: 25, requirement: .journalEntries(count: 3), weekStartDate: weekStart),
            WeeklyChallenge(title: "Tool Explorer", description: "Use 2 different tools", icon: "wrench.and.screwdriver.fill", xpReward: 20, requirement: .useTools(count: 2), weekStartDate: weekStart),
            WeeklyChallenge(title: "Connector", description: "Add 2 networking contacts", icon: "person.3.fill", xpReward: 25, requirement: .networkContacts(count: 2), weekStartDate: weekStart),
            WeeklyChallenge(title: "Pulse Check", description: "Complete your weekly check-in", icon: "heart.text.square.fill", xpReward: 15, requirement: .weeklyCheckIn, weekStartDate: weekStart),
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: weekStart) ?? 0
        let startIdx = dayOfYear % allChallenges.count
        return Array(0..<3).map { allChallenges[(startIdx + $0) % allChallenges.count] }
    }
}
