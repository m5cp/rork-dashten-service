import SwiftUI

struct SalaryNegotiationView: View {
    @State private var offerASalary: String = ""
    @State private var offerAHealthInsurance: String = ""
    @State private var offerAPTO: String = ""
    @State private var offerARetirementMatch: String = ""
    @State private var offerACommute: String = ""
    @State private var offerABonus: String = ""

    @State private var offerBSalary: String = ""
    @State private var offerBHealthInsurance: String = ""
    @State private var offerBPTO: String = ""
    @State private var offerBRetirementMatch: String = ""
    @State private var offerBCommute: String = ""
    @State private var offerBBonus: String = ""

    @State private var showResults: Bool = false

    private func totalComp(salary: String, health: String, pto: String, retirement: String, commute: String, bonus: String) -> Double {
        let sal = Double(salary) ?? 0
        let healthVal = Double(health) ?? 0
        let ptoVal = Double(pto) ?? 0
        let retVal = sal * ((Double(retirement) ?? 0) / 100)
        let commuteVal = Double(commute) ?? 0
        let bonusVal = Double(bonus) ?? 0
        return sal + healthVal + ptoVal + retVal - commuteVal + bonusVal
    }

    private var totalA: Double {
        totalComp(salary: offerASalary, health: offerAHealthInsurance, pto: offerAPTO, retirement: offerARetirementMatch, commute: offerACommute, bonus: offerABonus)
    }

    private var totalB: Double {
        totalComp(salary: offerBSalary, health: offerBHealthInsurance, pto: offerBPTO, retirement: offerBRetirementMatch, commute: offerBCommute, bonus: offerBBonus)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "scalemass.fill")
                            .foregroundStyle(.indigo)
                        Text("Compare the Full Picture")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("A higher salary doesn't always mean more money. Compare total compensation including benefits, retirement, and commute costs.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.indigo.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                offerSection(title: "Offer A", color: .teal, salary: $offerASalary, health: $offerAHealthInsurance, pto: $offerAPTO, retirement: $offerARetirementMatch, commute: $offerACommute, bonus: $offerABonus)

                offerSection(title: "Offer B", color: .purple, salary: $offerBSalary, health: $offerBHealthInsurance, pto: $offerBPTO, retirement: $offerBRetirementMatch, commute: $offerBCommute, bonus: $offerBBonus)

                Button {
                    withAnimation(.spring(response: 0.4)) { showResults = true }
                } label: {
                    Text("Compare Offers")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }

                if showResults {
                    comparisonResults
                }

                TaxProfessionalDisclaimer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Salary Negotiation")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func offerSection(title: String, color: Color, salary: Binding<String>, health: Binding<String>, pto: Binding<String>, retirement: Binding<String>, commute: Binding<String>, bonus: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(color).frame(width: 10, height: 10)
                Text(title)
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
                PayInputRow(label: "Base Salary", sublabel: "Annual gross", value: salary, color: color)
                Divider()
                PayInputRow(label: "Health Insurance Value", sublabel: "Annual employer contribution", value: health, color: color)
                Divider()
                PayInputRow(label: "PTO Value", sublabel: "Annual value of paid time off", value: pto, color: color)
                Divider()
                PayInputRow(label: "Retirement Match", sublabel: "Employer match %", value: retirement, color: color)
                Divider()
                PayInputRow(label: "Annual Commute Cost", sublabel: "Gas, transit, parking", value: commute, color: .red)
                Divider()
                PayInputRow(label: "Signing Bonus", sublabel: "One-time bonus", value: bonus, color: color)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var comparisonResults: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Total Compensation Comparison")
                    .font(.headline.weight(.bold))
            }

            HStack(spacing: 12) {
                VStack(spacing: 8) {
                    Circle().fill(.teal).frame(width: 10, height: 10)
                    Text("Offer A")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Text(formatCurrency(totalA))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.teal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.teal.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(spacing: 8) {
                    Circle().fill(.purple).frame(width: 10, height: 10)
                    Text("Offer B")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Text(formatCurrency(totalB))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.purple)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.purple.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))
            }

            let diff = totalA - totalB
            HStack {
                Text("Difference")
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("\(diff >= 0 ? "Offer A" : "Offer B") wins by \(formatCurrency(abs(diff)))")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(diff >= 0 ? .teal : .purple)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
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
