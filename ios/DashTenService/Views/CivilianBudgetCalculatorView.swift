import SwiftUI

struct CivilianBudgetCalculatorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var monthlyIncome: String = ""
    @State private var rent: String = ""
    @State private var utilities: String = ""
    @State private var groceries: String = ""
    @State private var transportation: String = ""
    @State private var healthInsurance: String = ""
    @State private var phoneInternet: String = ""
    @State private var debtPayments: String = ""
    @State private var childcare: String = ""
    @State private var savings: String = ""
    @State private var entertainment: String = ""
    @State private var clothing: String = ""
    @State private var miscellaneous: String = ""

    private var income: Double { Double(monthlyIncome) ?? 0 }

    private var expenses: [(String, String, Color)] {
        [
            ("Rent / Mortgage", rent, .orange),
            ("Utilities", utilities, .orange),
            ("Groceries", groceries, .orange),
            ("Transportation", transportation, .orange),
            ("Health Insurance", healthInsurance, .red),
            ("Phone & Internet", phoneInternet, .blue),
            ("Debt Payments", debtPayments, .red),
            ("Childcare / Education", childcare, .purple),
            ("Savings / Retirement", savings, AppTheme.forestGreen),
            ("Entertainment", entertainment, .teal),
            ("Clothing", clothing, .pink),
            ("Miscellaneous", miscellaneous, .primary.opacity(0.6)),
        ]
    }

    private var totalExpenses: Double {
        [rent, utilities, groceries, transportation, healthInsurance, phoneInternet, debtPayments, childcare, savings, entertainment, clothing, miscellaneous]
            .compactMap { Double($0) }
            .reduce(0, +)
    }

    private var remaining: Double {
        income - totalExpenses
    }

    private var expenseRatio: Double {
        guard income > 0 else { return 0 }
        return totalExpenses / income
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundStyle(AppTheme.forestGreen)
                            Text("Monthly Income")
                                .font(.headline.weight(.bold))
                        }

                        VStack(spacing: 10) {
                            PayInputRow(label: "Take-Home Pay", sublabel: "After taxes", value: $monthlyIncome, color: AppTheme.forestGreen)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundStyle(.orange)
                            Text("Monthly Expenses")
                                .font(.headline.weight(.bold))
                        }

                        VStack(spacing: 10) {
                            PayInputRow(label: "Rent / Mortgage", sublabel: "No more BAH", value: $rent, color: .orange)
                            Divider()
                            PayInputRow(label: "Utilities", sublabel: "Electric, water, gas", value: $utilities, color: .orange)
                            Divider()
                            PayInputRow(label: "Groceries", sublabel: "No more BAS", value: $groceries, color: .orange)
                            Divider()
                            PayInputRow(label: "Transportation", sublabel: "Car, gas, insurance", value: $transportation, color: .orange)
                            Divider()
                            PayInputRow(label: "Health Insurance", sublabel: "TRICARE ends at separation — enter your new plan cost", value: $healthInsurance, color: .red)
                            Divider()
                            PayInputRow(label: "Phone & Internet", sublabel: "Monthly bills", value: $phoneInternet, color: .blue)
                            Divider()
                            PayInputRow(label: "Debt Payments", sublabel: "Cards, loans, student", value: $debtPayments, color: .red)
                            Divider()
                            PayInputRow(label: "Childcare / Education", sublabel: "Kids, tuition", value: $childcare, color: .purple)
                            Divider()
                            PayInputRow(label: "Savings / Retirement", sublabel: "401k, IRA, emergency", value: $savings, color: AppTheme.forestGreen)
                            Divider()
                            PayInputRow(label: "Entertainment", sublabel: "Dining, streaming, etc.", value: $entertainment, color: .teal)
                            Divider()
                            PayInputRow(label: "Clothing", sublabel: "No more uniform allowance", value: $clothing, color: .pink)
                            Divider()
                            PayInputRow(label: "Miscellaneous", sublabel: "Everything else", value: $miscellaneous, color: .gray)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    resultsSection

                    DashTenInfoFooter()
                }
                .readableContentWidth()
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Civilian Budget")
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
                Image(systemName: "chart.pie.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Budget Summary")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Income")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.6))
                        Text(formatCurrency(income))
                            .font(.title3.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Expenses")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.6))
                        Text(formatCurrency(totalExpenses))
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.orange)
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.primary.opacity(0.08))
                        RoundedRectangle(cornerRadius: 6)
                            .fill(expenseRatio > 1.0 ? .red : expenseRatio > 0.9 ? .orange : AppTheme.forestGreen)
                            .frame(width: geo.size.width * min(expenseRatio, 1.0))
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("\(Int(expenseRatio * 100))% of income used")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Spacer()
                }

                Divider()

                HStack {
                    Text("Remaining")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text(formatCurrency(remaining))
                        .font(.title2.weight(.bold))
                        .foregroundStyle(remaining >= 0 ? AppTheme.forestGreen : .red)
                }

                if remaining < 0 {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.top, 2)
                        Text("Your expenses exceed your income by \(formatCurrency(abs(remaining)))/month. Look for areas to cut or revisit your salary target.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(10)
                    .background(.red.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 10))
                } else if remaining > 0 && remaining < income * 0.1 {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .padding(.top, 2)
                        Text("Your budget is tight with less than 10% remaining. Consider building more margin for unexpected expenses.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(10)
                    .background(.orange.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 10))
                } else if remaining > 0 {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(.top, 2)
                        Text("Your budget has healthy margin. Consider allocating extra to savings or debt payoff.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(10)
                    .background(AppTheme.forestGreen.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 10))
                }

                newCostsBanner
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var newCostsBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Costs You Didn't Have Before")
                .font(.caption.weight(.bold))
                .foregroundStyle(.red)

            VStack(alignment: .leading, spacing: 4) {
                CostReminderRow(text: "Health insurance premiums — TRICARE ends at separation for most veterans")
                CostReminderRow(text: "Full rent/mortgage at market rate (no BAH)")
                CostReminderRow(text: "Full grocery bill (no BAS)")
                CostReminderRow(text: "Professional clothing (no uniform allowance)")
                CostReminderRow(text: "Commuting costs")
                CostReminderRow(text: "Retirement contributions (employer may not match military TSP rate)")
            }
        }
        .padding(10)
        .background(.red.opacity(0.04))
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

struct CostReminderRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "minus.circle.fill")
                .font(.caption2)
                .foregroundStyle(.red.opacity(0.7))
                .padding(.top, 2)
            Text(text)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
        }
    }
}
