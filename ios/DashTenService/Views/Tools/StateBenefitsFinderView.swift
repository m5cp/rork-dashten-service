import SwiftUI

struct StateBenefitsFinderView: View {
    @State private var selectedState: String = ""
    @State private var searchText: String = ""

    private var filteredStates: [StateBenefitData] {
        if searchText.isEmpty { return allStates }
        return allStates.filter { $0.state.localizedStandardContains(searchText) }
    }

    private var selected: StateBenefitData? {
        allStates.first { $0.state == selectedState }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                stateSelector

                if let data = selected {
                    stateDetailView(data)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Text("Benefits change frequently. Always verify current eligibility and availability with your state's Department of Veterans Affairs.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("State Benefits")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(response: 0.35), value: selectedState)
    }

    private var headerCard: some View {
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
    }

    private var stateSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Your State")
                .font(.headline.weight(.bold))

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search states", text: $searchText)
                    .font(.subheadline)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 10))

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                    ForEach(filteredStates, id: \.state) { data in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedState = data.state }
                        } label: {
                            Text(data.abbreviation)
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
            .frame(maxHeight: selectedState.isEmpty ? 400 : 200)
        }
    }

    private func stateDetailView(_ data: StateBenefitData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.forestGreen)
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.state)
                        .font(.title3.weight(.bold))
                    Text(data.abbreviation)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 0) {
                benefitRow(label: "Income Tax", value: data.incomeTax, icon: "dollarsign.circle.fill", color: .blue, isFirst: true)
                Divider().padding(.leading, 44)
                benefitRow(label: "Property Tax", value: data.propertyTax, icon: "house.fill", color: .orange, isFirst: false)
                Divider().padding(.leading, 44)
                benefitRow(label: "Education", value: data.education, icon: "graduationcap.fill", color: .purple, isFirst: false)
                Divider().padding(.leading, 44)
                benefitRow(label: "Licensing", value: data.license, icon: "doc.text.fill", color: .teal, isFirst: false)
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            if !data.other.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Additional Benefits")
                        .font(.subheadline.weight(.bold))

                    ForEach(data.other, id: \.self) { item in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(AppTheme.forestGreen)
                                .padding(.top, 2)
                            Text(item)
                                .font(.subheadline)
                                .foregroundStyle(.primary.opacity(0.85))
                        }
                    }
                }
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }

    private func benefitRow(label: String, value: String, icon: String, color: Color, isFirst: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.12))
                .clipShape(.rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private let allStates: [StateBenefitData] = [
        StateBenefitData(state: "Alabama", abbreviation: "AL", incomeTax: "State income tax (2%-5%)", propertyTax: "100% disabled veterans exempt", education: "GI Dependents' Scholarship for children", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing license for disabled veterans", "State veteran cemeteries", "Veteran preference in state hiring"]),
        StateBenefitData(state: "Alaska", abbreviation: "AK", incomeTax: "No state income tax", propertyTax: "Disabled veteran property tax exemption up to $150,000", education: "Free tuition at University of Alaska for eligible veterans", license: "Military spouse temporary license", other: ["Permanent Fund Dividend", "Free state park passes for veterans", "Veteran preference in state employment"]),
        StateBenefitData(state: "Arizona", abbreviation: "AZ", incomeTax: "Flat income tax (2.5%)", propertyTax: "Disabled veteran property tax exemption", education: "In-state tuition for all veterans regardless of residency", license: "Universal license recognition", other: ["Free state park passes for veterans", "Arizona veteran tax credit", "Employer veteran hiring incentives"]),
        StateBenefitData(state: "Arkansas", abbreviation: "AR", incomeTax: "State income tax (2%-4.7%)", propertyTax: "Disabled veteran homestead tax credit", education: "Tuition assistance for dependents of disabled veterans", license: "Expedited licensing for military", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "California", abbreviation: "CA", incomeTax: "State income tax (1%-13.3%)", propertyTax: "Disabled veteran property tax exemption", education: "CalVet fee waiver at community colleges and CSUs", license: "Temporary license for military spouses", other: ["CalVet home loan program", "Veteran preference in state employment", "Free fishing license for disabled veterans"]),
        StateBenefitData(state: "Colorado", abbreviation: "CO", incomeTax: "Flat income tax (~4.4%)", propertyTax: "Disabled veteran property tax exemption", education: "Colorado National Guard tuition assistance", license: "Military spouse temporary license", other: ["Free veteran license plates", "Veterans trust fund grants", "State veteran community living centers"]),
        StateBenefitData(state: "Connecticut", abbreviation: "CT", incomeTax: "State income tax (3%-6.99%)", propertyTax: "Disabled veteran property tax exemption up to $10,000", education: "Tuition waiver at state colleges for veterans", license: "Military spouse licensing accommodation", other: ["Free veteran license plates", "Veteran hiring preference", "State veteran cemeteries"]),
        StateBenefitData(state: "Delaware", abbreviation: "DE", incomeTax: "State income tax (2.2%-6.6%)", propertyTax: "Disabled veteran school property tax credit", education: "Tuition assistance for Guard members", license: "Military spouse expedited license", other: ["Free veteran license plates", "State veteran benefits hotline", "Veteran preference in state hiring"]),
        StateBenefitData(state: "Florida", abbreviation: "FL", incomeTax: "No state income tax", propertyTax: "Homestead exemption + additional for disabled veterans", education: "State tuition waiver for Purple Heart and combat veterans", license: "Expedited licensing for military spouses", other: ["Free toll transponder for disabled veterans", "Veteran preference in state hiring", "Free hunting/fishing license for disabled veterans"]),
        StateBenefitData(state: "Georgia", abbreviation: "GA", incomeTax: "State income tax (1%-5.49%)", propertyTax: "Disabled veterans up to $109,986 exemption", education: "HERO scholarship for dependents", license: "Expedited licensing for military", other: ["Free veteran ID card", "Veteran preference in state hiring", "Georgia Military College tuition discounts"]),
        StateBenefitData(state: "Hawaii", abbreviation: "HI", incomeTax: "State income tax (1.4%-11%)", propertyTax: "Disabled veteran property tax exemption", education: "Tuition waiver at University of Hawaii for veterans", license: "Military spouse licensing accommodation", other: ["State veteran cemeteries", "Veteran preference in state hiring", "Free state park passes for disabled veterans"]),
        StateBenefitData(state: "Idaho", abbreviation: "ID", incomeTax: "Flat income tax (5.8%)", propertyTax: "Disabled veteran property tax reduction", education: "In-state tuition for veterans", license: "Military spouse expedited license", other: ["Free hunting/fishing license for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Illinois", abbreviation: "IL", incomeTax: "Flat income tax (4.95%)", propertyTax: "Disabled veteran homestead exemption up to $100,000", education: "Illinois Veteran Grant — free tuition at state universities", license: "Military spouse expedited licensing", other: ["Free state park passes for veterans", "Veteran preference in state hiring", "Property tax freeze for seniors/disabled veterans"]),
        StateBenefitData(state: "Indiana", abbreviation: "IN", incomeTax: "Flat income tax (3.05%)", propertyTax: "Disabled veteran property tax deduction", education: "Free tuition at state schools for children of disabled veterans", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Iowa", abbreviation: "IA", incomeTax: "State income tax (4.4%-6%)", propertyTax: "Disabled veteran homestead tax credit", education: "War Orphans Educational Aid", license: "Military spouse temporary license", other: ["Free hunting/fishing for disabled veterans", "Iowa Veterans Trust Fund", "Veteran preference in state hiring"]),
        StateBenefitData(state: "Kansas", abbreviation: "KS", incomeTax: "State income tax (3.1%-5.7%)", propertyTax: "Disabled veteran property tax exemption", education: "Tuition assistance for Guard members", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Kentucky", abbreviation: "KY", incomeTax: "Flat income tax (4.5%)", propertyTax: "Disabled veteran homestead exemption", education: "Tuition waiver for dependents of disabled veterans", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Kentucky Veteran Program Trust Fund"]),
        StateBenefitData(state: "Louisiana", abbreviation: "LA", incomeTax: "State income tax (1.85%-4.25%)", propertyTax: "Disabled veteran special assessment freeze", education: "Free tuition at state schools for dependents of disabled veterans", license: "Military spouse expedited license", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Maine", abbreviation: "ME", incomeTax: "State income tax (5.8%-7.15%)", propertyTax: "Disabled veteran property tax exemption", education: "Tuition waiver at state universities for veterans", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Maine Veterans' Homes"]),
        StateBenefitData(state: "Maryland", abbreviation: "MD", incomeTax: "State income tax (2%-5.75%)", propertyTax: "Disabled veteran property tax exemption", education: "Edward T. Conroy Memorial Scholarship", license: "Military spouse expedited licensing", other: ["Free state park passes for veterans", "Veteran preference in state hiring", "Maryland Veterans Trust Fund"]),
        StateBenefitData(state: "Massachusetts", abbreviation: "MA", incomeTax: "Flat income tax (5%)", propertyTax: "Disabled veteran property tax exemption", education: "Tuition waiver at state schools for veterans", license: "Military spouse licensing accommodation", other: ["Free mass transit for disabled veterans", "Veteran preference in state hiring", "Annuity for 100% disabled veterans"]),
        StateBenefitData(state: "Michigan", abbreviation: "MI", incomeTax: "Flat income tax (4.25%)", propertyTax: "Disabled veteran property tax exemption", education: "Michigan tuition grant for veterans", license: "Military spouse expedited license", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Michigan Veterans Trust Fund"]),
        StateBenefitData(state: "Minnesota", abbreviation: "MN", incomeTax: "State income tax (5.35%-9.85%)", propertyTax: "Disabled veteran homestead market value exclusion", education: "MN GI Bill for veterans and dependents", license: "Military spouse licensing accommodation", other: ["Free state park pass for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Mississippi", abbreviation: "MS", incomeTax: "State income tax (0%-5%)", propertyTax: "Disabled veteran homestead exemption", education: "Free tuition at state schools for children of disabled veterans", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Missouri", abbreviation: "MO", incomeTax: "State income tax (2%-4.95%)", propertyTax: "100% disabled veteran property tax exemption", education: "Returning Heroes and Missouri Military Act", license: "Military spouse expedited licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Missouri Veterans Commission programs"]),
        StateBenefitData(state: "Montana", abbreviation: "MT", incomeTax: "State income tax (4.7%-6.75%)", propertyTax: "Disabled veteran property tax reduction", education: "Montana University System fee waiver for veterans", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "Nebraska", abbreviation: "NE", incomeTax: "State income tax (2.46%-6.64%)", propertyTax: "Disabled veteran homestead exemption", education: "Waiver of tuition for Guard members", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Nebraska Veterans' Homes"]),
        StateBenefitData(state: "Nevada", abbreviation: "NV", incomeTax: "No state income tax", propertyTax: "Disabled veteran property tax exemption", education: "In-state tuition for veterans", license: "Military spouse expedited licensing", other: ["Free veteran license plates", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "New Hampshire", abbreviation: "NH", incomeTax: "No state income tax on wages", propertyTax: "Disabled veteran property tax credit", education: "Tuition waiver at state schools for veterans", license: "Military spouse licensing accommodation", other: ["Free toll road pass for disabled veterans", "Veteran preference in state hiring", "New Hampshire Veterans Home"]),
        StateBenefitData(state: "New Jersey", abbreviation: "NJ", incomeTax: "State income tax (1.4%-10.75%)", propertyTax: "100% disabled veteran full property tax exemption", education: "Tuition-free at state schools for eligible veterans", license: "Military spouse licensing", other: ["Free NJ Transit for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "New Mexico", abbreviation: "NM", incomeTax: "State income tax (1.7%-5.9%)", propertyTax: "Disabled veteran property tax exemption", education: "Vietnam Veterans scholarship for dependents", license: "Military spouse expedited license", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "New York", abbreviation: "NY", incomeTax: "State income tax (4%-10.9%)", propertyTax: "Multiple veteran property tax exemptions", education: "NYS Veterans Tuition Awards", license: "Military spouse licensing accommodation", other: ["Free state park passes for veterans", "Veteran preference in state hiring", "NYS Division of Veterans' Services programs"]),
        StateBenefitData(state: "North Carolina", abbreviation: "NC", incomeTax: "Flat income tax (~4.5%)", propertyTax: "Disabled veteran property tax exclusion up to $45,000", education: "Scholarship for children of wartime veterans", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran business enterprise certification", "State veteran cemeteries"]),
        StateBenefitData(state: "North Dakota", abbreviation: "ND", incomeTax: "State income tax (1.95%)", propertyTax: "Disabled veteran property tax credit", education: "Tuition waiver for dependents of disabled veterans", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "North Dakota Veterans Home"]),
        StateBenefitData(state: "Ohio", abbreviation: "OH", incomeTax: "State income tax (0%-3.75%)", propertyTax: "Disabled veteran homestead exemption", education: "Ohio War Orphans Scholarship", license: "Military spouse expedited licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Ohio Veterans Homes"]),
        StateBenefitData(state: "Oklahoma", abbreviation: "OK", incomeTax: "State income tax (0.25%-4.75%)", propertyTax: "100% disabled veteran full property tax exemption", education: "Tuition waiver for dependents of military", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Oklahoma Veterans Centers"]),
        StateBenefitData(state: "Oregon", abbreviation: "OR", incomeTax: "State income tax (4.75%-9.9%)", propertyTax: "Disabled veteran property tax exemption", education: "Oregon Veterans' Educational Aid", license: "Military spouse expedited license", other: ["Free state park day-use for veterans", "Veteran preference in state hiring", "Oregon Veterans' Homes"]),
        StateBenefitData(state: "Pennsylvania", abbreviation: "PA", incomeTax: "Flat income tax (3.07%)", propertyTax: "Disabled veteran property tax exemption", education: "Free education at state schools for dependents of disabled veterans", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "PA Veterans Homes"]),
        StateBenefitData(state: "Rhode Island", abbreviation: "RI", incomeTax: "State income tax (3.75%-5.99%)", propertyTax: "Disabled veteran property tax exemption", education: "Tuition waiver at state institutions for veterans", license: "Military spouse licensing accommodation", other: ["Free state park passes for veterans", "Veteran preference in state hiring", "Rhode Island Veterans Home"]),
        StateBenefitData(state: "South Carolina", abbreviation: "SC", incomeTax: "State income tax (0%-6.4%)", propertyTax: "100% disabled veteran homestead exemption", education: "Free tuition at state schools for children of certain veterans", license: "Military spouse expedited licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "State veteran cemeteries"]),
        StateBenefitData(state: "South Dakota", abbreviation: "SD", incomeTax: "No state income tax", propertyTax: "Disabled veteran property tax exemption", education: "Free tuition for Guard members", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "South Dakota Veterans Home"]),
        StateBenefitData(state: "Tennessee", abbreviation: "TN", incomeTax: "No state income tax", propertyTax: "Disabled veteran property tax reduction", education: "THEC veteran reconnect grant", license: "Military occupational licensing", other: ["Free state parks admission", "Veterans employment services", "State veteran cemeteries"]),
        StateBenefitData(state: "Texas", abbreviation: "TX", incomeTax: "No state income tax", propertyTax: "Disabled veterans may qualify for property tax exemptions", education: "Hazlewood Act — free tuition at state schools for eligible veterans and dependents", license: "Expedited licensing for military spouses", other: ["Free state parks pass for disabled veterans", "Veteran entrepreneur program", "Free driver license for veterans"]),
        StateBenefitData(state: "Utah", abbreviation: "UT", incomeTax: "Flat income tax (4.65%)", propertyTax: "Disabled veteran property tax exemption", education: "Purple Heart tuition waiver", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Utah Veterans Homes"]),
        StateBenefitData(state: "Vermont", abbreviation: "VT", incomeTax: "State income tax (3.35%-8.75%)", propertyTax: "Disabled veteran property tax exemption", education: "Tuition benefits for Guard members", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Vermont Veterans' Home"]),
        StateBenefitData(state: "Virginia", abbreviation: "VA", incomeTax: "State income tax (2%-5.75%)", propertyTax: "100% disabled veterans exempt from property tax", education: "Virginia Military Survivors and Dependents Education Program", license: "Expedited licensing reciprocity", other: ["Free state park admission for disabled veterans", "Virginia Values Veterans employer program", "Veteran-owned business preference"]),
        StateBenefitData(state: "Washington", abbreviation: "WA", incomeTax: "No state income tax", propertyTax: "Property tax assistance for senior/disabled veterans", education: "State needs grant available to veterans", license: "Expedited licensing", other: ["Free fishing license for disabled veterans", "Veteran-owned business preference", "Free state parks pass for disabled veterans"]),
        StateBenefitData(state: "West Virginia", abbreviation: "WV", incomeTax: "State income tax (3%-6.5%)", propertyTax: "Disabled veteran homestead exemption", education: "Free tuition for dependents of disabled veterans", license: "Military spouse licensing accommodation", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "West Virginia Veterans Nursing Facility"]),
        StateBenefitData(state: "Wisconsin", abbreviation: "WI", incomeTax: "State income tax (3.54%-7.65%)", propertyTax: "Disabled veteran property tax credit", education: "Wisconsin GI Bill — tuition remission at UW schools", license: "Military spouse expedited licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Wisconsin Veterans Homes"]),
        StateBenefitData(state: "Wyoming", abbreviation: "WY", incomeTax: "No state income tax", propertyTax: "Disabled veteran property tax exemption", education: "Tuition benefits for Guard members", license: "Military spouse licensing", other: ["Free hunting/fishing for disabled veterans", "Veteran preference in state hiring", "Wyoming Veterans Home"]),
    ]
}

private nonisolated struct StateBenefitData: Sendable {
    let state: String
    let abbreviation: String
    let incomeTax: String
    let propertyTax: String
    let education: String
    let license: String
    let other: [String]
}
