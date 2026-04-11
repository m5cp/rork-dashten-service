import SwiftUI

struct ToolboxView: View {
    let storage: StorageService
    @State private var activeSheet: ToolboxSheet?

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    readinessHeader

                    toolboxHero

                    financialToolsSection

                    careerToolsSection

                    educationToolsSection

                    relocationToolsSection

                    wellnessToolsSection

                    planningGuidesSection

                    resourcesSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Toolbox")
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

    private var readinessHeader: some View {
        NavigationLink(value: PlanningRoute.readiness) {
            HStack(spacing: 16) {
                ProgressRing(progress: readiness.overall, size: 56, lineWidth: 5)
                    .overlay {
                        Text("\(readiness.overallPercent)%")
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.forestGreen)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Transition Readiness")
                        .font(.headline.weight(.bold))
                    Text(readinessMessage)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.4))
            }
            .padding(16)
            .background(AppTheme.forestGreen.opacity(0.06))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var readinessMessage: String {
        let pct = readiness.overallPercent
        if pct >= 75 { return "Excellent progress. Keep it up!" }
        if pct >= 50 { return "Halfway there. Stay consistent." }
        if pct >= 25 { return "Good start. Focus on key areas." }
        return "Every step counts. Let's go."
    }

    private var toolboxHero: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Interactive Tools")
                    .font(.title3.weight(.bold))
            }
            Text("Calculators, trackers, and planners to take action — not just read about it.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            LinearGradient(
                colors: [AppTheme.forestGreen.opacity(0.08), AppTheme.gold.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
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
            ToolboxNavRow(title: "TSP Rollover Advisor", subtitle: "Compare your rollover options", icon: "arrow.triangle.swap", color: .blue, route: .tspRollover)
            ToolboxNavRow(title: "Salary Negotiation Calculator", subtitle: "Compare total compensation packages", icon: "scalemass.fill", color: .indigo, route: .salaryNegotiation)
            ToolboxNavRow(title: "Cost of Living Comparator", subtitle: "Compare cities side by side", icon: "building.2.fill", color: .mint, route: .costOfLiving)
        }
    }

    private var careerToolsSection: some View {
        ToolboxSection(title: "Career", icon: "briefcase.fill", color: .teal) {
            ToolboxNavRow(title: "Resume Translator", subtitle: "Military to civilian language", icon: "doc.text.fill", color: .teal, route: .resumeTranslator)
            ToolboxNavRow(title: "Interview Prep", subtitle: "Practice behavioral questions", icon: "person.fill.questionmark", color: .blue, route: .interviewPrep)
            ToolboxNavRow(title: "Networking Scorecard", subtitle: "Track weekly connections", icon: "person.3.fill", color: .purple, route: .networkingScorecard)
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

    private var wellnessToolsSection: some View {
        ToolboxSection(title: "Wellness & Tracking", icon: "heart.fill", color: .red) {
            ToolboxNavRow(title: "Transition Journal", subtitle: "Daily guided prompts", icon: "book.fill", color: .purple, route: .transitionJournal)
            ToolboxNavRow(title: "90-Day Goal Tracker", subtitle: "Set and track your top goals", icon: "target", color: AppTheme.forestGreen, route: .goalTracker)
            ToolboxNavRow(title: "Weekly Check-In", subtitle: "Track your well-being over time", icon: "chart.xyaxis.line", color: .blue, route: .weeklyCheckIn)
        }
    }

    private var planningGuidesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Planning Guides")
                .font(.headline.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                PlanGridCard(title: "Career", icon: "briefcase.fill", color: .teal, route: .career)
                PlanGridCard(title: "Education", icon: "graduationcap.fill", color: .blue, route: .education)
                PlanGridCard(title: "Family", icon: "figure.2.and.child.holdinghands", color: .pink, route: .family)
                PlanGridCard(title: "Financial", icon: "dollarsign.circle.fill", color: AppTheme.gold, route: .financial)
            }
        }
    }

    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resources")
                .font(.headline.weight(.bold))

            VStack(spacing: 8) {
                PlanListRow(title: "First 30 Days", subtitle: "Week-by-week survival guide", icon: "flag.fill", color: .purple, route: .firstThirtyDays)
                PlanListRow(title: "Mindset Shifts", subtitle: "Navigate the mental side", icon: "brain.fill", color: .purple, route: .mindsetShifts)
                PlanListRow(title: "Civilian Playbook", subtitle: "Unwritten rules of civilian life", icon: "book.closed.fill", color: .blue, route: .civilianPlaybook)
                PlanListRow(title: "Readiness Check-In", subtitle: "Quick self-assessment", icon: "checklist.checked", color: .teal, route: .selfAssessment)
                PlanListRow(title: "Final Gear Check", subtitle: "Pre-separation review", icon: "checkmark.shield.fill", color: .orange, route: .finalGearCheck)
                PlanListRow(title: "Mentor Tracker", subtitle: "Build your civilian network", icon: "person.2.fill", color: .pink, route: .mentorTracker)
                PlanListRow(title: "Documents", subtitle: "Track your transition paperwork", icon: "doc.text.fill", color: .orange, route: .documents)
            }
        }
    }
}

enum ToolboxSheet: String, Identifiable {
    case compensation, incomeGap, civilianBudget, emergencyFund
    var id: String { rawValue }
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
                    .foregroundStyle(.primary.opacity(0.6))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary.opacity(0.4))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
