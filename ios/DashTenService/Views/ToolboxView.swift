import SwiftUI

struct ToolboxView: View {
    let storage: StorageService
    @State private var activeSheet: ToolboxSheet?
    @State private var searchText: String = ""

    private var currentPhase: TimelinePhase? {
        guard let sepDate = storage.profile.separationDate else { return nil }
        let months = Calendar.current.dateComponents([.month], from: Date(), to: sepDate).month ?? 0
        if months > 18 { return .eighteenToTwentyFour }
        if months > 12 { return .twelveMonths }
        if months > 6 { return .sixMonths }
        if months > 3 { return .ninetyDays }
        if months > 0 { return .thirtyDays }
        let monthsSince = Calendar.current.dateComponents([.month], from: sepDate, to: Date()).month ?? 0
        if monthsSince <= 3 { return .firstNinety }
        return .firstYear
    }

    @State private var navPath: [PlanningRoute] = []

    private var recommendedTools: [(String, String, String, Color, ToolAction)] {
        var tools: [(String, String, String, Color, ToolAction)] = []
        let goals = Set(storage.profile.goals)

        if goals.contains(.financialReset) || goals.contains(.employment) {
            tools.append(("Compensation Calculator", "Compare military vs. civilian pay", "equal.circle.fill", AppTheme.forestGreen, .sheet(.compensation)))
        }
        if goals.contains(.employment) || goals.contains(.certification) {
            tools.append(("Elevator Pitch Builder", "Craft your intro", "mic.fill", .purple, .nav(.elevatorPitch)))
        }
        if goals.contains(.school) || goals.contains(.certification) {
            tools.append(("GI Bill BAH Calculator", "Estimate housing by location", "house.fill", .blue, .nav(.giBillBAH)))
        }
        if goals.contains(.relocation) || goals.contains(.familyReadiness) {
            tools.append(("Relocation Cost Estimator", "Plan your moving budget", "shippingbox.fill", .pink, .nav(.relocationCost)))
        }
        if goals.contains(.financialReset) {
            tools.append(("Job Offer Compare", "Side-by-side offers", "scalemass.fill", .indigo, .nav(.jobOfferCompare)))
        }

        if tools.isEmpty {
            tools.append(("Daily Power-Up", "Your daily motivation", "bolt.fill", AppTheme.gold, .nav(.dailyPowerUp)))
            tools.append(("Elevator Pitch Builder", "Craft your intro", "mic.fill", .purple, .nav(.elevatorPitch)))
            tools.append(("Jargon Translator", "Military ↔ civilian", "character.book.closed.fill", .teal, .nav(.jargonTranslator)))
        }

        return Array(tools.prefix(4))
    }

    private var isSearching: Bool { !searchText.isEmpty }

    private struct ToolEntry: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let icon: String
        let color: Color
        let action: ToolAction
    }

    private var allTools: [ToolEntry] {
        [
            ToolEntry(title: "Compensation Calculator", subtitle: "Military vs. civilian pay comparison", icon: "equal.circle.fill", color: AppTheme.forestGreen, action: .sheet(.compensation)),
            ToolEntry(title: "Income Gap Planner", subtitle: "Estimate savings needed for the gap", icon: "chart.line.downtrend.xyaxis", color: .orange, action: .sheet(.incomeGap)),
            ToolEntry(title: "Civilian Budget Builder", subtitle: "Build your post-service budget", icon: "creditcard.fill", color: .purple, action: .sheet(.civilianBudget)),
            ToolEntry(title: "Emergency Fund Calculator", subtitle: "3-6 months of essential expenses", icon: "shield.lefthalf.filled", color: .teal, action: .sheet(.emergencyFund)),
            ToolEntry(title: "Research TSP", subtitle: "Explore your TSP rollover options", icon: "arrow.triangle.swap", color: .blue, action: .nav(.tspRollover)),
            ToolEntry(title: "Salary Negotiation", subtitle: "Compare total compensation packages", icon: "scalemass.fill", color: .indigo, action: .nav(.salaryNegotiation)),
            ToolEntry(title: "Cost of Living Comparator", subtitle: "Compare cities side by side", icon: "building.2.fill", color: .mint, action: .nav(.costOfLiving)),
            ToolEntry(title: "Job Offer Compare", subtitle: "Side-by-side offer analysis", icon: "scalemass.fill", color: .indigo, action: .nav(.jobOfferCompare)),
            ToolEntry(title: "Benefits Enrollment Countdown", subtitle: "Track enrollment deadlines", icon: "clock.badge.exclamationmark.fill", color: .orange, action: .nav(.benefitsCountdown)),
            ToolEntry(title: "Resume Translator", subtitle: "Military to civilian language", icon: "doc.text.fill", color: .teal, action: .nav(.resumeTranslator)),
            ToolEntry(title: "Interview Prep", subtitle: "Practice behavioral questions", icon: "person.fill.questionmark", color: .blue, action: .nav(.interviewPrep)),
            ToolEntry(title: "Networking Scorecard", subtitle: "Track weekly connections", icon: "person.3.fill", color: .purple, action: .nav(.networkingScorecard)),
            ToolEntry(title: "Skills Inventory", subtitle: "Map skills to civilian careers", icon: "list.clipboard.fill", color: .orange, action: .nav(.skillsInventory)),
            ToolEntry(title: "Elevator Pitch Builder", subtitle: "Craft your 30/60/90-second intro", icon: "mic.fill", color: .purple, action: .nav(.elevatorPitch)),
            ToolEntry(title: "Jargon Translator", subtitle: "Military ↔ civilian language", icon: "character.book.closed.fill", color: .teal, action: .nav(.jargonTranslator)),
            ToolEntry(title: "Personal Brand Audit", subtitle: "Score your professional presence", icon: "person.crop.circle.badge.checkmark", color: .blue, action: .nav(.personalBrandAudit)),
            ToolEntry(title: "Networking Event Prep", subtitle: "Prepare and follow up", icon: "person.3.sequence.fill", color: .pink, action: .nav(.networkingEventPrep)),
            ToolEntry(title: "GI Bill BAH Calculator", subtitle: "Estimate housing allowance by location", icon: "house.fill", color: .blue, action: .nav(.giBillBAH)),
            ToolEntry(title: "Education Benefit Comparison", subtitle: "Compare GI Bill options side by side", icon: "chart.bar.doc.horizontal.fill", color: .indigo, action: .nav(.educationComparison)),
            ToolEntry(title: "Relocation Cost Estimator", subtitle: "Plan your moving budget", icon: "shippingbox.fill", color: .pink, action: .nav(.relocationCost)),
            ToolEntry(title: "State Benefits Finder", subtitle: "Find state-specific veteran benefits", icon: "flag.fill", color: AppTheme.forestGreen, action: .nav(.stateBenefits)),
            ToolEntry(title: "Decision Matrix", subtitle: "Weighted decision tool", icon: "square.grid.3x3.fill", color: .blue, action: .nav(.decisionMatrix)),
            ToolEntry(title: "First 90 Days Planner", subtitle: "Week-by-week post-hire plan", icon: "calendar.badge.clock", color: .purple, action: .nav(.ninetyDayPlanner)),
            ToolEntry(title: "Transition Journal", subtitle: "Daily guided prompts", icon: "book.fill", color: .purple, action: .nav(.transitionJournal)),
            ToolEntry(title: "90-Day Goal Tracker", subtitle: "Set and track your top goals", icon: "target", color: AppTheme.forestGreen, action: .nav(.goalTracker)),
            ToolEntry(title: "Weekly Check-In", subtitle: "Track your well-being over time", icon: "chart.xyaxis.line", color: .blue, action: .nav(.weeklyCheckIn)),
            ToolEntry(title: "Weekly Challenges", subtitle: "Earn XP with weekly tasks", icon: "bolt.fill", color: AppTheme.gold, action: .nav(.weeklyChallenges)),
            ToolEntry(title: "Daily Power-Up", subtitle: "Daily motivation + priority", icon: "bolt.fill", color: AppTheme.gold, action: .nav(.dailyPowerUp)),
            ToolEntry(title: "Readiness Check-In", subtitle: "Quick self-assessment", icon: "checklist.checked", color: .teal, action: .nav(.selfAssessment)),
            ToolEntry(title: "Final Gear Check", subtitle: "Pre-separation review", icon: "checkmark.shield.fill", color: .orange, action: .nav(.finalGearCheck)),
            ToolEntry(title: "Mentor Tracker", subtitle: "Build your civilian network", icon: "person.2.fill", color: .pink, action: .nav(.mentorTracker)),
            ToolEntry(title: "Achievement Badges", subtitle: "Track your accomplishments", icon: "trophy.fill", color: AppTheme.gold, action: .nav(.achievementBadges)),
        ]
    }

    private var searchResults: [ToolEntry] {
        guard isSearching else { return [] }
        return allTools.filter {
            $0.title.localizedStandardContains(searchText) ||
            $0.subtitle.localizedStandardContains(searchText)
        }
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(spacing: 20) {
                    if isSearching {
                        searchResultsSection
                    } else {
                        gamificationHeader
                        recommendedSection
                        interactiveToolsSection
                        financialToolsSection
                        careerToolsSection
                        educationToolsSection
                        relocationToolsSection
                        planningToolsSection
                        wellnessToolsSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tools")
            .searchable(text: $searchText, prompt: "Search tools")
            .navigationDestination(for: PlanningRoute.self) { route in
                routeDestination(route)
            }
            .sheet(item: $activeSheet) { sheet in
                sheetContent(sheet)
            }
        }
    }

    @ViewBuilder
    private func routeDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .career: CareerPlanningView(storage: storage)
        case .education: EducationPlanningView(storage: storage)
        case .family: FamilyPlanningView()
        case .financial: FinancialPlanningView()
        case .readiness: ReadinessDashboardView(storage: storage)
        case .crisis: CrisisResourcesView()
        case .firstThirtyDays: FirstThirtyDaysView()
        case .mindsetShifts: MindsetShiftsView()
        case .civilianPlaybook: CivilianPlaybookView()
        case .selfAssessment: SelfAssessmentView(storage: storage)
        case .finalGearCheck: FinalGearCheckView(storage: storage)
        case .mentorTracker: MentorTrackerView(storage: storage)
        case .documents: DocumentsView(storage: storage)
        case .tspRollover: TSPRolloverView()
        case .salaryNegotiation: SalaryNegotiationView()
        case .costOfLiving: CostOfLivingView()
        case .resumeTranslator: ResumeTranslatorView()
        case .interviewPrep: InterviewPrepView(storage: storage)
        case .networkingScorecard: NetworkingScorecardView(storage: storage)
        case .skillsInventory: SkillsInventoryView()
        case .giBillBAH: GIBillBAHCalculatorView()
        case .educationComparison: EducationBenefitComparisonView()
        case .relocationCost: RelocationCostView()
        case .stateBenefits: StateBenefitsFinderView()
        case .transitionJournal: TransitionJournalView(storage: storage)
        case .goalTracker: GoalTrackerView(storage: storage)
        case .weeklyCheckIn: WeeklyCheckInView(storage: storage)
        case .elevatorPitch: ElevatorPitchBuilderView(storage: storage)
        case .jargonTranslator: CivilianJargonTranslatorView()
        case .jobOfferCompare: JobOfferComparisonView(storage: storage)
        case .decisionMatrix: DecisionMatrixView(storage: storage)
        case .ninetyDayPlanner: NinetyDayPlannerView(storage: storage)
        case .weeklyChallenges: WeeklyChallengesView(storage: storage)
        case .dailyPowerUp: DailyPowerUpView(storage: storage)
        case .networkingEventPrep: NetworkingEventPrepView(storage: storage)
        case .personalBrandAudit: PersonalBrandAuditView(storage: storage)
        case .benefitsCountdown: BenefitsEnrollmentCountdownView(storage: storage)
        case .achievementBadges: AchievementBadgesView(storage: storage)
        }
    }

    @ViewBuilder
    private func sheetContent(_ sheet: ToolboxSheet) -> some View {
        switch sheet {
        case .compensation: MilitaryCompCalculatorView()
        case .incomeGap: IncomeGapCalculatorView()
        case .civilianBudget: CivilianBudgetCalculatorView()
        case .emergencyFund: EmergencyFundCalculatorView()
        }
    }

    private var gamificationHeader: some View {
        NavigationLink(value: PlanningRoute.achievementBadges) {
            HStack(spacing: 16) {
                ProgressRing(progress: storage.transitionLevel.progressToNextLevel, size: 48, lineWidth: 4, color: AppTheme.gold)
                    .overlay {
                        Text("Lv\(storage.transitionLevel.level)")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundStyle(AppTheme.gold)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(storage.transitionLevel.levelTitle)
                        .font(.headline.weight(.bold))
                    HStack(spacing: 12) {
                        Label("\(storage.transitionLevel.totalXPEarned) XP", systemImage: "star.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                        Label("\(storage.badges.filter(\.isUnlocked).count) badges", systemImage: "trophy.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(
                LinearGradient(colors: [AppTheme.gold.opacity(0.08), AppTheme.gold.opacity(0.02)], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(AppTheme.gold.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Recommended for You")
                    .font(.title3.weight(.bold))
            }

            if !storage.profile.goals.isEmpty {
                Text("Based on your goals")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(recommendedTools.enumerated()), id: \.offset) { _, tool in
                        RecommendedToolCard(
                            title: tool.0,
                            subtitle: tool.1,
                            icon: tool.2,
                            color: tool.3,
                            action: { handleAction(tool.4) }
                        )
                    }
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if searchResults.isEmpty {
                ContentUnavailableView("No tools found", systemImage: "magnifyingglass", description: Text("Try a different search term"))
                    .frame(minHeight: 200)
            } else {
                Text("\(searchResults.count) results")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                VStack(spacing: 2) {
                    ForEach(searchResults) { tool in
                        Button {
                            handleAction(tool.action)
                        } label: {
                            ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private func handleAction(_ action: ToolAction) {
        switch action {
        case .sheet(let sheet):
            activeSheet = sheet
        case .nav(let route):
            navPath.append(route)
        }
    }

    private var interactiveToolsSection: some View {
        ToolboxSection(title: "Interactive Tools", icon: "sparkle.magnifyingglass", color: AppTheme.forestGreen) {
            ToolboxNavRow(title: "Daily Power-Up", subtitle: "Daily motivation + #1 priority", icon: "bolt.fill", color: AppTheme.gold, route: .dailyPowerUp)
            ToolboxNavRow(title: "Weekly Challenges", subtitle: "Earn XP with weekly tasks", icon: "flame.fill", color: .orange, route: .weeklyChallenges)
            ToolboxNavRow(title: "Achievement Badges", subtitle: "Track your accomplishments", icon: "trophy.fill", color: AppTheme.gold, route: .achievementBadges)
            ToolboxNavRow(title: "Elevator Pitch Builder", subtitle: "Craft your 30/60/90-second intro", icon: "mic.fill", color: .purple, route: .elevatorPitch)
            ToolboxNavRow(title: "Jargon Translator", subtitle: "Military ↔ civilian language", icon: "character.book.closed.fill", color: .teal, route: .jargonTranslator)
            ToolboxNavRow(title: "Decision Matrix", subtitle: "Weighted decision-making tool", icon: "square.grid.3x3.fill", color: .blue, route: .decisionMatrix)
            ToolboxNavRow(title: "First 90 Days Planner", subtitle: "Week-by-week post-hire plan", icon: "calendar.badge.clock", color: .purple, route: .ninetyDayPlanner)
            ToolboxNavRow(title: "Personal Brand Audit", subtitle: "Score your professional presence", icon: "person.crop.circle.badge.checkmark", color: .blue, route: .personalBrandAudit)
        }
    }

    private var financialToolsSection: some View {
        ToolboxSection(title: "Financial", icon: "dollarsign.circle.fill", color: AppTheme.gold) {
            ToolboxSheetRow(title: "Compensation Calculator", subtitle: "Military vs. civilian pay comparison", icon: "equal.circle.fill", color: AppTheme.forestGreen) {
                activeSheet = .compensation
            }
            ToolboxSheetRow(title: "Income Gap Planner", subtitle: "Estimate savings needed for the gap", icon: "chart.line.downtrend.xyaxis", color: .orange) {
                activeSheet = .incomeGap
            }
            ToolboxSheetRow(title: "Civilian Budget Builder", subtitle: "Build your post-service budget", icon: "creditcard.fill", color: .purple) {
                activeSheet = .civilianBudget
            }
            ToolboxSheetRow(title: "Emergency Fund Calculator", subtitle: "3-6 months of essential expenses", icon: "shield.lefthalf.filled", color: .teal) {
                activeSheet = .emergencyFund
            }
            ToolboxNavRow(title: "Research TSP", subtitle: "Explore your TSP rollover options", icon: "arrow.triangle.swap", color: .blue, route: .tspRollover)
            ToolboxNavRow(title: "Salary Negotiation", subtitle: "Compare total compensation packages", icon: "scalemass.fill", color: .indigo, route: .salaryNegotiation)
            ToolboxNavRow(title: "Cost of Living Comparator", subtitle: "Compare cities side by side", icon: "building.2.fill", color: .mint, route: .costOfLiving)
            ToolboxNavRow(title: "Job Offer Compare", subtitle: "Side-by-side offer analysis", icon: "scalemass.fill", color: .indigo, route: .jobOfferCompare)
            ToolboxNavRow(title: "Benefits Enrollment Countdown", subtitle: "Track enrollment deadlines", icon: "clock.badge.exclamationmark.fill", color: .orange, route: .benefitsCountdown)
        }
    }

    private var careerToolsSection: some View {
        ToolboxSection(title: "Career", icon: "briefcase.fill", color: .teal) {
            ToolboxNavRow(title: "Resume Translator", subtitle: "Military to civilian language", icon: "doc.text.fill", color: .teal, route: .resumeTranslator)
            ToolboxNavRow(title: "Interview Prep", subtitle: "Practice behavioral questions", icon: "person.fill.questionmark", color: .blue, route: .interviewPrep)
            ToolboxNavRow(title: "Networking Scorecard", subtitle: "Track weekly connections", icon: "person.3.fill", color: .purple, route: .networkingScorecard)
            ToolboxNavRow(title: "Networking Event Prep", subtitle: "Prepare and follow up on events", icon: "person.3.sequence.fill", color: .pink, route: .networkingEventPrep)
            ToolboxNavRow(title: "Skills Inventory", subtitle: "Map skills to civilian careers", icon: "list.clipboard.fill", color: .orange, route: .skillsInventory)
        }
    }

    private var educationToolsSection: some View {
        ToolboxSection(title: "Education", icon: "graduationcap.fill", color: .blue) {
            ToolboxNavRow(title: "GI Bill BAH Calculator", subtitle: "Estimate housing allowance by location", icon: "house.fill", color: .blue, route: .giBillBAH)
            ToolboxNavRow(title: "Education Benefit Comparison", subtitle: "Compare GI Bill options side by side", icon: "chart.bar.doc.horizontal.fill", color: .indigo, route: .educationComparison)
        }
    }

    private var relocationToolsSection: some View {
        ToolboxSection(title: "Relocation", icon: "map.fill", color: .pink) {
            ToolboxNavRow(title: "Relocation Cost Estimator", subtitle: "Plan your moving budget", icon: "shippingbox.fill", color: .pink, route: .relocationCost)
            ToolboxNavRow(title: "State Benefits Finder", subtitle: "Find state-specific veteran benefits", icon: "flag.fill", color: AppTheme.forestGreen, route: .stateBenefits)
        }
    }

    private var planningToolsSection: some View {
        ToolboxSection(title: "Planning & Decisions", icon: "map.fill", color: .purple) {
            ToolboxNavRow(title: "Decision Matrix", subtitle: "Weighted decision-making tool", icon: "square.grid.3x3.fill", color: .blue, route: .decisionMatrix)
            ToolboxNavRow(title: "First 90 Days Planner", subtitle: "Week-by-week post-hire plan", icon: "calendar.badge.clock", color: .purple, route: .ninetyDayPlanner)
        }
    }

    private var wellnessToolsSection: some View {
        ToolboxSection(title: "Wellness & Tracking", icon: "heart.fill", color: .red) {
            ToolboxNavRow(title: "Transition Journal", subtitle: "Daily guided prompts", icon: "book.fill", color: .purple, route: .transitionJournal)
            ToolboxNavRow(title: "90-Day Goal Tracker", subtitle: "Set and track your top goals", icon: "target", color: AppTheme.forestGreen, route: .goalTracker)
            ToolboxNavRow(title: "Weekly Check-In", subtitle: "Track your well-being over time", icon: "chart.xyaxis.line", color: .blue, route: .weeklyCheckIn)
            ToolboxNavRow(title: "Readiness Check-In", subtitle: "Quick self-assessment", icon: "checklist.checked", color: .teal, route: .selfAssessment)
            ToolboxNavRow(title: "Final Gear Check", subtitle: "Pre-separation review", icon: "checkmark.shield.fill", color: .orange, route: .finalGearCheck)
            ToolboxNavRow(title: "Mentor Tracker", subtitle: "Build your civilian network", icon: "person.2.fill", color: .pink, route: .mentorTracker)
        }
    }
}

enum ToolAction {
    case sheet(ToolboxSheet)
    case nav(PlanningRoute)
}

enum ToolboxSheet: String, Identifiable {
    case compensation, incomeGap, civilianBudget, emergencyFund
    var id: String { rawValue }
}

struct RecommendedToolCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(color.gradient)
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Text(subtitle)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .frame(width: 150, alignment: .leading)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

struct ToolboxSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 2) {
                content
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }
}

struct ToolboxNavRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let route: PlanningRoute

    var body: some View {
        NavigationLink(value: route) {
            ToolboxRowContent(title: title, subtitle: subtitle, icon: icon, color: color)
        }
        .buttonStyle(.plain)
    }
}

struct ToolboxSheetRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ToolboxRowContent(title: title, subtitle: subtitle, icon: icon, color: color)
        }
        .buttonStyle(.plain)
    }
}

struct ToolboxRowContent: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.12))
                .clipShape(.rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
