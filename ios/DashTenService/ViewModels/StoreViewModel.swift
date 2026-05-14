import Foundation
import Observation
import RevenueCat

@Observable
@MainActor
class StoreViewModel {
    var offerings: Offerings?
    var isPremium: Bool = false
    var isLoading: Bool = false
    var isPurchasing: Bool = false
    var error: String?

    init() {
        Task { await listenForUpdates() }
        Task { await fetchOfferings() }
    }

    private func listenForUpdates() async {
        for await info in Purchases.shared.customerInfoStream {
            self.isPremium = info.entitlements["premium"]?.isActive == true
        }
    }

    func fetchOfferings() async {
        isLoading = true
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            self.error = AppError.from(error).userMessage
        }
        isLoading = false
    }

    func purchase(package: Package) async {
        isPurchasing = true
        AnalyticsService.shared.log(.featureUsed, properties: [
            "name": "purchase_attempt",
            "package": package.identifier
        ])
        do {
            let result = try await Purchases.shared.purchase(package: package)
            if !result.userCancelled {
                let active = result.customerInfo.entitlements["premium"]?.isActive == true
                isPremium = active
                if active {
                    AnalyticsService.shared.log(.paywallConverted, properties: ["package": package.identifier])
                    AnalyticsService.shared.log(.subscriptionStarted, properties: ["package": package.identifier])
                }
            } else {
                AnalyticsService.shared.log(.featureUsed, properties: ["name": "purchase_cancelled"])
            }
        } catch ErrorCode.purchaseCancelledError {
            AnalyticsService.shared.log(.featureUsed, properties: ["name": "purchase_cancelled"])
        } catch ErrorCode.paymentPendingError {
            self.error = AppError.purchasePending.userMessage
        } catch {
            self.error = AppError.from(error).userMessage
        }
        isPurchasing = false
    }

    func restore() async {
        AnalyticsService.shared.log(.featureUsed, properties: ["name": "restore_tapped"])
        do {
            let info = try await Purchases.shared.restorePurchases()
            let active = info.entitlements["premium"]?.isActive == true
            isPremium = active
            if active {
                AnalyticsService.shared.log(.subscriptionRestored)
            } else {
                self.error = AppError.restoreFailed.userMessage
            }
        } catch {
            self.error = AppError.from(error).userMessage
        }
    }

    func checkStatus() async {
        do {
            let info = try await Purchases.shared.customerInfo()
            isPremium = info.entitlements["premium"]?.isActive == true
        } catch {
            self.error = AppError.from(error).userMessage
        }
    }

    static let proToolIds: Set<String> = [
        "Interview Prep",
        "Elevator Pitch Builder",
        "Networking Hub",
        "Personal Brand Audit",
        "First 90 Days Planner",
        "Transition Journal",
        "Wellness Check-In",
        "Networking Event Prep",
    ]

    static let proGuideRoutes: Set<PlanningRoute> = [
        .civilianPlaybook,
        .firstThirtyDays,
    ]

    func isToolLocked(_ toolTitle: String) -> Bool {
        !isPremium && Self.proToolIds.contains(toolTitle)
    }

    func isGuideLocked(_ route: PlanningRoute) -> Bool {
        !isPremium && Self.proGuideRoutes.contains(route)
    }
}
