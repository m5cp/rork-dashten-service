import SwiftUI

struct ToolboxView: View {
    let storage: StorageService
    var store: StoreViewModel
    @State private var activeSheet: ToolboxSheet?
    @State private var searchText: String = ""
    @State private var navPath: [PlanningRoute] = []
    @State private var showPaywall: Bool = false

    private var isSearching: Bool { !searchText.isEmpty }

    struct ToolEntry: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let icon: String
        let color: Color
        let action: ToolAction
        let keywords: [String]

        init(title: String, subtitle: String, icon: String, color: Color, action: ToolAction, keywords: [String] = []) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
            self.color = color
            self.action = action
            self.keywords = keywords
        }
    }

    private var moneyTools: [ToolEntry] {
        [
            ToolEntry(title: "Compensation Calculator", subtitle: "See what your military pay equals in civilian terms", icon: "equal.circle.fill", color: AppTheme.forestGreen, action: .sheet(.compensation), keywords: ["pay", "salary", "money"]),
            ToolEntry(title: "Income Gap Planner", subtitle: "How much savings you need for the gap", icon: "chart.line.downtrend.xyaxis", color: .orange, action: .sheet(.incomeGap), keywords: ["savings", "gap"]),
            ToolEntry(title: "Civilian Budget Builder", subtitle: "Build your post-service monthly budget", icon: "creditcard.fill", color: .purple, action: .sheet(.civilianBudget), keywords: ["budget", "expenses"]),
            ToolEntry(title: "Emergency Fund Calculator", subtitle: "Target 3–6 months of essential expenses", icon: "shield.lefthalf.filled", color: .teal, action: .sheet(.emergencyFund), keywords: ["emergency", "fund"]),
            ToolEntry(title: "Cost of Living Comparator", subtitle: "Compare cities side by side", icon: "building.2.fill", color: .mint, action: .nav(.costOfLiving), keywords: ["city", "cost", "compare"]),
            ToolEntry(title: "Research TSP", subtitle: "Explore rollover options", icon: "arrow.triangle.swap", color: .blue, action: .nav(.tspRollover), keywords: ["tsp", "retirement", "401k"]),
            ToolEntry(title: "Job Offer Compare", subtitle: "Side-by-side total compensation analysis", icon: "scalemass.fill", color: .indigo, action: .nav(.jobOfferCompare), keywords: ["offer", "compare", "job"]),
            ToolEntry(title: "Salary Negotiation", subtitle: "Know your worth and ask for it", icon: "hand.raised.fill", color: .pink, action: .nav(.salaryNegotiation), keywords: ["negotiate", "salary"]),
        ]
    }

    private var careerTools: [ToolEntry] {
        [
            ToolEntry(title: "Resume Translator", subtitle: "Military → civilian language + jargon lookup", icon: "doc.text.fill", color: .teal, action: .nav(.resumeTranslator), keywords: ["resume", "jargon", "translate"]),
            ToolEntry(title: "Skills Inventory", subtitle: "Map your skills to civilian career fields", icon: "list.clipboard.fill", color: .orange, action: .nav(.skillsInventory), keywords: ["skills", "career"]),
            ToolEntry(title: "Interview Prep", subtitle: "Practice with flashcards and coaching tips", icon: "person.fill.questionmark", color: .blue, action: .nav(.interviewPrep), keywords: ["interview", "practice"]),
            ToolEntry(title: "Elevator Pitch Builder", subtitle: "Craft your 30/60/90-second intro", icon: "mic.fill", color: .purple, action: .nav(.elevatorPitch), keywords: ["pitch", "intro"]),
            ToolEntry(title: "Networking Hub", subtitle: "Track contacts, events, and follow-ups", icon: "person.3.fill", color: .purple, action: .nav(.networkingScorecard), keywords: ["networking", "contacts"]),
            ToolEntry(title: "Personal Brand Audit", subtitle: "Score your professional presence", icon: "person.crop.circle.badge.checkmark", color: .blue, action: .nav(.personalBrandAudit), keywords: ["brand", "linkedin"]),
        ]
    }

    private var planningTools: [ToolEntry] {
        [
            ToolEntry(title: "Decision Matrix", subtitle: "Weighted side-by-side comparison tool", icon: "square.grid.3x3.fill", color: .blue, action: .nav(.decisionMatrix), keywords: ["decision", "compare"]),
            ToolEntry(title: "First 90 Days Planner", subtitle: "Week-by-week post-hire plan + goal tracking", icon: "calendar.badge.clock", color: .purple, action: .nav(.ninetyDayPlanner), keywords: ["90 days", "planner", "goals"]),
            ToolEntry(title: "Transition Journal", subtitle: "Daily guided prompts and reflections", icon: "book.fill", color: .purple, action: .nav(.transitionJournal), keywords: ["journal", "write"]),
            ToolEntry(title: "Wellness Check-In", subtitle: "Track well-being and readiness over time", icon: "chart.xyaxis.line", color: .blue, action: .nav(.weeklyCheckIn), keywords: ["wellness", "checkin", "stress"]),
            ToolEntry(title: "GI Bill BAH Calculator", subtitle: "Housing allowance by school location", icon: "house.fill", color: .blue, action: .nav(.giBillBAH), keywords: ["gi bill", "bah", "housing"]),
            ToolEntry(title: "Education Benefits", subtitle: "Compare GI Bill options side by side", icon: "chart.bar.doc.horizontal.fill", color: .indigo, action: .nav(.educationComparison), keywords: ["education", "gi bill"]),
            ToolEntry(title: "Relocation Cost Estimator", subtitle: "Plan your moving budget", icon: "shippingbox.fill", color: .pink, action: .nav(.relocationCost), keywords: ["moving", "relocation"]),
            ToolEntry(title: "State Benefits Finder", subtitle: "State-specific veteran benefits", icon: "flag.fill", color: AppTheme.forestGreen, action: .nav(.stateBenefits), keywords: ["state", "benefits"]),
        ]
    }

    private var allTools: [ToolEntry] {
        moneyTools + careerTools + planningTools
    }

    private var searchResults: [ToolEntry] {
        guard isSearching else { return [] }
        return allTools.filter {
            $0.title.localizedStandardContains(searchText) ||
            $0.subtitle.localizedStandardContains(searchText) ||
            $0.keywords.contains(where: { $0.localizedStandardContains(searchText) })
        }
    }

    private var recommendedTools: [ToolEntry] {
        var recs: [ToolEntry] = []
        let timeline = storage.profile.timeline
        let goals = storage.profile.goals

        if !storage.toolsUsedIds.contains("compensation") {
            if let tool = allTools.first(where: { $0.title == "Compensation Calculator" }) {
                recs.append(tool)
            }
        }

        if goals.contains(.employment) || goals.contains(.careerReadiness) {
            if !storage.toolsUsedIds.contains("skills_inventory") {
                if let tool = allTools.first(where: { $0.title == "Skills Inventory" }) {
                    recs.append(tool)
                }
            }
            if storage.practicedQuestions.isEmpty {
                if let tool = allTools.first(where: { $0.title == "Interview Prep" }) {
                    recs.append(tool)
                }
            }
        }

        if goals.contains(.school) || goals.contains(.certification) {
            if let tool = allTools.first(where: { $0.title == "GI Bill BAH Calculator" }) {
                recs.append(tool)
            }
        }

        if goals.contains(.relocation) {
            if let tool = allTools.first(where: { $0.title == "Cost of Living Comparator" }) {
                recs.append(tool)
            }
        }

        if goals.contains(.financialReset) {
            if let tool = allTools.first(where: { $0.title == "Civilian Budget Builder" }) {
                recs.append(tool)
            }
        }

        if timeline == .ninetyDays || timeline == .separated {
            if let tool = allTools.first(where: { $0.title == "First 90 Days Planner" }) {
                recs.append(tool)
            }
        }

        if recs.isEmpty {
            recs = Array(allTools.prefix(3))
        }

        return Array(recs.prefix(3))
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(spacing: 24) {
                    if isSearching {
                        searchResultsSection
                    } else {
                        heroCategoriesSection
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
            .navigationDestination(for: ToolCategory.self) { category in
                CategoryToolsView(storage: storage, store: store, category: category, tools: toolsFor(category), onAction: { action in handleAction(action) })
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(store: store)
            }
            .sheet(item: $activeSheet) { sheet in
                sheetContent(sheet)
            }
        }
    }

    private func toolsFor(_ category: ToolCategory) -> [ToolEntry] {
        switch category {
        case .money: return moneyTools
        case .career: return careerTools
        case .planning: return planningTools
        }
    }

    private var heroCategoriesSection: some View {
        VStack(spacing: 14) {
            ForEach(ToolCategory.allCases) { category in
                NavigationLink(value: category) {
                    ToolCategoryHeroCard(category: category, toolCount: toolsFor(category).count)
                }
                .buttonStyle(.plain)
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
        case .firstYearGuide: FirstYearGuideView()
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

    private func handleAction(_ action: ToolAction, toolTitle: String = "") {
        if store.isToolLocked(toolTitle) {
            showPaywall = true
            return
        }
        switch action {
        case .sheet(let sheet):
            activeSheet = sheet
        case .nav(let route):
            navPath.append(route)
        }
    }

    // MARK: - Recommended

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Recommended for You")
                    .font(.headline.weight(.bold))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recommendedTools) { tool in
                        Button {
                            handleAction(tool.action)
                        } label: {
                            RecommendedToolCard(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    // MARK: - Search

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
                            handleAction(tool.action, toolTitle: tool.title)
                        } label: {
                            ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color, isLocked: store.isToolLocked(tool.title))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

}

enum ToolCategory: String, CaseIterable, Identifiable, Hashable {
    case money = "Money"
    case career = "Career"
    case planning = "Planning"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .money: return "dollarsign.circle.fill"
        case .career: return "briefcase.fill"
        case .planning: return "chart.xyaxis.line"
        }
    }

    var subtitle: String {
        switch self {
        case .money: return "Pay, budgets, savings & financial tools"
        case .career: return "Resume, skills, interviews & networking"
        case .planning: return "Decisions, goals, wellness & education"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .money:
            return LinearGradient(colors: [Color(red: 0.18, green: 0.42, blue: 0.22), Color(red: 0.12, green: 0.30, blue: 0.14)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .career:
            return LinearGradient(colors: [Color(red: 0.12, green: 0.38, blue: 0.42), Color(red: 0.08, green: 0.26, blue: 0.32)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .planning:
            return LinearGradient(colors: [Color(red: 0.30, green: 0.22, blue: 0.46), Color(red: 0.20, green: 0.14, blue: 0.36)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var accentColor: Color {
        switch self {
        case .money: return AppTheme.gold
        case .career: return .teal
        case .planning: return .purple
        }
    }
}

private struct ToolCategoryHeroCard: View {
    let category: ToolCategory
    let toolCount: Int

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 12))

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(category.subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 12)

            VStack {
                Spacer()
                HStack(spacing: 6) {
                    Text("\(toolCount) tools")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.8))
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background(category.gradient)
        .clipShape(.rect(cornerRadius: 20))
    }
}

// MARK: - Recommended Card

private struct RecommendedToolCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text(subtitle)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            HStack(spacing: 4) {
                Text("Open")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
                Image(systemName: "arrow.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(color)
            }
        }
        .padding(14)
        .frame(width: 160, height: 170, alignment: .topLeading)
        .background(color.opacity(0.08))
        .clipShape(.rect(cornerRadius: 16))
    }
}

// MARK: - Category Tools View

struct CategoryToolsView: View {
    let storage: StorageService
    var store: StoreViewModel
    let category: ToolCategory
    let tools: [ToolboxView.ToolEntry]
    let onAction: (ToolAction) -> Void
    @State private var activeSheet: ToolboxSheet?
    @State private var showPaywall: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection

                VStack(spacing: 2) {
                    ForEach(Array(tools.enumerated()), id: \.element.id) { index, tool in
                        toolRow(tool)
                        if index < tools.count - 1 {
                            Divider()
                                .padding(.leading, 58)
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .compensation: MilitaryCompCalculatorView()
            case .incomeGap: IncomeGapCalculatorView()
            case .civilianBudget: CivilianBudgetCalculatorView()
            case .emergencyFund: EmergencyFundCalculatorView()
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(store: store)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.largeTitle.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(category.gradient)
                .clipShape(.rect(cornerRadius: 18))

            Text(category.subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("\(tools.count) tools")
                .font(.caption.weight(.bold))
                .foregroundStyle(category.accentColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(category.accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func toolRow(_ tool: ToolboxView.ToolEntry) -> some View {
        let locked = store.isToolLocked(tool.title)
        if locked {
            Button {
                showPaywall = true
            } label: {
                ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color, isLocked: true)
            }
            .buttonStyle(.plain)
        } else {
            switch tool.action {
            case .sheet(let sheet):
                Button {
                    activeSheet = sheet
                } label: {
                    ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color)
                }
                .buttonStyle(.plain)
            case .nav(let route):
                NavigationLink(value: route) {
                    ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color)
                }
                .buttonStyle(.plain)
            }
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

// MARK: - Section & Row Components

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

            ToolboxDividedStack {
                content
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }
}

struct ToolboxDividedStack<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        _VariadicView.Tree(DividedLayout()) {
            content
        }
    }
}

private struct DividedLayout: _VariadicView_MultiViewRoot {
    func body(children: _VariadicView.Children) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(children.enumerated()), id: \.element.id) { index, child in
                child
                if index < children.count - 1 {
                    Divider()
                        .padding(.leading, 58)
                }
            }
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
    var isLocked: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(isLocked ? .secondary : color)
                .frame(width: 32, height: 32)
                .background((isLocked ? Color.secondary : color).opacity(0.12))
                .clipShape(.rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(isLocked ? .secondary : .primary)
                    if isLocked {
                        Text("PRO")
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(AppTheme.gold)
                            .clipShape(Capsule())
                    }
                }
                Text(subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isLocked {
                Image(systemName: "lock.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
