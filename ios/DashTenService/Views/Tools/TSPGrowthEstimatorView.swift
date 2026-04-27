import SwiftUI

struct TSPGrowthEstimatorView: View {
    @State private var currentCategory: PayCategory = .enlisted
    @State private var currentGrade: String = "E-5"
    @State private var currentYoS: Double = 5

    @State private var currentBalance: String = ""
    @State private var contributionPct: Double = 5

    @State private var yearsToSeparation: Double = 10
    @State private var projectedGrade: String = "E-7"

    @State private var expectedReturn: Double = 7
    @State private var annualCOLA: Double = 3

    @State private var showResults: Bool = false

    private var currentBasicPay: Double {
        MilitaryPayTables.basicPay(grade: currentGrade, yearsOfService: currentYoS) ?? 0
    }

    private var projectedBasicPay: Double {
        let totalYoS = currentYoS + yearsToSeparation
        return MilitaryPayTables.basicPay(grade: projectedGrade, yearsOfService: totalYoS) ?? 0
    }

    private var projection: TSPProjectionResult {
        TSPProjectionEngine.project(inputs: TSPProjectionInputs(
            currentBasicPay: currentBasicPay,
            projectedBasicPay: projectedBasicPay,
            currentBalance: Double(currentBalance) ?? 0,
            contributionPct: contributionPct,
            yearsToSeparation: yearsToSeparation,
            expectedReturnPct: expectedReturn,
            annualCOLAPct: annualCOLA
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                TSPIntroCard()

                TSPCurrentStatusSection(
                    category: $currentCategory,
                    grade: $currentGrade,
                    yearsOfService: $currentYoS
                )

                TSPSetupSection(
                    currentBalance: $currentBalance,
                    contributionPct: $contributionPct
                )

                TSPPlanSection(
                    yearsToSeparation: $yearsToSeparation,
                    projectedGrade: $projectedGrade,
                    currentYoS: currentYoS
                )

                TSPInvestmentSection(
                    expectedReturn: $expectedReturn,
                    annualCOLA: $annualCOLA
                )

                TSPMatchTableSection(contributionPct: contributionPct)

                if showResults {
                    TSPResultsView(
                        result: projection,
                        currentGrade: currentGrade,
                        projectedGrade: projectedGrade,
                        yearsToSeparation: yearsToSeparation,
                        expectedReturn: expectedReturn,
                        annualCOLA: annualCOLA
                    )
                }

                calculateButton

                TSPDisclaimerFooter()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("TSP Growth Estimator")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: currentCategory) { _, newCategory in
            if !newCategory.grades.contains(currentGrade), let firstGrade = newCategory.grades.first {
                currentGrade = firstGrade
            }
        }
    }

    private var calculateButton: some View {
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
    }
}

#Preview {
    NavigationStack {
        TSPGrowthEstimatorView()
    }
}
