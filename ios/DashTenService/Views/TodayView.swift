import SwiftUI

struct TodayView: View {
    let storage: StorageService
    var store: StoreViewModel
    @Binding var selectedTab: Int

    @State private var appeared: Bool = false
    @State private var showCelebration: Bool = false
    @State private var celebrationTitle: String = ""
    @State private var celebrationSubtitle: String = ""
    @State private var showPaywall: Bool = false
    @State private var showSearch: Bool = false

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

    private var streakDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        for i in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { break }
            let hasJournal = storage.journalEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let hasCheckIn = storage.weeklyCheckIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let hasToday = i == 0 && completedTaskCount > 0
            if hasJournal || hasCheckIn || hasToday {
                streak += 1
            } else if i > 0 {
                break
            }
        }
        return streak
    }

    private var weekActivity: [(date: Date, active: Bool, isToday: Bool)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let hasJournal = storage.journalEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let hasCheckIn = storage.weeklyCheckIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let active = hasJournal || hasCheckIn || (offset == 0 && completedTaskCount > 0)
            return (date, active, offset == 0)
        }
    }

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

                    if let focus = focusAction {
                        focusCard(focus)
                            .delayedEntrance(appeared, delay: 0.16)
                    } else {
                        allCaughtUpCard
                            .delayedEntrance(appeared, delay: 0.16)
                    }

                    streakStrip
                        .delayedEntrance(appeared, delay: 0.24)

                    if let card = insightCard {
                        insightView(card)
                            .delayedEntrance(appeared, delay: 0.32)
                    }
                }
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
                        Button { showPaywall = true } label: {
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
                }
            }
        }
        .overlay {
            CelebrationOverlay(
                isShowing: $showCelebration,
                title: celebrationTitle,
                subtitle: celebrationSubtitle
            )
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(store: store)
        }
        .sheet(isPresented: $showSearch) {
            SearchView(storage: storage, store: store)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
                appeared = true
            }
            AnalyticsService.shared.log(.screenView, properties: ["name": "home"])
        }
        .onChange(of: readiness.overallPercent) { oldValue, newValue in
            checkMilestone(old: oldValue, new: newValue)
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
                statusPillView
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

            HStack(alignment: .top, spacing: 14) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        storage.toggleChecklistItem(item.id)
                    }
                } label: {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : .primary.opacity(0.35))
                        .symbolEffect(.bounce, value: item.isCompleted)
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.success, trigger: item.isCompleted)

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

    // MARK: - Streak strip

    private var streakStrip: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("\(streakDays)")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                Text(streakDays == 1 ? "day" : "days")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 6) {
                ForEach(Array(weekActivity.enumerated()), id: \.offset) { _, day in
                    dayDot(active: day.active, isToday: day.isToday)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func dayDot(active: Bool, isToday: Bool) -> some View {
        Circle()
            .fill(active ? AppTheme.forestGreen : Color.primary.opacity(0.08))
            .frame(width: isToday ? 12 : 8, height: isToday ? 12 : 8)
            .overlay(
                Circle()
                    .strokeBorder(isToday ? AppTheme.gold : .clear, lineWidth: 2)
            )
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

    private func checkMilestone(old: Int, new: Int) {
        let thresholds = [25, 50, 75, 100]
        for t in thresholds {
            if old < t && new >= t {
                celebrationTitle = new >= 100 ? "Fully Prepared!" : "\(t)% Ready!"
                celebrationSubtitle = new >= 100
                    ? "You've completed your entire transition plan."
                    : "Major milestone hit. Keep going."
                withAnimation(.spring) { showCelebration = true }
                return
            }
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
