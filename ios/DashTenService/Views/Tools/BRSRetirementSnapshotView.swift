import SwiftUI

struct BRSRetirementSnapshotView: View {
    @State private var basicPay: String = ""
    @State private var currentTSPBalance: String = ""
    @State private var contributionPct: Double = 5
    @State private var expectedReturn: Double = 7

    @State private var yearsOfService: Double = 20
    @State private var high3BasicPay: String = ""

    @State private var showResults: Bool = false

    private let dodAutoMatch: Double = 1.0
    private let brsMultiplier: Double = 0.02

    private var pay: Double { Double(basicPay) ?? 0 }
    private var tspBalance: Double { Double(currentTSPBalance) ?? 0 }
    private var high3: Double { Double(high3BasicPay) ?? 0 }

    private var dodMatchPct: Double {
        let c = contributionPct
        if c <= 0 { return 0 }
        let firstThree = min(c, 3.0) * 1.0
        let nextTwo = max(0, min(c - 3.0, 2.0)) * 0.5
        return firstThree + nextTwo
    }

    private var totalMonthlyTSPContribution: Double {
        let yourMonthly = pay * contributionPct / 100.0
        let dodAutoMonthly = pay * dodAutoMatch / 100.0
        let dodMatchMonthly = pay * dodMatchPct / 100.0
        return yourMonthly + dodAutoMonthly + dodMatchMonthly
    }

    private var projectedTSPBalance: Double {
        let years = yearsOfService
        let annualRate = expectedReturn / 100.0
        let monthlyRate = annualRate / 12.0
        let months = years * 12.0

        let fvLump = tspBalance * pow(1 + annualRate, years)

        let fvContrib: Double
        if monthlyRate == 0 {
            fvContrib = totalMonthlyTSPContribution * months
        } else {
            fvContrib = totalMonthlyTSPContribution * ((pow(1 + monthlyRate, months) - 1) / monthlyRate)
        }

        return fvLump + fvContrib
    }

    private var monthlyTSPIncome: Double {
        projectedTSPBalance * 0.04 / 12.0
    }

    private var annualPension: Double {
        brsMultiplier * yearsOfService * (high3 * 12.0)
    }

    private var monthlyPension: Double {
        annualPension / 12.0
    }

    private var combinedMonthlyIncome: Double {
        monthlyTSPIncome + monthlyPension
    }

    private var pensionEligible: Bool {
        yearsOfService >= 20
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                introSection

                tspInputSection

                pensionInputSection

                if showResults {
                    combinedSnapshotSection
                    tspResultSection
                    pensionResultSection
                }

                Button {
                    withAnimation(.spring(response: 0.4)) { showResults = true }
                } label: {
                    Text("Show My Snapshot")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }

                disclaimerFooter
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("BRS Snapshot")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "chart.pie.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("BRS Retirement Snapshot")
                    .font(.subheadline.weight(.bold))
            }
            Text("The Blended Retirement System has two components. This tool estimates both — your TSP savings and your military pension — so you can see the full picture.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.forestGreen)
                    .padding(.top, 2)
                Text("Available to service members who entered service on or after January 1, 2018, or opted in during the 2018 window.")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .padding(10)
            .background(AppTheme.forestGreen.opacity(0.08))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding(14)
        .background(AppTheme.gold.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var tspInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "banknote.fill")
                    .foregroundStyle(.blue)
                Text("TSP Side (Your Account)")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
                PayInputRow(label: "Monthly Basic Pay", sublabel: "Current basic pay", value: $basicPay, color: AppTheme.forestGreen)
                Divider()
                PayInputRow(label: "Current TSP Balance", sublabel: "What you've saved", value: $currentTSPBalance, color: .blue)
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
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

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
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var pensionInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Pension Side (Monthly Check)")
                    .font(.headline.weight(.bold))
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Years of Service at Retirement")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text("\(Int(yearsOfService)) yr")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.purple)
                }
                Slider(value: $yearsOfService, in: 0...30, step: 1)
                    .tint(.purple)
                if !pensionEligible {
                    Text("BRS pension generally requires 20+ years of service.")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(spacing: 10) {
                PayInputRow(label: "High-3 Average Basic Pay", sublabel: "Avg of highest 3 years (monthly)", value: $high3BasicPay, color: AppTheme.gold)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "function")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("BRS Pension Formula")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                    Text("2.0% × Years of Service × High-3 Basic Pay = Annual Pension")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                }
            }
            .padding(10)
            .background(AppTheme.gold.opacity(0.08))
            .clipShape(.rect(cornerRadius: 8))
        }
    }

    private var combinedSnapshotSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Combined Picture")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.8))
            Text("Estimated Monthly Retirement Income")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
            Text(formatCurrency(combinedMonthlyIncome) + " /mo")
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                snapshotChip(label: "TSP", value: formatCurrency(monthlyTSPIncome), icon: "banknote.fill")
                snapshotChip(label: "Pension", value: formatCurrency(monthlyPension), icon: "checkmark.seal.fill")
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppTheme.forestGreen)
        .clipShape(.rect(cornerRadius: 16))
    }

    private func snapshotChip(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.gold)
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
                Text(value)
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.white.opacity(0.15))
        .clipShape(.rect(cornerRadius: 10))
    }

    private var tspResultSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "banknote.fill")
                    .foregroundStyle(.blue)
                Text("TSP — Defined Contribution")
                    .font(.subheadline.weight(.bold))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Projected Balance at \(Int(yearsOfService)) Years")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(formatCurrency(projectedTSPBalance))
                    .font(.title.weight(.heavy))
                    .foregroundStyle(.blue)
                Text("At a 4% withdrawal rate, that's about \(formatCurrency(monthlyTSPIncome))/mo")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(.blue.opacity(0.08))
            .clipShape(.rect(cornerRadius: 12))
        }
    }

    private var pensionResultSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Pension — Defined Benefit")
                    .font(.subheadline.weight(.bold))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Estimated Monthly Pension")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(formatCurrency(monthlyPension) + " /mo")
                    .font(.title.weight(.heavy))
                    .foregroundStyle(AppTheme.gold)
                Text("Annual: \(formatCurrency(annualPension))")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                if !pensionEligible {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text("Pension typically requires 20+ years of service to vest.")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.orange)
                    }
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(AppTheme.gold.opacity(0.08))
            .clipShape(.rect(cornerRadius: 12))
        }
    }

    private var disclaimerFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
                Text("DashTen is not affiliated with the Department of Defense or any government agency. This is an educational estimator only — not financial, tax, or legal advice. Results are hypothetical projections. Actual benefits depend on your service record, pay grade, and applicable regulations. Consult a financial professional and your service finance office before making retirement decisions.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
        }
        .padding(12)
        .background(.orange.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

#Preview {
    NavigationStack {
        BRSRetirementSnapshotView()
    }
}
