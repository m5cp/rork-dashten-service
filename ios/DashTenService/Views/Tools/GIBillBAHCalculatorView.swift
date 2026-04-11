import SwiftUI

struct GIBillBAHCalculatorView: View {
    @State private var selectedZIP: String = ""
    @State private var enrollmentStatus: String = "Full-time"
    @State private var showResults: Bool = false

    private let enrollmentOptions = ["Full-time", "3/4 time", "Half-time", "Online only"]

    private let bahData: [BAHEntry] = [
        BAHEntry(zip: "92101", city: "San Diego, CA", fullTime: 3252, threeQuarter: 2439, halfTime: 1626, online: 1054),
        BAHEntry(zip: "78201", city: "San Antonio, TX", fullTime: 1902, threeQuarter: 1427, halfTime: 951, online: 1054),
        BAHEntry(zip: "23451", city: "Virginia Beach, VA", fullTime: 2247, threeQuarter: 1685, halfTime: 1124, online: 1054),
        BAHEntry(zip: "28301", city: "Fayetteville, NC", fullTime: 1557, threeQuarter: 1168, halfTime: 779, online: 1054),
        BAHEntry(zip: "80901", city: "Colorado Springs, CO", fullTime: 2175, threeQuarter: 1631, halfTime: 1088, online: 1054),
        BAHEntry(zip: "32099", city: "Jacksonville, FL", fullTime: 1968, threeQuarter: 1476, halfTime: 984, online: 1054),
        BAHEntry(zip: "98402", city: "Tacoma, WA", fullTime: 2574, threeQuarter: 1931, halfTime: 1287, online: 1054),
        BAHEntry(zip: "96801", city: "Honolulu, HI", fullTime: 3726, threeQuarter: 2795, halfTime: 1863, online: 1054),
        BAHEntry(zip: "79901", city: "El Paso, TX", fullTime: 1554, threeQuarter: 1166, halfTime: 777, online: 1054),
        BAHEntry(zip: "23501", city: "Norfolk, VA", fullTime: 2109, threeQuarter: 1582, halfTime: 1055, online: 1054),
        BAHEntry(zip: "76541", city: "Killeen, TX", fullTime: 1593, threeQuarter: 1195, halfTime: 797, online: 1054),
        BAHEntry(zip: "37040", city: "Clarksville, TN", fullTime: 1692, threeQuarter: 1269, halfTime: 846, online: 1054),
        BAHEntry(zip: "29201", city: "Columbia, SC", fullTime: 1734, threeQuarter: 1301, halfTime: 867, online: 1054),
        BAHEntry(zip: "73301", city: "Austin, TX", fullTime: 2421, threeQuarter: 1816, halfTime: 1211, online: 1054),
        BAHEntry(zip: "85001", city: "Phoenix, AZ", fullTime: 2127, threeQuarter: 1595, halfTime: 1064, online: 1054),
        BAHEntry(zip: "33601", city: "Tampa, FL", fullTime: 2190, threeQuarter: 1643, halfTime: 1095, online: 1054),
        BAHEntry(zip: "27601", city: "Raleigh, NC", fullTime: 2022, threeQuarter: 1517, halfTime: 1011, online: 1054),
        BAHEntry(zip: "37201", city: "Nashville, TN", fullTime: 2178, threeQuarter: 1634, halfTime: 1089, online: 1054),
        BAHEntry(zip: "75201", city: "Dallas, TX", fullTime: 2253, threeQuarter: 1690, halfTime: 1127, online: 1054),
        BAHEntry(zip: "32501", city: "Pensacola, FL", fullTime: 1809, threeQuarter: 1357, halfTime: 905, online: 1054),
    ]

    private var selectedEntry: BAHEntry? {
        bahData.first { $0.zip == selectedZIP }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.blue)
                        Text("Estimate Your Housing Allowance")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("The Post-9/11 GI Bill pays a monthly housing allowance based on where you attend school and your enrollment status. Online-only students receive a flat national rate.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.blue.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select School Location")
                        .font(.headline.weight(.bold))

                    ForEach(bahData, id: \.zip) { entry in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedZIP = entry.zip
                                showResults = true
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text(entry.zip)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 52, height: 28)
                                    .background(selectedZIP == entry.zip ? .blue : .primary.opacity(0.25))
                                    .clipShape(.rect(cornerRadius: 6))

                                Text(entry.city)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.primary)

                                Spacer()

                                Text(formatCurrency(entry.fullTime))
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.blue)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(selectedZIP == entry.zip ? .blue.opacity(0.06) : Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }

                if showResults, let entry = selectedEntry {
                    resultsSection(entry)
                }

                Text("Rates are estimates based on E-5 with dependents BAH. Actual rates vary by year and eligibility. Verify with official sources.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("GI Bill BAH Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func resultsSection(_ entry: BAHEntry) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text(entry.city)
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
                bahRow(status: "Full-time", amount: entry.fullTime, isHighlighted: enrollmentStatus == "Full-time")
                bahRow(status: "3/4 time", amount: entry.threeQuarter, isHighlighted: enrollmentStatus == "3/4 time")
                bahRow(status: "Half-time", amount: entry.halfTime, isHighlighted: enrollmentStatus == "Half-time")
                bahRow(status: "Online only", amount: entry.online, isHighlighted: enrollmentStatus == "Online only")
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                Text("Annual Housing Estimate")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.6))
                Text(formatCurrency(entry.fullTime * 12))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.blue)
                Text("at full-time enrollment (12 months)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(14)
            .background(.blue.opacity(0.06))
            .clipShape(.rect(cornerRadius: 12))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func bahRow(status: String, amount: Double, isHighlighted: Bool) -> some View {
        HStack {
            Text(status)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
            Spacer()
            Text(formatCurrency(amount))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(isHighlighted ? .blue : .primary.opacity(0.7))
            Text("/month")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.4))
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

private nonisolated struct BAHEntry: Sendable {
    let zip: String
    let city: String
    let fullTime: Double
    let threeQuarter: Double
    let halfTime: Double
    let online: Double
}
