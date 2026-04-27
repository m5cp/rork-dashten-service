import SwiftUI

struct TSPGrowthEstimatorView: View {
    @State private var basicPay: String = ""
    @State private var currentBalance: String = ""
    @State private var contributionPct: Double = 5
    @State private var yearsToSeparation: Double = 10
    @State private var expectedReturn: Double = 7

    @State private var showResults: Bool = false

    private let dodAutoMatch: Double = 1.0
    private let dodMatchMax: Double = 4.0

    private var pay: Double { Double(basicPay) ?? 0 }
    private var balance: Double { Double(currentBalance) ?? 0 }

    private var dodMatchPct: Double {
        let c = contributionPct
        if c <= 0 { return 0 }
        let firstThree = min(c, 3.0) * 1.0
        let nextTwo = max(0, min(c - 3.0, 2.0)) * 0.5
        return firstThree + nextTwo
    }

    private var totalMonthlyContribution: Double {
        let yourMonthly = pay * contributionPct / 100.0
        let dodAutoMonthly = pay * dodAutoMatch / 100.0
        let dodMatchMonthly = pay * dodMatchPct / 100.0
        return yourMonthly + dodAutoMonthly + dodMatchMonthly
    }

    private var projectedBalance: Double {
        let years = yearsToSeparation
        let annualRate = expectedReturn / 100.0
        let monthlyRate = annualRate / 12.0
        let months = years * 12.0

        let fvLump = balance * pow(1 + annualRate, years)

        let fvContrib: Double
        if monthlyRate == 0 {
            fvContrib = totalMonthlyContribution * months
        } else {
            fvContrib = totalMonthlyContribution * ((pow(1 + monthlyRate, months) - 1) / monthlyRate)
        }

        return fvLump + fvContrib
    }

    private var totalYourContributions: Double {
        let yourMonthly = pay * contributionPct / 100.0
        return yourMonthly * yearsToSeparation * 12.0
    }

    private var totalDoDContributions: Double {
        let dodMonthly = pay * (dodAutoMatch + dodMatchPct) / 100.0
        return dodMonthly * yearsToSeparation * 12.0
    }

    private var estimatedGrowth: Double {
        max(0, projectedBalance - balance - totalYourContributions - totalDoDContributions)
    }

    private var monthlyAt4Percent: Double {
        projectedBalance * 0.04 / 12.0
    }

    private var leavingMatchOnTable: Bool {
        contributionPct < 5.0
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                introSection

                inputSection

                matchTableSection

                if showResults {
                    resultsSection
                }

                Button {
                    withAnimation(.spring(response: 0.4)) { showResults = true }
                } label: {
                    Text("Calculate My Estimate")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }

                disclaimerFooter
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("TSP Growth Estimator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Project Your TSP at Separation")
                    .font(.subheadline.weight(.bold))
            }
            Text("See what your Thrift Savings Plan could be worth when you separate, including DoD matching contributions under the Blended Retirement System.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.forestGreen)
                Text("This is a hypothetical projection — actual returns vary.")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .padding(10)
            .background(AppTheme.forestGreen.opacity(0.08))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding(14)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Your TSP Details")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
                PayInputRow(label: "Monthly Basic Pay", sublabel: "Your current basic pay", value: $basicPay, color: AppTheme.forestGreen)
                Divider()
                PayInputRow(label: "Current TSP Balance", sublabel: "What you've saved so far", value: $currentBalance, color: .blue)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Your Contribution")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text("\(Int(contributionPct))%")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                }
                Slider(value: $contributionPct, in: 0...15, step: 1)
                    .tint(AppTheme.forestGreen)
                Text("Most service members should aim for at least 5% to capture the full DoD match.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Years to Separation")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text("\(Int(yearsToSeparation)) yr")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.blue)
                }
                Slider(value: $yearsToSeparation, in: 1...30, step: 1)
                    .tint(.blue)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Expected Annual Return")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text("\(String(format: "%.1f", expectedReturn))%")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.orange)
                }
                Slider(value: $expectedReturn, in: 1...12, step: 0.5)
                    .tint(.orange)
                Text("Historical TSP C Fund avg ~10%. Conservative estimate ~5–7%.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var matchTableSection: some View {
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

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Estimated TSP at Separation")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.8))
                Text(formatCurrency(projectedBalance))
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Text("Based on \(Int(yearsToSeparation)) years at \(String(format: "%.1f", expectedReturn))% avg annual return")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(AppTheme.forestGreen)
            .clipShape(.rect(cornerRadius: 16))

            VStack(spacing: 10) {
                breakdownRow(label: "Your Contributions", value: totalYourContributions, color: .blue, icon: "person.fill")
                breakdownRow(label: "DoD Contributions", value: totalDoDContributions, color: AppTheme.gold, icon: "shield.fill")
                breakdownRow(label: "Estimated Growth", value: estimatedGrowth, color: AppTheme.forestGreen, icon: "chart.line.uptrend.xyaxis")
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundStyle(AppTheme.gold)
                    Text("At a 4% Withdrawal Rate")
                        .font(.subheadline.weight(.bold))
                }
                Text(formatCurrency(monthlyAt4Percent) + " /mo")
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("This is a common planning benchmark — not a guarantee. Would supplement your military pension and any other retirement income.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(AppTheme.gold.opacity(0.08))
            .clipShape(.rect(cornerRadius: 14))
        }
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
            Text(formatCurrency(value))
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(color)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var disclaimerFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
                Text("DashTen is not affiliated with the Department of Defense, the Thrift Savings Plan, or any government agency. This estimator uses general planning assumptions and is not financial advice. Results are hypothetical projections. Actual returns vary. Consult a financial professional before making retirement decisions.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
        }
        .padding(12)
        .background(.orange.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

#Preview {
    NavigationStack {
        TSPGrowthEstimatorView()
    }
}
