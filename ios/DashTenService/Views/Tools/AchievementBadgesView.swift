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
                summaryHeader
                categoryFilter
                badgesGrid
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var progress: Double {
        guard !storage.badges.isEmpty else { return 0 }
        return Double(unlockedCount) / Double(storage.badges.count)
    }

    private var summaryHeader: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 7)
                Circle()
                    .trim(from: 0, to: min(progress, 1.0))
                    .stroke(AppTheme.gold, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6), value: progress)
                VStack(spacing: 0) {
                    Text("\(unlockedCount)")
                        .font(.title2.weight(.heavy))
                        .foregroundStyle(.white)
                    Text("of \(storage.badges.count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .frame(width: 84, height: 84)

            VStack(alignment: .leading, spacing: 6) {
                Text("Your Badges")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                Text(unlockedCount == 0
                     ? "Take any action to earn your first badge."
                     : "Earned by completing real tasks across your transition.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
                        .foregroundStyle(Color.primary.opacity(0.7))
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
