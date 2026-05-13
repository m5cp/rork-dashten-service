import SwiftUI

struct TSPRolloverView: View {
    @State private var tspBalance: String = ""
    @State private var monthlyContribution: String = ""
    @State private var yearsUntilRetirement: Double = 20

    private var balance: Double { Double(tspBalance) ?? 0 }
    private var monthly: Double { Double(monthlyContribution) ?? 0 }

    private let options: [(String, String, Double, String, Color)] = [
        ("Leave in TSP", "shield.fill", 0.05, "Low fees (~0.04%), limited fund choices, stable government plan", .teal),
        ("Traditional IRA", "building.columns.fill", 0.06, "Tax-deferred growth, wider investment options, no tax on rollover", .blue),
        ("Roth IRA", "sun.max.fill", 0.06, "Tax-free withdrawals in retirement, pay taxes on conversion now", .orange),
        ("New Employer 401(k)", "briefcase.fill", 0.06, "Consolidate accounts, possible employer match, varies by plan", .purple),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                inputSection

                resultsSection

                DashTenInfoFooter()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("TSP Options")
        .navigationBarTitleDisplayMode(.inline)
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
                PayInputRow(label: "Current TSP Balance", sublabel: "Total balance", value: $tspBalance, color: AppTheme.forestGreen)
                Divider()
                PayInputRow(label: "Monthly Contribution", sublabel: "Future monthly savings", value: $monthlyContribution, color: .blue)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Years Until Retirement")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text("\(Int(yearsUntilRetirement)) years")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                }
                Slider(value: $yearsUntilRetirement, in: 5...40, step: 1)
                    .tint(AppTheme.forestGreen)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Estimated Growth Comparison")
                    .font(.headline.weight(.bold))
            }

            ForEach(options, id: \.0) { name, icon, rate, description, color in
                let projected = projectGrowth(balance: balance, monthly: monthly, rate: rate, years: Int(yearsUntilRetirement))

                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(color)
                            .frame(width: 32, height: 32)
                            .background(color.opacity(0.12))
                            .clipShape(.rect(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(.subheadline.weight(.bold))
                            Text("~\(Int(rate * 100))% avg annual return")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(color)
                        }

                        Spacer()

                        Text(formatCurrency(projected))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(color)
                    }

                    Text(description)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Things to Know")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)

                VStack(alignment: .leading, spacing: 6) {
                    BulletPoint(text: "Roth conversions typically create a taxable event in the year of conversion.", color: AppTheme.forestGreen)
                    BulletPoint(text: "Converting a large balance can push you into a higher tax bracket that year.", color: AppTheme.forestGreen)
                    BulletPoint(text: "TSP expense ratios are among the lowest available.", color: AppTheme.forestGreen)
                    BulletPoint(text: "Employer 401(k) plans vary widely on fees — compare before rolling over.", color: AppTheme.forestGreen)
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private func projectGrowth(balance: Double, monthly: Double, rate: Double, years: Int) -> Double {
        let monthlyRate = rate / 12
        let months = Double(years * 12)
        let balanceGrowth = balance * pow(1 + monthlyRate, months)
        let contributionGrowth = monthly * ((pow(1 + monthlyRate, months) - 1) / monthlyRate)
        return balanceGrowth + (monthly > 0 ? contributionGrowth : 0)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

struct BulletPoint: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "arrow.forward.circle.fill")
                .font(.caption2)
                .foregroundStyle(color)
                .padding(.top, 2)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }
}

