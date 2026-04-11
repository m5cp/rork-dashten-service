import SwiftUI

struct RelocationCostView: View {
    @State private var familySize: Int = 2
    @State private var distance: String = ""
    @State private var householdGoods: String = "Medium"
    @State private var vehicleCount: String = "1"
    @State private var temporaryHousingDays: String = "14"
    @State private var showResults: Bool = false

    private let goodsSizes = ["Light", "Medium", "Heavy"]

    private var distanceMiles: Double { Double(distance) ?? 0 }
    private var vehicles: Int { Int(vehicleCount) ?? 1 }
    private var tempDays: Int { Int(temporaryHousingDays) ?? 14 }

    private var movingCost: Double {
        let baseWeight: Double
        switch householdGoods {
        case "Light": baseWeight = 3000
        case "Heavy": baseWeight = 10000
        default: baseWeight = 6000
        }
        let weightCost = baseWeight * 0.80
        let distanceFactor = distanceMiles * 0.60
        return weightCost + distanceFactor
    }

    private var vehicleTransport: Double {
        guard distanceMiles > 500 else { return 0 }
        return Double(vehicles) * (500 + distanceMiles * 0.50)
    }

    private var tempHousing: Double {
        let dailyRate: Double = familySize <= 2 ? 120 : 160
        return dailyRate * Double(tempDays)
    }

    private var travelCost: Double {
        let gasPerMile = 0.25
        let mealsPerDay = Double(familySize) * 30
        let drivingDays = max(1, distanceMiles / 500)
        let hotelCost = max(0, (drivingDays - 1)) * 140
        return (distanceMiles * gasPerMile) + (mealsPerDay * drivingDays) + hotelCost
    }

    private var deposits: Double {
        1500 + (Double(familySize) * 200)
    }

    private var totalEstimate: Double {
        movingCost + vehicleTransport + tempHousing + travelCost + deposits
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "shippingbox.fill")
                            .foregroundStyle(.pink)
                        Text("Plan Your Move Budget")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Civilian moves aren't covered like PCS moves. Estimate what your relocation will actually cost so you can budget accordingly.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.pink.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Move Details")
                        .font(.headline.weight(.bold))

                    VStack(spacing: 14) {
                        HStack {
                            Text("Family Size")
                                .font(.subheadline.weight(.bold))
                            Spacer()
                            Picker("", selection: $familySize) {
                                ForEach(1...8, id: \.self) { Text("\($0)").tag($0) }
                            }
                            .pickerStyle(.menu)
                        }

                        Divider()

                        PayInputRow(label: "Distance (miles)", sublabel: "Origin to destination", value: $distance, color: .pink)

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Household Goods")
                                    .font(.subheadline.weight(.bold))
                                Text("Estimate your load")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(.pink)
                            }
                            Spacer()
                            Picker("", selection: $householdGoods) {
                                ForEach(goodsSizes, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }

                        Divider()

                        PayInputRow(label: "Vehicles to Move", sublabel: "Count", value: $vehicleCount, color: .pink)

                        Divider()

                        PayInputRow(label: "Temp Housing Days", sublabel: "Before moving in", value: $temporaryHousingDays, color: .pink)
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }

                Button {
                    withAnimation(.spring(response: 0.4)) { showResults = true }
                } label: {
                    Text("Estimate Costs")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }

                if showResults {
                    resultsSection
                }

                Text("These are rough estimates. Get actual quotes from moving companies and research housing costs in your specific area.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Relocation Costs")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Estimated Move Budget")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 10) {
                costLine(label: "Moving / Shipping", value: movingCost, icon: "shippingbox.fill")
                if vehicleTransport > 0 {
                    costLine(label: "Vehicle Transport", value: vehicleTransport, icon: "car.fill")
                }
                costLine(label: "Temporary Housing (\(tempDays) days)", value: tempHousing, icon: "bed.double.fill")
                costLine(label: "Travel (gas, meals, hotels)", value: travelCost, icon: "fuelpump.fill")
                costLine(label: "Deposits & Setup", value: deposits, icon: "key.fill")
                Divider()
                HStack {
                    Text("Total Estimated Cost")
                        .font(.subheadline.weight(.bold))
                    Spacer()
                    Text(formatCurrency(totalEstimate))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.pink)
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                BulletPoint(text: "Get at least 3 quotes from moving companies", color: .pink)
                BulletPoint(text: "Budget an extra 10-20% for unexpected costs", color: .pink)
                BulletPoint(text: "Check if your new employer offers relocation assistance", color: .pink)
                BulletPoint(text: "Start decluttering early to reduce moving weight and cost", color: .pink)
            }
            .padding(14)
            .background(.pink.opacity(0.06))
            .clipShape(.rect(cornerRadius: 12))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func costLine(label: String, value: Double, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.pink)
                .frame(width: 20)
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
            Spacer()
            Text(formatCurrency(value))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary)
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
