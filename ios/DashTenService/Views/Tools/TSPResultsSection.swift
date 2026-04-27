import SwiftUI

// ============================================================================
// TSPResultsSection
// ----------------------------------------------------------------------------
// The BRS matching reference table and the projected results display.
// ============================================================================

struct TSPMatchTableSection: View {
    let contributionPct: Double

    private var leavingMatchOnTable: Bool {
        contributionPct < 5.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "table.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("BRS Matching Table")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 0) {
                matchRow("0%", auto: "1%", match: "0%", total: "1%", highlight: false)
                Divider()
                matchRow("1%", auto: "1%", match: "1%", total: "3%", highlight: false)
                Divider()
                matchRow("2%", auto: "1%", match: "2%", total: "5%", highlight: false)
                Divider()
                matchRow("3%", auto: "1%", match: "3%", total: "7%", highlight: false)
                Divider()
                matchRow("4%", auto: "1%", match: "3.5%", total: "8.5%", highlight: false)
                Divider()
                matchRow("5%", auto: "1%", match: "4%", total: "10%", highlight: true)
            }
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            if leavingMatchOnTable {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Contributing 5% captures the maximum match. You're currently leaving DoD money on the table.")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary)
                }
                .padding(10)
                .background(.orange.opacity(0.12))
                .clipShape(.rect(cornerRadius: 8))
            }
        }
    }

    private func matchRow(_ you: String, auto: String, match: String, total: String, highlight: Bool) -> some View {
        HStack {
            Text(you)
                .font(.caption.weight(.bold))
                .frame(width: 50, alignment: .leading)
                .foregroundStyle(highlight ? AppTheme.forestGreen : .primary)
            Text(auto)
                .font(.caption.weight(.semibold))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.secondary)
            Text(match)
                .font(.caption.weight(.semibold))
                .frame(maxWidth: .infinity)
                .foregroundStyle(.secondary)
            Text(total)
                .font(.caption.weight(.bold))
                .frame(width: 60, alignment: .trailing)
                .foregroundStyle(highlight ? AppTheme.forestGreen : .primary)
        }
        .padding(.vertical, 6)
        .background(highlight ? AppTheme.forestGreen.opacity(0.06) : Color.clear)
    }
}

struct TSPResultsView: View {
    let result: TSPProjectionResult
    let currentGrade: String
    let projectedGrade: String
    let yearsToSeparation: Double
    let expectedReturn: Double
    let annualCOLA: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            heroCard
            breakdownCards
            monthlyIncomeCard
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Estimated TSP at Separation")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.8))
            Text(formatTSPCurrency(result.endingBalance))
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            Text("\(currentGrade) → \(projectedGrade) over \(Int(yearsToSeparation)) yr • \(String(format: "%.1f", expectedReturn))% return • \(String(format: "%.1f", annualCOLA))% COLA")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppTheme.forestGreen)
        .clipShape(.rect(cornerRadius: 16))
    }

    private var breakdownCards: some View {
        VStack(spacing: 10) {
            breakdownRow(label: "Your Contributions", value: result.totalYourContribs, color: .blue, icon: "person.fill")
            breakdownRow(label: "DoD Contributions", value: result.totalDoDContribs, color: AppTheme.gold, icon: "shield.fill")
            breakdownRow(label: "Estimated Growth", value: result.estimatedGrowth, color: AppTheme.forestGreen, icon: "chart.line.uptrend.xyaxis")
        }
    }

    private var monthlyIncomeCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(AppTheme.gold)
                Text("At a 4% Withdrawal Rate")
                    .font(.subheadline.weight(.bold))
            }
            Text(formatTSPCurrency(result.monthlyAt4Percent) + " /mo")
                .font(.title2.weight(.heavy))
                .foregroundStyle(AppTheme.forestGreen)
            Text("Common planning benchmark — not a guarantee. Would supplement your military pension and any other retirement income.")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(AppTheme.gold.opacity(0.08))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func breakdownRow(label: String, value: Double, color: Color, icon: String) -> some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(color)
                    .clipShape(.rect(cornerRadius: 8))
                Text(label)
                    .font(.subheadline.weight(.bold))
            }
            Spacer()
            Text(formatTSPCurrency(value))
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(color)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}
