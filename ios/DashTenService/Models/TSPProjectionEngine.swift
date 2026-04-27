import Foundation

// ============================================================================
// TSPProjectionEngine
// ----------------------------------------------------------------------------
// Pure math — no SwiftUI, no state. Given inputs, returns a projection.
// Easier to test, reason about, and reuse (e.g. in BRSRetirementSnapshotView).
// ============================================================================

struct TSPProjectionInputs {
    var currentBasicPay: Double
    var projectedBasicPay: Double
    var currentBalance: Double
    var contributionPct: Double      // your contribution %
    var yearsToSeparation: Double
    var expectedReturnPct: Double
    var annualCOLAPct: Double
}

struct TSPProjectionResult {
    var endingBalance: Double = 0
    var totalYourContribs: Double = 0
    var totalDoDContribs: Double = 0
    var estimatedGrowth: Double = 0
    var monthlyAt4Percent: Double = 0
}

enum TSPProjectionEngine {
    /// BRS DoD additional match: dollar-for-dollar on first 3%, 50¢ on next 2%
    static let dodAutoMatch: Double = 1.0   // 1% automatic
    static let dodMatchMax: Double = 4.0    // up to 4% additional

    static func dodMatchPct(forContribution c: Double) -> Double {
        if c <= 0 { return 0 }
        let firstThree = min(c, 3.0) * 1.0
        let nextTwo = max(0, min(c - 3.0, 2.0)) * 0.5
        return firstThree + nextTwo
    }

    /// Computes month-by-month projection.
    /// Basic pay each month = linear interpolation from current to projected (in 2026 $)
    ///                        × (1 + COLA)^years_elapsed
    static func project(inputs: TSPProjectionInputs) -> TSPProjectionResult {
        let years = Int(inputs.yearsToSeparation)
        let totalMonths = years * 12
        guard totalMonths > 0 else { return TSPProjectionResult() }

        let monthlyReturn = (inputs.expectedReturnPct / 100.0) / 12.0
        let annualCOLAFactor = inputs.annualCOLAPct / 100.0
        let dodMatch = dodMatchPct(forContribution: inputs.contributionPct)
        let payDelta = inputs.projectedBasicPay - inputs.currentBasicPay

        var endingBalance = inputs.currentBalance * pow(1 + inputs.expectedReturnPct / 100.0, Double(years))
        var totalYour: Double = 0
        var totalDoD: Double = 0

        for m in 0..<totalMonths {
            let monthIndex = Double(m)
            let yearElapsed = monthIndex / 12.0
            let frac = monthIndex / Double(totalMonths)

            let basicPay2026 = inputs.currentBasicPay + payDelta * frac
            let basicPayThisMonth = basicPay2026 * pow(1 + annualCOLAFactor, yearElapsed)

            let yourMonthly = basicPayThisMonth * inputs.contributionPct / 100.0
            let dodMonthly = basicPayThisMonth * (dodAutoMatch + dodMatch) / 100.0
            let totalMonthly = yourMonthly + dodMonthly

            let monthsRemaining = Double(totalMonths - m - 1)
            let fvFactor = pow(1 + monthlyReturn, monthsRemaining)
            endingBalance += totalMonthly * fvFactor

            totalYour += yourMonthly
            totalDoD += dodMonthly
        }

        let growth = max(0, endingBalance - inputs.currentBalance - totalYour - totalDoD)

        return TSPProjectionResult(
            endingBalance: endingBalance,
            totalYourContribs: totalYour,
            totalDoDContribs: totalDoD,
            estimatedGrowth: growth,
            monthlyAt4Percent: endingBalance * 0.04 / 12.0
        )
    }
}
