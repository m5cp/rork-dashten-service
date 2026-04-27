import SwiftUI

struct JobOfferComparisonView: View {
    @Bindable var storage: StorageService
    @State private var showAddOffer: Bool = false
    @State private var selectedOffer: JobOffer?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if storage.jobOffers.isEmpty {
                    emptyState
                } else {
                    if storage.jobOffers.count >= 2 {
                        comparisonSummary
                    }
                    offersList
                }

                taxDisclaimer
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Job Offer Compare")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddOffer = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.forestGreen)
                }
                .accessibilityLabel("Add job offer")
            }
        }
        .sheet(isPresented: $showAddOffer) {
            AddJobOfferSheet(storage: storage)
        }
        .sheet(item: $selectedOffer) { offer in
            EditJobOfferSheet(storage: storage, offer: offer)
        }
        .onAppear {
            storage.trackToolUsed("job_offer_compare")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "scalemass.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.forestGreen.opacity(0.3))
            Text("No Offers Yet")
                .font(.title3.weight(.bold))
            Text("Add job offers to compare them side by side. Evaluate salary, benefits, PTO, commute, and growth potential.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                showAddOffer = true
            } label: {
                Label("Add First Offer", systemImage: "plus")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(32)
    }

    private var comparisonSummary: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Quick Comparison")
                    .font(.headline.weight(.bold))
            }

            let sorted = storage.jobOffers.sorted { $0.totalCompensation > $1.totalCompensation }

            VStack(spacing: 10) {
                CompareRow(label: "Highest Total Comp", value: sorted.first?.companyName ?? "", detail: formatCurrency(sorted.first?.totalCompensation ?? 0), color: AppTheme.forestGreen)
                CompareRow(label: "Most PTO", value: storage.jobOffers.max(by: { $0.ptoWeeks < $1.ptoWeeks })?.companyName ?? "", detail: "\(Int(storage.jobOffers.max(by: { $0.ptoWeeks < $1.ptoWeeks })?.ptoWeeks ?? 0)) weeks", color: .blue)
                CompareRow(label: "Most Remote", value: storage.jobOffers.max(by: { $0.remotePercentage < $1.remotePercentage })?.companyName ?? "", detail: "\(storage.jobOffers.max(by: { $0.remotePercentage < $1.remotePercentage })?.remotePercentage ?? 0)%", color: .purple)
                CompareRow(label: "Shortest Commute", value: storage.jobOffers.min(by: { $0.commuteMinutes < $1.commuteMinutes })?.companyName ?? "", detail: "\(storage.jobOffers.min(by: { $0.commuteMinutes < $1.commuteMinutes })?.commuteMinutes ?? 0) min", color: .teal)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private var offersList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Offers")
                .font(.headline.weight(.bold))

            ForEach(storage.jobOffers) { offer in
                Button {
                    selectedOffer = offer
                } label: {
                    OfferCard(offer: offer, isBest: offer.id == storage.jobOffers.max(by: { $0.totalCompensation < $1.totalCompensation })?.id)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var taxDisclaimer: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(.top, 2)
            Text("This tool provides estimates only. Tax implications vary significantly. Consult a tax professional for advice specific to your situation.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
        }
        .padding(12)
        .background(.orange.opacity(0.06))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

private struct CompareRow: View {
    let label: String
    let value: String
    let detail: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption.weight(.bold))
            Text(detail)
                .font(.caption.weight(.bold))
                .foregroundStyle(color)
        }
    }
}

private struct OfferCard: View {
    let offer: JobOffer
    let isBest: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(offer.companyName.isEmpty ? "Untitled" : offer.companyName)
                        .font(.headline.weight(.bold))
                    Text(offer.roleTitle.isEmpty ? "No role" : offer.roleTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if isBest {
                    StatusBadge(text: "Top Offer", color: AppTheme.forestGreen)
                }
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }

            HStack(spacing: 16) {
                OfferStat(label: "Base", value: formatCurrency(offer.baseSalary))
                OfferStat(label: "Total Comp", value: formatCurrency(offer.totalCompensation))
                OfferStat(label: "PTO", value: "\(Int(offer.ptoWeeks))w")
                OfferStat(label: "Remote", value: "\(offer.remotePercentage)%")
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

private struct OfferStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.caption.weight(.bold))
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.tertiary)
        }
    }
}

struct AddJobOfferSheet: View {
    let storage: StorageService
    @Environment(\.dismiss) private var dismiss
    @State private var offer = JobOffer()

    var body: some View {
        NavigationStack {
            JobOfferForm(offer: $offer)
                .navigationTitle("Add Offer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            storage.jobOffers.append(offer)
                            if storage.jobOffers.count >= 2 {
                                storage.unlockBadge("offer_compared")
                            }
                            dismiss()
                        }
                        .font(.body.weight(.bold))
                    }
                }
        }
    }
}

struct EditJobOfferSheet: View {
    let storage: StorageService
    let offer: JobOffer
    @Environment(\.dismiss) private var dismiss
    @State private var editedOffer: JobOffer

    init(storage: StorageService, offer: JobOffer) {
        self.storage = storage
        self.offer = offer
        self._editedOffer = State(initialValue: offer)
    }

    var body: some View {
        NavigationStack {
            JobOfferForm(offer: $editedOffer)
                .navigationTitle("Edit Offer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if let idx = storage.jobOffers.firstIndex(where: { $0.id == offer.id }) {
                                storage.jobOffers[idx] = editedOffer
                            }
                            dismiss()
                        }
                        .font(.body.weight(.bold))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Offer", role: .destructive) {
                            storage.jobOffers.removeAll { $0.id == offer.id }
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct JobOfferForm: View {
    @Binding var offer: JobOffer

    var body: some View {
        Form {
            Section("Company") {
                TextField("Company Name", text: $offer.companyName)
                TextField("Role Title", text: $offer.roleTitle)
            }
            Section("Compensation") {
                HStack {
                    Text("Base Salary")
                    Spacer()
                    TextField("$0", value: $offer.baseSalary, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Signing Bonus")
                    Spacer()
                    TextField("$0", value: $offer.signingBonus, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Annual Bonus")
                    Spacer()
                    TextField("$0", value: $offer.annualBonus, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Retirement Match %")
                    Spacer()
                    TextField("0", value: $offer.retirementMatch, format: .number.precision(.fractionLength(1)))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            Section("Benefits & Lifestyle") {
                HStack {
                    Text("PTO (weeks/year)")
                    Spacer()
                    TextField("2", value: $offer.ptoWeeks, format: .number.precision(.fractionLength(1)))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Health Insurance ($/mo)")
                    Spacer()
                    TextField("$0", value: $offer.healthInsuranceCost, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Commute (minutes)")
                    Spacer()
                    TextField("0", value: $offer.commuteMinutes, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Remote Work %")
                    Spacer()
                    TextField("0", value: $offer.remotePercentage, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                Picker("Growth Potential", selection: $offer.growthRating) {
                    ForEach(1...5, id: \.self) { rating in
                        Text("\(rating) / 5").tag(rating)
                    }
                }
            }
            Section("Notes") {
                TextEditor(text: $offer.overallNotes)
                    .frame(minHeight: 80)
            }
        }
    }
}
