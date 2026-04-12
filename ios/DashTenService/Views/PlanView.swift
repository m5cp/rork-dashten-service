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

    private var urgentTasks: [ChecklistItem] {
        Array(currentPhaseTasks.filter { !$0.isCompleted }.prefix(3))
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

    private var securedDocs: Int {
        storage.documents.filter { $0.status == .verified || $0.status == .received }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    missionBriefing
                    priorityActions
                    planningAreas
                    documentsSection
                    firstYearGuideCard
                    timelineRoadmap
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
        case .firstYearGuide: FirstYearGuideView()
        case .aiCoach: AICoachView()
        }
    }

    // MARK: - Mission Briefing

    private var missionBriefing: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(currentPhase.rawValue)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(phaseGuidance)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                NavigationLink(value: PlanningRoute.readiness) {
                    ProgressRing(progress: readiness.overall, size: 60, lineWidth: 5, color: AppTheme.gold)
                        .overlay {
                            Text("\(readiness.overallPercent)%")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(20)

            HStack(spacing: 0) {
                briefingStat(
                    value: "\(overallCompleted)/\(overallTotal)",
                    label: "Tasks Done",
                    icon: "checkmark.circle.fill"
                )
                briefingDivider
                briefingStat(
                    value: "\(securedDocs)/\(storage.documents.count)",
                    label: "Docs Secured",
                    icon: "doc.text.fill"
                )
                briefingDivider
                briefingStat(
                    value: "\(storage.benefitCategories.filter(\.isStarted).count)",
                    label: "Benefits Started",
                    icon: "star.fill"
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(AppTheme.heroMesh)
        .clipShape(.rect(cornerRadius: 20))
    }

    private func briefingStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }

    private var briefingDivider: some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(width: 1, height: 30)
    }

    private var phaseGuidance: String {
        switch currentPhase {
        case .eighteenToTwentyFour:
            return "Start planning early. Build your foundation now while you have time."
        case .twelveMonths:
            return "Lock in your education path, update your resume, and start networking."
        case .sixMonths:
            return "Time to finalize plans. File claims, apply to programs, secure housing."
        case .ninetyDays:
            return "Final push. Complete medical exams, confirm orders, and tie up loose ends."
        case .thirtyDays:
            return "Last-minute essentials. Verify DD214, set up civilian accounts."
        case .firstNinety:
            return "Stabilize first. Enroll in health care, file claims, build your routine."
        case .firstYear:
            return "Settle in. Review your plan, adjust your budget, follow up on claims."
        }
    }

    // MARK: - Priority Actions

    private var priorityActions: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "scope")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Do Now")
                    .font(.headline.weight(.bold))
                Spacer()
                if !urgentTasks.isEmpty {
                    let phaseComplete = currentPhaseTasks.filter(\.isCompleted).count
                    let phaseTotal = currentPhaseTasks.count
                    Text("\(phaseComplete)/\(phaseTotal) done")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
            }

            if urgentTasks.isEmpty {
                HStack(spacing: 14) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.forestGreen)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phase complete!")
                            .font(.subheadline.weight(.bold))
                        Text("All tasks for this phase are done. Review the timeline below for upcoming phases.")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(16)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 14))
            } else {
                VStack(spacing: 8) {
                    ForEach(urgentTasks) { item in
                        PlanTaskRow(item: item, storage: storage)
                    }
                }

                if currentPhaseTasks.filter({ !$0.isCompleted }).count > 3 {
                    NavigationLink(value: currentPhase) {
                        HStack {
                            Text("See all \(currentPhaseTasks.filter { !$0.isCompleted }.count) tasks")
                                .font(.subheadline.weight(.semibold))
                            Image(systemName: "arrow.right")
                                .font(.caption.weight(.bold))
                        }
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppTheme.forestGreen.opacity(0.06))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Planning Areas

    private var planningAreas: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Planning Areas")
                .font(.headline.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                PlanAreaCard(
                    title: "Career",
                    icon: "briefcase.fill",
                    color: .teal,
                    progress: readiness.categories[.employment] ?? 0,
                    route: .career
                )
                PlanAreaCard(
                    title: "Education",
                    icon: "graduationcap.fill",
                    color: .blue,
                    progress: readiness.categories[.education] ?? 0,
                    route: .education
                )
                PlanAreaCard(
                    title: "Family",
                    icon: "figure.2.and.child.holdinghands",
                    color: .pink,
                    progress: readiness.categories[.family] ?? 0,
                    route: .family
                )
                PlanAreaCard(
                    title: "Financial",
                    icon: "dollarsign.circle.fill",
                    color: AppTheme.gold,
                    progress: readiness.categories[.finance] ?? 0,
                    route: .financial
                )
            }
        }
    }

    // MARK: - Documents

    private var documentsSection: some View {
        NavigationLink(value: PlanningRoute.documents) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.orange.opacity(0.12))
                        .frame(width: 48, height: 48)

                    let docProgress = storage.documents.isEmpty ? 0.0 : Double(securedDocs) / Double(storage.documents.count)
                    Circle()
                        .trim(from: 0, to: docProgress)
                        .stroke(.orange, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 48, height: 48)

                    Image(systemName: "doc.text.fill")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.orange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Documents")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("\(securedDocs) of \(storage.documents.count) secured")
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

    // MARK: - Timeline Roadmap

    private var firstYearGuideCard: some View {
        NavigationLink(value: PlanningRoute.firstYearGuide) {
            HStack(spacing: 14) {
                Image(systemName: "star.circle.fill")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("First Year Guide")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Quarter-by-quarter roadmap for your first 12 months")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [AppTheme.forestGreen.opacity(0.08), AppTheme.forestGreen.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(AppTheme.forestGreen.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var timelineRoadmap: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Your Roadmap")
                    .font(.headline.weight(.bold))
                Spacer()
            }

            VStack(spacing: 0) {
                ForEach(Array(TimelinePhase.allCases.enumerated()), id: \.element.id) { index, phase in
                    let items = storage.checklistItems.filter { $0.phase == phase }
                    let completed = items.filter(\.isCompleted).count
                    let total = items.count
                    let isCurrent = phase == currentPhase
                    let isLast = index == TimelinePhase.allCases.count - 1
                    let isPast = isPhaseCompleted(phase)

                    NavigationLink(value: phase) {
                        RoadmapRow(
                            phase: phase,
                            completed: completed,
                            total: total,
                            isCurrent: isCurrent,
                            isPast: isPast,
                            isLast: isLast
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
    }

    private func isPhaseCompleted(_ phase: TimelinePhase) -> Bool {
        let allPhases = TimelinePhase.allCases
        guard let currentIdx = allPhases.firstIndex(of: currentPhase),
              let phaseIdx = allPhases.firstIndex(of: phase) else { return false }
        return phaseIdx < currentIdx
    }

    // MARK: - Add Item Sheet

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

// MARK: - Planning Area Card

struct PlanAreaCard: View {
    let title: String
    let icon: String
    let color: Color
    let progress: Double
    let route: PlanningRoute

    var body: some View {
        NavigationLink(value: route) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(color.gradient)
                        .clipShape(.rect(cornerRadius: 10))

                    Spacer()

                    Text("\(Int(progress * 100))%")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(progress > 0 ? color : Color(.tertiaryLabel))
                }

                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(color.opacity(0.12))
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(color)
                            .frame(width: proxy.size.width * min(progress, 1.0), height: 5)
                            .animation(.spring(response: 0.5), value: progress)
                    }
                }
                .frame(height: 5)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Roadmap Row

struct RoadmapRow: View {
    let phase: TimelinePhase
    let completed: Int
    let total: Int
    let isCurrent: Bool
    let isPast: Bool
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
                            .fill(AppTheme.forestGreen.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Circle()
                            .fill(AppTheme.forestGreen)
                            .frame(width: 20, height: 20)
                        Image(systemName: "location.fill")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                    } else if isDone {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(AppTheme.forestGreen)
                    } else if isPast {
                        Circle()
                            .fill(AppTheme.forestGreen.opacity(0.4))
                            .frame(width: 14, height: 14)
                    } else {
                        Circle()
                            .stroke(Color(.quaternaryLabel), lineWidth: 2)
                            .frame(width: 14, height: 14)
                    }
                }
                .frame(width: 32, height: 32)

                if !isLast {
                    Rectangle()
                        .fill(isPast || isDone ? AppTheme.forestGreen.opacity(0.3) : Color(.quaternaryLabel))
                        .frame(width: 2, height: 24)
                }
            }
            .frame(width: 32)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(phase.rawValue)
                        .font(.subheadline.weight(isCurrent ? .bold : .semibold))
                        .foregroundStyle(isCurrent ? .primary : .secondary)

                    if isCurrent {
                        Text("NOW")
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppTheme.forestGreen)
                            .clipShape(Capsule())
                    }
                }

                HStack(spacing: 6) {
                    Text("\(completed)/\(total)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.tertiary)

                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(AppTheme.forestGreen.opacity(0.1))
                                .frame(height: 3)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(AppTheme.forestGreen)
                                .frame(width: proxy.size.width * progress, height: 3)
                        }
                    }
                    .frame(height: 3)
                }
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

// MARK: - Task Row (reused)

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
