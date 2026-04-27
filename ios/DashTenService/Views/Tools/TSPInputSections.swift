import SwiftUI

// ============================================================================
// TSPInputSections
// ----------------------------------------------------------------------------
// The four input cards: Current Status, TSP Setup, Plan, Investment.
// Each is a standalone View that takes bindings to the parent's state.
// ============================================================================

struct TSPCurrentStatusSection: View {
    @Binding var category: PayCategory
    @Binding var grade: String
    @Binding var yearsOfService: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Your Current Status")
                    .font(.headline.weight(.bold))
            }
            Text("Pay grade only — same scale across all six branches. Service-specific ranks (e.g. SGT, CPT) are not used here.")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                payGroupRow
                Divider().padding(.leading, 14)
                payGradeRow
                Divider().padding(.leading, 14)
                yosSlider
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            let basicPay = MilitaryPayTables.basicPay(grade: grade, yearsOfService: yearsOfService) ?? 0
            TSPPayDisplayCard(
                title: "Current Monthly Basic Pay",
                value: basicPay,
                subtitle: "\(grade) at \(MilitaryPayTables.bracketLabel(forYearsOfService: yearsOfService).lowercased()) (2026 rate)",
                color: AppTheme.forestGreen
            )

            Text(category.detail)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
        }
    }

    private var payGroupRow: some View {
        HStack {
            Text("Pay Group")
                .font(.subheadline.weight(.bold))
            Spacer()
            Picker("Pay Group", selection: $category) {
                ForEach(PayCategory.allCases) { cat in
                    Text(cat.shortLabel).tag(cat)
                }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.forestGreen)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var payGradeRow: some View {
        HStack {
            Text("Current Pay Grade")
                .font(.subheadline.weight(.bold))
            Spacer()
            Picker("Current Pay Grade", selection: $grade) {
                ForEach(category.grades, id: \.self) { g in
                    Text(g).tag(g)
                }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.forestGreen)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var yosSlider: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Years of Service")
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("\(Int(yearsOfService)) yr")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            Slider(value: $yearsOfService, in: 0...30, step: 1)
                .tint(AppTheme.forestGreen)
            Text(MilitaryPayTables.bracketLabel(forYearsOfService: yearsOfService))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(14)
    }
}

struct TSPSetupSection: View {
    @Binding var currentBalance: String
    @Binding var contributionPct: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Your TSP Setup")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
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
                Text("Contribute at least 5% to capture the full DoD match.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }
}

struct TSPPlanSection: View {
    @Binding var yearsToSeparation: Double
    @Binding var projectedGrade: String
    let currentYoS: Double

    private var totalYoSAtRetirement: Double {
        currentYoS + yearsToSeparation
    }

    private var allGrades: [String] {
        PayCategory.allCases.flatMap { $0.grades }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "flag.checkered")
                    .foregroundStyle(.purple)
                Text("Your Plan")
                    .font(.headline.weight(.bold))
            }

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
                Text("Total YoS at retirement: \(Int(totalYoSAtRetirement)) years")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            HStack {
                Text("Projected Pay Grade at Retirement")
                    .font(.subheadline.weight(.bold))
                    .lineLimit(2)
                Spacer()
                Picker("Projected Grade", selection: $projectedGrade) {
                    ForEach(allGrades, id: \.self) { g in
                        Text(g).tag(g)
                    }
                }
                .pickerStyle(.menu)
                .tint(.purple)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            let projectedPay = MilitaryPayTables.basicPay(grade: projectedGrade, yearsOfService: totalYoSAtRetirement) ?? 0
            TSPPayDisplayCard(
                title: "Projected Monthly Basic Pay",
                value: projectedPay,
                subtitle: "\(projectedGrade) at \(MilitaryPayTables.bracketLabel(forYearsOfService: totalYoSAtRetirement).lowercased()) (2026 rate)",
                color: .purple
            )
        }
    }
}

struct TSPInvestmentSection: View {
    @Binding var expectedReturn: Double
    @Binding var annualCOLA: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(.orange)
                Text("Investment Assumptions")
                    .font(.headline.weight(.bold))
            }

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

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Annual COLA / Pay Table Raise")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text("\(String(format: "%.1f", annualCOLA))%")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.indigo)
                }
                Slider(value: $annualCOLA, in: 0...6, step: 0.5)
                    .tint(.indigo)
                Text("Yearly pay table inflation on top of promotions. 2026 NDAA raise was 3.8%. Historical avg ~3%.")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }
}
