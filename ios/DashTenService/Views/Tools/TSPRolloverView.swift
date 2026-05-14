import SwiftUI

struct TSPRolloverView: View {
    @State private var tspBalance: String = ""
    @State private var monthlyContribution: String = ""
    @State private var yearsUntilRetirement: Double = 20
    @State private var checklistExpanded: Bool = false

    private var balance: Double { Double(tspBalance) ?? 0 }
    private var monthly: Double { Double(monthlyContribution) ?? 0 }

    private let options: [(String, String, Double, String, Color)] = [
        ("Leave in TSP", "shield.fill", 0.05, "Lowest fees of any plan (~0.04%), limited fund choices, stable government plan", .teal),
        ("Traditional IRA", "building.columns.fill", 0.06, "Tax-deferred growth, wider investment options, no tax owed on rollover from traditional TSP", .blue),
        ("Roth IRA", "sun.max.fill", 0.06, "Tax-free withdrawals in retirement — conversion creates a taxable event in the year it happens", .orange),
        ("New Employer 401(k)", "briefcase.fill", 0.06, "Consolidate accounts, possible employer match, fee structure varies by plan", .purple),
    ]

    private func projected(_ rate: Double) -> String {
        guard balance > 0 || monthly > 0 else { return "—" }
        let monthlyRate = rate / 12
        let months = Double(Int(yearsUntilRetirement) * 12)
        let b = balance * pow(1 + monthlyRate, months)
        let c = monthly > 0 ? monthly * ((pow(1 + monthlyRate, months) - 1) / monthlyRate) : 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: b + c)) ?? "—"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                rollIntoTSPCard
                checklistSection
                directVsIndirectCard
                age55Card

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Numbers")
                        .font(.headline.weight(.bold))
                        .padding(.horizontal, 16)

                    VStack(spacing: 10) {
                        PayInputRow(label: "Current TSP Balance", sublabel: "Total balance", value: $tspBalance, color: AppTheme.forestGreen)
                        Divider()
                        PayInputRow(label: "Monthly Contribution", sublabel: "Future monthly savings", value: $monthlyContribution, color: .blue)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                    .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Years Until Retirement")
                                .font(.subheadline.weight(.bold))
                            Spacer()
                            Text("\(Int(yearsUntilRetirement)) yr")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(AppTheme.forestGreen)
                        }
                        Slider(value: $yearsUntilRetirement, in: 5...40, step: 1)
                            .tint(AppTheme.forestGreen)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                    .padding(.horizontal, 16)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Estimated Growth")
                        .font(.headline.weight(.bold))
                        .padding(.horizontal, 16)

                    ForEach(options, id: \.0) { name, icon, rate, description, color in
                        HStack(spacing: 12) {
                            Image(systemName: icon)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(color)
                                .frame(width: 36, height: 36)
                                .background(color.opacity(0.12))
                                .clipShape(.rect(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(name)
                                    .font(.subheadline.weight(.bold))
                                Text(description)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                            Text(projected(rate))
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(color)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                        .padding(.horizontal, 16)
                    }
                }

                advisorNote

                Text("General information only · Not affiliated with any government agency")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .readableContentWidth()
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("TSP Options")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var rollIntoTSPCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Rolling money INTO TSP is also an option")
                    .font(.subheadline.weight(.bold))
            }
            Text("Traditional IRAs, 401(k)s, 403(b)s, and 457(b)s can be transferred into TSP. Roth IRA funds cannot.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(AppTheme.gold.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.gold.opacity(0.3), lineWidth: 1))
        .clipShape(.rect(cornerRadius: 12))
        .padding(.horizontal, 16)
    }

    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    checklistExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "checklist")
                        .font(.body.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(width: 32, height: 32)
                        .background(AppTheme.forestGreen.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))
                    Text("10 Things to Consider")
                        .font(.headline.weight(.bold))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(checklistExpanded ? 0 : -90))
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: checklistExpanded)
            .padding(.horizontal, 16)

            if checklistExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(checklistItems, id: \.0) { num, title, detail in
                        HStack(alignment: .top, spacing: 10) {
                            Text(num)
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(AppTheme.forestGreen)
                                .frame(width: 20, alignment: .center)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(title).font(.caption.weight(.bold))
                                Text(detail).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        if num != "10" { Divider() }
                    }
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
                .padding(.horizontal, 16)
            }
        }
    }

    private let checklistItems: [(String, String, String)] = [
        ("1","Evaluate all four options","Stay in TSP, roll to a new employer plan, roll to an IRA, or cash out. Cashing out before age 59.5 typically results in a 10% penalty plus taxes."),
        ("2","Match the account type","Traditional TSP to Traditional IRA — no immediate tax. Roth TSP to Roth IRA — no immediate tax. Mixing types creates a taxable event."),
        ("3","Understand indirect rollovers","With a direct rollover, TSP sends funds straight to the new account. With an indirect rollover, TSP withholds 20% and you have 60 days to deposit the full original amount."),
        ("4","Watch out for 'free' or 'no fee' claims","The rollover may have no direct cost but the receiving account typically has ongoing fees for administration or investments."),
        ("5","Understand how financial professionals are compensated","Professionals who recommend rolling out of TSP may receive compensation from that move. Worth understanding before deciding."),
        ("6","Compare investment options and fees","IRAs offer more choices. TSP expense ratios are among the lowest available. Whether the added options are worth added cost depends on the situation."),
        ("7","Ask for fee information in writing","Request a written breakdown of all fees — account administration, fund expenses, and any advisory charges — before deciding."),
        ("8","Understand the tax impact of Roth conversions","Converting traditional to Roth increases taxable income in the year of conversion and can affect your tax bracket."),
        ("9","Know the age 55 window","Separating from service at 55 or older may allow penalty-free TSP withdrawals before 59.5. Rolling to an IRA before using this window typically removes access to it."),
        ("10","Rolling into TSP is also an option","Traditional IRAs, 401(k)s, 403(b)s, and 457(b)s can be transferred into TSP — an option not often highlighted in general retirement advertising."),
    ]

    private var directVsIndirectCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Direct vs Indirect Rollover")
                .font(.subheadline.weight(.bold))
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Direct", systemImage: "checkmark.circle.fill").font(.caption.weight(.bold)).foregroundStyle(.teal)
                    Text("TSP sends funds straight to the new account. No withholding. No deadline.")
                        .font(.caption2.weight(.semibold)).foregroundStyle(.primary.opacity(0.8)).fixedSize(horizontal: false, vertical: true)
                }
                .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 6) {
                    Label("Indirect", systemImage: "exclamationmark.triangle.fill").font(.caption.weight(.bold)).foregroundStyle(.orange)
                    Text("TSP withholds 20%. The full original amount must be deposited within 60 days or the withheld portion becomes taxable.")
                        .font(.caption2.weight(.semibold)).foregroundStyle(.primary.opacity(0.8)).fixedSize(horizontal: false, vertical: true)
                }
                .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 10))
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .padding(.horizontal, 16)
    }

    private var age55Card: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "calendar.badge.exclamationmark").foregroundStyle(.purple)
                Text("The Age 55 Window").font(.subheadline.weight(.bold))
            }
            Text("Separating at 55 or older may allow penalty-free TSP withdrawals before 59.5. Rolling to an IRA before using this window typically removes that option — IRA penalty-free withdrawals generally start at 59.5.")
                .font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(.purple.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
        .padding(.horizontal, 16)
    }

    private var advisorNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass.circle.fill").font(.caption).foregroundStyle(.blue)
            Text("Financial professionals who work with investments are required to be licensed. Background information is publicly available through government and regulatory databases at no cost.")
                .font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(.blue.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal, 16)
    }
}
