import SwiftUI

struct PlanView: View {
    let storage: StorageService
    @State private var showAddItem: Bool = false
    @State private var newItemTitle: String = ""
    @State private var newItemPhase: TimelinePhase = .eighteenToTwentyFour
    @State private var newItemCategory: ReadinessCategory = .admin

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
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

    private func itemsForPhase(_ phase: TimelinePhase) -> [ChecklistItem] {
        storage.checklistItems.filter { $0.phase == phase }
    }

    private func completionForPhase(_ phase: TimelinePhase) -> Double {
        let items = itemsForPhase(phase)
        guard !items.isEmpty else { return 0 }
        return Double(items.filter(\.isCompleted).count) / Double(items.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    readinessOverview

                    categoryRingsSection

                    documentsCard

                    roadmapSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Plan")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddItem = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(AppTheme.forestGreen)
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                addItemSheet
            }
            .navigationDestination(for: TimelinePhase.self) { phase in
                PhaseDetailView(storage: storage, phase: phase)
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

    private var readinessOverview: some View {
        NavigationLink(value: PlanningRoute.readiness) {
            HStack(spacing: 20) {
                ProgressRing(progress: readiness.overall, size: 72, lineWidth: 7)
                    .overlay {
                        VStack(spacing: 0) {
                            Text("\(readiness.overallPercent)")
                                .font(.title3.bold())
                                .foregroundStyle(AppTheme.forestGreen)
                            Text("%")
                                .font(.caption2.bold())
                                .foregroundStyle(AppTheme.forestGreen.opacity(0.7))
                        }
                    }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Transition Readiness")
                        .font(.title3.weight(.bold))
                    Text(readinessMessage)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        MiniStat(value: "\(storage.checklistItems.filter(\.isCompleted).count)", label: "Done", color: AppTheme.forestGreen)
                        MiniStat(value: "\(storage.checklistItems.count - storage.checklistItems.filter(\.isCompleted).count)", label: "Left", color: .orange)
                    }
                    .padding(.top, 2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
        .buttonStyle(.plain)
    }

    private var readinessMessage: String {
        let pct = readiness.overallPercent
        if pct >= 75 { return "Excellent progress. Almost there." }
        if pct >= 50 { return "Halfway there. Stay consistent." }
        if pct >= 25 { return "Good start. Focus on key areas." }
        return "Every step counts. Let's go."
    }

    private var categoryRingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("By Category")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 14) {
                ForEach(ReadinessCategory.allCases) { category in
                    let pct = readiness.percent(for: category)
                    VStack(spacing: 8) {
                        ProgressRing(progress: Double(pct) / 100.0, size: 44, lineWidth: 4, color: colorForCategory(category))
                            .overlay {
                                Image(systemName: category.icon)
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(colorForCategory(category))
                            }
                        Text(category.shortLabel)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
    }

    private var documentsCard: some View {
        NavigationLink(value: PlanningRoute.documents) {
            let missingCount = storage.documents.filter { $0.status == .missing }.count
            let verifiedCount = storage.documents.filter { $0.status == .verified || $0.status == .received }.count
            let total = storage.documents.count
            let progress = total > 0 ? Double(verifiedCount) / Double(total) : 0

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.orange.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: "doc.text.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.orange)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Documents")
                        .font(.headline.weight(.bold))

                    ProgressView(value: progress)
                        .tint(.orange)

                    HStack {
                        Text("\(verifiedCount)/\(total) secured")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer()
                        if missingCount > 0 {
                            Text("\(missingCount) missing")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.orange)
                        }
                    }
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var roadmapSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Timeline")
                .font(.title3.weight(.bold))

            VStack(spacing: 0) {
                ForEach(Array(TimelinePhase.allCases.enumerated()), id: \.element.id) { index, phase in
                    let isCurrent = phase == currentPhase
                    let isPast = isPhaseCompleted(phase)
                    let isLast = index == TimelinePhase.allCases.count - 1

                    NavigationLink(value: phase) {
                        TimelineRow(
                            phase: phase,
                            completion: completionForPhase(phase),
                            itemCount: itemsForPhase(phase).count,
                            completedCount: itemsForPhase(phase).filter(\.isCompleted).count,
                            isCurrent: isCurrent,
                            isPast: isPast,
                            isLast: isLast
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func isPhaseCompleted(_ phase: TimelinePhase) -> Bool {
        guard let current = currentPhase else { return false }
        let allPhases = TimelinePhase.allCases
        guard let currentIdx = allPhases.firstIndex(of: current),
              let phaseIdx = allPhases.firstIndex(of: phase) else { return false }
        return phaseIdx < currentIdx
    }

    private func colorForCategory(_ category: ReadinessCategory) -> Color {
        switch category {
        case .admin: .gray
        case .health: .red
        case .education: .blue
        case .employment: .teal
        case .family: .pink
        case .finance: AppTheme.gold
        case .housing: AppTheme.forestGreen
        }
    }

    private var addItemSheet: some View {
        NavigationStack {
            Form {
                Section("New Task") {
                    TextField("Task title", text: $newItemTitle)
                }
                Section("Phase") {
                    Picker("Timeline Phase", selection: $newItemPhase) {
                        ForEach(TimelinePhase.allCases) { phase in
                            Text(phase.rawValue).tag(phase)
                        }
                    }
                }
                Section("Category") {
                    Picker("Category", selection: $newItemCategory) {
                        ForEach(ReadinessCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Add Custom Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAddItem = false
                        newItemTitle = ""
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        storage.addCustomChecklistItem(
                            title: newItemTitle.trimmingCharacters(in: .whitespaces),
                            phase: newItemPhase,
                            category: newItemCategory
                        )
                        newItemTitle = ""
                        showAddItem = false
                    }
                    .disabled(newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct MiniStat: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
        }
    }
}
