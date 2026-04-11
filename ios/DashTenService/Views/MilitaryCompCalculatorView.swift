import SwiftUI

struct MilitaryCompCalculatorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var basePay: String = ""
    @State private var bah: String = ""
    @State private var bas: String = ""
    @State private var specialtyPay: String = ""
    @State private var incentivePay: String = ""
    @State private var boardCertPay: String = ""

    @State private var expectedCivilianSalary: String = ""
    @State private var showResults: Bool = false

    private var militaryBaseTaxable: Double {
        (Double(basePay) ?? 0)
    }

    private var militaryNonTaxable: Double {
        (Double(bah) ?? 0) +
        (Double(bas) ?? 0) +
        (Double(specialtyPay) ?? 0) +
        (Double(incentivePay) ?? 0) +
        (Double(boardCertPay) ?? 0)
    }

    private var totalMilitaryMonthly: Double {
        militaryBaseTaxable + militaryNonTaxable
    }

    private var totalMilitaryAnnual: Double {
        totalMilitaryMonthly * 12
    }

    private var civilianMonthly: Double {
        (Double(expectedCivilianSalary) ?? 0) / 12
    }

    private var civilianAnnual: Double {
        Double(expectedCivilianSalary) ?? 0
    }

    private var estimatedMilitaryTax: Double {
        militaryBaseTaxable * 0.22
    }

    private var estimatedCivilianTax: Double {
        civilianAnnual * 0.22
    }

    private var militaryTakeHome: Double {
        (militaryBaseTaxable - estimatedMilitaryTax) + (militaryNonTaxable * 12)
    }

    private var civilianTakeHome: Double {
        civilianAnnual - estimatedCivilianTax
    }

    private var annualDifference: Double {
        civilianTakeHome - militaryTakeHome
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    infoBanner

                    militaryPaySection

                    civilianPaySection

                    if showResults {
                        resultsSection
                    }

                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            showResults = true
                        }
                    } label: {
                        Text("Calculate Comparison")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.forestGreen)
                            .clipShape(.rect(cornerRadius: 14))
                    }

                    Text("This is an estimate only. Actual tax rates vary by filing status, state, deductions, and other factors. Consult a tax professional.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Compensation Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.semibold))
                }
            }
        }
    }

    private var infoBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Why This Matters")
                    .font(.subheadline.weight(.bold))
            }
            Text("Your military compensation includes non-taxable benefits (BAH, BAS, specialty pay) that you won't receive as a civilian. A $60K civilian salary may feel like far less than a $60K total military package once you factor in taxes and lost benefits.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
        .padding(14)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var militaryPaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Current Military Pay")
                    .font(.headline.weight(.bold))
                Text("(Monthly)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }

            VStack(spacing: 10) {
                PayInputRow(label: "Base Pay", sublabel: "Taxable", value: $basePay, color: AppTheme.forestGreen)
                Divider()
                PayInputRow(label: "BAH", sublabel: "Non-Taxable", value: $bah, color: .teal)
                Divider()
                PayInputRow(label: "BAS", sublabel: "Non-Taxable", value: $bas, color: .teal)
                Divider()
                PayInputRow(label: "Specialty Pay", sublabel: "Non-Taxable", value: $specialtyPay, color: .teal)
                Divider()
                PayInputRow(label: "Incentive Pay", sublabel: "Non-Taxable", value: $incentivePay, color: .teal)
                Divider()
                PayInputRow(label: "Board Cert Pay", sublabel: "Non-Taxable", value: $boardCertPay, color: .teal)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            HStack {
                Text("Total Monthly")
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text(formatCurrency(totalMilitaryMonthly))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .padding(.horizontal, 4)
        }
    }

    private var civilianPaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .foregroundStyle(.blue)
                Text("Expected Civilian Salary")
                    .font(.headline.weight(.bold))
                Text("(Annual)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }

            VStack(spacing: 10) {
                PayInputRow(label: "Gross Salary", sublabel: "All Taxable", value: $expectedCivilianSalary, color: .blue)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.top, 2)
                    Text("No BAH, no BAS, no incentive pay, no specialty pay. Your entire civilian salary is taxable income.")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Estimated Comparison")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 12) {
                ComparisonRow(
                    label: "Military Annual (Gross)",
                    value: formatCurrency(totalMilitaryAnnual),
                    color: AppTheme.forestGreen
                )
                ComparisonRow(
                    label: "Non-Taxable Portion",
                    value: formatCurrency(militaryNonTaxable * 12),
                    color: .teal
                )
                ComparisonRow(
                    label: "Est. Military Tax (~22%)",
                    value: "-" + formatCurrency(estimatedMilitaryTax),
                    color: .red
                )
                Divider()
                ComparisonRow(
                    label: "Military Take-Home (Est.)",
                    value: formatCurrency(militaryTakeHome),
                    color: AppTheme.forestGreen,
                    isBold: true
                )

                Rectangle()
                    .fill(.primary.opacity(0.08))
                    .frame(height: 2)
                    .padding(.vertical, 4)

                ComparisonRow(
                    label: "Civilian Annual (Gross)",
                    value: formatCurrency(civilianAnnual),
                    color: .blue
                )
                ComparisonRow(
                    label: "Est. Civilian Tax (~22%)",
                    value: "-" + formatCurrency(estimatedCivilianTax),
                    color: .red
                )
                Divider()
                ComparisonRow(
                    label: "Civilian Take-Home (Est.)",
                    value: formatCurrency(civilianTakeHome),
                    color: .blue,
                    isBold: true
                )

                Rectangle()
                    .fill(.primary.opacity(0.08))
                    .frame(height: 2)
                    .padding(.vertical, 4)

                HStack {
                    Text("Annual Difference")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text(annualDifference >= 0 ? "+" + formatCurrency(annualDifference) : formatCurrency(annualDifference))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(annualDifference >= 0 ? AppTheme.forestGreen : .red)
                }

                if annualDifference < 0 {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.top, 2)
                        Text("Your estimated civilian take-home is \(formatCurrency(abs(annualDifference))) less per year. Plan for this gap before separating.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(10)
                    .background(.red.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 10))
                }

                if annualDifference >= 0 {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(.top, 2)
                        Text("Your civilian salary matches or exceeds your military take-home. Factor in new costs like health insurance, commute, and retirement contributions.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(10)
                    .background(AppTheme.forestGreen.opacity(0.06))
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            monthlyBreakdown
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var monthlyBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.purple)
                Text("Monthly Breakdown")
                    .font(.headline.weight(.bold))
            }

            HStack(spacing: 12) {
                VStack(spacing: 6) {
                    Text("Military")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Text(formatCurrency(militaryTakeHome / 12))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                    Text("/month")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(spacing: 6) {
                    Text("Civilian")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Text(formatCurrency(civilianTakeHome / 12))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.blue)
                    Text("/month")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.blue.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

struct PayInputRow: View {
    let label: String
    let sublabel: String
    @Binding var value: String
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline.weight(.bold))
                Text(sublabel)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(color)
            }
            Spacer()
            HStack(spacing: 4) {
                Text("$")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.5))
                TextField("0", text: $value)
                    .font(.subheadline.weight(.bold))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
            }
        }
    }
}

struct ComparisonRow: View {
    let label: String
    let value: String
    let color: Color
    var isBold: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .subheadline.weight(.bold) : .caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(isBold ? 1.0 : 0.7))
            Spacer()
            Text(value)
                .font(isBold ? .headline.weight(.bold) : .subheadline.weight(.bold))
                .foregroundStyle(color)
        }
    }
}
