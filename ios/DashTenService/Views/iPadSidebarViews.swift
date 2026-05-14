import SwiftUI

// MARK: - Plan iPad Sidebar

nonisolated enum PlanSidebarItem: Hashable, Identifiable, Sendable, CaseIterable {
    case overview
    case roadmap
    case career
    case education
    case family
    case financial
    case documents
    case readiness

    var id: Self { self }

    var title: String {
        switch self {
        case .overview: "Overview"
        case .roadmap: "Roadmap"
        case .career: "Career"
        case .education: "Education"
        case .family: "Family"
        case .financial: "Financial"
        case .documents: "Documents"
        case .readiness: "Readiness"
        }
    }

    var icon: String {
        switch self {
        case .overview: "square.grid.2x2.fill"
        case .roadmap: "map.fill"
        case .career: "briefcase.fill"
        case .education: "graduationcap.fill"
        case .family: "figure.2.and.child.holdinghands"
        case .financial: "dollarsign.circle.fill"
        case .documents: "doc.text.fill"
        case .readiness: "chart.bar.fill"
        }
    }

    var tint: Color {
        switch self {
        case .overview: AppTheme.forestGreen
        case .roadmap: AppTheme.forestGreen
        case .career: .teal
        case .education: .blue
        case .family: .pink
        case .financial: AppTheme.gold
        case .documents: .orange
        case .readiness: AppTheme.forestGreen
        }
    }
}

struct PlanSidebarView: View {
    let storage: StorageService
    @State private var selection: PlanSidebarItem? = .overview

    var body: some View {
        NavigationSplitView {
            List(PlanSidebarItem.allCases, selection: $selection) { item in
                NavigationLink(value: item) {
                    Label {
                        Text(item.title)
                            .font(.body.weight(.semibold))
                    } icon: {
                        Image(systemName: item.icon)
                            .foregroundStyle(item.tint)
                    }
                }
            }
            .navigationTitle("Plan")
        } detail: {
            NavigationStack {
                detail(for: selection ?? .overview)
                    .navigationDestination(for: PlanningRoute.self) { route in
                        PlanRouteDestination(storage: storage, route: route)
                    }
                    .navigationDestination(for: TimelinePhase.self) { phase in
                        PhaseDetailView(storage: storage, phase: phase)
                    }
            }
        }
    }

    @ViewBuilder
    private func detail(for item: PlanSidebarItem) -> some View {
        switch item {
        case .overview: PlanView(storage: storage)
        case .roadmap: RoadmapView(storage: storage)
        case .career: CareerPlanningView(storage: storage)
        case .education: EducationPlanningView(storage: storage)
        case .family: FamilyPlanningView()
        case .financial: FinancialPlanningView()
        case .documents: DocumentsView(storage: storage)
        case .readiness: ReadinessDashboardView(storage: storage)
        }
    }
}

// MARK: - Tools iPad Sidebar

nonisolated enum ToolsSidebarItem: Hashable, Identifiable, Sendable, CaseIterable {
    case overview
    case money
    case career
    case planning
    case stateBenefits

    var id: Self { self }

    var title: String {
        switch self {
        case .overview: "All Tools"
        case .money: "Money"
        case .career: "Career"
        case .planning: "Planning"
        case .stateBenefits: "State Benefits"
        }
    }

    var icon: String {
        switch self {
        case .overview: "wrench.and.screwdriver.fill"
        case .money: "dollarsign.circle.fill"
        case .career: "briefcase.fill"
        case .planning: "calendar.badge.clock"
        case .stateBenefits: "map.fill"
        }
    }

    var tint: Color {
        switch self {
        case .overview: AppTheme.forestGreen
        case .money: AppTheme.gold
        case .career: .teal
        case .planning: .purple
        case .stateBenefits: .blue
        }
    }
}

struct ToolsSidebarView: View {
    let storage: StorageService
    var store: StoreViewModel
    @State private var selection: ToolsSidebarItem? = .overview

    var body: some View {
        NavigationSplitView {
            List(ToolsSidebarItem.allCases, selection: $selection) { item in
                NavigationLink(value: item) {
                    Label {
                        Text(item.title)
                            .font(.body.weight(.semibold))
                    } icon: {
                        Image(systemName: item.icon)
                            .foregroundStyle(item.tint)
                    }
                }
            }
            .navigationTitle("Tools")
        } detail: {
            NavigationStack {
                detail(for: selection ?? .overview)
            }
        }
    }

    @ViewBuilder
    private func detail(for item: ToolsSidebarItem) -> some View {
        switch item {
        case .overview, .money, .career, .planning, .stateBenefits:
            // For all categories we render the existing ToolboxView and let
            // its internal navigation handle category drill-downs.
            ToolboxView(storage: storage, store: store)
        }
    }
}

// MARK: - Plan Route Destination (shared)

struct PlanRouteDestination: View {
    let storage: StorageService
    let route: PlanningRoute

    var body: some View {
        switch route {
        case .career: CareerPlanningView(storage: storage)
        case .education: EducationPlanningView(storage: storage)
        case .family: FamilyPlanningView()
        case .financial: FinancialPlanningView()
        case .readiness: ReadinessDashboardView(storage: storage)
        case .roadmap: RoadmapView(storage: storage)
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
        case .tspGrowthEstimator: TSPGrowthEstimatorView()
        case .brsRetirementSnapshot: BRSRetirementSnapshotView()
        case .scraProtections: SCRAProtectionsView()
        case .financialReadiness: FinancialReadinessResourcesView()
        case .vaFundingFee: VAFundingFeeCalculatorView(storage: storage)
        case .vaHomeLoanGuide: VAHomeLoanGuideView(storage: storage)
        case .disabilityBenefits: DisabilityBenefitsView(storage: storage)
        case .vaHealthcareGuide: VAHealthcareGuideView()
        }
    }
}
