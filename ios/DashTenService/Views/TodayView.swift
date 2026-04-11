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
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return cards[dayOfYear % cards.count]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    countdownAndProgress
                    nextActionsSection
                    planningToolsSection
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
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !storage.profile.displayName.isEmpty {
                Text("Welcome back, \(storage.profile.displayName)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            if let branch = storage.profile.branch {
                Text(branch.rawValue)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var countdownAndProgress: some View {
        HStack(spacing: 12) {
            if let date = storage.profile.separationDate {
                CardView {
                    CountdownView(targetDate: date)
                        .frame(maxWidth: .infinity)
                }
            }

            NavigationLink(value: PlanningRoute.readiness) {
                CardView {
                    VStack(spacing: 8) {
                        ProgressRing(progress: readiness.overall, size: 64, lineWidth: 7)
                            .overlay {
                                Text("\(readiness.overallPercent)%")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(AppTheme.forestGreen)
                            }
                        Text("Readiness")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.plain)
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
                                .font(.subheadline.weight(.medium))
                            Text("Check back for new tasks as your timeline progresses")
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
                                        .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : .secondary)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.medium))
                                        .strikethrough(item.isCompleted)
                                    if !item.subtitle.isEmpty {
                                        Text(item.subtitle)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                StatusBadge(text: item.phase.rawValue, color: AppTheme.forestGreen)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .sensoryFeedback(.success, trigger: item.isCompleted)
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
                    PlanningToolChip(title: "Crisis Help", icon: "heart.fill", color: .red, route: .crisis)
                }
            }
            .contentMargins(.horizontal, 0)
            .scrollIndicators(.hidden)
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
                                .font(.subheadline.weight(.semibold))
                            Text(card.body)
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
                                            .font(.subheadline.weight(.medium))
                                        Text(doc.category.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
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
                            .font(.subheadline.weight(.medium))
                        Text("Crisis Lifeline: call or text 988")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
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
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.primary)
            }
            .frame(width: 76)
        }
        .buttonStyle(.plain)
    }
}
