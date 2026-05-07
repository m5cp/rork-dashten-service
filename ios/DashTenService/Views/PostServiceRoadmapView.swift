import SwiftUI

nonisolated enum NextStepPillar: String, CaseIterable, Identifiable, Hashable {
    case benefits = "Benefits"
    case career = "Career & Resume"
    case mindset = "Mindset & Wellness"
    case growth = "Long-Term Growth"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .benefits: "shield.lefthalf.filled"
        case .career: "briefcase.fill"
        case .mindset: "brain.head.profile"
        case .growth: "chart.line.uptrend.xyaxis"
        }
    }

    var subtitle: String {
        switch self {
        case .benefits: "VA, healthcare, claims, state perks"
        case .career: "Resume, LinkedIn, certs, interviews"
        case .mindset: "Identity, wellness, family"
        case .growth: "Education, finances, mentoring"
        }
    }

    var color: Color {
        switch self {
        case .benefits: AppTheme.forestGreen
        case .career: Color(red: 0.07, green: 0.36, blue: 0.42)
        case .mindset: Color(red: 0.55, green: 0.27, blue: 0.42)
        case .growth: AppTheme.gold
        }
    }

    var taskIDs: [String] {
        switch self {
        case .benefits:
            return ["p30_2", "p30_3", "p90_1", "p90_3", "p90_4", "p90_6", "p90_7",
                    "ret_1", "ret_4", "ret_6", "sep_1"]
        case .career:
            return ["py1_1", "py1_2", "py1_3", "py1_4", "py1_5",
                    "sep_2", "sep_3", "sep_4", "sep_5"]
        case .mindset:
            return ["py1_6", "py1_8", "py2_5", "py2_6", "p30_5", "p30_7"]
        case .growth:
            return ["p90_5", "py1_7", "py2_1", "py2_2", "py2_3", "py2_4", "py2_7",
                    "ret_2", "ret_3", "ret_5"]
        }
    }
}

struct PostServiceRoadmapView: View {
    @Bindable var storage: StorageService
    @State private var reviewExpanded: Bool = false
    @State private var pillarSelection: NextStepPillar?

    private var status: PostServiceStatus {
        storage.profile.postServiceStatus ?? .separated
    }

    private var greeting: String {
        status == .retired ? "Welcome to retirement" : "Welcome back, Veteran"
    }

    private var subhead: String {
        status == .retired
            ? "Your roadmap is now about pension, Tricare, family planning, and what's next."
            : "Your roadmap is now forward-looking — benefits, career, mindset, and growth."
    }

    private var preSepItems: [ChecklistItem] {
        let phases = Set(TimelinePhase.preSeparationPhases)
        return storage.checklistItems.filter { phases.contains($0.phase) }
    }

    private var preSepCompleted: Int {
        preSepItems.filter(\.isCompleted).count
    }

    private var preSepGaps: Int {
        preSepItems.count - preSepCompleted
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroHeader
                preSeparationReviewCard
                pillarsSection
                timelineSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Roadmap")
        .navigationDestination(for: NextStepPillar.self) { pillar in
            PillarDetailView(storage: storage, pillar: pillar)
        }
        .navigationDestination(for: TimelinePhase.self) { phase in
            PhaseDetailView(storage: storage, phase: phase)
        }
    }

    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: status.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text(greeting)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
            }
            Text(subhead)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            LinearGradient(
                colors: [AppTheme.darkGreen, AppTheme.forestGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 18))
        .padding(.top, 8)
    }

    private var preSeparationReviewCard: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    reviewExpanded.toggle()
                }
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: preSepGaps == 0 ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(preSepGaps == 0 ? AppTheme.forestGreen : Color.orange)
                        .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Pre-Separation Review")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.primary)
                        Text(preSepGaps == 0
                             ? "All steps reviewed — tap to expand if you want to flag a gap"
                             : "\(preSepGaps) item\(preSepGaps == 1 ? "" : "s") still need attention")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(reviewExpanded ? 180 : 0))
                }
                .padding(14)
            }
            .buttonStyle(.plain)

            if reviewExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                    Text("You've already crossed the starting line. Tap any step to flag it as a gap you still need to close.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    if preSepCompleted < preSepItems.count {
                        Button {
                            withAnimation(.spring(response: 0.4)) {
                                storage.bulkMarkPreSeparationComplete()
                            }
                        } label: {
                            Label("Mark all as reviewed & complete", systemImage: "checkmark.circle.fill")
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.forestGreen)
                                .clipShape(.rect(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .sensoryFeedback(.success, trigger: preSepCompleted)
                    }

                    ForEach(TimelinePhase.preSeparationPhases) { phase in
                        let items = preSepItems.filter { $0.phase == phase }
                        if !items.isEmpty {
                            phaseGroup(phase: phase, items: items)
                        }
                    }
                }
                .padding(14)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func phaseGroup(phase: TimelinePhase, items: [ChecklistItem]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(phase.rawValue.uppercased())
                .font(.caption2.weight(.heavy))
                .foregroundStyle(AppTheme.forestGreen)
            ForEach(items) { item in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        storage.toggleChecklistItem(item.id)
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(item.isCompleted ? AppTheme.forestGreen : .orange)
                        Text(item.title)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(item.isCompleted ? .secondary : .primary)
                            .strikethrough(item.isCompleted)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if !item.isCompleted {
                            Text("Gap")
                                .font(.caption2.weight(.heavy))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.orange)
                                .clipShape(Capsule())
                        }
                    }
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: item.isCompleted)
            }
        }
    }

    private var pillarsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("What's Next")
                    .font(.title3.weight(.heavy))
                Spacer()
                Text("Your forward roadmap")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(NextStepPillar.allCases) { pillar in
                    NavigationLink(value: pillar) {
                        PillarCard(
                            pillar: pillar,
                            completion: pillarCompletion(pillar),
                            totalCount: pillarItems(pillar).count,
                            completedCount: pillarItems(pillar).filter(\.isCompleted).count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func pillarItems(_ pillar: NextStepPillar) -> [ChecklistItem] {
        let ids = Set(pillar.taskIDs)
        return storage.checklistItems.filter { ids.contains($0.id) }
    }

    private func pillarCompletion(_ pillar: NextStepPillar) -> Double {
        let items = pillarItems(pillar)
        guard !items.isEmpty else { return 0 }
        return Double(items.filter(\.isCompleted).count) / Double(items.count)
    }

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Post-Service Timeline")
                    .font(.title3.weight(.heavy))
                Spacer()
                Text("First 30 → Year 2+")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 0) {
                ForEach(Array(TimelinePhase.postServicePhases.enumerated()), id: \.element.id) { index, phase in
                    let items = storage.checklistItems.filter { $0.phase == phase }
                    let completed = items.filter(\.isCompleted).count
                    NavigationLink(value: phase) {
                        TimelineRow(
                            phase: phase,
                            completion: items.isEmpty ? 0 : Double(completed) / Double(items.count),
                            itemCount: items.count,
                            completedCount: completed,
                            isCurrent: false,
                            isPast: false,
                            isLast: index == TimelinePhase.postServicePhases.count - 1
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct PillarCard: View {
    let pillar: NextStepPillar
    let completion: Double
    let totalCount: Int
    let completedCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: pillar.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.18))
                    .clipShape(.rect(cornerRadius: 10))
                Spacer()
                Text("\(completedCount)/\(totalCount)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(pillar.rawValue)
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(.white)
                Text(pillar.subtitle)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.white.opacity(0.2))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.white)
                        .frame(width: proxy.size.width * completion, height: 5)
                        .animation(.spring(response: 0.5), value: completion)
                }
            }
            .frame(height: 5)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [pillar.color, pillar.color.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: pillar.color.opacity(0.25), radius: 8, y: 4)
    }
}

struct PillarDetailView: View {
    let storage: StorageService
    let pillar: NextStepPillar

    private var items: [ChecklistItem] {
        let ids = Set(pillar.taskIDs)
        return storage.checklistItems.filter { ids.contains($0.id) }
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
                hero
                ForEach(groupedByCategory, id: \.0) { category, categoryItems in
                    VStack(alignment: .leading, spacing: 10) {
                        Label(category.rawValue, systemImage: category.icon)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(pillar.color)
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
        .navigationTitle(pillar.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        let completed = items.filter(\.isCompleted).count
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: pillar.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(.white.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 3) {
                    Text(pillar.rawValue)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(pillar.subtitle)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
            }
            HStack(spacing: 8) {
                ProgressView(value: items.isEmpty ? 0 : Double(completed) / Double(items.count))
                    .tint(.white)
                Text("\(completed)/\(items.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [pillar.color, pillar.color.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .padding(.top, 8)
    }
}
