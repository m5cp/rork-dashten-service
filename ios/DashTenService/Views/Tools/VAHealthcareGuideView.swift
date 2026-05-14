import SwiftUI

struct VAHealthcareGuideView: View {
	@State private var expanded: String? = "enroll"

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {

				accordion("enroll", "cross.circle.fill", .blue, "How to Enroll") {
					VStack(alignment: .leading, spacing: 10) {
						Text("Enrollment is not automatic — you must apply. Most veterans can apply online, by phone, in person at any VA facility, or by mail.")
							.font(.caption.weight(.semibold))
							.foregroundStyle(.primary.opacity(0.85))
							.fixedSize(horizontal: false, vertical: true)
						stepRow("1", "Gather your discharge documents (DD-214 or equivalent) and your Social Security number.")
						stepRow("2", "Apply at va.gov/health-care/apply, call 1-877-222-8387, or visit any VA medical center.")
						stepRow("3", "VA will determine your priority group and notify you of enrollment status.")
						stepRow("4", "Once enrolled, you can schedule appointments at VA facilities nationwide.")
					}
				}

				accordion("groups", "list.number", AppTheme.forestGreen, "Priority Groups") {
					VStack(alignment: .leading, spacing: 8) {
						Text("VA assigns each enrolled veteran to a priority group (1–8). Group 1 gets first access and lowest copays. Group 8 may have income limits.")
							.font(.caption.weight(.semibold))
							.foregroundStyle(.primary.opacity(0.85))
							.fixedSize(horizontal: false, vertical: true)
						ForEach(priorityGroups, id: \.0) { group, description in
							HStack(alignment: .top, spacing: 10) {
								Text("G\(group)")
									.font(.caption2.weight(.heavy))
									.foregroundStyle(.white)
									.frame(width: 28, height: 22)
									.background(group <= 2 ? AppTheme.forestGreen : (group <= 4 ? AppTheme.gold : .secondary))
									.clipShape(.rect(cornerRadius: 6))
								Text(description)
									.font(.caption.weight(.semibold))
									.foregroundStyle(.primary.opacity(0.85))
									.fixedSize(horizontal: false, vertical: true)
							}
						}
					}
				}

				accordion("tricare", "stethoscope", .orange, "TRICARE vs VA Healthcare") {
					VStack(alignment: .leading, spacing: 10) {
						compRow("TRICARE", "Provided through DoD. Requires premiums after separation (unless retired 20+ years or 100% P&T). Nationwide private provider network.", AppTheme.forestGreen)
						compRow("VA Healthcare", "Provided through VA facilities. No premiums for enrolled veterans. Covers service-connected conditions and more. Based on priority group and eligibility.", .blue)
						Text("Some veterans use both — VA for service-connected conditions and TRICARE or private insurance for other care. They are separate systems and do not automatically coordinate.")
							.font(.caption2.weight(.semibold))
							.foregroundStyle(.secondary)
							.fixedSize(horizontal: false, vertical: true)
					}
				}

				accordion("pt100", "heart.fill", .red, "100% P&T — Permanent and Total") {
					VStack(alignment: .leading, spacing: 10) {
						Text("Veterans rated 100% permanent and total have a different set of benefits than veterans with a 100% schedular rating.")
							.font(.caption.weight(.semibold))
							.foregroundStyle(.primary.opacity(0.85))
							.fixedSize(horizontal: false, vertical: true)
						ForEach(ptBenefits, id: \.self) { benefit in
							HStack(alignment: .top, spacing: 8) {
								Circle().fill(.red).frame(width: 5, height: 5).padding(.top, 7)
								Text(benefit)
									.font(.caption.weight(.semibold))
									.foregroundStyle(.primary.opacity(0.85))
									.fixedSize(horizontal: false, vertical: true)
							}
						}
					}
				}

				Text("General information only · Not affiliated with any government agency · Enroll at va.gov or call 1-877-222-8387")
					.font(.caption2)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
					.frame(maxWidth: .infinity)
			}
			.readableContentWidth()
			.padding(.horizontal, 16)
			.padding(.bottom, 40)
		}
		.background(Color(.systemGroupedBackground))
		.navigationTitle("VA Healthcare")
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

	private func stepRow(_ num: String, _ text: String) -> some View {
		HStack(alignment: .top, spacing: 10) {
			Text(num).font(.caption.weight(.heavy)).foregroundStyle(.white)
				.frame(width: 22, height: 22).background(.blue).clipShape(Circle())
			Text(text).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
		}
	}

	private func compRow(_ title: String, _ detail: String, _ color: Color) -> some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(title).font(.caption.weight(.bold)).foregroundStyle(color)
			Text(detail).font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
		}
		.padding(10).frame(maxWidth: .infinity, alignment: .leading)
		.background(color.opacity(0.06)).clipShape(.rect(cornerRadius: 10))
	}

	private let priorityGroups: [(Int, String)] = [
		(1, "Veterans with service-connected disabilities rated 50%+ or receiving compensation for specific conditions."),
		(2, "Veterans rated 30–40% service-connected."),
		(3, "Veterans rated 10–20% service-connected, former POWs, Purple Heart recipients, veterans discharged for disability."),
		(4, "Veterans receiving Aid and Attendance, or determined to be catastrophically disabled."),
		(5, "Veterans without service-connected disabilities who meet income and net worth thresholds."),
		(6, "World War I veterans, veterans exposed to certain hazardous materials, and others with specific qualifying conditions."),
		(7, "Veterans with income above the threshold but below the geographic income limit."),
		(8, "Veterans with income above all thresholds — enrollment may have waiting periods depending on VA capacity."),
	]

	private let ptBenefits = [
		"VA healthcare for life at no cost for any condition, not only service-connected ones.",
		"No VA funding fee on home loans.",
		"Commissary and military exchange access for life.",
		"Dependents may qualify for education benefits under the Dependents Educational Assistance program.",
		"State property tax exemptions in most states — check your state benefits finder.",
		"Special Monthly Compensation may apply depending on the nature of qualifying disabilities.",
	]
}
