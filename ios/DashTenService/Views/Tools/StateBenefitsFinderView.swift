import SwiftUI

struct StateBenefitsFinderView: View {
    @State private var selectedState: String = "Texas"

    private let stateData: [StateBenefitData] = [
        StateBenefitData(state: "Texas", incomeTax: "No state income tax", propertyTax: "Disabled veterans may qualify for property tax exemptions", education: "Hazlewood Act — free tuition at state schools for eligible veterans and dependents", license: "Expedited licensing for military spouses", other: ["Free state parks pass for disabled veterans", "Veteran entrepreneur program", "Free driver license for veterans"]),
        StateBenefitData(state: "Florida", incomeTax: "No state income tax", propertyTax: "Homestead exemption + additional for disabled veterans", education: "State tuition waiver for Purple Heart and combat-decorated veterans", license: "Expedited licensing for military spouses", other: ["Free toll road transponder for disabled veterans", "Veteran preference in state hiring", "Free hunting/fishing license for disabled veterans"]),
        StateBenefitData(state: "California", incomeTax: "State income tax applies (1%-13.3%)", propertyTax: "Disabled veteran property tax exemption", education: "CalVet fee waiver at community colleges and CSUs", license: "Temporary license for military spouses", other: ["CalVet home loan program", "Veteran preference in state employment", "Free fishing license for disabled veterans"]),
        StateBenefitData(state: "Virginia", incomeTax: "State income tax applies (2%-5.75%)", propertyTax: "100% disabled veterans exempt from property tax", education: "Virginia Military Survivors and Dependents Education Program", license: "Expedited licensing reciprocity", other: ["Free state park admission for disabled veterans", "Virginia Values Veterans employer program", "Veteran-owned business preference"]),
        StateBenefitData(state: "North Carolina", incomeTax: "Flat state income tax (~4.5%)", propertyTax: "Disabled veteran property tax exclusion up to $45,000", education: "Scholarship for children of wartime veterans", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing license for disabled veterans", "Veteran business enterprise certification", "State veteran cemeteries"]),
        StateBenefitData(state: "Colorado", incomeTax: "Flat state income tax (~4.4%)", propertyTax: "Disabled veteran property tax exemption", education: "Colorado National Guard tuition assistance", license: "Military spouse temporary license", other: ["Free veteran license plates", "Veterans trust fund grants", "State veteran community living centers"]),
        StateBenefitData(state: "Georgia", incomeTax: "State income tax applies (1%-5.49%)", propertyTax: "Disabled veterans up to $109,986 exemption", education: "HERO scholarship for dependents", license: "Expedited licensing for military", other: ["Free veteran ID card", "Veteran preference in state hiring", "Georgia Military College tuition discounts"]),
        StateBenefitData(state: "Washington", incomeTax: "No state income tax", propertyTax: "Property tax assistance for senior/disabled veterans", education: "State needs grant available to veterans", license: "Expedited licensing", other: ["Free fishing license for disabled veterans", "Veteran-owned business preference", "Free state parks pass for disabled veterans"]),
        StateBenefitData(state: "Tennessee", incomeTax: "No state income tax", propertyTax: "Disabled veteran property tax reduction", education: "THEC veteran reconnect grant", license: "Military occupational licensing", other: ["Free state parks admission", "Veterans employment services", "State veteran cemeteries"]),
        StateBenefitData(state: "Arizona", incomeTax: "Flat state income tax (2.5%)", propertyTax: "Disabled veteran property tax exemption", education: "In-state tuition for all veterans regardless of residency", license: "Universal license recognition", other: ["Free state park passes for veterans", "Arizona veteran tax credit", "Employer veteran hiring incentives"]),
    ]

    private var selected: StateBenefitData? {
        stateData.first { $0.state == selectedState }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("State-Specific Benefits")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Every state offers different benefits for veterans. Select your destination state to see what's available. Benefits vary by disability status and eligibility.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Your State")
                        .font(.headline.weight(.bold))

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                        ForEach(stateData, id: \.state) { data in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedState = data.state }
                            } label: {
                                Text(data.state)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(selectedState == data.state ? .white : .primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedState == data.state ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if let data = selected {
                    stateDetail(data)
                }

                Text("Benefits change frequently. Always verify current eligibility and availability with your state's Department of Veterans Affairs.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("State Benefits")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stateDetail(_ data: StateBenefitData) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(data.state)
                .font(.title3.weight(.bold))

            VStack(spacing: 10) {
                benefitRow(label: "Income Tax", value: data.incomeTax, icon: "dollarsign.circle.fill", color: .blue)
                Divider()
                benefitRow(label: "Property Tax", value: data.propertyTax, icon: "house.fill", color: .orange)
                Divider()
                benefitRow(label: "Education", value: data.education, icon: "graduationcap.fill", color: .purple)
                Divider()
                benefitRow(label: "Licensing", value: data.license, icon: "doc.text.fill", color: .teal)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 8) {
                Text("Additional Benefits")
                    .font(.subheadline.weight(.bold))

                ForEach(data.other, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(.top, 2)
                        Text(item)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                }
            }
            .padding(14)
            .background(AppTheme.forestGreen.opacity(0.06))
            .clipShape(.rect(cornerRadius: 12))
        }
        .transition(.opacity)
    }

    private func benefitRow(label: String, value: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 20)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.6))
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
            }
        }
    }
}

private nonisolated struct StateBenefitData: Sendable {
    let state: String
    let incomeTax: String
    let propertyTax: String
    let education: String
    let license: String
    let other: [String]
}
