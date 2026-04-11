import SwiftUI

struct CostOfLivingView: View {
    @State private var cityA: String = "San Diego, CA"
    @State private var cityB: String = "San Antonio, TX"

    private let cities: [CityData] = [
        CityData(name: "San Diego, CA", housing: 2800, groceries: 450, transport: 380, utilities: 220, healthcare: 520),
        CityData(name: "San Antonio, TX", housing: 1400, groceries: 350, transport: 300, utilities: 180, healthcare: 440),
        CityData(name: "Virginia Beach, VA", housing: 1900, groceries: 380, transport: 320, utilities: 200, healthcare: 460),
        CityData(name: "Fayetteville, NC", housing: 1100, groceries: 320, transport: 280, utilities: 170, healthcare: 420),
        CityData(name: "Colorado Springs, CO", housing: 1800, groceries: 390, transport: 310, utilities: 190, healthcare: 470),
        CityData(name: "Jacksonville, FL", housing: 1500, groceries: 360, transport: 310, utilities: 200, healthcare: 450),
        CityData(name: "Tacoma, WA", housing: 2100, groceries: 410, transport: 340, utilities: 210, healthcare: 490),
        CityData(name: "Honolulu, HI", housing: 3200, groceries: 550, transport: 400, utilities: 280, healthcare: 560),
        CityData(name: "El Paso, TX", housing: 1100, groceries: 330, transport: 270, utilities: 170, healthcare: 410),
        CityData(name: "Norfolk, VA", housing: 1700, groceries: 370, transport: 310, utilities: 200, healthcare: 460),
        CityData(name: "Killeen, TX", housing: 1200, groceries: 340, transport: 280, utilities: 175, healthcare: 430),
        CityData(name: "Clarksville, TN", housing: 1300, groceries: 340, transport: 290, utilities: 180, healthcare: 430),
        CityData(name: "Columbia, SC", housing: 1350, groceries: 350, transport: 290, utilities: 185, healthcare: 440),
        CityData(name: "Pensacola, FL", housing: 1400, groceries: 350, transport: 300, utilities: 195, healthcare: 440),
        CityData(name: "Austin, TX", housing: 2000, groceries: 380, transport: 320, utilities: 195, healthcare: 460),
        CityData(name: "Phoenix, AZ", housing: 1700, groceries: 370, transport: 310, utilities: 210, healthcare: 455),
        CityData(name: "Tampa, FL", housing: 1800, groceries: 370, transport: 310, utilities: 200, healthcare: 455),
        CityData(name: "Raleigh, NC", housing: 1650, groceries: 365, transport: 305, utilities: 190, healthcare: 450),
        CityData(name: "Nashville, TN", housing: 1800, groceries: 375, transport: 310, utilities: 190, healthcare: 460),
        CityData(name: "Dallas, TX", housing: 1700, groceries: 370, transport: 320, utilities: 195, healthcare: 455),
    ]

    private var dataA: CityData? { cities.first { $0.name == cityA } }
    private var dataB: CityData? { cities.first { $0.name == cityB } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "building.2.fill")
                            .foregroundStyle(.mint)
                        Text("Compare Where You Live")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Your duty station costs may be very different from where you're moving. Compare estimated monthly costs between military-connected cities.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.mint.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Circle().fill(.teal).frame(width: 10, height: 10)
                        Text("Current Location")
                            .font(.headline.weight(.bold))
                    }
                    Picker("City A", selection: $cityA) {
                        ForEach(cities, id: \.name) { city in
                            Text(city.name).tag(city.name)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 10))
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Circle().fill(.purple).frame(width: 10, height: 10)
                        Text("Target Location")
                            .font(.headline.weight(.bold))
                    }
                    Picker("City B", selection: $cityB) {
                        ForEach(cities, id: \.name) { city in
                            Text(city.name).tag(city.name)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 10))
                }

                if let a = dataA, let b = dataB {
                    comparisonSection(a: a, b: b)
                }

                Text("Estimates based on average costs for single/small household. Actual costs vary significantly by neighborhood, lifestyle, and family size.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Cost of Living")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func comparisonSection(a: CityData, b: CityData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Monthly Cost Comparison")
                    .font(.headline.weight(.bold))
            }

            costRow(category: "Housing", iconName: "house.fill", valueA: a.housing, valueB: b.housing)
            costRow(category: "Groceries", iconName: "cart.fill", valueA: a.groceries, valueB: b.groceries)
            costRow(category: "Transportation", iconName: "car.fill", valueA: a.transport, valueB: b.transport)
            costRow(category: "Utilities", iconName: "bolt.fill", valueA: a.utilities, valueB: b.utilities)
            costRow(category: "Healthcare", iconName: "cross.case.fill", valueA: a.healthcare, valueB: b.healthcare)

            Divider()

            let totalA = a.total
            let totalB = b.total
            let diff = totalB - totalA
            let pctDiff = totalA > 0 ? (diff / totalA) * 100 : 0

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total Monthly")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    HStack(spacing: 16) {
                        Text(formatCurrency(totalA))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.teal)
                        Text("vs")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.4))
                        Text(formatCurrency(totalB))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.purple)
                    }
                }
                Spacer()
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: diff > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.caption)
                    .foregroundStyle(diff > 0 ? .red : AppTheme.forestGreen)
                    .padding(.top, 2)
                Text("\(b.name) is \(formatCurrency(abs(diff)))/month (\(String(format: "%.0f", abs(pctDiff)))%) \(diff > 0 ? "more expensive" : "less expensive") than \(a.name)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.8))
            }
            .padding(12)
            .background((diff > 0 ? Color.red : AppTheme.forestGreen).opacity(0.06))
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func costRow(category: String, iconName: String, valueA: Double, valueB: Double) -> some View {
        let diff = valueB - valueA
        return HStack {
            Image(systemName: iconName)
                .font(.caption)
                .foregroundStyle(.primary.opacity(0.5))
                .frame(width: 20)
            Text(category)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
            Spacer()
            Text(formatCurrency(valueA))
                .font(.caption.weight(.bold))
                .foregroundStyle(.teal)
                .frame(width: 70, alignment: .trailing)
            Text(formatCurrency(valueB))
                .font(.caption.weight(.bold))
                .foregroundStyle(.purple)
                .frame(width: 70, alignment: .trailing)
            Text(diff >= 0 ? "+\(formatCurrency(diff))" : formatCurrency(diff))
                .font(.caption2.weight(.bold))
                .foregroundStyle(diff > 0 ? .red : AppTheme.forestGreen)
                .frame(width: 60, alignment: .trailing)
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

private nonisolated struct CityData: Sendable {
    let name: String
    let housing: Double
    let groceries: Double
    let transport: Double
    let utilities: Double
    let healthcare: Double

    var total: Double { housing + groceries + transport + utilities + healthcare }
}
