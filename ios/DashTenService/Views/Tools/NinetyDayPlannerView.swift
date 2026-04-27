import SwiftUI

struct NinetyDayPlannerView: View {
    @Bindable var storage: StorageService
    @State private var selectedWeek: Int = 1
    @State private var newGoal: String = ""
    @State private var newPerson: String = ""
    @State private var newWin: String = ""

    private var plan: NinetyDayPlan {
        if let existing = storage.ninetyDayPlan { return existing }
        let p = NinetyDayPlan()
        return p
    }

    private var weekIndex: Int? {
        storage.ninetyDayPlan?.weeks.firstIndex(where: { $0.weekNumber == selectedWeek })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                phaseSelector
                weekContent
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("First 90 Days")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if storage.ninetyDayPlan == nil {
                storage.ninetyDayPlan = NinetyDayPlan()
                storage.unlockBadge("ninety_plan")
            }
            storage.trackToolUsed("ninety_day_planner")
        }
    }

    private var phaseSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.clock")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Your 90-Day Plan")
                    .font(.headline.weight(.bold))
            }

            HStack(spacing: 0) {
                PhaseTab(title: "Month 1", subtitle: "Weeks 1-4", isSelected: selectedWeek <= 4, color: .purple) {
                    withAnimation(.spring(response: 0.3)) { selectedWeek = 1 }
                }
                PhaseTab(title: "Month 2", subtitle: "Weeks 5-8", isSelected: selectedWeek >= 5 && selectedWeek <= 8, color: .blue) {
                    withAnimation(.spring(response: 0.3)) { selectedWeek = 5 }
                }
                PhaseTab(title: "Month 3", subtitle: "Weeks 9-12", isSelected: selectedWeek >= 9, color: AppTheme.forestGreen) {
                    withAnimation(.spring(response: 0.3)) { selectedWeek = 9 }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(1...12, id: \.self) { week in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedWeek = week }
                        } label: {
                            Text("W\(week)")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(selectedWeek == week ? .white : .primary)
                                .frame(width: 40, height: 32)
                                .background(selectedWeek == week ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    private var weekContent: some View {
        VStack(spacing: 16) {
            weekHeader

            goalsSection
            peopleSection
            winsSection

            weekTips
        }
    }

    private var weekHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Week \(selectedWeek)")
                    .font(.title2.weight(.bold))
                Text(weekPhaseLabel)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(weekPhaseColor)
            }
            Spacer()
            let goalsCount = storage.ninetyDayPlan?.weeks.first(where: { $0.weekNumber == selectedWeek })?.goals.count ?? 0
            let winsCount = storage.ninetyDayPlan?.weeks.first(where: { $0.weekNumber == selectedWeek })?.wins.count ?? 0
            VStack(spacing: 2) {
                Text("\(goalsCount + winsCount)")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("items")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var weekPhaseLabel: String {
        if selectedWeek <= 4 { return "Stabilize & Orient" }
        if selectedWeek <= 8 { return "Build Momentum" }
        return "Accelerate & Assess"
    }

    private var weekPhaseColor: Color {
        if selectedWeek <= 4 { return .purple }
        if selectedWeek <= 8 { return .blue }
        return AppTheme.forestGreen
    }

    private var goalsSection: some View {
        PlanSection(
            title: "Goals This Week",
            icon: "target",
            color: AppTheme.forestGreen,
            items: storage.ninetyDayPlan?.weeks.first(where: { $0.weekNumber == selectedWeek })?.goals ?? [],
            newItemText: $newGoal,
            placeholder: "Add a goal...",
            onAdd: {
                guard let idx = weekIndex, !newGoal.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                storage.ninetyDayPlan?.weeks[idx].goals.append(newGoal.trimmingCharacters(in: .whitespaces))
                newGoal = ""
            },
            onDelete: { item in
                guard let idx = weekIndex else { return }
                storage.ninetyDayPlan?.weeks[idx].goals.removeAll { $0 == item }
            }
        )
    }

    private var peopleSection: some View {
        PlanSection(
            title: "People to Meet",
            icon: "person.2.fill",
            color: .blue,
            items: storage.ninetyDayPlan?.weeks.first(where: { $0.weekNumber == selectedWeek })?.peopleToMeet ?? [],
            newItemText: $newPerson,
            placeholder: "Add a person...",
            onAdd: {
                guard let idx = weekIndex, !newPerson.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                storage.ninetyDayPlan?.weeks[idx].peopleToMeet.append(newPerson.trimmingCharacters(in: .whitespaces))
                newPerson = ""
            },
            onDelete: { item in
                guard let idx = weekIndex else { return }
                storage.ninetyDayPlan?.weeks[idx].peopleToMeet.removeAll { $0 == item }
            }
        )
    }

    private var winsSection: some View {
        PlanSection(
            title: "Wins & Learnings",
            icon: "star.fill",
            color: AppTheme.gold,
            items: storage.ninetyDayPlan?.weeks.first(where: { $0.weekNumber == selectedWeek })?.wins ?? [],
            newItemText: $newWin,
            placeholder: "Record a win...",
            onAdd: {
                guard let idx = weekIndex, !newWin.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                storage.ninetyDayPlan?.weeks[idx].wins.append(newWin.trimmingCharacters(in: .whitespaces))
                newWin = ""
            },
            onDelete: { item in
                guard let idx = weekIndex else { return }
                storage.ninetyDayPlan?.weeks[idx].wins.removeAll { $0 == item }
            }
        )
    }

    private var weekTips: some View {
        let tips: [(String, String)] = {
            if selectedWeek <= 2 {
                return [
                    ("Focus on stability", "Secure housing, set up accounts, establish routines"),
                    ("Don't rush decisions", "Your first 2 weeks are about orientation, not perfection"),
                ]
            } else if selectedWeek <= 4 {
                return [
                    ("Start building habits", "Daily routines, networking, and self-care"),
                    ("Document everything", "Keep notes on contacts, ideas, and observations"),
                ]
            } else if selectedWeek <= 8 {
                return [
                    ("Push your comfort zone", "Apply for roles, attend events, ask for introductions"),
                    ("Track your progress", "Review weekly — what worked, what didn't, what to adjust"),
                ]
            } else {
                return [
                    ("Assess and adjust", "What's working? Double down. What's not? Pivot."),
                    ("Plan the next quarter", "Set goals for months 4-6 based on what you've learned"),
                ]
            }
        }()

        return VStack(alignment: .leading, spacing: 10) {
            Text("Tips for This Week")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            ForEach(tips, id: \.0) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.gold)
                        .padding(.top, 2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(tip.0)
                            .font(.caption.weight(.bold))
                        Text(tip.1)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(14)
        .background(AppTheme.gold.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}

private struct PhaseTab: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption.weight(.bold))
                Text(subtitle)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(isSelected ? AnyShapeStyle(color.opacity(0.8)) : AnyShapeStyle(.tertiary))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? color.opacity(0.12) : Color.clear)
            .clipShape(.rect(cornerRadius: 10))
        }
        .foregroundStyle(isSelected ? color : .secondary)
    }
}

private struct PlanSection: View {
    let title: String
    let icon: String
    let color: Color
    let items: [String]
    @Binding var newItemText: String
    let placeholder: String
    let onAdd: () -> Void
    let onDelete: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("\(items.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }

            ForEach(items, id: \.self) { item in
                HStack(spacing: 10) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 5))
                        .foregroundStyle(color)
                    Text(item)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Button {
                        onDelete(item)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .accessibilityLabel("Remove item")
                }
            }

            HStack {
                TextField(placeholder, text: $newItemText)
                    .font(.subheadline)
                    .onSubmit { onAdd() }
                Button {
                    onAdd()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(color)
                }
                .disabled(newItemText.trimmingCharacters(in: .whitespaces).isEmpty)
                .accessibilityLabel("Add item")
            }
            .padding(10)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}
