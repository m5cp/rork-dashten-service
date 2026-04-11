import SwiftUI

struct RoadmapView: View {
    let storage: StorageService
    @State private var searchText: String = ""
    @State private var showAddItem: Bool = false
    @State private var newItemTitle: String = ""
    @State private var newItemPhase: TimelinePhase = .eighteenToTwentyFour
    @State private var newItemCategory: ReadinessCategory = .admin

    private func itemsForPhase(_ phase: TimelinePhase) -> [ChecklistItem] {
        storage.checklistItems.filter { $0.phase == phase }
    }

    private func completionForPhase(_ phase: TimelinePhase) -> Double {
        let items = itemsForPhase(phase)
        guard !items.isEmpty else { return 0 }
        return Double(items.filter(\.isCompleted).count) / Double(items.count)
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

    private var filteredPhases: [TimelinePhase] {
        guard !searchText.isEmpty else { return TimelinePhase.allCases.map { $0 } }
        return TimelinePhase.allCases.filter { phase in
            itemsForPhase(phase).contains { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredPhases) { phase in
                        NavigationLink(value: phase) {
                            PhaseCard(
                                phase: phase,
                                completion: completionForPhase(phase),
                                itemCount: itemsForPhase(phase).count,
                                completedCount: itemsForPhase(phase).filter(\.isCompleted).count,
                                isCurrent: phase == currentPhase
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Roadmap")
            .searchable(text: $searchText, prompt: "Search tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddItem = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(AppTheme.forestGreen)
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                addItemSheet
            }
            .navigationDestination(for: TimelinePhase.self) { phase in
                PhaseDetailView(storage: storage, phase: phase)
            }
        }
    }

    private var addItemSheet: some View {
        NavigationStack {
            Form {
                Section("New Task") {
                    TextField("Task title", text: $newItemTitle)
                }
                Section("Phase") {
                    Picker("Timeline Phase", selection: $newItemPhase) {
                        ForEach(TimelinePhase.allCases) { phase in
                            Text(phase.rawValue).tag(phase)
                        }
                    }
                }
                Section("Category") {
                    Picker("Category", selection: $newItemCategory) {
                        ForEach(ReadinessCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Add Custom Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAddItem = false
                        newItemTitle = ""
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        storage.addCustomChecklistItem(
                            title: newItemTitle.trimmingCharacters(in: .whitespaces),
                            phase: newItemPhase,
                            category: newItemCategory
                        )
                        newItemTitle = ""
                        showAddItem = false
                    }
                    .disabled(newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct PhaseCard: View {
    let phase: TimelinePhase
    let completion: Double
    let itemCount: Int
    let completedCount: Int
    let isCurrent: Bool

    var body: some View {
        HStack(spacing: 14) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isCurrent ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: phase.icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(isCurrent ? .white : AppTheme.forestGreen)
                }
                if phase != TimelinePhase.allCases.last {
                    Rectangle()
                        .fill(AppTheme.forestGreen.opacity(0.2))
                        .frame(width: 2, height: 12)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(phase.rawValue)
                        .font(.headline.weight(.bold))
                    if isCurrent {
                        StatusBadge(text: "Current", color: AppTheme.forestGreen)
                    }
                }
                Text(phase.subtitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
                HStack(spacing: 12) {
                    ProgressView(value: completion)
                        .tint(AppTheme.forestGreen)
                    Text("\(completedCount)/\(itemCount)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.7))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary.opacity(0.5))
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isCurrent ? AppTheme.forestGreen.opacity(0.3) : .clear, lineWidth: 1.5)
        )
    }
}

struct PhaseDetailView: View {
    let storage: StorageService
    let phase: TimelinePhase

    private var items: [ChecklistItem] {
        storage.checklistItems.filter { $0.phase == phase }
    }

    private var groupedByCategory: [(ReadinessCategory, [ChecklistItem])] {
        let grouped = Dictionary(grouping: items, by: \.readinessCategory)
        return ReadinessCategory.allCases.compactMap { cat in
            guard let items = grouped[cat], !items.isEmpty else { return nil }
            return (cat, items)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: phase.icon)
                            .font(.title2)
                            .foregroundStyle(AppTheme.forestGreen)
                        Text(phase.rawValue)
                            .font(.title2.bold())
                    }
                    Text(phase.subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))

                    let completed = items.filter(\.isCompleted).count
                    HStack(spacing: 8) {
                        ProgressView(value: items.isEmpty ? 0 : Double(completed) / Double(items.count))
                            .tint(AppTheme.forestGreen)
                        Text("\(completed) of \(items.count) complete")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                }

                ForEach(groupedByCategory, id: \.0) { category, categoryItems in
                    VStack(alignment: .leading, spacing: 10) {
                        Label(category.rawValue, systemImage: category.icon)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)

                        VStack(spacing: 6) {
                            ForEach(categoryItems) { item in
                                HStack(spacing: 12) {
                                    Button {
                                        withAnimation(.spring(response: 0.3)) {
                                            storage.toggleChecklistItem(item.id)
                                        }
                                    } label: {
                                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title3)
                                            .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : Color.primary.opacity(0.5))
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 6) {
                                            Text(item.title)
                                                .font(.subheadline.weight(.semibold))
                                                .strikethrough(item.isCompleted)
                                                .foregroundStyle(item.isCompleted ? Color.primary.opacity(0.5) : Color.primary)
                                            if item.isCustom {
                                                Image(systemName: "person.fill")
                                                    .font(.caption2)
                                                    .foregroundStyle(Color.primary.opacity(0.5))
                                            }
                                        }
                                        if !item.subtitle.isEmpty {
                                            Text(item.subtitle)
                                                .font(.caption.weight(.medium))
                                                .foregroundStyle(.primary.opacity(0.6))
                                        }
                                    }
                                    Spacer()
                                    if item.isCustom {
                                        Button {
                                            storage.removeChecklistItem(item.id)
                                        } label: {
                                            Image(systemName: "trash")
                                                .font(.caption)
                                                .foregroundStyle(.red.opacity(0.8))
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(.rect(cornerRadius: 10))
                                .sensoryFeedback(.success, trigger: item.isCompleted)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}
