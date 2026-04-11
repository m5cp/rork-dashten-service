import SwiftUI

struct TSPRolloverView: View {
    @State private var tspBalance: String = ""
    @State private var monthlyContribution: String = ""
    @State private var yearsUntilRetirement: Double = 20
    @State private var showResults: Bool = false

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
            VStack(alignment: .leading, spacing: 24) {
                taxDisclaimer

                inputSection

                if showResults {
                    resultsSection
                }

                Button {
                    withAnimation(.spring(response: 0.4)) { showResults = true }
                } label: {
                    Text("Compare Options")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }

                TaxProfessionalDisclaimer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Research TSP")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var taxDisclaimer: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.swap")
                    .foregroundStyle(.blue)
                Text("Know Your Options")
                    .font(.subheadline.weight(.bold))
            }
            Text("Your Thrift Savings Plan doesn't disappear when you separate. You have several options — each with different tax implications and growth potential.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            HStack(spacing: 8) {
                Image(systemName: "person.fill.badge.plus")
                    .font(.caption)
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Consult with a financial advisor about your retirement plan before making any changes.")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .padding(10)
            .background(AppTheme.forestGreen.opacity(0.08))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding(14)
        .background(.blue.opacity(0.06))
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
                Label("Important Considerations", systemImage: "exclamationmark.circle.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 6) {
                    BulletPoint(text: "Roth conversion triggers a tax event — you pay income tax on the converted amount", color: .orange)
                    BulletPoint(text: "Traditional IRA to Roth conversions can push you into a higher tax bracket", color: .orange)
                    BulletPoint(text: "TSP has the lowest fees of any retirement plan in the country", color: .orange)
                    BulletPoint(text: "Some employer 401(k) plans have high fees — compare before rolling over", color: .orange)
                }
            }
            .padding(14)
            .background(.orange.opacity(0.06))
            .clipShape(.rect(cornerRadius: 12))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
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

struct TaxProfessionalDisclaimer: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(.top, 2)
            Text("This tool provides estimates only. Tax laws vary by state and situation. Consult a qualified tax professional before making financial decisions.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
        }
        .padding(12)
        .background(.orange.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }
}
