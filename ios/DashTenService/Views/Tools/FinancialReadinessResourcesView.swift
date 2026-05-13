import SwiftUI

struct FinancialReadinessResourcesView: View {
	@State private var selectedBranch: MilitaryBranch = .army

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				branchPicker
				branchResourceCard
				universalResourcesSection
				Text("General information only · Not affiliated with any government agency")
					.font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center).frame(maxWidth: .infinity)
			}
			.padding(.horizontal, 16)
			.padding(.bottom, 40)
		}
		.background(Color(.systemGroupedBackground))
		.navigationTitle("Pay Help")
		.navigationBarTitleDisplayMode(.inline)
	}

	private var branchPicker: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Your Branch").font(.headline.weight(.bold))
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 10) {
					ForEach([MilitaryBranch.army, .navy, .marineCorps, .airForce, .spaceForce, .coastGuard, .nationalGuard, .reserve, .spouseFamily, .veteran], id: \.self) { branch in
						Button {
							withAnimation(.spring(response: 0.3)) { selectedBranch = branch }
						} label: {
							HStack(spacing: 6) {
								Image(systemName: branch.icon).font(.caption.weight(.bold))
								Text(branch.rawValue).font(.caption.weight(.bold))
							}
							.padding(.horizontal, 14).padding(.vertical, 10)
							.background(selectedBranch == branch ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
							.foregroundStyle(selectedBranch == branch ? .white : .primary)
							.clipShape(Capsule())
						}.buttonStyle(.plain)
					}
				}.padding(.vertical, 2)
			}
		}
	}

	private var branchResourceCard: some View {
		let r = resource(for: selectedBranch)
		return VStack(alignment: .leading, spacing: 14) {
			HStack(spacing: 12) {
				Image(systemName: selectedBranch.icon).font(.title3.weight(.bold)).foregroundStyle(.white)
					.frame(width: 44, height: 44).background(AppTheme.forestGreen).clipShape(.rect(cornerRadius: 12))
				VStack(alignment: .leading, spacing: 3) {
					Text(r.name).font(.subheadline.weight(.bold))
					Text(r.location).font(.caption2.weight(.bold)).foregroundStyle(AppTheme.forestGreen).fixedSize(horizontal: false, vertical: true)
				}
			}
			Text(r.description).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
			if !r.topics.isEmpty {
				Divider()
				Text("Topics Covered").font(.caption.weight(.bold)).foregroundStyle(.secondary)
				ForEach(r.topics, id: \.self) { topic in
					HStack(alignment: .top, spacing: 8) {
						Circle().fill(AppTheme.forestGreen).frame(width: 5, height: 5).padding(.top, 7)
						Text(topic).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
					}
				}
			}
		}
		.padding(16).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
	}

	private var universalResourcesSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Available to Everyone").font(.headline.weight(.bold))
			VStack(spacing: 10) {
				uRow("headphones.circle.fill", .blue, "24/7 Financial Counseling", "The Department of Defense provides a free 24-hour financial counseling line for active duty, Guard, Reserve, and family members.")
				uRow("building.columns.fill", .teal, "Consumer Financial Protection Bureau", "A federal agency with tools for comparing loan offers, filing complaints, and guides on mortgages, credit, and student loans. consumerfinance.gov")
				uRow("magnifyingglass.circle.fill", .orange, "Verifying a Financial Professional", "Financial professionals who work with investments are required to be licensed. Background information is publicly searchable through government and regulatory databases at no cost.")
				uRow("chart.bar.fill", AppTheme.forestGreen, "Government Financial Education Tools", "Free online tools for retirement calculations, investor education, and fund comparison are available through federal financial regulatory agencies.")
			}
		}
	}

	private func uRow(_ icon: String, _ color: Color, _ name: String, _ desc: String) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(spacing: 10) {
				Image(systemName: icon).font(.body.weight(.semibold)).foregroundStyle(color)
					.frame(width: 32, height: 32).background(color.opacity(0.12)).clipShape(.rect(cornerRadius: 8))
				Text(name).font(.subheadline.weight(.bold))
			}
			Text(desc).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.8)).fixedSize(horizontal: false, vertical: true)
		}
		.padding(14).background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 12))
	}

	private struct BranchInfo { let name: String; let location: String; let description: String; let topics: [String] }

	private func resource(for branch: MilitaryBranch) -> BranchInfo {
		switch branch {
		case .army: return BranchInfo(name: "Personal Financial Readiness Program", location: "Army Community Service (ACS) Centers",
			description: "ACS centers provide financial readiness counseling and workshops at Army installations at no cost.",
			topics: ["Budget and spending plans", "Debt management", "TSP and retirement", "PCS financial preparation", "Tax assistance"])
		case .navy: return BranchInfo(name: "Personal Financial Management Program", location: "Fleet and Family Support Centers (FFSC)",
			description: "FFSCs provide individual financial counseling and workshops for Navy and Marine Corps personnel and families.",
			topics: ["Budget development", "Deployment financial preparation", "Consumer information", "Transition planning"])
		case .marineCorps: return BranchInfo(name: "Personal Financial Management Program", location: "Marine Corps Community Services (MCCS)",
			description: "MCCS Personal Financial Specialists provide individual counseling and group workshops.",
			topics: ["Spending plan development", "Credit and debt information", "Savings basics", "Transition preparation"])
		case .airForce, .spaceForce: return BranchInfo(name: "Personal Financial Information Program", location: "Airman and Family Readiness Centers (A&FRC)",
			description: "A&FRCs provide financial workshops and individual consultations for Air Force and Space Force members and families.",
			topics: ["Budget counseling", "PCS financial preparation", "Benefits information", "Transition preparation"])
		case .coastGuard: return BranchInfo(name: "Personal Financial Management Program", location: "Health, Safety, and Work-Life (HSWL) Regional Offices",
			description: "HSWL regional offices provide financial counseling services and workshops for Coast Guard members.",
			topics: ["Budget counseling", "Financial goal planning", "Transition information"])
		case .nationalGuard: return BranchInfo(name: "National Guard Financial Readiness", location: "State Joint Force Headquarters",
			description: "National Guard members can access financial resources through their State Joint Force Headquarters and reintegration programs.",
			topics: ["Reintegration financial workshops", "Federal phone counseling", "SCRA information during activation"])
		case .reserve: return BranchInfo(name: "Reserve Financial Readiness", location: "Reserve centers and federal counseling services",
			description: "Reserve members access counseling through federal 24-hour phone services and installation resources when on active orders.",
			topics: ["Federal phone counseling", "Reintegration workshops", "SCRA information", "TSP information"])
		case .spouseFamily: return BranchInfo(name: "Military Family Financial Resources", location: "Installation family support centers",
			description: "Military spouses and family members have access to the same installation financial counseling services as the service member.",
			topics: ["Individual counseling", "PCS budgeting", "Employment and career planning", "SCRA spousal information"])
		case .veteran: return BranchInfo(name: "Veteran Financial Resources", location: "VA facilities and Veterans Service Organizations",
			description: "Veterans have access to financial guidance through VA financial counselors, Veterans Service Organizations, and government-affiliated agencies.",
			topics: ["VA benefits information", "VSO claims assistance", "Government-approved housing counseling"])
		}
	}
}
