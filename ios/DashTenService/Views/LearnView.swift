import SwiftUI

struct LearnView: View {
    let storage: StorageService
    @State private var searchText: String = ""
    @State private var selectedFilter: LearnFilter = .all

    private var filteredCategories: [BenefitCategory] {
        var cats = storage.benefitCategories
        if selectedFilter == .saved {
            cats = cats.filter(\.isSaved)
        } else if selectedFilter == .inProgress {
            cats = cats.filter(\.isStarted)
        }
        guard !searchText.isEmpty else { return cats }
        return cats.filter {
            $0.type.rawValue.localizedStandardContains(searchText) ||
            $0.overview.localizedStandardContains(searchText)
        }
    }

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

    private var insightCard: InsightCard? {
        let cards = TransitionDataService.insightCards()
        guard !cards.isEmpty else { return nil }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return cards[dayOfYear % cards.count]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    insightSection

                    guidesSection

                    filterBar

                    benefitCategoriesGrid
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Learn")
            .searchable(text: $searchText, prompt: "Search benefits & guides")
            .navigationDestination(for: String.self) { categoryId in
                if let category = storage.benefitCategories.first(where: { $0.id == categoryId }) {
                    BenefitDetailView(storage: storage, category: category)
                }
            }
            .navigationDestination(for: PlanningRoute.self) { route in
                routeDestination(route)
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
        }
    }

    private var insightSection: some View {
        Group {
            if let card = insightCard {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        Image(systemName: "quote.opening")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Daily Insight")
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(AppTheme.gold)
                                .textCase(.uppercase)
                            StatusBadge(text: card.category.rawValue, color: AppTheme.gold)
                        }
                        Spacer()
                    }

                    Text(card.title)
                        .font(.headline.weight(.bold))

                    Text(card.body)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
                .padding(18)
                .background(
                    LinearGradient(
                        colors: [AppTheme.gold.opacity(0.1), AppTheme.gold.opacity(0.03)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(.rect(cornerRadius: 18))
            }
        }
    }

    private var guidesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Guides")
                .font(.title3.weight(.bold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    GuideCard(title: "First 30 Days", subtitle: "Week-by-week", icon: "flag.fill", color: .purple, route: .firstThirtyDays)
                    GuideCard(title: "Mindset Shifts", subtitle: "Mental prep", icon: "brain.fill", color: .indigo, route: .mindsetShifts)
                    GuideCard(title: "Civilian Playbook", subtitle: "Unwritten rules", icon: "book.closed.fill", color: .blue, route: .civilianPlaybook)
                    GuideCard(title: "Career Planning", subtitle: "Resume & interview", icon: "briefcase.fill", color: .teal, route: .career)
                    GuideCard(title: "Education", subtitle: "GI Bill & more", icon: "graduationcap.fill", color: .blue, route: .education)
                    GuideCard(title: "Family & Move", subtitle: "Relocation guide", icon: "figure.2.and.child.holdinghands", color: .pink, route: .family)
                    GuideCard(title: "Financial Reset", subtitle: "Budget & taxes", icon: "dollarsign.circle.fill", color: AppTheme.gold, route: .financial)
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    private var filterBar: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Benefits")
                .font(.title3.weight(.bold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(LearnFilter.allCases) { filter in
                        FilterChip(title: filter.rawValue, isSelected: selectedFilter == filter) {
                            withAnimation(.snappy) { selectedFilter = filter }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    private var benefitCategoriesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            ForEach(filteredCategories) { category in
                NavigationLink(value: category.id) {
                    BenefitCategoryCard(category: category)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

nonisolated enum LearnFilter: String, CaseIterable, Identifiable, Sendable {
    case all = "All"
    case saved = "Saved"
    case inProgress = "In Progress"

    var id: String { rawValue }
}

struct GuideCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let route: PlanningRoute

    var body: some View {
        NavigationLink(value: route) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(color.gradient)
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 130, alignment: .leading)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
