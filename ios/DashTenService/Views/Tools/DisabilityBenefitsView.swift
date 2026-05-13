import SwiftUI

struct DisabilityBenefitsView: View {
	let storage: StorageService
	@State private var selectedRating: Int

	init(storage: StorageService) {
		self.storage = storage
		self._selectedRating = State(initialValue: storage.profile.disabilityRating)
	}

	private var ratingLabel: String {
		selectedRating == 0 ? "No Rating" : "\(selectedRating)%"
	}

	private var applicableBenefits: [DisabilityBenefitItem] {
		allBenefits.filter { selectedRating >= $0.minimumRating }
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {

				howRatingsCard
				ratingSelector
				benefitsList
				noteCard

				Text("General information only · Not affiliated with any government agency · Benefits vary by state and circumstance")
					.font(.caption2)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
					.frame(maxWidth: .infinity)
			}
			.padding(.horizontal, 16)
			.padding(.bottom, 40)
		}
		.background(Color(.systemGroupedBackground))
		.navigationTitle("Benefits by Rating")
		.navigationBarTitleDisplayMode(.inline)
	}

	private var howRatingsCard: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(spacing: 8) {
				Image(systemName: "info.circle.fill")
					.foregroundStyle(.blue)
				Text("How Ratings Are Determined")
					.font(.subheadline.weight(.bold))
			}
			Text("VA disability ratings are determined by the Department of Veterans Affairs — not by a formula you can calculate in advance. The outcome depends on your medical records, the examiner, and how your conditions are documented.")
				.font(.caption.weight(.semibold))
				.foregroundStyle(.primary.opacity(0.85))
				.fixedSize(horizontal: false, vertical: true)

			Divider()

			Text("Ratings do not add up the way you might expect.")
				.font(.caption.weight(.bold))
				.foregroundStyle(.primary)
			Text("A 50% rating and a 30% rating do not combine to 80%. The VA applies each rating to what is left of your functional capacity — not to 100. Two conditions rated at 50% and 30% typically result in a combined rating of 65%, which rounds to 60%.")
				.font(.caption.weight(.semibold))
				.foregroundStyle(.primary.opacity(0.8))
				.fixedSize(horizontal: false, vertical: true)

			Divider()

			Text("You may qualify at the 100% rate without a 100% rating.")
				.font(.caption.weight(.bold))
				.foregroundStyle(.primary)
			Text("Total Disability based on Individual Unemployability (TDIU) allows veterans who cannot maintain employment due to service-connected conditions to receive compensation at the 100% rate, even if their combined rating is lower. This is one of the most underutilized benefits available.")
				.font(.caption.weight(.semibold))
				.foregroundStyle(.primary.opacity(0.8))
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding(14)
		.background(.blue.opacity(0.06))
		.clipShape(.rect(cornerRadius: 14))
	}

	private var ratingSelector: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack {
				Text("VA Disability Rating")
					.font(.headline.weight(.bold))
				Spacer()
				Text(ratingLabel)
					.font(.title3.weight(.heavy))
					.foregroundStyle(selectedRating == 0 ? .secondary : AppTheme.forestGreen)
			}
			Slider(value: Binding(
				get: { Double(selectedRating) },
				set: { selectedRating = Int($0.rounded() / 10) * 10 }
			), in: 0...100, step: 10)
			.tint(AppTheme.forestGreen)
			Text("Move the slider to see which additional benefits typically apply at each rating level.")
				.font(.caption2.weight(.semibold))
				.foregroundStyle(.secondary)
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding(16)
		.background(Color(.secondarySystemGroupedBackground))
		.clipShape(.rect(cornerRadius: 14))
	}

	private var benefitsList: some View {
		VStack(alignment: .leading, spacing: 12) {
			if applicableBenefits.isEmpty {
				Text("Select a rating above to see applicable benefits.")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .center)
					.padding(20)
			} else {
				Text("\(applicableBenefits.count) benefits at \(ratingLabel)")
					.font(.caption.weight(.bold))
					.foregroundStyle(.secondary)

				ForEach(allBenefits) { benefit in
					let isActive = selectedRating >= benefit.minimumRating
					HStack(alignment: .top, spacing: 12) {
						Image(systemName: benefit.icon)
							.font(.body.weight(.semibold))
							.foregroundStyle(isActive ? benefit.color : .secondary)
							.frame(width: 36, height: 36)
							.background((isActive ? benefit.color : Color.secondary).opacity(0.12))
							.clipShape(.rect(cornerRadius: 10))

						VStack(alignment: .leading, spacing: 4) {
							HStack(spacing: 8) {
								Text(benefit.title)
									.font(.subheadline.weight(.bold))
									.foregroundStyle(isActive ? .primary : .secondary)
								Spacer()
								Text("\(benefit.minimumRating)%+")
									.font(.caption2.weight(.heavy))
									.foregroundStyle(isActive ? benefit.color : .secondary)
									.padding(.horizontal, 7)
									.padding(.vertical, 3)
									.background((isActive ? benefit.color : Color.secondary).opacity(0.12))
									.clipShape(Capsule())
							}
							Text(benefit.description)
								.font(.caption.weight(.semibold))
								.foregroundStyle(isActive ? AnyShapeStyle(Color.primary.opacity(0.8)) : AnyShapeStyle(HierarchicalShapeStyle.secondary))
								.fixedSize(horizontal: false, vertical: true)
						}
					}
					.padding(14)
					.background(Color(.secondarySystemGroupedBackground))
					.clipShape(.rect(cornerRadius: 14))
					.opacity(isActive ? 1.0 : 0.4)
				}
			}
		}
	}

	private var noteCard: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(spacing: 8) {
				Image(systemName: "info.circle.fill")
					.foregroundStyle(.blue)
				Text("About This Tool")
					.font(.subheadline.weight(.bold))
			}
			Text("This is a general reference guide. The benefits listed are informational and based on widely published federal guidelines. Actual eligibility depends on your specific service history, discharge status, and the applicable laws at the time of your claim. Benefits are subject to change.")
				.font(.caption.weight(.semibold))
				.foregroundStyle(.primary.opacity(0.8))
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding(14)
		.background(.blue.opacity(0.06))
		.clipShape(.rect(cornerRadius: 12))
	}

	private var allBenefits: [DisabilityBenefitItem] {[
		DisabilityBenefitItem(id: "comp", icon: "dollarsign.circle.fill", color: AppTheme.forestGreen,
			title: "Monthly Disability Compensation",
			description: "Tax-free monthly payment for service-connected conditions. The amount is based on your rating and dependent status, set by published federal tables that update annually.",
			minimumRating: 10),
		DisabilityBenefitItem(id: "va_hc", icon: "cross.fill", color: .blue,
			title: "VA Healthcare Enrollment",
			description: "Veterans with a service-connected rating of 10% or higher are in Priority Group 1 for VA healthcare, with no copays for conditions related to their rating.",
			minimumRating: 10),
		DisabilityBenefitItem(id: "funding_fee", icon: "house.fill", color: .teal,
			title: "VA Loan Funding Fee Exemption",
			description: "Veterans receiving disability compensation are exempt from the VA home loan funding fee, which can save thousands of dollars at closing.",
			minimumRating: 10),
		DisabilityBenefitItem(id: "travel", icon: "car.fill", color: .purple,
			title: "VA Travel Pay",
			description: "Eligible veterans may be reimbursed for travel to and from VA medical appointments. Eligibility is based on rating, income, and distance traveled.",
			minimumRating: 30),
		DisabilityBenefitItem(id: "commissary", icon: "cart.fill", color: AppTheme.gold,
			title: "Commissary and Exchange Access",
			description: "Veterans with a permanent and total (100% P&T) rating have lifetime access to military commissary and exchange facilities.",
			minimumRating: 100),
		DisabilityBenefitItem(id: "property_tax", icon: "building.columns.fill", color: .orange,
			title: "State Property Tax Exemptions",
			description: "Most states offer property tax exemptions or reductions for disabled veterans. The threshold and amount vary by state — check your state benefits finder for specifics.",
			minimumRating: 50),
		DisabilityBenefitItem(id: "dental", icon: "staroflife.fill", color: .indigo,
			title: "VA Dental Care",
			description: "Veterans rated 100% disabled (or equivalent) are eligible for comprehensive VA dental care at no cost.",
			minimumRating: 100),
		DisabilityBenefitItem(id: "lifetime_hc", icon: "heart.fill", color: .red,
			title: "Lifetime Healthcare Coverage",
			description: "Veterans rated 100% permanent and total (P&T) are enrolled in VA healthcare for life with no copays for any condition, not just service-connected ones.",
			minimumRating: 100),
		DisabilityBenefitItem(id: "chapter35", icon: "graduationcap.fill", color: AppTheme.forestGreen,
			title: "Chapter 35 — Dependents Education",
			description: "Dependents (spouse and children) of veterans rated 100% P&T may be eligible for education and training benefits under the Dependents Educational Assistance program.",
			minimumRating: 100),
		DisabilityBenefitItem(id: "smc", icon: "star.fill", color: AppTheme.gold,
			title: "Special Monthly Compensation",
			description: "Veterans with certain severe disabilities — such as loss of use of limbs or specific combinations of ratings — may qualify for additional compensation above the standard rating amount.",
			minimumRating: 100),
	]}
}

struct DisabilityBenefitItem: Identifiable {
	let id: String
	let icon: String
	let color: Color
	let title: String
	let description: String
	let minimumRating: Int
}
