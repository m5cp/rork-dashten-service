import SwiftUI

// ============================================================================
// TSPSharedComponents
// ----------------------------------------------------------------------------
// Small reusable views and helpers used by TSPGrowthEstimatorView and its
// section files.
// ============================================================================

struct TSPIntroCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Project Your TSP at Separation")
                    .font(.subheadline.weight(.bold))
            }
            Text("Estimates your Thrift Savings Plan balance at separation using 2026 DFAS basic pay tables, your projected pay grade, and Blended Retirement System DoD matching.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
                Text("ESTIMATE ONLY. Basic pay may change at any time. Not affiliated with the Department of War / DoD. Consult your installation finance office or a financial advisor before making decisions.")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.85))
            }
            .padding(10)
            .background(.orange.opacity(0.10))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding(14)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct TSPPayDisplayCard: View {
    let title: String
    let value: Double
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value > 0 ? formatTSPCurrency(value) : "Select grade & YoS")
                .font(.title2.weight(.heavy))
                .foregroundStyle(color)
            Text(subtitle)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(color.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct TSPDisclaimerFooter: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Estimator Only — Not Official Guidance")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Pay tables shown are 2026 DFAS-published basic pay rates. Basic pay can change at any time through National Defense Authorization Acts, Executive Orders, or other regulatory action.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                    Text("DashTen is not affiliated with, endorsed by, or associated with the Department of War / DoD, DFAS, the Thrift Savings Plan, the U.S. Government, or any branch of service. These projections are educational only — not financial, tax, or legal advice.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                    Text("For official guidance, consult a qualified financial advisor or your installation finance office. Verify your actual pay against your LES via myPay.")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(14)
        .background(.orange.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Helpers

func formatTSPCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 0
    formatter.currencyCode = "USD"
    return formatter.string(from: NSNumber(value: value)) ?? "$0"
}
