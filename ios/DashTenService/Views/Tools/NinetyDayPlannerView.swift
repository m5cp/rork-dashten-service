import SwiftUI

struct NinetyDayPlannerView: View {
    @Bindable var storage: StorageService
    @State private var selectedWeek: Int = 1
    @State private var newGoal: String = ""
    @State private var newPerson: String = ""
    @State private var newWin: String = ""
    @State private var showTemplateSheet: Bool = false
    @State private var showRegenerateAlert: Bool = false

    private var currentTemplate: NinetyDayTemplate {
        if let raw = storage.profile.ninetyDayTemplate,
           let t = NinetyDayTemplate(rawValue: raw) {
            return t
        }
        return NinetyDayPlanGenerator.suggestedTemplate(profile: storage.profile)
    }

    private var weekIndex: Int? {
        storage.ninetyDayPlan?.weeks.firstIndex(where: { $0.weekNumber == selectedWeek })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                templateBanner
                phaseSelector
                weekContent
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .keyboardDoneToolbar()
        .navigationTitle("First 90 Days")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showTemplateSheet = true
                    } label: {
                        Label("Switch template", systemImage: "rectangle.stack.fill")
                    }
                    Button(role: .destructive) {
                        showRegenerateAlert = true
                    } label: {
                        Label("Regenerate plan", systemImage: "arrow.triangle.2.circlepath")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.subheadline.weight(.bold))
                }
                .accessibilityLabel("Plan options")
            }
        }
        .sheet(isPresented: $showTemplateSheet) {
            TemplatePickerSheet(storage: storage, currentTemplate: currentTemplate)
                .presentationDetents([.medium, .large])
        }
        .alert("Regenerate plan?", isPresented: $showRegenerateAlert) {
            Button("Regenerate", role: .destructive) { regenerate() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This replaces all weeks with fresh suggestions for the \(currentTemplate.title) template. Your existing entries will be lost.")
        }
        .onAppear {
            if storage.ninetyDayPlan == nil {
                seedInitialPlan()
                storage.unlockBadge("ninety_plan")
            }
            storage.trackToolUsed("ninety_day_planner")
        }
    }

    // MARK: - Template banner

    private var templateBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: currentTemplate.icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text("YOUR TEMPLATE")
                        .font(.caption2.weight(.heavy))
                        .tracking(1.2)
                        .foregroundStyle(.secondary)
                    Text(currentTemplate.title)
                        .font(.subheadline.weight(.heavy))
                }
                Spacer()
                Button {
                    showTemplateSheet = true
                } label: {
                    Text("Change")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(AppTheme.forestGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppTheme.forestGreen.opacity(0.12))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            Text(currentTemplate.subtitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
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

    // MARK: - Actions

    private func seedInitialPlan() {
        let template = NinetyDayPlanGenerator.suggestedTemplate(profile: storage.profile)
        storage.ninetyDayPlan = NinetyDayPlanGenerator.generate(profile: storage.profile, template: template)
        storage.profile.ninetyDayTemplate = template.rawValue
    }

    private func regenerate() {
        storage.ninetyDayPlan = NinetyDayPlanGenerator.generate(profile: storage.profile, template: currentTemplate)
    }
}

// MARK: - Template picker

private struct TemplatePickerSheet: View {
    @Bindable var storage: StorageService
    let currentTemplate: NinetyDayTemplate
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(NinetyDayTemplate.allCases) { template in
                        Button {
                            apply(template)
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: template.icon)
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 44, height: 44)
                                    .background(template == currentTemplate ? AppTheme.forestGreen : Color.gray.opacity(0.5))
                                    .clipShape(.rect(cornerRadius: 12))

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(template.title)
                                            .font(.subheadline.weight(.heavy))
                                            .foregroundStyle(.primary)
                                        if template == currentTemplate {
                                            Text("Current")
                                                .font(.caption2.weight(.heavy))
                                                .foregroundStyle(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(AppTheme.forestGreen, in: Capsule())
                                        }
                                    }
                                    Text(template.subtitle)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer(minLength: 4)
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Switching a template replaces all weeks with fresh suggestions. You can still edit, add, or remove anything.")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                        .padding(.horizontal, 12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Choose a template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func apply(_ template: NinetyDayTemplate) {
        storage.profile.ninetyDayTemplate = template.rawValue
        storage.ninetyDayPlan = NinetyDayPlanGenerator.generate(profile: storage.profile, template: template)
        dismiss()
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
                        .fixedSize(horizontal: false, vertical: true)
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
