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
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func purchase(package: Package) async {
        isPurchasing = true
        do {
            let result = try await Purchases.shared.purchase(package: package)
            if !result.userCancelled {
                isPremium = result.customerInfo.entitlements["premium"]?.isActive == true
            }
        } catch ErrorCode.purchaseCancelledError {
        } catch ErrorCode.paymentPendingError {
        } catch {
            self.error = error.localizedDescription
        }
        isPurchasing = false
    }

    func restore() async {
        do {
            let info = try await Purchases.shared.restorePurchases()
            isPremium = info.entitlements["premium"]?.isActive == true
        } catch {
            self.error = error.localizedDescription
        }
    }

    func checkStatus() async {
        do {
            let info = try await Purchases.shared.customerInfo()
            isPremium = info.entitlements["premium"]?.isActive == true
        } catch {
            self.error = error.localizedDescription
        }
    }

    static let proToolIds: Set<String> = [
        "Resume Translator",
        "Interview Prep",
        "Elevator Pitch Builder",
        "Networking Hub",
        "Personal Brand Audit",
        "Job Offer Compare",
        "Salary Negotiation",
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
