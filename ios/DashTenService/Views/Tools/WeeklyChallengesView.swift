import SwiftUI

struct WeeklyChallengesView: View {
    @Bindable var storage: StorageService

    private var currentWeekStart: Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
    }

    private var activeChallenges: [WeeklyChallenge] {
        let weekStart = currentWeekStart
        let existing = storage.weeklyChallenges.filter {
            Calendar.current.isDate($0.weekStartDate, equalTo: weekStart, toGranularity: .weekOfYear)
        }
        if existing.isEmpty {
            let newChallenges = GamificationService.generateWeeklyChallenges(weekStart: weekStart)
            Task { @MainActor in
                storage.weeklyChallenges.append(contentsOf: newChallenges)
            }
            return newChallenges
        }
        return existing
    }

    private var completedCount: Int {
        activeChallenges.filter(\.isCompleted).count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                weekHeader

                ForEach(activeChallenges) { challenge in
                    ChallengeCard(challenge: challenge) {
                        completeChallenge(challenge.id)
                    }
                }

                streakSection
                xpExplainer
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Weekly Challenges")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            storage.trackToolUsed("weekly_challenges")
        }
    }

    private var weekHeader: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Week's Challenges")
                        .font(.title3.weight(.bold))
                    Text("Complete challenges to earn XP and level up")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text("\(completedCount)/\(activeChallenges.count)")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                    Text("done")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
            }

            ProgressView(value: Double(completedCount), total: Double(max(activeChallenges.count, 1)))
                .tint(AppTheme.forestGreen)

            if completedCount == activeChallenges.count && !activeChallenges.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(AppTheme.gold)
                    Text("All challenges complete! Nice work.")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(AppTheme.gold.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private var streakSection: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("Level \(storage.transitionLevel.level)")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text(storage.transitionLevel.levelTitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(storage.transitionLevel.totalXPEarned) XP")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    if storage.transitionLevel.level < 10 {
                        Text("\(storage.transitionLevel.xpForNextLevel) XP to next")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.tertiary)
                    }
                }
                ProgressView(value: storage.transitionLevel.progressToNextLevel)
                    .tint(AppTheme.gold)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var xpExplainer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How to Earn XP")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            XPRow(action: "Complete a checklist item", xp: "+10 XP")
            XPRow(action: "Write a journal entry", xp: "+10 XP")
            XPRow(action: "Weekly check-in", xp: "+15 XP")
            XPRow(action: "Verify a document", xp: "+15 XP")
            XPRow(action: "Unlock a badge", xp: "+20 XP")
            XPRow(action: "Complete a goal", xp: "+25 XP")
            XPRow(action: "Use a tool", xp: "+5 XP")
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func completeChallenge(_ id: String) {
        let weekStart = currentWeekStart
        guard let idx = storage.weeklyChallenges.firstIndex(where: {
            $0.id == id && Calendar.current.isDate($0.weekStartDate, equalTo: weekStart, toGranularity: .weekOfYear)
        }) else { return }
        guard !storage.weeklyChallenges[idx].isCompleted else { return }
        storage.weeklyChallenges[idx].isCompleted = true
        storage.awardXP(storage.weeklyChallenges[idx].xpReward)
        storage.unlockBadge("challenge_done")
    }
}

private struct ChallengeCard: View {
    let challenge: WeeklyChallenge
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: challenge.icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(challenge.isCompleted ? Color.gray : AppTheme.forestGreen)
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.subheadline.weight(.bold))
                    .strikethrough(challenge.isCompleted)
                Text(challenge.description)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if challenge.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(AppTheme.forestGreen)
            } else {
                VStack(spacing: 2) {
                    Text("+\(challenge.xpReward)")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(AppTheme.gold)
                    Text("XP")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.tertiary)
                }

                Button {
                    withAnimation(.spring(response: 0.3)) { onComplete() }
                } label: {
                    Text("Done")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(AppTheme.forestGreen)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .opacity(challenge.isCompleted ? 0.7 : 1)
    }
}

private struct XPRow: View {
    let action: String
    let xp: String

    var body: some View {
        HStack {
            Text(action)
                .font(.caption.weight(.medium))
                .foregroundStyle(.primary.opacity(0.8))
            Spacer()
            Text(xp)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.gold)
        }
    }
}
