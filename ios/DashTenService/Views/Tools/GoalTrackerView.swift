import SwiftUI

struct GoalTrackerView: View {
    let storage: StorageService
    @State private var showAddGoal: Bool = false
    @State private var newGoalTitle: String = ""
    @State private var newGoalDeadline: Date = Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()

    private var activeGoals: [GoalItem] {
        storage.goals.filter { !$0.isCompleted }
    }

    private var completedGoals: [GoalItem] {
        storage.goals.filter(\.isCompleted)
    }

    private var overallProgress: Double {
        guard !storage.goals.isEmpty else { return 0 }
        return storage.goals.reduce(0.0) { $0 + $1.progress } / Double(storage.goals.count)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                progressHeader

                if showAddGoal {
                    addGoalSection
                }

                if activeGoals.isEmpty && !showAddGoal {
                    emptyState
                } else {
                    activeGoalsSection
                }

                if !completedGoals.isEmpty {
                    completedGoalsSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("90-Day Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3)) { showAddGoal.toggle() }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }
        }
    }

    private var progressHeader: some View {
        HStack(spacing: 16) {
            ProgressRing(progress: overallProgress, size: 64, lineWidth: 6)
                .overlay {
                    Text("\(Int(overallProgress * 100))%")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.forestGreen)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("Overall Progress")
                    .font(.headline.weight(.bold))
                Text("\(activeGoals.count) active, \(completedGoals.count) completed")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [AppTheme.forestGreen.opacity(0.08), AppTheme.gold.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
    }

    private var addGoalSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("New Goal")
                .font(.headline.weight(.bold))

            TextField("What do you want to accomplish?", text: $newGoalTitle)
                .font(.body.weight(.semibold))
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))

            DatePicker("Target Date", selection: $newGoalDeadline, in: Date()..., displayedComponents: .date)
                .font(.subheadline.weight(.semibold))
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showAddGoal = false
                        newGoalTitle = ""
                    }
                } label: {
                    Text("Cancel")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 12))
                }

                Button {
                    guard !newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    let goal = GoalItem(title: newGoalTitle, deadline: newGoalDeadline)
                    storage.addGoal(goal)
                    withAnimation(.spring(response: 0.3)) {
                        showAddGoal = false
                        newGoalTitle = ""
                        newGoalDeadline = Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()
                    }
                } label: {
                    Text("Add Goal")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "target")
                .font(.system(size: 40))
                .foregroundStyle(AppTheme.forestGreen.opacity(0.4))

            Text("Set Your First Goal")
                .font(.headline.weight(.bold))

            Text("The first 90 days after separation are critical. Set 3-5 concrete goals to keep yourself on track.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
                .multilineTextAlignment(.center)

            Button {
                withAnimation(.spring(response: 0.3)) { showAddGoal = true }
            } label: {
                Label("Add a Goal", systemImage: "plus.circle.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppTheme.forestGreen)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private var activeGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Goals")
                .font(.headline.weight(.bold))

            ForEach(activeGoals) { goal in
                goalCard(goal)
            }
        }
    }

    private func goalCard(_ goal: GoalItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text(goal.deadline, format: .dateTime.month(.abbreviated).day())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(daysUntil(goal.deadline) < 7 ? .red : .primary.opacity(0.5))
            }

            HStack(spacing: 12) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.primary.opacity(0.08))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.forestGreen)
                            .frame(width: geo.size.width * goal.progress)
                            .animation(.spring(response: 0.3), value: goal.progress)
                    }
                }
                .frame(height: 8)

                Text("\(Int(goal.progress * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                    .frame(width: 36)
            }

            HStack(spacing: 8) {
                ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { value in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            storage.updateGoalProgress(goal.id, progress: value)
                        }
                    } label: {
                        Text("\(Int(value * 100))%")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(goal.progress >= value ? .white : .primary.opacity(0.6))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(goal.progress >= value ? AppTheme.forestGreen : Color(.tertiarySystemGroupedBackground))
                            .clipShape(Capsule())
                    }
                    .sensoryFeedback(.selection, trigger: goal.progress)
                }

                Spacer()

                Button {
                    storage.removeGoal(goal.id)
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundStyle(.red.opacity(0.6))
                }
            }

            let days = daysUntil(goal.deadline)
            if days > 0 {
                Text("\(days) days remaining")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(days < 7 ? .red : .primary.opacity(0.5))
            } else {
                Text("Past deadline")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.red)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var completedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed")
                .font(.headline.weight(.bold))

            ForEach(completedGoals) { goal in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.forestGreen)

                    Text(goal.title)
                        .font(.subheadline.weight(.semibold))
                        .strikethrough()
                        .foregroundStyle(.primary.opacity(0.6))

                    Spacer()
                }
                .padding(12)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }

    private func daysUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}
