import SwiftUI

struct ContentView: View {
    @State private var storage = StorageService()
    @State private var store = StoreViewModel()
    @State private var selectedTab: Int = 0
    @State private var showAICoach: Bool = false

    var body: some View {
        if storage.profile.hasCompletedOnboarding {
            mainTabView
                .tint(AppTheme.forestGreen)
        } else {
            OnboardingView(storage: storage)
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            Tab("Today", systemImage: "sun.max.fill", value: 0) {
                TodayView(storage: storage, store: store, selectedTab: $selectedTab)
            }
            Tab("Plan", systemImage: "map.fill", value: 1) {
                PlanView(storage: storage)
            }
            Tab("Tools", systemImage: "wrench.and.screwdriver.fill", value: 2) {
                ToolboxView(storage: storage, store: store)
            }
            Tab("Learn", systemImage: "book.fill", value: 3) {
                LearnView(storage: storage, store: store)
            }
            Tab("Profile", systemImage: "person.fill", value: 4) {
                ProfileView(storage: storage, store: store)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingAICoachButton {
                showAICoach = true
            }
            .padding(.trailing, 18)
            .padding(.bottom, 70)
        }
        .sheet(isPresented: $showAICoach) {
            AICoachSheet(storage: storage)
        }
    }
}

private struct FloatingAICoachButton: View {
    let action: () -> Void
    @State private var pulse: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.gold, AppTheme.gold.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .shadow(color: AppTheme.gold.opacity(0.4), radius: 10, x: 0, y: 4)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

                Image(systemName: "sparkles")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.darkGreen)
                    .scaleEffect(pulse ? 1.08 : 1.0)
            }
            .overlay(
                Circle()
                    .strokeBorder(Color.white.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Apple Intelligence coach")
        .sensoryFeedback(.selection, trigger: pulse)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

private struct AICoachSheet: View {
    let storage: StorageService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(AppTheme.darkGreen)
                                .frame(width: 40, height: 40)
                                .background(AppTheme.gold.opacity(0.25))
                                .clipShape(.rect(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Apple Intelligence")
                                    .font(.headline.weight(.bold))
                                Text("On-device coaching — private & free")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    AICoachCard(storage: storage)

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Runs on your device", systemImage: "lock.shield.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text("Your progress never leaves your phone. Requires an Apple Intelligence compatible device.")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Your Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
