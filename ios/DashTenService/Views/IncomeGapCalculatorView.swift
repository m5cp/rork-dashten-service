import SwiftUI

struct IncomeGapCalculatorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentMonthlyIncome: String = ""
    @State private var expectedMonthlyIncome: String = ""
    @State private var monthsUntilEmployment: String = ""
    @State private var disabilityCompensation: String = ""
    @State private var spouseIncome: String = ""
    @State private var otherIncome: String = ""
    @State private var showResults: Bool = false

    private var currentMonthly: Double { Double(currentMonthlyIncome) ?? 0 }
    private var expectedMonthly: Double { Double(expectedMonthlyIncome) ?? 0 }
    private var gapMonths: Double { Double(monthsUntilEmployment) ?? 0 }
    private var disabilityMonthly: Double { Double(disabilityCompensation) ?? 0 }
    private var spouseMonthly: Double { Double(spouseIncome) ?? 0 }
    private var otherMonthly: Double { Double(otherIncome) ?? 0 }

    private var monthlyGap: Double {
        currentMonthly - expectedMonthly - disabilityMonthly - spouseMonthly - otherMonthly
    }

    private var totalGapNeeded: Double {
        max(0, monthlyGap * gapMonths)
    }

    private var incomeWithSupplements: Double {
        expectedMonthly + disabilityMonthly + spouseMonthly + otherMonthly
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "chart.line.downtrend.xyaxis")
                                .foregroundStyle(.orange)
                            Text("Plan for the Gap")
                                .font(.subheadline.weight(.bold))
                        }
                        Text("Most service members experience an income gap during transition. This calculator helps you estimate how much savings you need to bridge that gap comfortably.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(14)
                    .background(.orange.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundStyle(.red)
                            Text("Current vs. Expected")
                                .font(.headline.weight(.bold))
                        }

                        VStack(spacing: 10) {
                            PayInputRow(label: "Current Monthly Income", sublabel: "Total take-home", value: $currentMonthlyIncome, color: AppTheme.forestGreen)
                            Divider()
                            PayInputRow(label: "Expected Civilian Income", sublabel: "Monthly take-home", value: $expectedMonthlyIncome, color: .blue)
                            Divider()
                            PayInputRow(label: "Months Until Employment", sublabel: "Estimated gap", value: $monthsUntilEmployment, color: .orange)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.teal)
                            Text("Supplemental Income")
                                .font(.headline.weight(.bold))
                        }

                        VStack(spacing: 10) {
                            PayInputRow(label: "Disability Compensation", sublabel: "Monthly (tax-free)", value: $disabilityCompensation, color: .teal)
                            Divider()
                            PayInputRow(label: "Spouse Income", sublabel: "Monthly", value: $spouseIncome, color: .teal)
                            Divider()
                            PayInputRow(label: "Other Income", sublabel: "GI Bill BAH, etc.", value: $otherIncome, color: .teal)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    Button {
                        withAnimation(.spring(response: 0.4)) { showResults = true }
                    } label: {
                        Text("Calculate Gap")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.forestGreen)
                            .clipShape(.rect(cornerRadius: 14))
                    }

                    if showResults {
                        resultsSection
                    }

                    Text("This is a planning estimate. Actual income and expenses will vary.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Income Gap Planner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.semibold))
                }
            }
        }
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Your Income Gap Analysis")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 12) {
                ComparisonRow(label: "Current Monthly Income", value: formatCurrency(currentMonthly), color: AppTheme.forestGreen)
                ComparisonRow(label: "Expected + Supplements", value: formatCurrency(incomeWithSupplements), color: .blue)
                Divider()
                ComparisonRow(label: "Monthly Shortfall", value: monthlyGap > 0 ? "-" + formatCurrency(monthlyGap) : formatCurrency(0), color: monthlyGap > 0 ? .red : AppTheme.forestGreen, isBold: true)
                ComparisonRow(label: "Gap Duration", value: "\(Int(gapMonths)) months", color: .orange)
                Divider()

                HStack {
                    Text("Savings Needed")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text(formatCurrency(totalGapNeeded))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(totalGapNeeded > 0 ? .red : AppTheme.forestGreen)
                }

                if totalGapNeeded > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "lightbulb.fill")
                                .font(.caption)
                                .foregroundStyle(.orange)
                                .padding(.top, 2)
                            Text("Start saving now. Set aside \(formatCurrency(totalGapNeeded / max(1, gapMonths)))/month to build this cushion before you separate.")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                    .padding(10)
                    .background(.orange.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
