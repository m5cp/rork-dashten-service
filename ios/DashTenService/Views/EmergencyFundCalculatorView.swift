import SwiftUI

struct EmergencyFundCalculatorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var monthlyRent: String = ""
    @State private var monthlyUtilities: String = ""
    @State private var monthlyGroceries: String = ""
    @State private var monthlyTransport: String = ""
    @State private var monthlyInsurance: String = ""
    @State private var monthlyDebt: String = ""
    @State private var monthlyOther: String = ""
    @State private var targetMonths: Int = 3
    @State private var currentSavings: String = ""

    private var totalMonthlyExpenses: Double {
        [monthlyRent, monthlyUtilities, monthlyGroceries, monthlyTransport, monthlyInsurance, monthlyDebt, monthlyOther]
            .compactMap { Double($0) }
            .reduce(0, +)
    }

    private var targetAmount: Double {
        totalMonthlyExpenses * Double(targetMonths)
    }

    private var savings: Double {
        Double(currentSavings) ?? 0
    }

    private var remaining: Double {
        max(0, targetAmount - savings)
    }

    private var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(savings / targetAmount, 1.0)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "list.bullet.rectangle.fill")
                                .foregroundStyle(.orange)
                            Text("Monthly Essential Expenses")
                                .font(.headline.weight(.bold))
                        }

                        VStack(spacing: 10) {
                            PayInputRow(label: "Rent / Mortgage", sublabel: "Housing cost", value: $monthlyRent, color: .orange)
                            Divider()
                            PayInputRow(label: "Utilities", sublabel: "Electric, water, internet", value: $monthlyUtilities, color: .orange)
                            Divider()
                            PayInputRow(label: "Groceries", sublabel: "Food & household", value: $monthlyGroceries, color: .orange)
                            Divider()
                            PayInputRow(label: "Transportation", sublabel: "Car, gas, insurance", value: $monthlyTransport, color: .orange)
                            Divider()
                            PayInputRow(label: "Health Insurance", sublabel: "Premiums", value: $monthlyInsurance, color: .orange)
                            Divider()
                            PayInputRow(label: "Debt Payments", sublabel: "Cards, loans", value: $monthlyDebt, color: .orange)
                            Divider()
                            PayInputRow(label: "Other Essentials", sublabel: "Phone, subscriptions", value: $monthlyOther, color: .orange)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))

                        HStack {
                            Text("Total Monthly")
                                .font(.subheadline.weight(.bold))
                            Spacer()
                            Text(formatCurrency(totalMonthlyExpenses))
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.orange)
                        }
                        .padding(.horizontal, 4)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "target")
                                .foregroundStyle(AppTheme.forestGreen)
                            Text("Target & Savings")
                                .font(.headline.weight(.bold))
                        }

                        VStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Target Duration")
                                    .font(.subheadline.weight(.bold))
                                Picker("Months", selection: $targetMonths) {
                                    Text("3 months").tag(3)
                                    Text("4 months").tag(4)
                                    Text("5 months").tag(5)
                                    Text("6 months").tag(6)
                                }
                                .pickerStyle(.segmented)
                            }

                            Divider()

                            PayInputRow(label: "Current Savings", sublabel: "What you have now", value: $currentSavings, color: AppTheme.forestGreen)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    resultsSection

                    DashTenInfoFooter()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Emergency Fund")
            .navigationBarTitleDisplayMode(.inline)
            .keyboardDoneToolbar()
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
                Text("Your Emergency Fund Goal")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 16) {
                ZStack {
                    ProgressRing(progress: progress, size: 120, lineWidth: 12, color: progress >= 1.0 ? AppTheme.forestGreen : .orange)
                    VStack(spacing: 2) {
                        Text("\(Int(progress * 100))%")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(progress >= 1.0 ? AppTheme.forestGreen : .orange)
                        Text("funded")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 10) {
                    ComparisonRow(label: "Monthly Expenses", value: formatCurrency(totalMonthlyExpenses), color: .orange)
                    ComparisonRow(label: "Target (\(targetMonths) months)", value: formatCurrency(targetAmount), color: AppTheme.forestGreen, isBold: true)
                    ComparisonRow(label: "Current Savings", value: formatCurrency(savings), color: .blue)
                    Divider()

                    HStack {
                        Text("Still Needed")
                            .font(.subheadline.weight(.bold))
                        Spacer()
                        Text(formatCurrency(remaining))
                            .font(.title3.weight(.bold))
                            .foregroundStyle(remaining > 0 ? .red : AppTheme.forestGreen)
                    }
                }

                if remaining > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Savings Plan")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.6))
                        HStack {
                            savingsPlanCard(months: 3, amount: remaining / 3)
                            savingsPlanCard(months: 6, amount: remaining / 6)
                            savingsPlanCard(months: 12, amount: remaining / 12)
                        }
                    }
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private func savingsPlanCard(months: Int, amount: Double) -> some View {
        VStack(spacing: 4) {
            Text("\(months)mo")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.6))
            Text(formatCurrency(amount))
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text("/month")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
