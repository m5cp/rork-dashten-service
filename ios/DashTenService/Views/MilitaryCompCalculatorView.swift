import SwiftUI

struct MilitaryCompCalculatorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var basePay: Double = 3500
    @State private var bah: Double = 1800
    @State private var bas: Double = 450
    @State private var specialtyPay: Double = 0
    @State private var expectedCivilianSalary: Double = 55000

    private var militaryBaseTaxable: Double { basePay }
    private var militaryNonTaxable: Double { bah + bas + specialtyPay }
    private var totalMilitaryMonthly: Double { militaryBaseTaxable + militaryNonTaxable }
    private var totalMilitaryAnnual: Double { totalMilitaryMonthly * 12 }
    private var civilianMonthly: Double { expectedCivilianSalary / 12 }

    private var estimatedMilitaryTax: Double { militaryBaseTaxable * 12 * 0.22 }
    private var estimatedCivilianTax: Double { expectedCivilianSalary * 0.22 }
    private var militaryTakeHome: Double { (militaryBaseTaxable * 12 - estimatedMilitaryTax) + (militaryNonTaxable * 12) }
    private var civilianTakeHome: Double { expectedCivilianSalary - estimatedCivilianTax }
    private var annualDifference: Double { civilianTakeHome - militaryTakeHome }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    resultsBanner

                    militaryPaySection

                    civilianPaySection

                    detailedBreakdown

                    monthlyComparison

                    Text("This is an estimate only. Actual tax rates vary by filing status, state, deductions, and other factors. Consult a tax professional for personalized advice.")
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

    private var resultsBanner: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Military")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Text(formatCurrency(militaryTakeHome))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                    Text("take-home/yr")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }

                VStack(spacing: 4) {
                    Text("vs")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.tertiary)
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                VStack(spacing: 4) {
                    Text("Civilian")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Text(formatCurrency(civilianTakeHome))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.blue)
                    Text("take-home/yr")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
            }

            HStack(spacing: 8) {
                Image(systemName: annualDifference >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .foregroundStyle(annualDifference >= 0 ? AppTheme.forestGreen : .red)
                Text(annualDifference >= 0 ? "+\(formatCurrency(annualDifference))" : formatCurrency(annualDifference))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(annualDifference >= 0 ? AppTheme.forestGreen : .red)
                Text("annual difference")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(annualDifference >= 0 ? AppTheme.forestGreen.opacity(0.08) : Color.red.opacity(0.08))
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private var militaryPaySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Military Pay")
                    .font(.headline.weight(.bold))
                Spacer()
                Text(formatCurrency(totalMilitaryMonthly) + "/mo")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }

            PaySliderRow(label: "Base Pay", sublabel: "Taxable", value: $basePay, range: 1500...8000, step: 100, color: AppTheme.forestGreen)
            PaySliderRow(label: "BAH", sublabel: "Non-Taxable", value: $bah, range: 0...4000, step: 50, color: .teal)
            PaySliderRow(label: "BAS", sublabel: "Non-Taxable", value: $bas, range: 0...600, step: 25, color: .teal)
            PaySliderRow(label: "Special/Incentive Pay", sublabel: "Non-Taxable", value: $specialtyPay, range: 0...2000, step: 50, color: .teal)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var civilianPaySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .foregroundStyle(.blue)
                Text("Civilian Salary")
                    .font(.headline.weight(.bold))
                Spacer()
                Text(formatCurrency(civilianMonthly) + "/mo")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Annual Gross Salary")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(formatCurrency(expectedCivilianSalary))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.blue)
                        .monospacedDigit()
                }

                Slider(value: $expectedCivilianSalary, in: 25000...200000, step: 1000)
                    .tint(.blue)

                HStack {
                    Text("$25K")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.4))
                    Spacer()
                    Text("$200K")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.4))
                }
            }

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
                Text("Your entire civilian salary is taxable. No BAH, no BAS, no tax-free allowances.")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
            .padding(10)
            .background(.orange.opacity(0.06))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var detailedBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Detailed Breakdown")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
                ComparisonRow(label: "Military Annual (Gross)", value: formatCurrency(totalMilitaryAnnual), color: AppTheme.forestGreen)
                ComparisonRow(label: "Non-Taxable Portion", value: formatCurrency(militaryNonTaxable * 12), color: .teal)
                ComparisonRow(label: "Est. Military Tax (~22%)", value: "-" + formatCurrency(estimatedMilitaryTax), color: .red)
                Divider()
                ComparisonRow(label: "Military Take-Home (Est.)", value: formatCurrency(militaryTakeHome), color: AppTheme.forestGreen, isBold: true)

                Rectangle()
                    .fill(.primary.opacity(0.08))
                    .frame(height: 2)
                    .padding(.vertical, 4)

                ComparisonRow(label: "Civilian Annual (Gross)", value: formatCurrency(expectedCivilianSalary), color: .blue)
                ComparisonRow(label: "Est. Civilian Tax (~22%)", value: "-" + formatCurrency(estimatedCivilianTax), color: .red)
                Divider()
                ComparisonRow(label: "Civilian Take-Home (Est.)", value: formatCurrency(civilianTakeHome), color: .blue, isBold: true)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))

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
            } else {
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
    }

    private var monthlyComparison: some View {
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

struct PaySliderRow: View {
    let label: String
    let sublabel: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.subheadline.weight(.semibold))
                    Text(sublabel)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(color)
                }
                Spacer()
                Text(formatValue(value))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(color)
                    .monospacedDigit()
            }
            Slider(value: $value, in: range, step: step)
                .tint(color)
        }
    }

    private func formatValue(_ val: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: val)) ?? "$0"
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
