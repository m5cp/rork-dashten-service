import SwiftUI

struct ContentView: View {
    @State private var storage = StorageService()
    @State private var selectedTab: Int = 0

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
                TodayView(storage: storage)
            }
            Tab("Roadmap", systemImage: "map.fill", value: 1) {
                RoadmapView(storage: storage)
            }
            Tab("Benefits", systemImage: "star.fill", value: 2) {
                BenefitsView(storage: storage)
            }
            Tab("Documents", systemImage: "doc.text.fill", value: 3) {
                DocumentsView(storage: storage)
            }
            Tab("Profile", systemImage: "person.fill", value: 4) {
                ProfileView(storage: storage)
            }
        }
    }
}
