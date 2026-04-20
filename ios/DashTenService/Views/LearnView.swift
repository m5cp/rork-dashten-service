import SwiftUI

struct LearnView: View {
    let storage: StorageService
    var store: StoreViewModel

    private var insightCard: InsightCard? {
        let cards = TransitionDataService.insightCards()
        guard !cards.isEmpty else { return nil }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return cards[dayOfYear % cards.count]
    }

    private var guidesCount: Int { 8 }

    private var benefitsCount: Int {
        storage.benefitCategories.count
    }

    private var benefitsProgress: Double {
        let total = storage.benefitCategories.flatMap(\.actionItems)
        guard !total.isEmpty else { return 0 }
        let completed = total.filter(\.isCompleted).count
        return Double(completed) / Double(total.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    insightSection

                    VStack(spacing: 14) {
                        NavigationLink(value: LearnDestination.guides) {
                            LearnHeroCard(
                                title: "Guides",
                                subtitle: "Step-by-step playbooks for your transition",
                                icon: "book.fill",
                                itemCount: guidesCount,
                                itemLabel: "guides",
                                gradient: LinearGradient(
                                    colors: [Color(red: 0.22, green: 0.36, blue: 0.52), Color(red: 0.14, green: 0.24, blue: 0.38)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                accentColor: .cyan
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: LearnDestination.benefits) {
                            LearnHeroCard(
                                title: "Benefits",
                                subtitle: "Understand & claim every benefit you've earned",
                                icon: "shield.fill",
                                itemCount: benefitsCount,
                                itemLabel: "categories",
                                gradient: LinearGradient(
                                    colors: [Color(red: 0.18, green: 0.42, blue: 0.22), Color(red: 0.12, green: 0.30, blue: 0.14)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                accentColor: AppTheme.gold,
                                progress: benefitsProgress
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Learn")
            .navigationDestination(for: LearnDestination.self) { dest in
                switch dest {
                case .guides:
                    GuidesListView(storage: storage, store: store)
                case .benefits:
                    LearnBenefitsListView(storage: storage)
                }
            }
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
}

nonisolated enum LearnDestination: Hashable, Sendable {
    case guides
    case benefits
}

// MARK: - Hero Card

private struct LearnHeroCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let itemCount: Int
    let itemLabel: String
    let gradient: LinearGradient
    let accentColor: Color
    var progress: Double? = nil

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(width: 48, height: 48)
                    .background(.white.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 14))

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)

                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                if let progress, progress > 0 {
                    HStack(spacing: 8) {
                        ProgressView(value: progress)
                            .tint(.white.opacity(0.8))
                            .frame(maxWidth: 120)
                        Text("\(Int(progress * 100))%")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }

            Spacer(minLength: 12)

            VStack {
                Spacer()
                HStack(spacing: 6) {
                    Text("\(itemCount) \(itemLabel)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.8))
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 170)
        .background(gradient)
        .clipShape(.rect(cornerRadius: 20))
    }
}

// MARK: - Guides List

struct GuidesListView: View {
    let storage: StorageService
    var store: StoreViewModel
    @State private var showPaywall: Bool = false
    @State private var expandedRoute: PlanningRoute?

    private let guides: [(title: String, subtitle: String, description: String, icon: String, color: Color, route: PlanningRoute)] = [
        ("First 30 Days", "Week-by-week", "A structured week-by-week plan for your first month after separation.", "flag.fill", .purple, .firstThirtyDays),
        ("First Year Guide", "Quarter-by-quarter", "Your complete roadmap for the first 12 months after separation.", "star.circle.fill", Color(red: 0.176, green: 0.373, blue: 0.176), .firstYearGuide),
        ("Mindset Shifts", "Mental prep", "Reframe your thinking from military to civilian mindset.", "brain.fill", .indigo, .mindsetShifts),
        ("Civilian Playbook", "Unwritten rules", "Navigate the unspoken norms of civilian workplaces and life.", "book.closed.fill", .blue, .civilianPlaybook),
        ("Career Planning", "Resume & interview", "Build your civilian career strategy from scratch.", "briefcase.fill", .teal, .career),
        ("Education", "GI Bill & more", "Plan your education path and maximize your benefits.", "graduationcap.fill", .blue, .education),
        ("Family & Move", "Relocation guide", "Prepare your family and plan your relocation.", "figure.2.and.child.holdinghands", .pink, .family),
        ("Financial Reset", "Budget & taxes", "Rebuild your finances for civilian life.", "dollarsign.circle.fill", AppTheme.gold, .financial),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                VStack(spacing: 12) {
                    Image(systemName: "book.fill")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.22, green: 0.36, blue: 0.52), Color(red: 0.14, green: 0.24, blue: 0.38)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 18))

                    Text("Tap a guide to expand it — your full transition playbook, in one place.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Text("\(guides.count) guides")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.cyan)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.cyan.opacity(0.12))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.bottom, 6)

                ForEach(Array(guides.enumerated()), id: \.offset) { _, guide in
                    ExpandableGuideCard(
                        title: guide.title,
                        subtitle: guide.subtitle,
                        description: guide.description,
                        icon: guide.icon,
                        color: guide.color,
                        route: guide.route,
                        locked: store.isGuideLocked(guide.route),
                        isExpanded: expandedRoute == guide.route,
                        onToggle: {
                            if store.isGuideLocked(guide.route) {
                                showPaywall = true
                                return
                            }
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                expandedRoute = (expandedRoute == guide.route) ? nil : guide.route
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Guides")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) {
            PaywallView(store: store)
        }
    }
}

struct ExpandableGuideCard: View {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let color: Color
    let route: PlanningRoute
    let locked: Bool
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(
                            LinearGradient(
                                colors: [color, color.opacity(0.75)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(title)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.primary)
                            if locked {
                                Text("PRO")
                                    .font(.system(size: 9, weight: .heavy))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(AppTheme.gold)
                                    .clipShape(Capsule())
                            }
                        }
                        Text(description)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()

                    Image(systemName: locked ? "lock.fill" : "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(locked ? AppTheme.gold : .secondary)
                        .rotationEffect(.degrees(isExpanded && !locked ? 180 : 0))
                }
                .padding(16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isExpanded)

            if isExpanded && !locked {
                VStack(alignment: .leading, spacing: 14) {
                    Divider()
                    GuideContentView(route: route)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }
}

@ViewBuilder
func GuideContentView(route: PlanningRoute) -> some View {
    switch route {
    case .firstThirtyDays: FirstThirtyDaysContent()
    case .firstYearGuide: FirstYearGuideContent()
    case .mindsetShifts: MindsetShiftsContent()
    case .civilianPlaybook: CivilianPlaybookContent()
    case .career: CareerPlanningContent()
    case .education: EducationPlanningContent()
    case .family: FamilyPlanningContent()
    case .financial: FinancialPlanningContent()
    default: EmptyView()
    }
}

// MARK: - Benefits List

struct LearnBenefitsListView: View {
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

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: "shield.fill")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.18, green: 0.42, blue: 0.22), Color(red: 0.12, green: 0.30, blue: 0.14)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 18))

                    Text("Understand & claim every benefit you've earned")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Text("\(storage.benefitCategories.count) categories")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(AppTheme.gold.opacity(0.12))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(LearnFilter.allCases) { filter in
                            FilterChip(title: filter.rawValue, isSelected: selectedFilter == filter) {
                                withAnimation(.snappy) { selectedFilter = filter }
                            }
                        }
                    }
                }
                .contentMargins(.horizontal, 16)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(filteredCategories) { category in
                        NavigationLink(value: category.id) {
                            BenefitCategoryCard(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Benefits")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search benefits")
    }
}

nonisolated enum LearnFilter: String, CaseIterable, Identifiable, Sendable {
    case all = "All"
    case saved = "Saved"
    case inProgress = "In Progress"

    var id: String { rawValue }
}
