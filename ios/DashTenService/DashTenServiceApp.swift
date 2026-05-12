import SwiftUI
import RevenueCat

@main
struct DashTenServiceApp: App {
    init() {
        KeyboardAccessoryInstaller.install()
        #if DEBUG
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Config.EXPO_PUBLIC_REVENUECAT_TEST_API_KEY)
        #else
        Purchases.configure(withAPIKey: Config.EXPO_PUBLIC_REVENUECAT_IOS_API_KEY)
        #endif
        AnalyticsService.shared.log(.appOpen)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, Locale(identifier: "en_US"))
        }
    }
}
