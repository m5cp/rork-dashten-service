import SwiftUI

struct TodayView: View {
    let storage: StorageService

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    private var nextActions: [ChecklistItem] {
        storage.checklistItems
            .filter { !$0.isCompleted }
            .prefix(3)
            .map { $0 }
    }

    private var upcomingDocs: [DocumentItem] {
        storage.documents
            .filter { $0.status == .missing || $0.status == .requested }
            .prefix(3)
            .map { $0 }
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

    private var weeklyFocusItems: [String] {
        var items: [String] = []
        if let phase = currentPhase {
            items.append("Focus: \(phase.rawValue) — \(phase.subtitle)")
        }
        let missingDocs = storage.documents.filter { $0.status == .missing }.count
        if missingDocs > 0 {
            items.append("\(missingDocs) documents still need attention")
        }
        let incompleteBenefits = storage.benefitCategories.filter { $0.isStarted && $0.actionItems.contains(where: { !$0.isCompleted }) }.count
        if incompleteBenefits > 0 {
            items.append("\(incompleteBenefits) benefit categories in progress")
        }
        return items
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroCard
                    nextActionsSection
                    weeklyFocusSection
                    planningToolsSection
                    mindsetSpotlight
                    insightSpotlight
                    documentsAlert
                    crisisQuickAccess
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .navigationDestination(for: PlanningRoute.self) { route in
                switch route {
                case .career:
                    CareerPlanningView(storage: storage)
                case .education:
                    EducationPlanningView(storage: storage)
                case .family:
                    FamilyPlanningView()
                case .financial:
                    FinancialPlanningView()
                case .readiness:
                    ReadinessDashboardView(storage: storage)
                case .crisis:
                    CrisisResourcesView()
                case .firstThirtyDays:
                    FirstThirtyDaysView()
                case .mindsetShifts:
                    MindsetShiftsView()
                case .civilianPlaybook:
                    CivilianPlaybookView()
                case .selfAssessment:
                    SelfAssessmentView(storage: storage)
                case .finalGearCheck:
                    FinalGearCheckView(storage: storage)
                case .mentorTracker:
                    MentorTrackerView(storage: storage)
                }
            }
        }
    }

    private var heroCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    if !storage.profile.displayName.isEmpty {
                        Text("Welcome back,")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))
                        Text(storage.profile.displayName)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    } else {
                        Text("Your Transition")
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
                    ProgressRing(progress: readiness.overall, size: 56, lineWidth: 5, color: AppTheme.gold)
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
                let info = countdownInfo(for: date)
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Text("\(info.days)")
                            .font(.system(size: 36, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                        VStack(alignment: .leading, spacing: 0) {
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
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(phase.rawValue)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white.opacity(0.9))
                            Text(phase.subtitle)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            } else {
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
        }
        .background(
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    AppTheme.darkGreen, AppTheme.forestGreen, AppTheme.darkGreen,
                    AppTheme.forestGreen, AppTheme.forestGreen.opacity(0.8), AppTheme.darkGreen,
                    AppTheme.darkGreen, AppTheme.forestGreen, AppTheme.darkGreen
                ]
            )
        )
        .clipShape(.rect(cornerRadius: 20))
    }

    private func countdownInfo(for date: Date) -> (days: Int, label: String) {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days > 0 {
            return (days, "until separation")
        } else if days == 0 {
            return (0, "separation day")
        } else {
            return (abs(days), "since separation")
        }
    }

    private var nextActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Next Actions", icon: "bolt.fill")

            if nextActions.isEmpty {
                CardView {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppTheme.forestGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("You're all caught up")
                                .font(.subheadline.weight(.bold))
                            Text("Check back for new tasks as your timeline progresses")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.7))
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                VStack(spacing: 8) {
                    ForEach(nextActions) { item in
                        CardView {
                            HStack(spacing: 12) {
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        storage.toggleChecklistItem(item.id)
                                    }
                                } label: {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : .primary.opacity(0.5))
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                        .strikethrough(item.isCompleted)
                                    if !item.subtitle.isEmpty {
                                        Text(item.subtitle)
                                            .font(.caption.weight(.medium))
                                            .foregroundStyle(.primary.opacity(0.7))
                                    }
                                }
                                Spacer()
                                StatusBadge(text: item.phase.shortLabel, color: AppTheme.forestGreen)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .sensoryFeedback(.success, trigger: item.isCompleted)
                    }
                }
            }
        }
    }

    private var weeklyFocusSection: some View {
        Group {
            if !weeklyFocusItems.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("This Week's Focus", icon: "target")

                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(weeklyFocusItems, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.forestGreen)
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private var planningToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Planning Tools", icon: "wrench.and.screwdriver.fill")

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    PlanningToolChip(title: "Career", icon: "briefcase.fill", color: .teal, route: .career)
                    PlanningToolChip(title: "Education", icon: "graduationcap.fill", color: .blue, route: .education)
                    PlanningToolChip(title: "Family", icon: "figure.2.and.child.holdinghands", color: .pink, route: .family)
                    PlanningToolChip(title: "Financial", icon: "dollarsign.circle.fill", color: AppTheme.gold, route: .financial)
                    PlanningToolChip(title: "Readiness", icon: "chart.bar.fill", color: AppTheme.forestGreen, route: .readiness)
                    PlanningToolChip(title: "First 30\nDays", icon: "flag.fill", color: .purple, route: .firstThirtyDays)
                    PlanningToolChip(title: "Mindset", icon: "brain.fill", color: .purple, route: .mindsetShifts)
                    PlanningToolChip(title: "Playbook", icon: "book.closed.fill", color: .blue, route: .civilianPlaybook)
                    PlanningToolChip(title: "Check-In", icon: "checklist.checked", color: .teal, route: .selfAssessment)
                    PlanningToolChip(title: "Gear\nCheck", icon: "checkmark.shield.fill", color: .orange, route: .finalGearCheck)
                    PlanningToolChip(title: "Mentors", icon: "person.2.fill", color: .pink, route: .mentorTracker)
                    PlanningToolChip(title: "Crisis Help", icon: "heart.fill", color: .red, route: .crisis)
                }
            }
            .contentMargins(.horizontal, 0)
            .scrollIndicators(.hidden)
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
                        CardView {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    StatusBadge(text: shift.category.rawValue, color: .purple)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.primary.opacity(0.4))
                                }
                                Text(shift.title)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)
                                Text(shift.insight)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.primary.opacity(0.8))
                                    .lineLimit(3)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var insightSpotlight: some View {
        Group {
            if let card = insightCard {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Daily Insight", icon: "lightbulb.fill")
                    CardView {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private var documentsAlert: some View {
        Group {
            if !upcomingDocs.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Documents Needing Attention", icon: "doc.text.fill")
                    VStack(spacing: 8) {
                        ForEach(upcomingDocs) { doc in
                            CardView {
                                HStack(spacing: 12) {
                                    Image(systemName: doc.status.icon)
                                        .foregroundStyle(doc.status == .missing ? .red : .orange)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(doc.name)
                                            .font(.subheadline.weight(.semibold))
                                        Text(doc.category.rawValue)
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(.primary.opacity(0.7))
                                    }
                                    Spacer()
                                    StatusBadge(text: doc.status.rawValue, color: doc.status == .missing ? .red : .orange)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
        }
    }

    private var crisisQuickAccess: some View {
        NavigationLink(value: PlanningRoute.crisis) {
            CardView {
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }
}

struct PlanningToolChip: View {
    let title: String
    let icon: String
    let color: Color
    let route: PlanningRoute

    var body: some View {
        NavigationLink(value: route) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(color)
                }
                Text(title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 76)
        }
        .buttonStyle(.plain)
    }
}
