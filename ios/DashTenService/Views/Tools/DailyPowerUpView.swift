import SwiftUI

struct DailyPowerUpView: View {
    let storage: StorageService
    @State private var appeared: Bool = false

    private var todaysPowerUp: DailyPowerUp {
        let powerUps = GamificationService.dailyPowerUps()
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return powerUps[dayOfYear % powerUps.count]
    }

    private var todaysPriority: ChecklistItem? {
        let incomplete = storage.checklistItems.filter { !$0.isCompleted }
        return incomplete.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                quoteCard
                priorityCard
                levelProgress
                quickActions
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Daily Power-Up")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
            storage.lastDailyPowerUpDate = Date()
        }
    }

    private var quoteCard: some View {
        VStack(spacing: 20) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.gold)
                .symbolEffect(.pulse, value: appeared)

            Text("\"\(todaysPowerUp.quote)\"")
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text("- \(todaysPowerUp.author)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(AppTheme.heroMesh)
        .clipShape(.rect(cornerRadius: 20))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
    }

    private var priorityCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "scope")
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("TODAY'S #1 PRIORITY")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(AppTheme.forestGreen)
            }

            if let priority = todaysPriority {
                HStack(spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            storage.toggleChecklistItem(priority.id)
                        }
                    } label: {
                        Image(systemName: priority.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundStyle(priority.isCompleted ? AppTheme.forestGreen : .primary.opacity(0.3))
                            .symbolEffect(.bounce, value: priority.isCompleted)
                    }
                    .sensoryFeedback(.success, trigger: priority.isCompleted)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(priority.title)
                            .font(.headline.weight(.bold))
                            .strikethrough(priority.isCompleted)
                        if !priority.subtitle.isEmpty {
                            Text(priority.subtitle)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            } else {
                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundStyle(AppTheme.gold)
                    Text("All caught up! Take a moment to reflect on your progress.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.forestGreen.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppTheme.forestGreen.opacity(0.12), lineWidth: 1)
                )
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.15), value: appeared)
    }

    private var levelProgress: some View {
        HStack(spacing: 16) {
            ProgressRing(progress: storage.transitionLevel.progressToNextLevel, size: 56, lineWidth: 5, color: AppTheme.gold)
                .overlay {
                    Text("Lv\(storage.transitionLevel.level)")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(AppTheme.gold)
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(storage.transitionLevel.levelTitle)
                    .font(.headline.weight(.bold))
                Text("\(storage.transitionLevel.totalXPEarned) XP earned")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                if storage.transitionLevel.level < 10 {
                    ProgressView(value: storage.transitionLevel.progressToNextLevel)
                        .tint(AppTheme.gold)
                }
            }

            Spacer()

            VStack(spacing: 2) {
                Text("\(storage.badges.filter(\.isUnlocked).count)")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("badges")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.2), value: appeared)
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                QuickActionCard(icon: "book.fill", title: "Journal", subtitle: "Write today", color: .purple)
                QuickActionCard(icon: "chart.xyaxis.line", title: "Check-In", subtitle: "How are you?", color: .blue)
                QuickActionCard(icon: "target", title: "Goals", subtitle: "Review progress", color: AppTheme.forestGreen)
                QuickActionCard(icon: "person.3.fill", title: "Network", subtitle: "Add a contact", color: .teal)
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.6).delay(0.25), value: appeared)
    }
}

private struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(color)
            Text(title)
                .font(.caption.weight(.bold))
            Text(subtitle)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }
}
