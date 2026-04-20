import SwiftUI

struct ContentView: View {
    @State private var storage = StorageService()
    @State private var store = StoreViewModel()
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
    }
}
