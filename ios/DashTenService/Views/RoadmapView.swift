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
                VStack(spacing: 0) {
                    ForEach(Array(filteredPhases.enumerated()), id: \.element.id) { index, phase in
                        let isCurrent = phase == currentPhase
                        let isPast = isPhaseCompleted(phase)
                        let isLast = index == filteredPhases.count - 1

                        NavigationLink(value: phase) {
                            TimelineRow(
                                phase: phase,
                                completion: completionForPhase(phase),
                                itemCount: itemsForPhase(phase).count,
                                completedCount: itemsForPhase(phase).filter(\.isCompleted).count,
                                isCurrent: isCurrent,
                                isPast: isPast,
                                isLast: isLast
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
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

    private func isPhaseCompleted(_ phase: TimelinePhase) -> Bool {
        guard let current = currentPhase else { return false }
        let allPhases = TimelinePhase.allCases
        guard let currentIdx = allPhases.firstIndex(of: current),
              let phaseIdx = allPhases.firstIndex(of: phase) else { return false }
        return phaseIdx < currentIdx
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

struct TimelineRow: View {
    let phase: TimelinePhase
    let completion: Double
    let itemCount: Int
    let completedCount: Int
    let isCurrent: Bool
    let isPast: Bool
    let isLast: Bool

    private var nodeColor: Color {
        if isCurrent { return AppTheme.forestGreen }
        if isPast { return AppTheme.forestGreen.opacity(0.6) }
        return Color(.quaternaryLabel)
    }

    private var railColor: Color {
        if isPast { return AppTheme.forestGreen.opacity(0.4) }
        return Color(.quaternaryLabel)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                ZStack {
                    if isCurrent {
                        Circle()
                            .fill(AppTheme.forestGreen.opacity(0.15))
                            .frame(width: 40, height: 40)

                        Circle()
                            .fill(AppTheme.forestGreen)
                            .frame(width: 24, height: 24)

                        Image(systemName: "location.fill")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                    } else if isPast && completion >= 1.0 {
                        Circle()
                            .fill(AppTheme.forestGreen.opacity(0.15))
                            .frame(width: 40, height: 40)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(AppTheme.forestGreen)
                    } else {
                        Circle()
                            .stroke(nodeColor, lineWidth: 2)
                            .frame(width: 20, height: 20)

                        if isPast {
                            Circle()
                                .fill(nodeColor)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .frame(width: 40, height: 40)

                if !isLast {
                    Rectangle()
                        .fill(railColor)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 40)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(phase.rawValue)
                        .font(.headline.weight(.bold))
                    if isCurrent {
                        Text("YOU ARE HERE")
                            .font(.caption2.weight(.heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(AppTheme.forestGreen)
                            .clipShape(Capsule())
                    }
                }

                Text(phase.subtitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))

                HStack(spacing: 12) {
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(AppTheme.forestGreen.opacity(0.12))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(AppTheme.forestGreen)
                                .frame(width: proxy.size.width * completion, height: 6)
                                .animation(.spring(response: 0.5), value: completion)
                        }
                    }
                    .frame(height: 6)

                    Text("\(completedCount)/\(itemCount)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                        .fixedSize()
                }

                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.3))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 12)
            .padding(.trailing, 4)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
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
                phaseHero

                ForEach(groupedByCategory, id: \.0) { category, categoryItems in
                    VStack(alignment: .leading, spacing: 10) {
                        Label(category.rawValue, systemImage: category.icon)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)

                        VStack(spacing: 10) {
                            ForEach(categoryItems) { item in
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
        .navigationBarTitleDisplayMode(.inline)
    }

    private var phaseHero: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: phase.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 3) {
                    Text(phase.rawValue)
                        .font(.title3.weight(.bold))
                    Text(phase.subtitle)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                }
                Spacer()
            }

            let completed = items.filter(\.isCompleted).count
            HStack(spacing: 8) {
                ProgressView(value: items.isEmpty ? 0 : Double(completed) / Double(items.count))
                    .tint(AppTheme.forestGreen)
                Text("\(completed)/\(items.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 16))
    }
}

struct TaskHowToCard: View {
    let item: ChecklistItem
    let storage: StorageService
    @State private var isExpanded: Bool = false

    private var howTo: TaskHowTo? { TaskHowToData.howTo(for: item.id) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        storage.toggleChecklistItem(item.id)
                    }
                } label: {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : Color.primary.opacity(0.35))
                        .symbolEffect(.bounce, value: item.isCompleted)
                }
                .sensoryFeedback(.success, trigger: item.isCompleted)
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.subheadline.weight(.bold))
                        .strikethrough(item.isCompleted)
                        .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    if !item.subtitle.isEmpty {
                        Text(item.subtitle)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if howTo != nil {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .frame(width: 28, height: 28)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)

            if isExpanded, let howTo {
                VStack(alignment: .leading, spacing: 10) {
                    Divider()
                    HStack(spacing: 6) {
                        Image(systemName: "list.number")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("How to do this")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(AppTheme.forestGreen)
                            .textCase(.uppercase)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(howTo.steps.enumerated()), id: \.offset) { idx, step in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(idx + 1)")
                                    .font(.caption.weight(.heavy))
                                    .foregroundStyle(.white)
                                    .frame(width: 20, height: 20)
                                    .background(AppTheme.forestGreen)
                                    .clipShape(Circle())
                                Text(step)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(.primary.opacity(0.85))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    if let tip = howTo.tip {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.gold)
                                .padding(.top, 2)
                            Text(tip)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.85))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.gold.opacity(0.08))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    if let link = howTo.link, let url = URL(string: link.url) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "arrow.up.right.square")
                                Text(link.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption2.weight(.bold))
                            }
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(10)
                            .background(AppTheme.forestGreen.opacity(0.08))
                            .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }
                .padding(14)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
        .contextMenu {
            Button {
                withAnimation { storage.toggleChecklistItem(item.id) }
            } label: {
                Label(item.isCompleted ? "Mark Incomplete" : "Mark Complete",
                      systemImage: item.isCompleted ? "circle" : "checkmark.circle.fill")
            }
            if item.isCustom {
                Button(role: .destructive) {
                    storage.removeChecklistItem(item.id)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
