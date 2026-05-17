import SwiftUI

// MARK: - ReadinessCategory color

extension ReadinessCategory {
    var accentColor: Color {
        switch self {
        case .admin: return .gray
        case .health: return .red
        case .education: return .blue
        case .employment: return .teal
        case .family: return .pink
        case .finance: return AppTheme.gold
        case .housing: return AppTheme.forestGreen
        }
    }
}

// MARK: - Phase tag

extension TimelinePhase {
    var tagLabel: String {
        switch self {
        case .eighteenToTwentyFour: return "18–24 mo"
        case .twelveMonths: return "12 mo"
        case .sixMonths: return "6 mo"
        case .ninetyDays: return "90 days"
        case .thirtyDays: return "30 days"
        case .firstThirty: return "First 30 days"
        case .firstNinety: return "First 90 days"
        case .firstYear: return "First year"
        case .yearTwoPlus: return "Year 2+"
        }
    }
}

// MARK: - CategoryCard

struct CategoryCard: View {
    let category: ReadinessCategory
    let completion: Double
    let completedCount: Int
    let totalCount: Int
    let nextOpenTitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(category.accentColor.opacity(0.18), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    Circle()
                        .trim(from: 0, to: completion)
                        .stroke(category.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.5), value: completion)
                    Image(systemName: category.icon)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(category.accentColor)
                }
                Spacer(minLength: 0)
                Text("\(completedCount)/\(totalCount)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                if let next = nextOpenTitle {
                    Text(next)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                        Text("All done")
                            .font(.caption2.weight(.heavy))
                    }
                    .foregroundStyle(category.accentColor)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 130)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
        .contentShape(Rectangle())
    }
}

// MARK: - CategoryDetailView

struct CategoryDetailView: View {
    let storage: StorageService
    let category: ReadinessCategory

    private var items: [ChecklistItem] {
        storage.checklistItems
            .filter { $0.readinessCategory == category }
            .sorted { lhs, rhs in
                let phases = TimelinePhase.allCases
                let li = phases.firstIndex(of: lhs.phase) ?? 0
                let ri = phases.firstIndex(of: rhs.phase) ?? 0
                if li != ri { return li < ri }
                return lhs.title < rhs.title
            }
    }

    private var groupedByPhase: [(TimelinePhase, [ChecklistItem])] {
        let grouped = Dictionary(grouping: items, by: \.phase)
        return TimelinePhase.allCases.compactMap { phase in
            guard let entries = grouped[phase], !entries.isEmpty else { return nil }
            return (phase, entries)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroHeader

                ForEach(groupedByPhase, id: \.0) { phase, phaseItems in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Text(phase.tagLabel.uppercased())
                                .font(.caption2.weight(.heavy))
                                .tracking(1.2)
                                .foregroundStyle(category.accentColor)
                            Rectangle()
                                .fill(category.accentColor.opacity(0.25))
                                .frame(height: 1)
                        }
                        VStack(spacing: 10) {
                            ForEach(phaseItems) { item in
                                TaskHowToCard(item: item, storage: storage)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroHeader: some View {
        let completed = items.filter(\.isCompleted).count
        let total = items.count
        let pct = total == 0 ? 0 : Double(completed) / Double(total)
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: category.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(category.accentColor)
                    .clipShape(.rect(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 3) {
                    Text(category.rawValue)
                        .font(.title3.weight(.bold))
                    Text("\(completed) of \(total) done")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            ProgressView(value: pct)
                .tint(category.accentColor)
        }
        .padding(16)
        .background(category.accentColor.opacity(0.08))
        .clipShape(.rect(cornerRadius: 16))
        .padding(.top, 8)
    }
}

// MARK: - EarlyItemsCheckInSheet

struct EarlyItemsCheckInSheet: View {
    let storage: StorageService
    let currentPhase: TimelinePhase?
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var pickedSome: Bool = false
    @State private var selected: Set<String> = []

    private var earlierItems: [ChecklistItem] {
        guard let current = currentPhase else { return [] }
        let phases = TimelinePhase.preSeparationPhases
        guard let currentIdx = phases.firstIndex(of: current) else { return [] }
        let earlierPhases = Set(phases.prefix(currentIdx))
        return storage.checklistItems
            .filter { earlierPhases.contains($0.phase) && !$0.isCompleted }
            .sorted { lhs, rhs in
                let allPhases = TimelinePhase.allCases
                return (allPhases.firstIndex(of: lhs.phase) ?? 0) < (allPhases.firstIndex(of: rhs.phase) ?? 0)
            }
    }

    private var phaseLabel: String {
        currentPhase?.displayName ?? "your current window"
    }

    var body: some View {
        NavigationStack {
            Group {
                if pickedSome {
                    pickList
                } else {
                    intro
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Catch up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") { finish() }
                }
            }
        }
        .presentationDetents([.large])
    }

    private var intro: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "flag.checkered")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(
                            LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(.rect(cornerRadius: 16))
                    Text("You're at \(phaseLabel).")
                        .font(.title2.weight(.bold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Have you already taken care of the earlier-planning items? Tell us once and your roadmap will reflect the truth.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 10) {
                    Button {
                        markAllEarlier()
                        finish()
                    } label: {
                        optionLabel(
                            icon: "checkmark.circle.fill",
                            title: "Yes, mark them all done",
                            subtitle: "\(earlierItems.count) earlier task\(earlierItems.count == 1 ? "" : "s") will be checked off.",
                            tint: AppTheme.forestGreen
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(earlierItems.isEmpty)

                    Button {
                        withAnimation(.spring(response: 0.35)) { pickedSome = true }
                    } label: {
                        optionLabel(
                            icon: "checklist",
                            title: "Some — let me pick",
                            subtitle: "Check off only the ones you actually finished.",
                            tint: AppTheme.gold
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(earlierItems.isEmpty)

                    Button {
                        finish()
                    } label: {
                        optionLabel(
                            icon: "xmark.circle",
                            title: "No, keep them open",
                            subtitle: "Leave earlier tasks as to-dos in your roadmap.",
                            tint: .secondary
                        )
                    }
                    .buttonStyle(.plain)
                }

                if earlierItems.isEmpty {
                    Text("No earlier-phase tasks to catch up on — you're set.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
    }

    private func optionLabel(icon: String, title: String, subtitle: String, tint: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(tint)
                .clipShape(.rect(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .contentShape(Rectangle())
    }

    private var pickList: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(earlierItems) { item in
                        Button {
                            if selected.contains(item.id) { selected.remove(item.id) }
                            else { selected.insert(item.id) }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: selected.contains(item.id) ? "checkmark.square.fill" : "square")
                                    .font(.title3)
                                    .foregroundStyle(selected.contains(item.id) ? AppTheme.forestGreen : .secondary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(item.phase.tagLabel)
                                        .font(.caption2.weight(.heavy))
                                        .foregroundStyle(item.readinessCategory.accentColor)
                                }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Tap each task you've already completed")
                }
            }
            .listStyle(.insetGrouped)

            Button {
                markSelected()
                finish()
            } label: {
                Text(selected.isEmpty ? "Done" : "Mark \(selected.count) as complete")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }

    private func markAllEarlier() {
        let ids = earlierItems.map(\.id)
        for id in ids where !storage.checklistItems.first(where: { $0.id == id })!.isCompleted {
            storage.toggleChecklistItem(id)
        }
    }

    private func markSelected() {
        for id in selected {
            if let item = storage.checklistItems.first(where: { $0.id == id }), !item.isCompleted {
                storage.toggleChecklistItem(id)
            }
        }
    }

    private func finish() {
        onDismiss()
        dismiss()
    }
}
