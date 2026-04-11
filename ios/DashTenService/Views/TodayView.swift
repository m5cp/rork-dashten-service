import SwiftUI

struct TodayView: View {
    let storage: StorageService
    @State private var showCelebration: Bool = false
    @State private var celebrationTitle: String = ""
    @State private var celebrationSubtitle: String = ""
    @State private var appeared: Bool = false

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    private var focusAction: ChecklistItem? {
        let phase = currentPhase
        let phaseItems = phase != nil
            ? storage.checklistItems.filter { !$0.isCompleted && $0.phase == phase }
            : []
        let allIncomplete = storage.checklistItems.filter { !$0.isCompleted }
        let source = phaseItems.isEmpty ? allIncomplete : phaseItems
        return source.first
    }

    private var nextActions: [ChecklistItem] {
        let phase = currentPhase
        let phaseItems = phase != nil
            ? storage.checklistItems.filter { !$0.isCompleted && $0.phase == phase }
            : []
        let allIncomplete = storage.checklistItems.filter { !$0.isCompleted }
        let source = phaseItems.isEmpty ? allIncomplete : phaseItems
        return Array(source.dropFirst().prefix(2))
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

    private var streakDays: Int {
        let calendar = Calendar.current
        var streak = 0
        if !storage.weeklyCheckIns.isEmpty || completedTaskCount > 0 {
            streak = max(1, storage.weeklyCheckIns.count)
        }
        if !storage.journalEntries.isEmpty {
            let today = calendar.startOfDay(for: Date())
            for i in 0..<30 {
                guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { break }
                let hasEntry = storage.journalEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
                if hasEntry { streak = max(streak, i + 1) } else if i > 0 { break }
            }
        }
        return streak
    }

    private var weeklyActivity: [Bool] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).reversed().map { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return false }
            let hasJournal = storage.journalEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let hasCheckIn = storage.weeklyCheckIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
            return hasJournal || hasCheckIn || (offset == 0 && completedTaskCount > 0)
        }
    }

    private var heroStyle: HeroStyle {
        guard let sepDate = storage.profile.separationDate else { return .standard }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: sepDate).day ?? 0
        if days <= 30 && days > 0 { return .urgent }
        if days <= 0 { return .postSeparation }
        return .standard
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroSection
                    focusCardSection
                    weeklyActivitySection
                    quickStatsBar
                    nextActionsSection
                    insightSpotlight
                    mindsetSpotlight
                    firstRunCards
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
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
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
        .background(heroStyle == .urgent ? AppTheme.urgentHeroMesh : AppTheme.heroMesh)
        .clipShape(.rect(cornerRadius: 20))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
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
                        .foregroundStyle(heroStyle == .urgent ? .white : AppTheme.gold)
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

    private var focusCardSection: some View {
        Group {
            if let focus = focusAction {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "scope")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("YOUR FOCUS")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(AppTheme.forestGreen)
                        Spacer()
                        if let phase = currentPhase {
                            StatusBadge(text: phase.shortLabel, color: AppTheme.forestGreen)
                        }
                    }

                    HStack(spacing: 14) {
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                storage.toggleChecklistItem(focus.id)
                            }
                        } label: {
                            Image(systemName: focus.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(focus.isCompleted ? AppTheme.forestGreen : .primary.opacity(0.3))
                                .symbolEffect(.bounce, value: focus.isCompleted)
                        }
                        .sensoryFeedback(.success, trigger: focus.isCompleted)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(focus.title)
                                .font(.headline.weight(.bold))
                                .strikethrough(focus.isCompleted)
                            if !focus.subtitle.isEmpty {
                                Text(focus.subtitle)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Text(focusReason)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.forestGreen)
                                .padding(.top, 2)
                        }
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(AppTheme.forestGreen.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(AppTheme.forestGreen.opacity(0.15), lineWidth: 1)
                        )
                )
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)
                .animation(.spring(response: 0.6).delay(0.15), value: appeared)
            }
        }
    }

    private var focusReason: String {
        guard let phase = currentPhase else { return "Start with this one" }
        switch phase {
        case .eighteenToTwentyFour, .twelveMonths:
            return "Foundation work — gets harder to do later"
        case .sixMonths:
            return "Critical phase — lock this in now"
        case .ninetyDays:
            return "Time-sensitive — don't delay"
        case .thirtyDays:
            return "Last-minute essential"
        case .firstNinety:
            return "Priority for your first 90 days"
        case .firstYear:
            return "Important for settling in"
        }
    }

    private var weeklyActivitySection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("This Week")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                HStack(spacing: 6) {
                    ForEach(Array(weeklyActivity.enumerated()), id: \.offset) { index, active in
                        let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(active ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.1))
                                .frame(width: 28, height: 28)
                                .overlay {
                                    if active {
                                        Image(systemName: "checkmark")
                                            .font(.caption2.weight(.bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            Text(dayLabels[index % 7])
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }

            Spacer()

            VStack(spacing: 4) {
                Text("\(streakDays)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.gold)
                Text(streakDays == 1 ? "day" : "days")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.gold)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.2), value: appeared)
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
                value: "\(storage.documents.filter { $0.status == .missing }.count)",
                label: "Docs Missing",
                color: storage.documents.filter({ $0.status == .missing }).count > 0 ? .orange : AppTheme.forestGreen
            )
            CompactStatCard(
                icon: "star.fill",
                value: "\(storage.benefitCategories.filter(\.isStarted).count)",
                label: "Benefits",
                color: .blue
            )
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.25), value: appeared)
    }

    private var nextActionsSection: some View {
        Group {
            if !nextActions.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("Up Next")
                            .font(.headline.weight(.bold))
                        Spacer()
                    }

                    VStack(spacing: 8) {
                        ForEach(nextActions) { item in
                            actionRow(item)
                        }
                    }
                }
            } else if focusAction == nil {
                emptyActionsCard
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
                    .foregroundStyle(.secondary)
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
                        .foregroundStyle(.secondary)
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
                            .foregroundStyle(.secondary)
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
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.tertiary)
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

    private var firstRunCards: some View {
        Group {
            let showSepDate = storage.profile.separationDate == nil
            let showTools = completedTaskCount == 0
            let showBenefits = storage.benefitCategories.filter(\.isStarted).isEmpty

            if showSepDate || showTools || showBenefits {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Get Started", icon: "arrow.right.circle.fill")

                    if showSepDate {
                        FirstRunCard(
                            icon: "calendar.badge.plus",
                            title: "Set your separation date",
                            subtitle: "Go to Profile to set your date and unlock your timeline",
                            color: .blue
                        )
                    }
                    if showTools {
                        NavigationLink(value: PlanningRoute.selfAssessment) {
                            FirstRunCard(
                                icon: "checklist.checked",
                                title: "Take the Readiness Check-In",
                                subtitle: "A quick self-assessment to see where you stand",
                                color: .teal
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    if showBenefits {
                        FirstRunCard(
                            icon: "star.fill",
                            title: "Explore your benefits",
                            subtitle: "Tap Learn to see what you've earned and start a benefit",
                            color: AppTheme.gold
                        )
                    }
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
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
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

nonisolated enum HeroStyle: Sendable {
    case standard
    case urgent
    case postSeparation
}

struct FirstRunCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(color.gradient)
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                Text(subtitle)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}
