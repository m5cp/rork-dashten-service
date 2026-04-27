import SwiftUI

struct SearchView: View {
    let storage: StorageService
    var store: StoreViewModel

    @State private var searchText: String = ""
    @State private var navPath = NavigationPath()
    @State private var activeSheet: ToolboxSheet?
    @State private var showPaywall: Bool = false
    @FocusState private var searchFocused: Bool

    private var isSearching: Bool { !searchText.isEmpty }

    private var allTools: [ToolboxView.ToolEntry] {
        moneyTools + careerTools + planningTools
    }

    private var moneyTools: [ToolboxView.ToolEntry] {
        [
            ToolboxView.ToolEntry(title: "Compensation Calculator", subtitle: "See what your military pay equals in civilian terms", icon: "equal.circle.fill", color: AppTheme.forestGreen, action: .sheet(.compensation), keywords: ["pay", "salary", "money", "compensation"]),
            ToolboxView.ToolEntry(title: "Income Gap Planner", subtitle: "How much savings you need for the gap", icon: "chart.line.downtrend.xyaxis", color: .orange, action: .sheet(.incomeGap), keywords: ["savings", "gap", "income"]),
            ToolboxView.ToolEntry(title: "Civilian Budget Builder", subtitle: "Build your post-service monthly budget", icon: "creditcard.fill", color: .purple, action: .sheet(.civilianBudget), keywords: ["budget", "expenses", "monthly"]),
            ToolboxView.ToolEntry(title: "Emergency Fund Calculator", subtitle: "Target 3–6 months of essential expenses", icon: "shield.lefthalf.filled", color: .teal, action: .sheet(.emergencyFund), keywords: ["emergency", "fund", "savings"]),
            ToolboxView.ToolEntry(title: "Cost of Living Comparator", subtitle: "Compare cities side by side", icon: "building.2.fill", color: .mint, action: .nav(.costOfLiving), keywords: ["city", "cost", "compare", "living"]),
            ToolboxView.ToolEntry(title: "Research TSP", subtitle: "Explore rollover options", icon: "arrow.triangle.swap", color: .blue, action: .nav(.tspRollover), keywords: ["tsp", "retirement", "401k", "rollover"]),
            ToolboxView.ToolEntry(title: "TSP Growth Estimator", subtitle: "Project your TSP at separation with DoD match", icon: "chart.line.uptrend.xyaxis", color: AppTheme.forestGreen, action: .nav(.tspGrowthEstimator), keywords: ["tsp", "growth", "retirement", "match", "brs"]),
            ToolboxView.ToolEntry(title: "BRS Retirement Snapshot", subtitle: "TSP + pension combined picture", icon: "chart.pie.fill", color: AppTheme.gold, action: .nav(.brsRetirementSnapshot), keywords: ["brs", "pension", "retirement", "snapshot"]),
            ToolboxView.ToolEntry(title: "Job Offer Compare", subtitle: "Side-by-side total compensation analysis", icon: "scalemass.fill", color: .indigo, action: .nav(.jobOfferCompare), keywords: ["offer", "compare", "job"]),
            ToolboxView.ToolEntry(title: "Salary Negotiation", subtitle: "Know your worth and ask for it", icon: "hand.raised.fill", color: .pink, action: .nav(.salaryNegotiation), keywords: ["negotiate", "salary"]),
        ]
    }

    private var careerTools: [ToolboxView.ToolEntry] {
        [
            ToolboxView.ToolEntry(title: "Resume Translator", subtitle: "Military → civilian language + jargon lookup", icon: "doc.text.fill", color: .teal, action: .nav(.resumeTranslator), keywords: ["resume", "jargon", "translate"]),
            ToolboxView.ToolEntry(title: "Skills Inventory", subtitle: "Map your skills to civilian career fields", icon: "list.clipboard.fill", color: .orange, action: .nav(.skillsInventory), keywords: ["skills", "career", "inventory"]),
            ToolboxView.ToolEntry(title: "Interview Prep", subtitle: "Practice with flashcards and coaching tips", icon: "person.fill.questionmark", color: .blue, action: .nav(.interviewPrep), keywords: ["interview", "practice", "prep"]),
            ToolboxView.ToolEntry(title: "Elevator Pitch Builder", subtitle: "Craft your 30/60/90-second intro", icon: "mic.fill", color: .purple, action: .nav(.elevatorPitch), keywords: ["pitch", "intro", "elevator"]),
            ToolboxView.ToolEntry(title: "Networking Hub", subtitle: "Track contacts, events, and follow-ups", icon: "person.3.fill", color: .purple, action: .nav(.networkingScorecard), keywords: ["networking", "contacts", "events"]),
            ToolboxView.ToolEntry(title: "Personal Brand Audit", subtitle: "Score your professional presence", icon: "person.crop.circle.badge.checkmark", color: .blue, action: .nav(.personalBrandAudit), keywords: ["brand", "linkedin", "audit"]),
        ]
    }

    private var planningTools: [ToolboxView.ToolEntry] {
        [
            ToolboxView.ToolEntry(title: "Decision Matrix", subtitle: "Weighted side-by-side comparison tool", icon: "square.grid.3x3.fill", color: .blue, action: .nav(.decisionMatrix), keywords: ["decision", "compare", "matrix"]),
            ToolboxView.ToolEntry(title: "First 90 Days Planner", subtitle: "Week-by-week post-hire plan + goal tracking", icon: "calendar.badge.clock", color: .purple, action: .nav(.ninetyDayPlanner), keywords: ["90 days", "planner", "goals"]),
            ToolboxView.ToolEntry(title: "Transition Journal", subtitle: "Daily guided prompts and reflections", icon: "book.fill", color: .purple, action: .nav(.transitionJournal), keywords: ["journal", "write", "reflect"]),
            ToolboxView.ToolEntry(title: "Wellness Check-In", subtitle: "Track well-being and readiness over time", icon: "chart.xyaxis.line", color: .blue, action: .nav(.weeklyCheckIn), keywords: ["wellness", "checkin", "stress"]),
            ToolboxView.ToolEntry(title: "GI Bill BAH Calculator", subtitle: "Housing allowance by school location", icon: "house.fill", color: .blue, action: .nav(.giBillBAH), keywords: ["gi bill", "bah", "housing"]),
            ToolboxView.ToolEntry(title: "Education Benefits", subtitle: "Compare GI Bill options side by side", icon: "chart.bar.doc.horizontal.fill", color: .indigo, action: .nav(.educationComparison), keywords: ["education", "gi bill"]),
            ToolboxView.ToolEntry(title: "Relocation Cost Estimator", subtitle: "Plan your moving budget", icon: "shippingbox.fill", color: .pink, action: .nav(.relocationCost), keywords: ["moving", "relocation"]),
            ToolboxView.ToolEntry(title: "State Benefits Finder", subtitle: "State-specific veteran benefits", icon: "flag.fill", color: AppTheme.forestGreen, action: .nav(.stateBenefits), keywords: ["state", "benefits", "veteran"]),
        ]
    }

    private var searchResults: [ToolboxView.ToolEntry] {
        guard isSearching else { return [] }
        return allTools.filter {
            $0.title.localizedStandardContains(searchText) ||
            $0.subtitle.localizedStandardContains(searchText) ||
            $0.keywords.contains(where: { $0.localizedStandardContains(searchText) })
        }
    }

    private let popularSearches: [String] = [
        "Resume", "Interview", "TSP", "Budget", "GI Bill", "Networking", "BAH", "Pension"
    ]

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if isSearching {
                        searchResultsSection
                    } else {
                        browseSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Search")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search all tools")
            .searchFocused($searchFocused)
            .navigationDestination(for: PlanningRoute.self) { route in
                routeDestination(route)
            }
            .sheet(item: $activeSheet) { sheet in
                sheetContent(sheet)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(store: store)
            }
        }
    }

    // MARK: - Browse (no query)

    private var browseSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            popularSection
            allToolsSection
        }
    }

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Popular Searches")
                    .font(.headline.weight(.bold))
            }

            FlowLayout(spacing: 8) {
                ForEach(popularSearches, id: \.self) { term in
                    Button {
                        searchText = term
                        searchFocused = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "magnifyingglass")
                                .font(.caption2.weight(.bold))
                            Text(term)
                                .font(.caption.weight(.bold))
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var allToolsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            categoryGroup(title: "Money", icon: "dollarsign.circle.fill", color: AppTheme.forestGreen, tools: moneyTools)
            categoryGroup(title: "Career", icon: "briefcase.fill", color: .teal, tools: careerTools)
            categoryGroup(title: "Planning", icon: "chart.xyaxis.line", color: .purple, tools: planningTools)
        }
    }

    private func categoryGroup(title: String, icon: String, color: Color, tools: [ToolboxView.ToolEntry]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline.weight(.bold))
                Spacer()
                Text("\(tools.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 0) {
                ForEach(Array(tools.enumerated()), id: \.element.id) { index, tool in
                    Button {
                        handleAction(tool.action, toolTitle: tool.title)
                    } label: {
                        ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color, isLocked: store.isToolLocked(tool.title))
                    }
                    .buttonStyle(.plain)
                    if index < tools.count - 1 {
                        Divider().padding(.leading, 58)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    // MARK: - Results

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if searchResults.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .frame(minHeight: 240)
            } else {
                Text("\(searchResults.count) result\(searchResults.count == 1 ? "" : "s")")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                VStack(spacing: 0) {
                    ForEach(Array(searchResults.enumerated()), id: \.element.id) { index, tool in
                        Button {
                            handleAction(tool.action, toolTitle: tool.title)
                        } label: {
                            ToolboxRowContent(title: tool.title, subtitle: tool.subtitle, icon: tool.icon, color: tool.color, isLocked: store.isToolLocked(tool.title))
                        }
                        .buttonStyle(.plain)
                        if index < searchResults.count - 1 {
                            Divider().padding(.leading, 58)
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    // MARK: - Routing

    @ViewBuilder
    private func routeDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .career: CareerPlanningView(storage: storage)
        case .education: EducationPlanningView(storage: storage)
        case .family: FamilyPlanningView()
        case .financial: FinancialPlanningView()
        case .readiness: ReadinessDashboardView(storage: storage)
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
        // NOTE: comment these two lines out if those tools haven't been added yet
        case .tspGrowthEstimator: TSPGrowthEstimatorView()
        case .brsRetirementSnapshot: BRSRetirementSnapshotView()
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
}

// MARK: - Simple flow layout for chips

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            totalWidth = max(totalWidth, x)
        }

        return CGSize(width: maxWidth.isFinite ? maxWidth : totalWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0
        let maxX = bounds.maxX

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
