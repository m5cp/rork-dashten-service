import SwiftUI

struct PlanView: View {
    let storage: StorageService
    @State private var showAddItem: Bool = false
    @State private var newItemTitle: String = ""
    @State private var newItemPhase: TimelinePhase = .eighteenToTwentyFour
    @State private var newItemCategory: ReadinessCategory = .admin

    private var currentPhase: TimelinePhase {
        guard let sepDate = storage.profile.separationDate else { return .eighteenToTwentyFour }
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

    private var currentPhaseTasks: [ChecklistItem] {
        storage.checklistItems.filter { $0.phase == currentPhase }
    }

    private var incompleteTasks: [ChecklistItem] {
        currentPhaseTasks.filter { !$0.isCompleted }
    }

    private var completedTasks: [ChecklistItem] {
        currentPhaseTasks.filter(\.isCompleted)
    }

    private var overallCompleted: Int {
        storage.checklistItems.filter(\.isCompleted).count
    }

    private var overallTotal: Int {
        storage.checklistItems.count
    }

    private var overallProgress: Double {
        guard overallTotal > 0 else { return 0 }
        return Double(overallCompleted) / Double(overallTotal)
    }

    private var missingDocs: Int {
        storage.documents.filter { $0.status == .missing }.count
    }

    private var verifiedDocs: Int {
        storage.documents.filter { $0.status == .verified || $0.status == .received }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    phaseHeader

                    if !incompleteTasks.isEmpty {
                        todoSection
                    }

                    if !completedTasks.isEmpty {
                        doneSection
                    }

                    documentsCard

                    timelineOverview
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

    private var phaseHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 14) {
                Image(systemName: currentPhase.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text("You are here")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .textCase(.uppercase)
                    Text(currentPhase.rawValue)
                        .font(.title3.weight(.bold))
                }

                Spacer()
            }

            VStack(spacing: 8) {
                HStack {
                    Text("\(overallCompleted) of \(overallTotal) tasks done")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(Int(overallProgress * 100))%")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.forestGreen.opacity(0.12))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.forestGreen)
                            .frame(width: proxy.size.width * overallProgress, height: 8)
                            .animation(.spring(response: 0.5), value: overallProgress)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var todoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("To Do")
                    .font(.title3.weight(.bold))
                Text("\(incompleteTasks.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.orange)
                    .clipShape(Capsule())
                Spacer()
            }

            VStack(spacing: 6) {
                ForEach(incompleteTasks) { item in
                    PlanTaskRow(item: item, storage: storage)
                }
            }
        }
    }

    private var doneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Done")
                    .font(.title3.weight(.bold))
                Text("\(completedTasks.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(AppTheme.forestGreen)
                    .clipShape(Capsule())
                Spacer()
            }

            VStack(spacing: 6) {
                ForEach(completedTasks) { item in
                    PlanTaskRow(item: item, storage: storage)
                }
            }
        }
    }

    private var documentsCard: some View {
        NavigationLink(value: PlanningRoute.documents) {
            HStack(spacing: 14) {
                Image(systemName: "doc.text.fill")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.orange)
                    .frame(width: 44, height: 44)
                    .background(.orange.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Documents")
                        .font(.headline.weight(.bold))
                    Text("\(verifiedDocs) of \(storage.documents.count) secured")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if missingDocs > 0 {
                    Text("\(missingDocs) missing")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.orange.opacity(0.12))
                        .clipShape(Capsule())
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

    private var timelineOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Full Timeline")
                .font(.title3.weight(.bold))

            VStack(spacing: 0) {
                ForEach(Array(TimelinePhase.allCases.enumerated()), id: \.element.id) { index, phase in
                    let items = storage.checklistItems.filter { $0.phase == phase }
                    let completed = items.filter(\.isCompleted).count
                    let total = items.count
                    let isCurrent = phase == currentPhase
                    let isLast = index == TimelinePhase.allCases.count - 1

                    NavigationLink(value: phase) {
                        SimpleTimelineRow(
                            phase: phase,
                            completed: completed,
                            total: total,
                            isCurrent: isCurrent,
                            isLast: isLast
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
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

struct PlanTaskRow: View {
    let item: ChecklistItem
    let storage: StorageService

    private var categoryColor: Color {
        switch item.readinessCategory {
        case .admin: .gray
        case .health: .red
        case .education: .blue
        case .employment: .teal
        case .family: .pink
        case .finance: Color(red: 0.788, green: 0.659, blue: 0.298)
        case .housing: Color(red: 0.176, green: 0.373, blue: 0.176)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    storage.toggleChecklistItem(item.id)
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : Color(.tertiaryLabel))
                    .symbolEffect(.bounce, value: item.isCompleted)
            }
            .sensoryFeedback(.success, trigger: item.isCompleted)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(item.readinessCategory.shortLabel)
                .font(.caption2.weight(.bold))
                .foregroundStyle(categoryColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(categoryColor.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
        .contextMenu {
            Button {
                withAnimation { storage.toggleChecklistItem(item.id) }
            } label: {
                Label(item.isCompleted ? "Mark Incomplete" : "Mark Complete",
                      systemImage: item.isCompleted ? "circle" : "checkmark.circle.fill")
            }
            if item.isCustom {
                Button(role: .destructive) {
                    storage.removeChecklistItem(item.id)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}

struct SimpleTimelineRow: View {
    let phase: TimelinePhase
    let completed: Int
    let total: Int
    let isCurrent: Bool
    let isLast: Bool

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }

    private var isDone: Bool {
        total > 0 && completed == total
    }

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(spacing: 0) {
                ZStack {
                    if isCurrent {
                        Circle()
                            .fill(AppTheme.forestGreen)
                            .frame(width: 28, height: 28)
                        Image(systemName: "location.fill")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                    } else if isDone {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(AppTheme.forestGreen)
                    } else {
                        Circle()
                            .stroke(Color(.quaternaryLabel), lineWidth: 2)
                            .frame(width: 18, height: 18)
                    }
                }
                .frame(width: 28, height: 28)

                if !isLast {
                    Rectangle()
                        .fill(isDone ? AppTheme.forestGreen.opacity(0.3) : Color(.quaternaryLabel))
                        .frame(width: 2, height: 32)
                }
            }
            .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(phase.rawValue)
                        .font(.subheadline.weight(isCurrent ? .bold : .semibold))
                        .foregroundStyle(isCurrent ? .primary : .secondary)

                    if isCurrent {
                        Text("NOW")
                            .font(.caption2.weight(.heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppTheme.forestGreen)
                            .clipShape(Capsule())
                    }
                }

                Text("\(completed)/\(total) tasks")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.quaternary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
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
