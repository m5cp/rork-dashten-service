import Foundation
import RevenueCat

/// Typed error surface for user-facing messages.
///
/// Wrap raw service errors with `AppError.from(_:)` to get a short,
/// reassuring string suited for an alert. Avoids leaking cryptic
/// localizedDescription strings to the user.
nonisolated enum AppError: Error, CustomStringConvertible, Sendable {
    case network
    case purchaseFailed
    case purchaseCancelled
    case purchasePending
    case productMissing
    case restoreFailed
    case offline
    case unknown(String)

    var description: String { userMessage }

    var userMessage: String {
        switch self {
        case .network:
            return "We couldn't reach the network. Check your connection and try again."
        case .purchaseFailed:
            return "Your purchase couldn't be completed. No charge was made. Please try again."
        case .purchaseCancelled:
            return "Purchase cancelled."
        case .purchasePending:
            return "Your purchase is pending approval. We'll unlock Pro automatically once it clears."
        case .productMissing:
            return "Subscription plans aren't loading right now. Pull down to refresh, or try again in a moment."
        case .restoreFailed:
            return "We couldn't restore your purchases. Make sure you're signed in with the same Apple ID."
        case .offline:
            return "You're offline. Reconnect to continue."
        case .unknown(let message):
            return message.isEmpty ? "Something went wrong. Please try again." : message
        }
    }

    static func from(_ error: Error) -> AppError {
        if let rc = error as? RevenueCat.ErrorCode {
            switch rc {
            case .purchaseCancelledError: return .purchaseCancelled
            case .paymentPendingError: return .purchasePending
            case .productNotAvailableForPurchaseError, .ineligibleError: return .productMissing
            case .networkError, .offlineConnectionError: return .network
            case .receiptAlreadyInUseError, .invalidReceiptError, .missingReceiptFileError: return .restoreFailed
            default: return .purchaseFailed
            }
        }
        let ns = error as NSError
        if ns.domain == NSURLErrorDomain {
            return .network
        }
        return .unknown(error.localizedDescription)
    }
}
