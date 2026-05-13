import SwiftUI

enum VALoanType: String, CaseIterable, Identifiable {
	case purchase = "Purchase"
	case cashOutRefi = "Cash-Out Refi"
	case irrrl = "Streamline Refi"
	case assumption = "Loan Assumption"
	var id: String { rawValue }
	var description: String {
		switch self {
		case .purchase: return "Buying or building a home."
		case .cashOutRefi: return "Refinancing a non-VA loan or taking equity out."
		case .irrrl: return "Refinancing an existing VA loan at a lower rate."
		case .assumption: return "A buyer takes over your existing VA loan."
		}
	}
}

enum DownPaymentTier: String, CaseIterable, Identifiable {
	case zero = "0%"; case five = "5%+"; case ten = "10%+"
	var id: String { rawValue }
}

struct VAFundingFeeCalculatorView: View {
	let storage: StorageService
	@State private var loanType: VALoanType = .purchase
	@State private var isFirstUse: Bool = true
	@State private var downPaymentTier: DownPaymentTier = .zero
	@State private var isExempt: Bool = false
	@State private var loanAmount: String = ""

	private var amt: Double { Double(loanAmount) ?? 0 }

	private var feePct: Double {
		guard !isExempt else { return 0 }
		switch loanType {
		case .purchase:
			return isFirstUse ? [DownPaymentTier.zero: 2.30, .five: 1.65, .ten: 1.40][downPaymentTier]! : [DownPaymentTier.zero: 3.60, .five: 1.65, .ten: 1.40][downPaymentTier]!
		case .cashOutRefi: return isFirstUse ? 2.30 : 3.60
		case .irrrl: return 0.50
		case .assumption: return 0.50
		}
	}

	private var feeDollars: Double { amt * feePct / 100.0 }
	private var pmiMonthly: Double { amt * 0.01 / 12.0 }

	private func fmt(_ v: Double) -> String {
		let f = NumberFormatter(); f.numberStyle = .currency; f.currencyCode = "USD"; f.maximumFractionDigits = 0
		return f.string(from: NSNumber(value: v)) ?? "$0"
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {

				exemptionSection

				VStack(alignment: .leading, spacing: 12) {
					Text("Loan Details").font(.headline.weight(.bold))
					VStack(spacing: 0) {
						VStack(alignment: .leading, spacing: 8) {
							Text("Loan Type").font(.subheadline.weight(.bold))
							Picker("", selection: $loanType) {
								ForEach(VALoanType.allCases) { Text($0.rawValue).tag($0) }
							}.pickerStyle(.menu).tint(AppTheme.forestGreen)
							Text(loanType.description).font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
						}.padding(14)
						Divider().padding(.leading, 14)
						VStack(alignment: .leading, spacing: 8) {
							Text("VA Loan Usage").font(.subheadline.weight(.bold))
							Picker("", selection: $isFirstUse) {
								Text("First Use").tag(true); Text("Subsequent Use").tag(false)
							}.pickerStyle(.segmented)
						}.padding(14)
						if loanType == .purchase {
							Divider().padding(.leading, 14)
							VStack(alignment: .leading, spacing: 8) {
								Text("Down Payment").font(.subheadline.weight(.bold))
								Picker("", selection: $downPaymentTier) {
									ForEach(DownPaymentTier.allCases) { Text($0.rawValue).tag($0) }
								}.pickerStyle(.segmented)
							}.padding(14)
						}
						Divider().padding(.leading, 14)
						PayInputRow(label: "Loan Amount", sublabel: "Total mortgage amount", value: $loanAmount, color: .blue).padding(14)
					}
					.background(Color(.secondarySystemGroupedBackground)).clipShape(.rect(cornerRadius: 14))
				}

				if isExempt {
					VStack(alignment: .leading, spacing: 6) {
						HStack(spacing: 8) {
							Image(systemName: "checkmark.shield.fill").foregroundStyle(.white)
							Text("Exempt — No Funding Fee").font(.headline.weight(.bold)).foregroundStyle(.white)
						}
						if amt > 0 {
							Text("Estimated savings vs standard first-time rate: \(fmt(amt * 0.023))")
								.font(.caption.weight(.semibold)).foregroundStyle(.white.opacity(0.85))
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(16).background(AppTheme.forestGreen).clipShape(.rect(cornerRadius: 14))
				} else if amt > 0 {
					VStack(alignment: .leading, spacing: 8) {
						Text("Estimated Funding Fee").font(.caption.weight(.bold)).foregroundStyle(.white.opacity(0.8))
						Text(fmt(feeDollars)).font(.system(size: 36, weight: .heavy, design: .rounded)).foregroundStyle(.white)
						Text("\(String(format: "%.2f", feePct))% of \(fmt(amt))").font(.caption2.weight(.semibold)).foregroundStyle(.white.opacity(0.7))
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(20).background(.blue).clipShape(.rect(cornerRadius: 16))

					HStack(spacing: 10) {
						VStack(alignment: .leading, spacing: 4) {
							Text("Pay at Closing").font(.caption.weight(.bold)).foregroundStyle(.blue)
							Text("Pay \(fmt(feeDollars)) upfront. Lower monthly payments.")
								.font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
						}.padding(12).frame(maxWidth: .infinity, alignment: .leading).background(.blue.opacity(0.08)).clipShape(.rect(cornerRadius: 10))

						VStack(alignment: .leading, spacing: 4) {
							Text("Roll Into Loan").font(.caption.weight(.bold)).foregroundStyle(.purple)
							Text("Added to loan amount. No cash needed at closing.")
								.font(.caption2.weight(.semibold)).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
						}.padding(12).frame(maxWidth: .infinity, alignment: .leading).background(.purple.opacity(0.08)).clipShape(.rect(cornerRadius: 10))
					}
				}

				rateTableSection

				if amt > 0 {
					VStack(alignment: .leading, spacing: 8) {
						HStack(spacing: 8) {
							Image(systemName: "checkmark.circle.fill").foregroundStyle(AppTheme.forestGreen)
							Text("No Private Mortgage Insurance").font(.subheadline.weight(.bold))
						}
						Text("Conventional loans with less than 20% down typically require PMI. VA loans do not.")
							.font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
						HStack {
							VStack(alignment: .leading, spacing: 2) {
								Text("Est. monthly PMI savings").font(.caption2.weight(.bold)).foregroundStyle(.secondary)
								Text(fmt(pmiMonthly) + " / mo").font(.title3.weight(.heavy)).foregroundStyle(AppTheme.forestGreen)
							}
							Spacer()
							VStack(alignment: .trailing, spacing: 2) {
								Text("Over 5 years").font(.caption2.weight(.bold)).foregroundStyle(.secondary)
								Text(fmt(pmiMonthly * 60)).font(.title3.weight(.heavy)).foregroundStyle(AppTheme.forestGreen)
							}
						}
						Text("Based on 1.0% annual PMI rate estimate.").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
					}
					.padding(14).background(AppTheme.forestGreen.opacity(0.06)).clipShape(.rect(cornerRadius: 14))
				}

				Text("General information only · Not affiliated with any government agency · Rates may change · Verify with a VA-approved lender")
					.font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center).frame(maxWidth: .infinity)
			}
			.padding(.horizontal, 16)
			.padding(.bottom, 40)
		}
		.background(Color(.systemGroupedBackground))
		.navigationTitle("VA Funding Fee")
		.navigationBarTitleDisplayMode(.inline)
	}

	private var exemptionSection: some View {
		VStack(alignment: .leading, spacing: 10) {
			if storage.profile.disabilityRating > 0 && !isExempt {
				HStack(spacing: 8) {
					Image(systemName: "checkmark.shield.fill")
						.foregroundStyle(AppTheme.forestGreen)
					Text("Your profile shows a disability rating. Veterans receiving VA compensation for a service-connected disability do not pay the VA funding fee.")
						.font(.caption.weight(.semibold))
						.foregroundStyle(.primary.opacity(0.85))
						.fixedSize(horizontal: false, vertical: true)
				}
				.padding(12)
				.background(AppTheme.forestGreen.opacity(0.08))
				.clipShape(.rect(cornerRadius: 10))
			}
			Text("Exemption").font(.headline.weight(.bold))
			VStack(alignment: .leading, spacing: 6) {
				exemptRow("Receiving VA compensation for a service-connected disability")
				exemptRow("Entitled to VA compensation but receiving retirement or active-duty pay instead")
				exemptRow("Unremarried surviving spouse of a veteran who died in service or from a service-connected disability")
				exemptRow("Active-duty member awarded the Purple Heart on or before loan closing")
			}
			Toggle(isOn: Binding(
				get: { isExempt || storage.profile.disabilityRating > 0 },
				set: { isExempt = $0 }
			)) {
				Text("I am exempt from the funding fee").font(.subheadline.weight(.bold))
			}.tint(AppTheme.forestGreen)
		}
		.padding(14)
		.background(isExempt ? AppTheme.forestGreen.opacity(0.06) : AppTheme.gold.opacity(0.06))
		.clipShape(.rect(cornerRadius: 14))
	}

	private func exemptRow(_ text: String) -> some View {
		HStack(alignment: .top, spacing: 8) {
			Image(systemName: "checkmark.circle.fill").font(.caption2).foregroundStyle(AppTheme.forestGreen).padding(.top, 2)
			Text(text).font(.caption.weight(.semibold)).foregroundStyle(.primary.opacity(0.85)).fixedSize(horizontal: false, vertical: true)
		}
	}

	private var rateTableSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Purchase Loan Rate Reference").font(.caption.weight(.bold)).foregroundStyle(.secondary)
			VStack(spacing: 0) {
				HStack {
					Text("Down Payment").font(.caption2.weight(.bold)).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading)
					Text("First Use").font(.caption2.weight(.bold)).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .center)
					Text("Subsequent").font(.caption2.weight(.bold)).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .trailing)
				}.padding(.horizontal, 12).padding(.vertical, 8).background(AppTheme.gold.opacity(0.12))
				feeRow("0%", "2.30%", "3.60%")
				feeRow("5%+", "1.65%", "1.65%")
				feeRow("10%+", "1.40%", "1.40%")
			}.clipShape(.rect(cornerRadius: 10))
		}
	}

	private func feeRow(_ dp: String, _ first: String, _ sub: String) -> some View {
		HStack {
			Text(dp).font(.caption.weight(.semibold)).frame(maxWidth: .infinity, alignment: .leading)
			Text(first).font(.caption.weight(.bold)).foregroundStyle(.blue).frame(maxWidth: .infinity, alignment: .center)
			Text(sub).font(.caption.weight(.bold)).foregroundStyle(.purple).frame(maxWidth: .infinity, alignment: .trailing)
		}.padding(.horizontal, 12).padding(.vertical, 9).background(Color(.secondarySystemGroupedBackground))
	}
}
