import SwiftUI

struct AchievementBadgesView: View {
    let storage: StorageService
    @State private var selectedCategory: BadgeCategory?

    private var unlockedCount: Int {
        storage.badges.filter(\.isUnlocked).count
    }

    private var filteredBadges: [AchievementBadge] {
        guard let category = selectedCategory else { return storage.badges }
        return storage.badges.filter { $0.category == category }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                levelHeader
                categoryFilter
                badgesGrid
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var levelHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                ProgressRing(progress: storage.transitionLevel.progressToNextLevel, size: 72, lineWidth: 6, color: AppTheme.gold)
                    .overlay {
                        VStack(spacing: 0) {
                            Text("\(storage.transitionLevel.level)")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        }
                    }

                VStack(alignment: .leading, spacing: 6) {
                    Text(storage.transitionLevel.levelTitle)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text("\(storage.transitionLevel.totalXPEarned) XP total")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.7))
                    if storage.transitionLevel.level < 10 {
                        ProgressView(value: storage.transitionLevel.progressToNextLevel)
                            .tint(AppTheme.gold)
                        Text("\(storage.transitionLevel.xpForNextLevel - storage.transitionLevel.totalXPEarned) XP to next level")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white.opacity(0.6))
                    } else {
                        Text("Max level reached!")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                    }
                }
                Spacer()
            }

            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("\(unlockedCount)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                    Text("unlocked")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.6))
                }
                VStack(spacing: 2) {
                    Text("\(storage.badges.count - unlockedCount)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white.opacity(0.5))
                    Text("locked")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
            }
        }
        .padding(20)
        .background(AppTheme.heroMesh)
        .clipShape(.rect(cornerRadius: 20))
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    withAnimation(.spring(response: 0.3)) { selectedCategory = nil }
                }
                ForEach(BadgeCategory.allCases, id: \.rawValue) { cat in
                    FilterChip(title: cat.rawValue, isSelected: selectedCategory == cat) {
                        withAnimation(.spring(response: 0.3)) { selectedCategory = cat }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 0)
    }

    private var badgesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            ForEach(filteredBadges) { badge in
                BadgeCard(badge: badge)
            }
        }
    }
}

private struct BadgeCard: View {
    let badge: AchievementBadge

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ? badgeColor.opacity(0.15) : Color(.tertiarySystemGroupedBackground))
                    .frame(width: 56, height: 56)
                Image(systemName: badge.icon)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(badge.isUnlocked ? badgeColor : Color.primary.opacity(0.15))
                if !badge.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.primary.opacity(0.3))
                        .offset(x: 18, y: 18)
                }
            }

            Text(badge.title)
                .font(.caption.weight(.bold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(badge.isUnlocked ? Color.primary : Color.primary.opacity(0.4))

            Text(badge.subtitle)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .opacity(badge.isUnlocked ? 1 : 0.6)
    }

    private var badgeColor: Color {
        switch badge.category {
        case .getting_started: return AppTheme.forestGreen
        case .financial: return AppTheme.gold
        case .career: return .teal
        case .wellness: return .purple
        case .milestones: return .blue
        case .streak: return .orange
        }
    }
}
