import SwiftUI

struct TodayView: View {
    let storage: StorageService
    var store: StoreViewModel
    @Binding var selectedTab: Int

    @Environment(PaywallCenter.self) private var paywall
    @State private var appeared: Bool = false
    @State private var showCelebration: Bool = false
    @State private var celebrationTitle: String = ""
    @State private var celebrationSubtitle: String = ""
    @State private var showSearch: Bool = false
    @State private var showFeedback: Bool = false
    @State private var showMilestoneShare: Bool = false
    @State private var celebratedMilestone: RetentionMilestone?
    @State private var goToAssessment: Bool = false

    private var isRetiredOrSeparated: Bool {
        storage.profile.timeline == .separated
    }

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(
            checklist: storage.checklistItems,
            documents: storage.documents,
            benefits: storage.benefitCategories
        )
    }

    private var focusAction: ChecklistItem? {
        storage.checklistItems.first { !$0.isCompleted }
    }

    private var completedTaskCount: Int {
        storage.checklistItems.filter(\.isCompleted).count
    }

    private var streakDays: Int { storage.currentStreak }


    private var insightCard: InsightCard? {
        let cards = TransitionDataService.insightCards()
        guard !cards.isEmpty else { return nil }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return cards[dayOfYear % cards.count]
    }

    private var statusPill: (text: String, color: Color)? {
        if isRetiredOrSeparated { return nil }
        let pct = readiness.overallPercent
        if pct >= 75 { return ("On track", AppTheme.forestGreen) }
        if pct >= 40 { return ("Building momentum", AppTheme.gold) }
        return ("Needs attention", .orange)
    }

    private var firstName: String {
        let name = storage.profile.displayName.trimmingCharacters(in: .whitespaces)
        return name.split(separator: " ").first.map(String.init) ?? ""
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroCard
                        .delayedEntrance(appeared, delay: 0.0)

                    readinessCard
                        .delayedEntrance(appeared, delay: 0.08)

                    RecentWinsCard(storage: storage)
                        .delayedEntrance(appeared, delay: 0.12)

                    if let focus = focusAction {
                        focusCard(focus)
                            .delayedEntrance(appeared, delay: 0.16)
                    } else {
                        allCaughtUpCard
                            .delayedEntrance(appeared, delay: 0.16)
                    }

                    if RetentionService.shouldPromptReassessment(storage: storage) {
                        ReassessmentPromptCard(
                            storage: storage,
                            onDismiss: { storage.reassessmentPromptDismissedAt = Date() },
                            onTakeAssessment: { goToAssessment = true }
                        )
                        .delayedEntrance(appeared, delay: 0.3)
                    }

                    if let card = insightCard {
                        insightView(card)
                            .delayedEntrance(appeared, delay: 0.32)
                    }
                }
                .readableContentWidth()
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .background(Color(.tertiarySystemGroupedBackground), in: Circle())
                    }
                    .accessibilityLabel("Search the app")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if store.isPremium {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .accessibilityLabel("DashTen Pro unlocked")
                    } else {
                        Button { paywall.present(source: "home_toolbar") } label: {
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
                    }
                }
            }
            .navigationDestination(for: PlanningRoute.self) { route in
                if case .readiness = route {
                    ReadinessDashboardView(storage: storage)
                } else if case .selfAssessment = route {
                    SelfAssessmentView(storage: storage)
                } else if case .achievementBadges = route {
                    AchievementBadgesView(storage: storage)
                }
            }
            .navigationDestination(isPresented: $goToAssessment) {
                SelfAssessmentView(storage: storage)
            }
        }
        .overlay {
            CelebrationOverlay(
                isShowing: $showCelebration,
                title: celebrationTitle,
                subtitle: celebrationSubtitle
            )
        }
        .sheet(isPresented: $showSearch) {
            SearchView(storage: storage, store: store)
        }
        .sheet(isPresented: $showFeedback) {
            FeedbackPromptSheet(storage: storage)
        }
        .sheet(isPresented: $showMilestoneShare) {
            if let m = celebratedMilestone {
                ShareProgressSheet(
                    storage: storage,
                    readinessPercent: readiness.overallPercent,
                    streakDays: storage.currentStreak,
                    tasksCompleted: completedTaskCount,
                    totalTasks: storage.checklistItems.count
                )
                .presentationDetents([.large])
                .interactiveDismissDisabled(false)
                .accessibilityLabel(m.title)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
                appeared = true
            }
            AnalyticsService.shared.log(.screenView, properties: ["name": "home"])
            _ = RetentionService.recordSession(storage: storage)
            checkPendingMilestone()
            checkPendingFeedback()
        }
        .onChange(of: readiness.overallPercent) { oldValue, newValue in
            checkMilestone(old: oldValue, new: newValue)
        }
        .onChange(of: storage.pendingFeedbackPrompt) { _, newValue in
            if newValue { checkPendingFeedback() }
        }
    }

    // MARK: - Hero

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Text(AppTheme.timeOfDayGreeting() + (firstName.isEmpty ? "" : ","))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
            }

            if !firstName.isEmpty {
                Text(firstName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }

            heroBigLine
                .padding(.top, 2)

            if let branch = storage.profile.branch {
                Text(branch.rawValue.uppercased())
                    .font(.caption2.weight(.heavy))
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 20))
    }

    @ViewBuilder
    private var heroBigLine: some View {
        if isRetiredOrSeparated {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("Retired")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.forestGreen)
                if let sep = storage.profile.separationDate {
                    let months = max(0, Calendar.current.dateComponents([.month], from: sep, to: Date()).month ?? 0)
                    Text("· \(months) \(months == 1 ? "month" : "months") out")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        } else if let date = storage.profile.separationDate {
            let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(abs(days))")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.forestGreen)
                    .contentTransition(.numericText())
                VStack(alignment: .leading, spacing: 0) {
                    Text(days == 1 ? "day" : "days")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.secondary)
                    Text(days >= 0 ? "until separation" : "since separation")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.6)
        } else {
            Button {
                selectedTab = 4
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.title3.weight(.semibold))
                    Text("Set your separation date")
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(AppTheme.forestGreen)
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var statusPillView: some View {
        if let pill = statusPill {
            HStack(spacing: 6) {
                Circle()
                    .fill(pill.color)
                    .frame(width: 6, height: 6)
                Text(pill.text)
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.tertiarySystemGroupedBackground), in: Capsule())
        }
    }

    // MARK: - Readiness

    private var readinessCard: some View {
        NavigationLink(value: PlanningRoute.readiness) {
            HStack(spacing: 18) {
                ZStack {
                    ProgressRing(progress: readiness.overall, size: 76, lineWidth: 8, color: AppTheme.forestGreen)
                    VStack(spacing: 0) {
                        Text("\(readiness.overallPercent)")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                            .contentTransition(.numericText())
                        Text("%")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Transition Readiness")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Documents, benefits & checklist combined")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Focus

    private func focusCard(_ item: ChecklistItem) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "scope")
                    .font(.caption.weight(.heavy))
                Text("TODAY'S FOCUS")
                    .font(.caption.weight(.heavy))
                    .tracking(1.2)
            }
            .foregroundStyle(AppTheme.gold)

            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                        .strikethrough(item.isCompleted)
                        .multilineTextAlignment(.leading)
                    if !item.subtitle.isEmpty {
                        Text(item.subtitle)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer(minLength: 0)
                Toggle("Mark complete", isOn: Binding(
                    get: { item.isCompleted },
                    set: { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            storage.toggleChecklistItem(item.id)
                        }
                    }
                ))
                .labelsHidden()
                .tint(AppTheme.forestGreen)
                .sensoryFeedback(.success, trigger: item.isCompleted)
            }

            Divider().opacity(0.4)

            Button {
                selectedTab = 1
            } label: {
                HStack(spacing: 6) {
                    Text("See all tasks")
                        .font(.subheadline.weight(.bold))
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(AppTheme.forestGreen)
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private var allCaughtUpCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title)
                .foregroundStyle(AppTheme.gold)
                .symbolEffect(.pulse)
            VStack(alignment: .leading, spacing: 4) {
                Text("All caught up")
                    .font(.headline.weight(.bold))
                Text("You're \(readiness.overallPercent)% ready. Nice work.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    // MARK: - Insight

    private func insightView(_ card: InsightCard) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption.weight(.bold))
                Text("DAILY INSIGHT")
                    .font(.caption.weight(.heavy))
                    .tracking(1.2)
            }
            .foregroundStyle(AppTheme.gold)

            Text(card.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            Text(card.body)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private func checkPendingMilestone() {
        for m in RetentionMilestone.allCases where storage.currentStreak >= m.rawValue {
            // Already celebrated in storage; show share only for the latest just-hit milestone
            _ = m
        }
        // Find the highest milestone reached this session that hasn't been shown via share yet
        let reached = RetentionMilestone.allCases.last { storage.currentStreak >= $0.rawValue }
        if let reached, storage.celebratedStreakMilestones.contains(reached.rawValue) {
            // Show celebration overlay (one-time per session); share is optional via overlay button
            if celebratedMilestone?.rawValue != reached.rawValue {
                celebratedMilestone = reached
                celebrationTitle = reached.title
                celebrationSubtitle = reached.subtitle
                // Only auto-show if this milestone was hit very recently (same day)
                if let last = storage.lastActiveDate,
                   Calendar.current.isDateInToday(last),
                   storage.currentStreak == reached.rawValue {
                    withAnimation(.spring) { showCelebration = true }
                }
            }
        }
    }

    private func checkMilestone(old: Int, new: Int) {
        let thresholds = [25, 50, 75, 100]
        for t in thresholds {
            if old < t && new >= t {
                celebrationTitle = new >= 100 ? "Fully Prepared!" : "\(t)% Ready!"
                celebrationSubtitle = new >= 100
                    ? "You've completed your entire transition plan."
                    : "Major milestone hit. Keep going."
                withAnimation(.spring) { showCelebration = true }
                // Big readiness milestones (50/75/100) are great moments to ask for a rating.
                if t >= 50 {
                    storage.tryQueueFeedbackPrompt()
                }
                return
            }
        }
    }

    private func checkPendingFeedback() {
        guard storage.pendingFeedbackPrompt else { return }
        // Avoid stacking on top of a celebration overlay or another sheet.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            guard storage.pendingFeedbackPrompt else { return }
            showFeedback = true
        }
    }
}

// MARK: - Helpers

private extension View {
    func delayedEntrance(_ appeared: Bool, delay: Double) -> some View {
        self
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(.spring(response: 0.65, dampingFraction: 0.85).delay(delay), value: appeared)
    }
}

nonisolated enum HeroStyle: Sendable {
    case standard
    case urgent
    case postSeparation
}

struct RecentWinsCard: View {
    let storage: StorageService

    private var unlockedBadges: [AchievementBadge] {
        storage.badges
            .filter { $0.isUnlocked }
            .sorted { ($0.unlockedDate ?? .distantPast) > ($1.unlockedDate ?? .distantPast) }
    }

    private var totalCount: Int { storage.badges.count }
    private var unlockedCount: Int { unlockedBadges.count }

    var body: some View {
        NavigationLink(value: PlanningRoute.achievementBadges) {
            cardBody
        }
        .buttonStyle(.plain)
    }

    private var cardBody: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "rosette")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                    Text("RECENT WINS")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(AppTheme.gold)
                        .tracking(1.5)
                }
                Spacer()
                Text("\(unlockedCount) of \(totalCount)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.tertiary)
            }

            if unlockedBadges.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "rosette")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Earn your first badge")
                            .font(.subheadline.weight(.bold))
                        Text("Complete tasks, verify documents, or use a tool to start unlocking badges.")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                }
            } else {
                HStack(spacing: 10) {
                    ForEach(Array(unlockedBadges.prefix(4))) { badge in
                        RecentBadgeChip(badge: badge)
                    }
                    if unlockedCount > 4 {
                        VStack(spacing: 4) {
                            Text("+\(unlockedCount - 4)")
                                .font(.subheadline.weight(.heavy))
                                .foregroundStyle(AppTheme.forestGreen)
                                .frame(width: 44, height: 44)
                                .background(AppTheme.forestGreen.opacity(0.1))
                                .clipShape(Circle())
                            Text("more")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
        .contentShape(Rectangle())
    }
}

private struct RecentBadgeChip: View {
    let badge: AchievementBadge

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(AppTheme.gold.opacity(0.18))
                    .frame(width: 44, height: 44)
                Image(systemName: badge.icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
            }
            Text(badge.title)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: 56)
        }
    }
}

