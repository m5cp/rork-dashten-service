import SwiftUI

// MARK: - Streak Strip with Freeze

struct StreakStripView: View {
    let storage: StorageService

    private var weekActivity: [(date: Date, active: Bool, isToday: Bool)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let hasJournal = storage.journalEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let hasCheckIn = storage.weeklyCheckIns.contains { calendar.isDate($0.date, inSameDayAs: date) }
            let isLastActive = storage.lastActiveDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
            return (date, hasJournal || hasCheckIn || isLastActive, offset == 0)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                    Text("\(storage.currentStreak)")
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())
                    Text(storage.currentStreak == 1 ? "day streak" : "day streak")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                if storage.streakFreezesAvailable > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "snowflake")
                            .font(.caption2.weight(.bold))
                        Text("×\(storage.streakFreezesAvailable)")
                            .font(.caption2.weight(.heavy))
                    }
                    .foregroundStyle(.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.cyan.opacity(0.12), in: Capsule())
                    .accessibilityLabel("\(storage.streakFreezesAvailable) streak freeze available")
                }

                Spacer()

                HStack(spacing: 6) {
                    ForEach(Array(weekActivity.enumerated()), id: \.offset) { _, day in
                        Circle()
                            .fill(day.active ? AppTheme.forestGreen : Color.primary.opacity(0.08))
                            .frame(width: day.isToday ? 12 : 8, height: day.isToday ? 12 : 8)
                            .overlay(
                                Circle().strokeBorder(day.isToday ? AppTheme.gold : .clear, lineWidth: 2)
                            )
                    }
                }
            }

            Text("Open the app or complete any task each day to grow your streak. Snowflakes protect a missed day.")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }
}

// MARK: - Weekly Summary Card

struct RetentionWeeklySummaryCard: View {
    let storage: StorageService

    private var summary: WeeklySummary { RetentionService.weeklySummary(storage: storage) }

    private var weekLabel: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        let end = Calendar.current.date(byAdding: .day, value: 6, to: summary.weekStart) ?? Date()
        return "\(f.string(from: summary.weekStart)) – \(f.string(from: end))"
    }

    private var nextStep: String {
        if summary.missionsCompleted < summary.missionsTotal {
            return "Finish a weekly mission to keep momentum."
        }
        if summary.journalEntries == 0 {
            return "Write a quick journal entry — even one line counts."
        }
        if summary.tasksCompleted == 0 {
            return "Knock out one checklist task this week."
        }
        return "Keep showing up. You're building real momentum."
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "chart.bar.fill")
                    .font(.caption.weight(.heavy))
                Text("THIS WEEK")
                    .font(.caption.weight(.heavy))
                    .tracking(1.2)
                Spacer()
                Text(weekLabel)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(AppTheme.gold)

            HStack(spacing: 10) {
                summaryStat(value: "\(summary.missionsCompleted)/\(summary.missionsTotal)", label: "missions", icon: "bolt.fill")
                summaryStat(value: "+\(summary.xpGained)", label: "XP gained", icon: "sparkles")
                summaryStat(value: "\(summary.journalEntries)", label: summary.journalEntries == 1 ? "entry" : "entries", icon: "book.fill")
            }

            HStack(spacing: 8) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text(nextStep)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func summaryStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text(value)
                .font(.headline.weight(.heavy))
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Reassessment Prompt

struct ReassessmentPromptCard: View {
    let storage: StorageService
    let onDismiss: () -> Void
    let onTakeAssessment: () -> Void

    private var daysSince: Int {
        let ref = storage.lastAssessment?.dateTaken ?? storage.profile.createdAt
        return Calendar.current.dateComponents([.day], from: ref, to: Date()).day ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.title3)
                    .foregroundStyle(AppTheme.gold)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Time for a check-in")
                        .font(.headline.weight(.bold))
                    Text("It's been \(daysSince) days since your last self-assessment.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                }
                .accessibilityLabel("Dismiss")
            }

            Button(action: onTakeAssessment) {
                HStack(spacing: 6) {
                    Text("Reassess my readiness")
                        .font(.subheadline.weight(.bold))
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .background(AppTheme.forestGreen)
                .clipShape(.rect(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.gold.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(AppTheme.gold.opacity(0.3), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 16))
    }
}
