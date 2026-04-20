import SwiftUI

struct TodayView: View {
    let storage: StorageService
    var store: StoreViewModel
    @Binding var selectedTab: Int
    @State private var showCelebration: Bool = false
    @State private var celebrationTitle: String = ""
    @State private var celebrationSubtitle: String = ""
    @State private var appeared: Bool = false
    @State private var searchText: String = ""
    @State private var shareItems: [Any] = []
    @State private var showShareSheet: Bool = false
    @State private var selectedWeekDay: Date?
    @State private var showPaywall: Bool = false
    @State private var showShareProgress: Bool = false

    private var isRetiredOrSeparated: Bool {
        storage.profile.timeline == .separated
    }

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
                    if isRetiredOrSeparated {
                        firstYearGuidePromo
                    }
                    milestoneSection
                    weeklySummarySection
                    focusCardSection
                    weeklyActivitySection
                    quickStatsBar
                    shareProgressSection
                    nextActionsSection
                    insightSpotlight
                    mindsetSpotlight
                    firstRunCards
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if store.isPremium {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .accessibilityLabel("DashTen Pro unlocked")
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                    .font(.caption2.weight(.heavy))
                                Text("Upgrade")
                                    .font(.caption.weight(.heavy))
                            }
                            .foregroundStyle(AppTheme.darkGreen)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(AppTheme.gold)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Upgrade to DashTen Pro")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search topics, tools, benefits...")
            .searchSuggestions {
                if !searchText.isEmpty {
                    ForEach(filteredSearchSuggestions, id: \.title) { suggestion in
                        NavigationLink(value: suggestion.route) {
                            Label(suggestion.title, systemImage: suggestion.icon)
                        }
                        .searchCompletion(suggestion.title)
                    }
                } else {
                    ForEach(topSearchSuggestions, id: \.title) { suggestion in
                        NavigationLink(value: suggestion.route) {
                            Label(suggestion.title, systemImage: suggestion.icon)
                        }
                        .searchCompletion(suggestion.title)
                    }
                }
            }
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
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView(items: shareItems)
        }
        .sheet(item: Binding(
            get: { selectedWeekDay.map { WeekDayWrapper(date: $0) } },
            set: { selectedWeekDay = $0?.date }
        )) { wrapper in
            DayDetailSheet(date: wrapper.date, storage: storage)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(store: store)
        }
        .sheet(isPresented: $showShareProgress) {
            ShareProgressSheet(
                storage: storage,
                readinessPercent: readiness.overallPercent,
                streakDays: streakDays,
                tasksCompleted: completedTaskCount,
                totalTasks: storage.checklistItems.count
            )
        }
        .onChange(of: readiness.overallPercent) { oldValue, newValue in
            checkMilestone(old: oldValue, new: newValue)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
            AnalyticsService.shared.log(.screenView, properties: ["name": "today"])
        }
        .onChange(of: showPaywall) { _, isShown in
            if isShown { AnalyticsService.shared.log(.paywallShown, properties: ["source": "home_upgrade_card"]) }
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

            if isRetiredOrSeparated {
                postServiceHeroContent
            } else if let date = storage.profile.separationDate {
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

    private var postServiceHeroContent: some View {
        HStack(spacing: 14) {
            Image(systemName: "star.circle.fill")
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppTheme.gold)
            VStack(alignment: .leading, spacing: 3) {
                Text("Welcome to civilian life")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                Text("Your first year roadmap is ready")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var firstYearGuidePromo: some View {
        NavigationLink(value: PlanningRoute.firstYearGuide) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
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
                        Text("Your First Year Guide")
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

                HStack(spacing: 8) {
                    ForEach(["Health", "Career", "Benefits", "Finance"], id: \.self) { tag in
                        Text(tag)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.forestGreen.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [AppTheme.forestGreen.opacity(0.1), AppTheme.forestGreen.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(AppTheme.forestGreen.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.1), value: appeared)
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
                Button {
                    selectedTab = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        NotificationCenter.default.post(name: .scrollToRoadmap, object: nil)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 8) {
                            Image(systemName: "scope")
                                .font(.subheadline.weight(.heavy))
                                .foregroundStyle(AppTheme.forestGreen)
                            Text("YOUR ROADMAP")
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(AppTheme.forestGreen)
                            Spacer()
                            if let phase = currentPhase {
                                StatusBadge(text: phase.shortLabel, color: AppTheme.forestGreen)
                            }
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppTheme.forestGreen.opacity(0.6))
                        }

                        HStack(spacing: 14) {
                            Image(systemName: focus.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(focus.isCompleted ? AppTheme.forestGreen : .primary.opacity(0.3))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(focus.title)
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.primary)
                                    .strikethrough(focus.isCompleted)
                                    .multilineTextAlignment(.leading)
                                if !focus.subtitle.isEmpty {
                                    Text(focus.subtitle)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                                Text(focusReason)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(AppTheme.forestGreen)
                                    .padding(.top, 2)
                            }
                            Spacer(minLength: 0)
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
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: selectedTab)
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

    private var weekDays: [Date] {
        CalendarService.shared.weekDays()
    }

    private var weeklyActivitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("This Week")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Spacer()
                HStack(spacing: 6) {
                    Text("\(streakDays)")
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(AppTheme.gold)
                    Text(streakDays == 1 ? "day streak" : "day streak")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.gold)
                }
            }

            HStack(spacing: 6) {
                ForEach(weekDays, id: \.self) { day in
                    WeekDayTile(
                        date: day,
                        isToday: Calendar.current.isDateInToday(day),
                        hasActivity: hasActivity(on: day),
                        activityCount: activityCount(on: day),
                        action: { selectedWeekDay = day }
                    )
                }
            }

            Text(weekHintText)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.2), value: appeared)
    }

    private var weekHintText: String {
        switch CalendarService.shared.accessState {
        case .authorized: return "Tap a day to see tasks, journal entries, and your calendar."
        case .notDetermined: return "Tap a day to see your plan — connect your calendar to see events too."
        case .denied, .restricted: return "Tap a day to see your tasks and journal entries."
        }
    }

    private func hasActivity(on date: Date) -> Bool {
        activityCount(on: date) > 0
    }

    private func activityCount(on date: Date) -> Int {
        let calendar = Calendar.current
        var count = 0
        count += storage.journalEntries.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
        count += storage.weeklyCheckIns.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
        if calendar.isDateInToday(date) && completedTaskCount > 0 { count += 1 }
        return count
    }

    private var documentsCollectedCount: Int {
        storage.documents.filter { $0.status == .received || $0.status == .verified }.count
    }

    private var quickStatsBar: some View {
        HStack(spacing: 10) {
            NavigationLink(value: PlanningRoute.finalGearCheck) {
                CompactStatCard(
                    icon: "checkmark.circle.fill",
                    value: "\(completedTaskCount)/\(storage.checklistItems.count)",
                    label: "Tasks",
                    color: AppTheme.forestGreen
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: PlanningRoute.documents) {
                CompactStatCard(
                    icon: "doc.text.fill",
                    value: "\(documentsCollectedCount)/\(storage.documents.count)",
                    label: "Collected",
                    color: documentsCollectedCount == storage.documents.count ? AppTheme.forestGreen : .orange
                )
            }
            .buttonStyle(.plain)
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
            let needsSetup = storage.profile.branch == nil || storage.profile.timeline == nil

            if needsSetup {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Complete Your Profile", icon: "person.crop.circle.badge.plus")

                    HStack(spacing: 14) {
                        Image(systemName: "person.text.rectangle.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(AppTheme.forestGreen.gradient)
                            .clipShape(.rect(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Set up your information")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.primary)
                            Text("Go to Profile to add your status, branch, timeline, and goals")
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
                    .background(AppTheme.forestGreen.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(AppTheme.forestGreen.opacity(0.15), lineWidth: 1)
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var upgradeCardSection: some View {
        if !store.isPremium {
            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.gold.opacity(0.18))
                            .frame(width: 52, height: 52)
                        Image(systemName: "arrow.up.forward.circle.fill")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text("Unlock DashTen Pro")
                                .font(.headline.weight(.heavy))
                                .foregroundStyle(.white)
                            Image(systemName: "sparkles")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppTheme.gold)
                        }
                        Text("11 tools • 2 guides • one-time purchase")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(1)
                    }

                    Spacer()

                    Text("Upgrade")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(AppTheme.darkGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppTheme.gold)
                        .clipShape(Capsule())
                }
                .padding(14)
                .background(
                    LinearGradient(
                        colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(.rect(cornerRadius: 18))
                .shadow(color: AppTheme.forestGreen.opacity(0.25), radius: 10, y: 4)
            }
            .buttonStyle(.plain)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.6).delay(0.05), value: appeared)
        }
    }

    private var shareProgressSection: some View {
        Button {
            AnalyticsService.shared.log(.shareTapped, properties: ["source": "today"])
            showShareProgress = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "square.and.arrow.up.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.forestGreen.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Share your progress")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("A clean card you can send to anyone")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private struct SearchSuggestion {
        let title: String
        let icon: String
        let route: PlanningRoute
        let keywords: [String]
    }

    private var allSearchSuggestions: [SearchSuggestion] {
        [
            SearchSuggestion(title: "First Year Guide", icon: "star.circle.fill", route: .firstYearGuide, keywords: ["first year", "roadmap", "quarter", "post service"]),
            SearchSuggestion(title: "Career Planning", icon: "briefcase.fill", route: .career, keywords: ["career", "job", "employment", "work"]),
            SearchSuggestion(title: "Education Planning", icon: "graduationcap.fill", route: .education, keywords: ["education", "school", "gi bill", "degree", "college"]),
            SearchSuggestion(title: "Financial Planning", icon: "dollarsign.circle.fill", route: .financial, keywords: ["finance", "money", "budget", "savings", "tsp"]),
            SearchSuggestion(title: "Family Planning", icon: "figure.2.and.child.holdinghands", route: .family, keywords: ["family", "spouse", "kids", "dependents"]),
            SearchSuggestion(title: "Documents", icon: "doc.text.fill", route: .documents, keywords: ["documents", "dd214", "records", "paperwork"]),
            SearchSuggestion(title: "Benefits", icon: "building.columns.fill", route: .finalGearCheck, keywords: ["benefits", "va", "health care", "disability"]),
            SearchSuggestion(title: "Resume Translator", icon: "doc.text.fill", route: .resumeTranslator, keywords: ["resume", "cv", "translate", "civilian"]),
            SearchSuggestion(title: "Interview Prep", icon: "person.fill.questionmark", route: .interviewPrep, keywords: ["interview", "practice", "questions"]),
            SearchSuggestion(title: "Skills Inventory", icon: "list.clipboard.fill", route: .skillsInventory, keywords: ["skills", "inventory", "mos"]),
            SearchSuggestion(title: "TSP & Retirement", icon: "arrow.triangle.swap", route: .tspRollover, keywords: ["tsp", "retirement", "401k", "rollover"]),
            SearchSuggestion(title: "Salary Negotiation", icon: "hand.raised.fill", route: .salaryNegotiation, keywords: ["salary", "negotiate", "pay"]),
            SearchSuggestion(title: "Cost of Living", icon: "building.2.fill", route: .costOfLiving, keywords: ["cost", "living", "city", "compare"]),
            SearchSuggestion(title: "GI Bill BAH Calculator", icon: "house.fill", route: .giBillBAH, keywords: ["gi bill", "bah", "housing allowance"]),
            SearchSuggestion(title: "State Benefits Finder", icon: "flag.fill", route: .stateBenefits, keywords: ["state", "benefits", "veteran"]),
            SearchSuggestion(title: "Mindset Shifts", icon: "brain.fill", route: .mindsetShifts, keywords: ["mindset", "mental", "identity", "adjustment"]),
            SearchSuggestion(title: "First 30 Days", icon: "flag.fill", route: .firstThirtyDays, keywords: ["first 30", "30 days", "survival"]),
            SearchSuggestion(title: "Civilian Playbook", icon: "book.closed.fill", route: .civilianPlaybook, keywords: ["civilian", "playbook", "rules"]),
            SearchSuggestion(title: "Readiness Dashboard", icon: "gauge.with.dots.needle.33percent", route: .readiness, keywords: ["readiness", "progress", "dashboard"]),
            SearchSuggestion(title: "Transition Journal", icon: "book.fill", route: .transitionJournal, keywords: ["journal", "write", "reflect"]),
            SearchSuggestion(title: "Goal Tracker", icon: "target", route: .goalTracker, keywords: ["goals", "track", "progress"]),
            SearchSuggestion(title: "Wellness Check-In", icon: "chart.xyaxis.line", route: .weeklyCheckIn, keywords: ["wellness", "check-in", "stress", "mental health"]),
            SearchSuggestion(title: "Networking Hub", icon: "person.3.fill", route: .networkingScorecard, keywords: ["networking", "contacts", "connections"]),
            SearchSuggestion(title: "Elevator Pitch", icon: "mic.fill", route: .elevatorPitch, keywords: ["pitch", "intro", "elevator"]),
            SearchSuggestion(title: "Relocation Cost", icon: "shippingbox.fill", route: .relocationCost, keywords: ["relocation", "moving", "pcs"]),
            SearchSuggestion(title: "Education Benefits", icon: "chart.bar.doc.horizontal.fill", route: .educationComparison, keywords: ["education", "benefits", "comparison"]),
            SearchSuggestion(title: "Mentor Tracker", icon: "person.2.fill", route: .mentorTracker, keywords: ["mentor", "network", "advisor"]),
            SearchSuggestion(title: "Decision Matrix", icon: "square.grid.3x3.fill", route: .decisionMatrix, keywords: ["decision", "compare", "matrix"]),
            SearchSuggestion(title: "90-Day Planner", icon: "calendar.badge.clock", route: .ninetyDayPlanner, keywords: ["90 day", "planner", "first job"]),
        ]
    }

    private var filteredSearchSuggestions: [SearchSuggestion] {
        allSearchSuggestions.filter { suggestion in
            suggestion.title.localizedStandardContains(searchText) ||
            suggestion.keywords.contains(where: { $0.localizedStandardContains(searchText) })
        }
    }

    private var topSearchSuggestions: [SearchSuggestion] {
        if isRetiredOrSeparated {
            return allSearchSuggestions.filter { ["First Year Guide", "Career Planning", "Benefits", "Wellness Check-In", "Documents"].contains($0.title) }
        }
        return Array(allSearchSuggestions.prefix(5))
    }

    private var daysUsingApp: Int {
        let start = Calendar.current.startOfDay(for: storage.profile.createdAt)
        let today = Calendar.current.startOfDay(for: Date())
        return Calendar.current.dateComponents([.day], from: start, to: today).day ?? 0
    }

    private var currentMilestone: (days: Int, title: String, subtitle: String)? {
        let d = daysUsingApp
        if d >= 90 { return (90, "90 days in — you're in it", "Three months of consistent work. You've built real momentum. Share the win — someone else is about to start.") }
        if d >= 30 { return (30, "One month strong", "30 days of showing up for your future. This is what steady progress looks like.") }
        if d >= 7 { return (7, "One week done", "You stuck with it for a full week. That's already more than most people do on this journey.") }
        return nil
    }

    private var shouldShowWeeklySummary: Bool {
        Calendar.current.component(.weekday, from: Date()) == 1 && daysUsingApp >= 7
    }

    private var journalEntriesThisWeek: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return storage.journalEntries.filter { $0.date >= weekAgo }.count
    }

    @ViewBuilder
    private var milestoneSection: some View {
        if let m = currentMilestone {
            MilestoneCelebrationCard(
                days: m.days,
                title: m.title,
                subtitle: m.subtitle,
                onShare: {
                    shareItems = ["I've been \(m.days) days into my transition with DashTen. Small steps, real progress."]
                    showShareSheet = true
                }
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
        }
    }

    @ViewBuilder
    private var weeklySummarySection: some View {
        if shouldShowWeeklySummary {
            WeeklySummaryCard(
                tasksCompleted: completedTaskCount,
                documentsVerified: storage.documents.filter { $0.status == .verified }.count,
                journalEntries: journalEntriesThisWeek,
                readinessPercent: readiness.overallPercent
            )
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
        }
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
