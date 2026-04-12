import SwiftUI

struct ContentView: View {
    @State private var storage = StorageService()
    @State private var store = StoreViewModel()
    @State private var selectedTab: Int = 0
    @State private var showCrisisSheet: Bool = false

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
                TodayView(storage: storage, store: store)
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
        .overlay(alignment: .bottom) {
            crisisFloatingButton
        }
        .sheet(isPresented: $showCrisisSheet) {
            NavigationStack {
                CrisisResourcesView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showCrisisSheet = false }
                        }
                    }
            }
        }
    }

    private var crisisFloatingButton: some View {
        HStack {
            Spacer()
            Button {
                showCrisisSheet = true
            } label: {
                Image(systemName: "heart.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.red, in: Circle())
                    .shadow(color: .red.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 72)
            .accessibilityLabel("Crisis support — call or text 988")
        }
    }
}
