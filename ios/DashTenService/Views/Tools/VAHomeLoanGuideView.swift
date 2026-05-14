import SwiftUI

struct VAHomeLoanGuideView: View {
	let storage: StorageService
	@State private var expanded: String? = "benefits"

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				accordion("benefits", "star.fill", AppTheme.gold, "Key Benefits") { benefitsContent }
				accordion("eligibility", "checkmark.shield.fill", .blue, "Who Is Eligible") { eligibilityContent }
				accordion("steps", "map.fill", AppTheme.forestGreen, "Homebuying Steps") { stepsContent }
				accordion("coe", "doc.badge.checkmark", .purple, "Certificate of Eligibility") { coeContent }
				accordion("concepts", "lightbulb.fill", .orange, "Key Concepts") { conceptsContent }

				NavigationLink(destination: VAFundingFeeCalculatorView(storage: storage)) {
					HStack(spacing: 12) {
						Image(systemName: "percent").font(.title3.weight(.bold)).foregroundStyle(.white)
							.frame(width: 44, height: 44).background(.blue).clipShape(.rect(cornerRadius: 12))
						VStack(alignment: .leading, spacing: 3) {
							Text("VA Funding Fee Calculator").font(.subheadline.weight(.bold)).foregroundStyle(.primary)
							Text("Calculate your exact fee based on loan type and down payment")
								.font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
						}
						Spacer()
						Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(.secondary)
					}
					.padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14)).contentShape(Rectangle())
				}.buttonStyle(.plain)

				Text("General information only · Not affiliated with any government agency · Verify eligibility at va.gov or with a VA-approved lender")
					.font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center).frame(maxWidth: .infinity)
			}
			.readableContentWidth()
			.padding(.horizontal, 16)
			.padding(.bottom, 40)
		}
		.background(Color(.systemGroupedBackground))
		.navigationTitle("VA Loan Basics")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func accordion<C: View>(_ id: String, _ icon: String, _ color: Color, _ title: String, @ViewBuilder content: () -> C) -> some View {
		VStack(alignment: .leading, spacing: 0) {
			Button {
				withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
					expanded = expanded == id ? nil : id
				}
			} label: {
				HStack(spacing: 12) {
					Image(systemName: icon).font(.body.weight(.semibold)).foregroundStyle(color)
						.frame(width: 36, height: 36).background(color.opacity(0.12)).clipShape(.rect(cornerRadius: 10))
					Text(title).font(.headline.weight(.bold)).foregroundStyle(.primary)
					Spacer()
					Image(systemName: "chevron.down").font(.caption.weight(.bold)).foregroundStyle(.secondary)
						.rotationEffect(.degrees(expanded == id ? 0 : -90))
				}
				.padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14)).contentShape(Rectangle())
			}
			.buttonStyle(.plain).sensoryFeedback(.selection, trigger: expanded)

			if expanded == id {
				VStack(alignment: .leading, spacing: 0) { content() }
					.padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
			}
		}
	}

	private var benefitsContent: some View {
		VStack(spacing: 8) {
			benefitRow("house.fill", AppTheme.forestGreen, "No Down Payment", "Eligible borrowers with full entitlement can purchase with no down payment as long as the sale price does not exceed the appraised value.")
			benefitRow("shield.slash.fill", .blue, "No Private Mortgage Insurance", "VA loans never require PMI — saving hundreds of dollars a month compared to conventional loans with less than 20% down.")
			benefitRow("chart.line.downtrend.xyaxis", .teal, "Competitive Interest Rates", "Lenders offer VA-backed loans at competitive rates because the VA guarantees a portion of the loan.")
			benefitRow("arrow.triangle.swap", .purple, "Reusable Benefit", "The VA home loan benefit can be used more than once. Once a prior VA loan is paid off, entitlement is restored.")
			benefitRow("dollarsign.circle.fill", AppTheme.gold, "Seller Can Pay Closing Costs", "VA rules allow sellers, lenders, or other parties to pay closing costs — reducing out-of-pocket expenses at closing.")
			benefitRow("xmark.circle.fill", .red, "No Prepayment Penalty", "A VA loan can be paid off early at any time without any penalty or fee.")
		}
	}

	private func benefitRow(_ icon: String, _ color: Color, _ title: String, _ detail: String) -> some View {
		HStack(alignment: .top, spacing: 10) {
			Image(systemName: icon).font(.caption.weight(.bold)).foregroundStyle(.white)
				.frame(width: 28, height: 28).background(color).clipShape(.rect(cornerRadius: 7))
			VStack(alignment: .leading, spacing: 3) {
				Text(title).font(.caption.weight(.bold))
				Text(detail).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
			}
		}
		.padding(10).background(Color(.tertiarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 10))
	}

	private var eligibilityContent: some View {
		VStack(alignment: .leading, spacing: 12) {
			eligibilityGroup("Active Duty", .blue, ["At least 90 continuous days of active-duty service."])
			eligibilityGroup("Veterans (Gulf War era — Aug 1990 to present)", .blue, [
				"24 continuous months, or",
				"Full period of at least 90 days if called or ordered to active duty, or",
				"At least 90 days if discharged for hardship, reduction in force, or convenience of government."])
			eligibilityGroup("National Guard and Reserve", .blue, [
				"6 creditable years in Selected Reserve or National Guard, and",
				"Honorable discharge, on the retired list, or continue to serve, or",
				"At least 90 days of non-training active-duty service."])
			eligibilityGroup("Surviving Spouses", .blue, [
				"Unremarried spouse of a veteran who died in service or from a service-connected disability.",
				"Spouse receiving Dependency and Indemnity Compensation.",
				"Spouse of a service member MIA or POW for 90+ days (one-time use)."])
			Text("Only the VA can make a final eligibility determination. Visit va.gov or contact a VA-approved lender to verify your situation.")
				.font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
		}
	}

	private func eligibilityGroup(_ title: String, _ color: Color, _ items: [String]) -> some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title).font(.caption.weight(.bold)).foregroundStyle(color)
			ForEach(items, id: \.self) { item in
				HStack(alignment: .top, spacing: 8) {
					Circle().fill(color).frame(width: 5, height: 5).padding(.top, 7)
					Text(item).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
				}
			}
		}
	}

	private var stepsContent: some View {
		VStack(alignment: .leading, spacing: 10) {
			ForEach(Array(steps.enumerated()), id: \.0) { i, step in
				HStack(alignment: .top, spacing: 10) {
					Text("\(i+1)").font(.caption.weight(.heavy)).foregroundStyle(.white)
						.frame(width: 24, height: 24).background(AppTheme.forestGreen).clipShape(Circle())
					VStack(alignment: .leading, spacing: 3) {
						Text(step.0).font(.caption.weight(.bold))
						Text(step.1).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
					}
				}
				if i < steps.count - 1 { Divider().padding(.leading, 34) }
			}
		}
	}

	private let steps = [
		("Apply for Your Certificate of Eligibility (COE)", "The COE confirms your eligibility to a lender. Apply online at va.gov, through your lender, or by mail."),
		("Review Your Finances", "Check your credit, income, and monthly expenses. Determine how much you want to spend on a mortgage including closing costs."),
		("Choose a VA-Approved Lender", "Shop around — lenders offer different rates and fees on VA-backed loans."),
		("Choose a Real Estate Agent", "Work with an agent familiar with VA loans. They help with offers, contracts, and the VA Escape Clause."),
		("Find a Home", "The home must be your primary residence."),
		("VA Appraisal", "Your lender orders a VA appraisal to determine the home's value and check basic property requirements."),
		("Home Inspection", "A separate, optional inspection by a licensed inspector that looks for issues beyond the appraisal."),
		("Close on Your Home", "Sign documents and take ownership."),
	]

	private var coeContent: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("The Certificate of Eligibility confirms to a lender that you qualify for the VA home loan. There are three ways to get it.")
				.font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
			coeMethodRow("1", "Through Your Lender", "Most lenders can obtain your COE in seconds through the VA's online system.")
			coeMethodRow("2", "Online at va.gov", "Log in using your DS Logon or ID.me account and apply directly.")
			coeMethodRow("3", "By Mail", "Fill out VA Form 26-1880 and mail it to the VA regional loan center for your state. Takes longer than the other methods.")
			Text("If you previously used a VA home loan, your COE will show how much entitlement is available. Full entitlement is restored when a prior VA-financed home is sold and the loan is paid off.")
				.font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
		}
	}

	private func coeMethodRow(_ num: String, _ title: String, _ detail: String) -> some View {
		HStack(alignment: .top, spacing: 10) {
			Text(num).font(.caption.weight(.heavy)).foregroundStyle(.white)
				.frame(width: 22, height: 22).background(.purple).clipShape(Circle())
			VStack(alignment: .leading, spacing: 3) {
				Text(title).font(.caption.weight(.bold))
				Text(detail).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
			}
		}
	}

	private var conceptsContent: some View {
		VStack(spacing: 8) {
			ForEach(concepts, id: \.0) { title, detail in
				VStack(alignment: .leading, spacing: 5) {
					Text(title).font(.caption.weight(.bold)).foregroundStyle(.orange)
					Text(detail).font(.caption2.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
				}
				.padding(10).frame(maxWidth: .infinity, alignment: .leading)
				.background(Color(.tertiarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 10))
			}
		}
	}

	private let concepts = [
		("VA Escape Clause", "Every VA sales contract includes a clause allowing you to walk away without losing your earnest money if the appraisal comes in below the contract price."),
		("Appraisal vs Home Inspection", "The VA appraisal determines the home's value and checks basic property requirements. A home inspection is a separate, more detailed review of the home's condition."),
		("Loan Entitlement", "With full entitlement there is no loan limit. With partial entitlement — when you have another active VA loan — the county conforming loan limit applies."),
		("Loan Assumption", "A VA loan can be assumed, meaning a buyer takes over your loan rather than getting a new one. VA approval is required. Your entitlement stays attached until the loan is paid off or another eligible veteran substitutes their entitlement."),
		("Energy Efficient Mortgage", "Up to $6,000 of energy efficiency improvements can be included in a VA loan at closing — solar panels, insulation, heat pumps, and similar upgrades."),
		("No Loan Limit with Full Entitlement", "As of 2020, service members with full VA entitlement can purchase at any price without a VA-imposed loan limit or required down payment."),
	]
}
