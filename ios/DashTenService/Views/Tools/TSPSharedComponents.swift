import SwiftUI

// ============================================================================
// TSPSharedComponents
// ----------------------------------------------------------------------------
// Small reusable views and helpers used by TSPGrowthEstimatorView and its
// section files.
// ============================================================================

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

// MARK: - Helpers

func formatTSPCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 0
    formatter.currencyCode = "USD"
    return formatter.string(from: NSNumber(value: value)) ?? "$0"
}
