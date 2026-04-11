import SwiftUI

struct TodayView: View {
    let storage: StorageService
    @State private var showCelebration: Bool = false
    @State private var celebrationTitle: String = ""
    @State private var celebrationSubtitle: String = ""
    @State private var previousReadinessPercent: Int = 0

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    private var nextActions: [ChecklistItem] {
        let phase = currentPhase
        let phaseItems = phase != nil
            ? storage.checklistItems.filter { !$0.isCompleted && $0.phase == phase }
            : []
        let allIncomplete = storage.checklistItems.filter { !$0.isCompleted }
        let source = phaseItems.isEmpty ? allIncomplete : phaseItems
        return Array(source.prefix(3))
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
        if let phase = currentPhase {
            let phaseCards = cards.filter { card in
                switch phase {
                case .eighteenToTwentyFour, .twelveMonths:
                    return card.category == .wishIKnew || card.category == .forgottenDoc
                case .sixMonths, .ninetyDays, .thirtyDays:
                    return card.category == .commonMistake || card.category == .forgottenDoc
                case .firstNinety, .firstYear:
                    return card.category == .benefitSpotlight || card.category == .wishIKnew
                }
            }
            if !phaseCards.isEmpty {
                let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
                return phaseCards[dayOfYear % phaseCards.count]
            }
        }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return cards[dayOfYear % cards.count]
    }

    private var completedTaskCount: Int {
        storage.checklistItems.filter(\.isCompleted).count
    }

    private var missingDocsCount: Int {
        storage.documents.filter { $0.status == .missing }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroSection
                    quickStatsBar
                    nextActionsSection
                    insightSpotlight
                    mindsetSpotlight
                    crisisQuickAccess
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .navigationDestination(for: PlanningRoute.self) { route in
                routeDestination(route)
            }
        }
        .overlay {
            CelebrationOverlay(
                isShowing: $showCelebration,
                title: celebrationTitle,
                subtitle: celebrationSubtitle
            )
        }
        .onChange(of: readiness.overallPercent) { oldValue, newValue in
            checkMilestone(old: oldValue, new: newValue)
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
        }
    }

    private var heroSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(personalGreeting)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    if !storage.profile.displayName.isEmpty {
                        Text(storage.profile.displayName)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                    if let branch = storage.profile.branch {
                        Text(branch.rawValue)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
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
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            if let date = storage.profile.separationDate {
                countdownSection(date: date)
            } else {
                noDatePrompt
            }
        }
        .background(AppTheme.heroMesh)
        .clipShape(.rect(cornerRadius: 20))
    }

    private var personalGreeting: String {
        let greeting = AppTheme.timeOfDayGreeting()
        if storage.profile.displayName.isEmpty {
            return greeting
        }
        return "\(greeting),"
    }

    private func countdownSection(date: Date) -> some View {
        let info = countdownInfo(for: date)
        return HStack(spacing: 16) {
            HStack(spacing: 10) {
                Text("\(info.days)")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                VStack(alignment: .leading, spacing: 2) {
                    Text(info.days == 1 ? "day" : "days")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                    Text(info.label)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }

            Spacer()

            if let phase = currentPhase {
                VStack(alignment: .trailing, spacing: 3) {
                    Text(phase.rawValue)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                    Text(phase.subtitle)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var noDatePrompt: some View {
        HStack {
            Image(systemName: "calendar.badge.plus")
                .foregroundStyle(.white.opacity(0.85))
            Text("Set your separation date in Profile to see countdown")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private func countdownInfo(for date: Date) -> (days: Int, label: String) {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days > 0 { return (days, "until separation") }
        if days == 0 { return (0, "separation day") }
        return (abs(days), "since separation")
    }

    private var quickStatsBar: some View {
        HStack(spacing: 10) {
            CompactStatCard(
                icon: "checkmark.circle.fill",
                value: "\(completedTaskCount)/\(storage.checklistItems.count)",
                label: "Tasks",
                color: AppTheme.forestGreen
            )
            CompactStatCard(
                icon: "doc.text.fill",
                value: "\(missingDocsCount)",
                label: "Docs Missing",
                color: missingDocsCount > 0 ? .orange : AppTheme.forestGreen
            )
            CompactStatCard(
                icon: "star.fill",
                value: "\(storage.benefitCategories.filter(\.isStarted).count)",
                label: "Benefits",
                color: .blue
            )
        }
    }

    private var nextActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bolt.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Priority Actions")
                    .font(.headline.weight(.bold))
                Spacer()
                if let phase = currentPhase {
                    StatusBadge(text: phase.shortLabel, color: AppTheme.forestGreen)
                }
            }

            if nextActions.isEmpty {
                emptyActionsCard
            } else {
                VStack(spacing: 8) {
                    ForEach(nextActions) { item in
                        actionRow(item)
                    }
                }
            }
        }
    }

    private var emptyActionsCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(AppTheme.gold)
                .symbolEffect(.pulse)

            VStack(alignment: .leading, spacing: 4) {
                Text("All caught up!")
                    .font(.subheadline.weight(.bold))
                Text("You're \(readiness.overallPercent)% transition ready. Keep checking in as your timeline progresses.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
            Spacer()
        }
        .padding(16)
        .background(AppTheme.gold.opacity(0.08))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func actionRow(_ item: ChecklistItem) -> some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    storage.toggleChecklistItem(item.id)
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : .primary.opacity(0.4))
                    .symbolEffect(.bounce, value: item.isCompleted)
            }
            .sensoryFeedback(.success, trigger: item.isCompleted)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? Color.primary.opacity(0.5) : Color.primary)
                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.6))
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
        .contextMenu {
            Button {
                withAnimation { storage.toggleChecklistItem(item.id) }
            } label: {
                Label(item.isCompleted ? "Mark Incomplete" : "Mark Complete",
                      systemImage: item.isCompleted ? "circle" : "checkmark.circle.fill")
            }
        }
    }

    private var insightSpotlight: some View {
        Group {
            if let card = insightCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Daily Insight", icon: "lightbulb.fill")

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            StatusBadge(text: card.category.rawValue, color: AppTheme.gold)
                            Spacer()
                        }
                        Text(card.title)
                            .font(.subheadline.weight(.bold))
                        Text(card.body)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.gold.opacity(0.08), AppTheme.gold.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 14))
                }
            }
        }
    }

    private var mindsetSpotlight: some View {
        Group {
            let shifts = TransitionDataService.mindsetShifts()
            if !shifts.isEmpty {
                let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
                let shift = shifts[dayOfYear % shifts.count]
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Mindset Shift", icon: "brain.fill")
                    NavigationLink(value: PlanningRoute.mindsetShifts) {
                        HStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 6) {
                                StatusBadge(text: shift.category.rawValue, color: .purple)
                                Text(shift.title)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)
                                Text(shift.insight)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.primary.opacity(0.7))
                                    .lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.primary.opacity(0.4))
                        }
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var crisisQuickAccess: some View {
        NavigationLink(value: PlanningRoute.crisis) {
            HStack(spacing: 12) {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundStyle(.red)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Need support?")
                        .font(.subheadline.weight(.bold))
                    Text("Crisis Lifeline: call or text 988")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private func checkMilestone(old: Int, new: Int) {
        let thresholds = [25, 50, 75, 100]
        for t in thresholds {
            if old < t && new >= t {
                celebrationTitle = new >= 100 ? "Fully Prepared!" : "\(t)% Ready!"
                celebrationSubtitle = new >= 100
                    ? "You've completed your entire transition plan. Incredible work."
                    : "You've hit a major milestone. Your preparation is paying off."
                withAnimation(.spring) { showCelebration = true }
                return
            }
        }
    }
}
