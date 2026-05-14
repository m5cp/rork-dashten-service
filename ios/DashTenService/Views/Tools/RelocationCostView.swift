import SwiftUI

struct RelocationCostView: View {
    @State private var familySize: Int = 2
    @State private var distance: String = ""
    @State private var householdGoods: String = "Medium"
    @State private var vehicleCount: String = "1"
    @State private var temporaryHousingDays: String = "14"
    @State private var securityDeposit: String = ""
    @State private var householdItems: String = ""
    @State private var schoolTransfer: String = ""
    @State private var vehicleRegistration: String = ""
    @State private var petRelocation: String = ""
    @State private var movingOutExpenses: String = ""
    @State private var monthsUntilMove: Double = 24
    @State private var additionalExpanded: Bool = false

    private let goodsSizes = ["Light", "Medium", "Heavy"]
    private var distanceMiles: Double { Double(distance) ?? 0 }
    private var vehicles: Int { Int(vehicleCount) ?? 1 }
    private var tempDays: Int { Int(temporaryHousingDays) ?? 14 }

    private var movingCost: Double {
        let baseWeight: Double = householdGoods == "Light" ? 3000 : householdGoods == "Heavy" ? 10000 : 6000
        return baseWeight * 0.80 + distanceMiles * 0.60
    }
    private var vehicleTransport: Double { distanceMiles > 500 ? Double(vehicles) * (500 + distanceMiles * 0.50) : 0 }
    private var tempHousing: Double { (familySize <= 2 ? 120.0 : 160.0) * Double(tempDays) }
    private var travelCost: Double {
        let days = max(1, distanceMiles / 500)
        return distanceMiles * 0.25 + Double(familySize) * 30 * days + max(0, days - 1) * 140
    }
    private var setupCost: Double { 1000 + Double(familySize) * 150 }
    private var additionalTotal: Double {
        let a: Double = (Double(securityDeposit) ?? 0) + (Double(householdItems) ?? 0)
        let b: Double = (Double(schoolTransfer) ?? 0) + (Double(vehicleRegistration) ?? 0)
        let c: Double = (Double(petRelocation) ?? 0) + (Double(movingOutExpenses) ?? 0)
        return a + b + c
    }
    private var totalEstimate: Double { movingCost + vehicleTransport + tempHousing + travelCost + setupCost + additionalTotal }
    private var monthlySavingsGoal: Double { monthsUntilMove > 0 ? totalEstimate / monthsUntilMove : 0 }

    private func fmt(_ v: Double) -> String {
        let f = NumberFormatter(); f.numberStyle = .currency; f.currencyCode = "USD"; f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: v)) ?? "$0"
    }
    private var hasDistance: Bool { distanceMiles > 0 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                VStack(alignment: .leading, spacing: 12) {
                    Text("Move Details")
                        .font(.headline.weight(.bold))
                    VStack(spacing: 14) {
                        HStack {
                            Text("Family Size").font(.subheadline.weight(.bold))
                            Spacer()
                            Picker("", selection: $familySize) {
                                ForEach(1...8, id: \.self) { Text("\($0)").tag($0) }
                            }.pickerStyle(.menu)
                        }.frame(minHeight: 44).contentShape(Rectangle())
                        Divider()
                        PayInputRow(label: "Distance (miles)", sublabel: "Origin to destination", value: $distance, color: .pink)
                        Divider()
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Household Goods").font(.subheadline.weight(.bold))
                                Text("Estimate your load").font(.caption2.weight(.bold)).foregroundStyle(.pink)
                            }
                            Spacer()
                            Picker("", selection: $householdGoods) {
                                ForEach(goodsSizes, id: \.self) { Text($0).tag($0) }
                            }.pickerStyle(.segmented).frame(width: 180)
                        }.frame(minHeight: 44)
                        Divider()
                        PayInputRow(label: "Vehicles to Move", sublabel: "Count", value: $vehicleCount, color: .pink)
                        Divider()
                        PayInputRow(label: "Temp Housing Days", sublabel: "Before moving in", value: $temporaryHousingDays, color: .pink)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }

                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { additionalExpanded.toggle() }
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill").font(.body.weight(.bold)).foregroundStyle(.pink)
                                .frame(width: 32, height: 32).background(Color.pink.opacity(0.12)).clipShape(.rect(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Additional Expenses").font(.headline.weight(.bold))
                                Text("Optional — enter what you know").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.down").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                                .rotationEffect(.degrees(additionalExpanded ? 0 : -90))
                        }
                        .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14)).contentShape(Rectangle())
                    }
                    .buttonStyle(.plain).sensoryFeedback(.selection, trigger: additionalExpanded)

                    if additionalExpanded {
                        VStack(spacing: 10) {
                            PayInputRow(label: "Security Deposit", sublabel: "First month at new location", value: $securityDeposit, color: .pink)
                            Divider()
                            PayInputRow(label: "Replacing Household Items", sublabel: "Items that cannot be shipped", value: $householdItems, color: .pink)
                            Divider()
                            PayInputRow(label: "School Transfer Costs", sublabel: "Tutoring, uniforms, supplies", value: $schoolTransfer, color: .pink)
                            Divider()
                            PayInputRow(label: "Vehicle Registration", sublabel: "New state fees", value: $vehicleRegistration, color: .pink)
                            Divider()
                            PayInputRow(label: "Pet Relocation", sublabel: "Transport, vet, boarding", value: $petRelocation, color: .pink)
                            Divider()
                            PayInputRow(label: "Moving-Out Expenses", sublabel: "Cleaning and repairs", value: $movingOutExpenses, color: .pink)
                        }
                        .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Months Until Move").font(.subheadline.weight(.bold))
                        Spacer()
                        Text("\(Int(monthsUntilMove)) mo").font(.subheadline.weight(.bold)).foregroundStyle(.pink)
                    }
                    Slider(value: $monthsUntilMove, in: 1...36, step: 1).tint(.pink)
                }
                .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Estimated Budget").font(.headline.weight(.bold))
                    VStack(spacing: 8) {
                        if hasDistance {
                            costRow("Moving / Shipping", movingCost, "shippingbox.fill")
                            if vehicleTransport > 0 { costRow("Vehicle Transport", vehicleTransport, "car.fill") }
                            costRow("Temp Housing (\(tempDays) days)", tempHousing, "bed.double.fill")
                            costRow("Travel", travelCost, "fuelpump.fill")
                            costRow("Setup and Deposits", setupCost, "key.fill")
                            if additionalTotal > 0 { costRow("Additional Expenses", additionalTotal, "plus.circle.fill") }
                            Divider()
                            HStack {
                                Text("Total Estimated Cost").font(.subheadline.weight(.bold))
                                Spacer()
                                Text(fmt(totalEstimate)).font(.title3.weight(.bold)).foregroundStyle(.pink)
                            }
                        } else {
                            Text("Enter distance to see estimate").font(.subheadline).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .center).padding()
                        }
                    }
                    .padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
                }

                if hasDistance {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar.badge.clock").foregroundStyle(AppTheme.gold)
                            Text("Monthly Savings Goal").font(.subheadline.weight(.bold))
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(fmt(monthlySavingsGoal)).font(.title.weight(.heavy)).foregroundStyle(AppTheme.forestGreen)
                            Text("/ month").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                        }
                        Text("Save \(fmt(monthlySavingsGoal)) per month over \(Int(monthsUntilMove)) months to cover your estimated \(fmt(totalEstimate)) move.")
                            .font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(14).background(AppTheme.gold.opacity(0.08)).clipShape(.rect(cornerRadius: 14))
                }

                Text("General information only · Not affiliated with any government agency")
                    .font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center).frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Move Budget")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func costRow(_ label: String, _ value: Double, _ icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.caption).foregroundStyle(.pink).frame(width: 20)
            Text(label).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.7)).fixedSize(horizontal: false, vertical: true)
            Spacer()
            Text(fmt(value)).font(.subheadline.weight(.bold))
        }
    }
}
