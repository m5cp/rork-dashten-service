import SwiftUI
import StoreKit
import RevenueCat

struct PaywallView: View {
	var store: StoreViewModel
	@Environment(\.dismiss) private var dismiss
	@State private var appeared: Bool = false
	@State private var showTerms: Bool = false
	@State private var showPrivacy: Bool = false
	@State private var showRedeemCode: Bool = false
	@State private var selectedPackageId: String?

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 0) {
					headerSection
					freeVsProSection
					purchaseSection
					restoreButton
					redeemCodeButton
					legalSection
				}
			}
			.background(Color(.systemGroupedBackground))
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button { dismiss() } label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title3)
							.symbolRenderingMode(.hierarchical)
							.foregroundStyle(.secondary)
					}
					.accessibilityLabel("Close")
					.frame(minWidth: 44, minHeight: 44)
				}
			}
			.alert("Error", isPresented: .init(
				get: { store.error != nil },
				set: { if !$0 { store.error = nil } }
			)) {
				Button("OK") { store.error = nil }
			} message: {
				Text(store.error ?? "")
			}
			.onChange(of: store.isPremium) { _, isPremium in
				if isPremium { dismiss() }
			}
			.onAppear {
				withAnimation(.spring(response: 0.7)) { appeared = true }
			}
			.sheet(isPresented: $showTerms) { TermsOfUseView() }
			.sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
			.offerCodeRedemption(isPresented: $showRedeemCode) { _ in
				Task { await store.checkStatus() }
			}
		}
	}

	// MARK: - Header

	private var headerSection: some View {
		VStack(spacing: 20) {
			ZStack {
				Circle()
					.fill(LinearGradient(
						colors: [AppTheme.forestGreen, AppTheme.darkGreen],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					))
					.frame(width: 88, height: 88)
				Image(systemName: "star.circle.fill")
					.font(.system(size: 44))
					.foregroundStyle(.white)
			}
			.scaleEffect(appeared ? 1 : 0.6)
			.opacity(appeared ? 1 : 0)

			VStack(spacing: 8) {
				Text("DashTen Pro")
					.font(.largeTitle.weight(.heavy))
					.tracking(-0.5)
				Text("Tools to land strong — not just get out safely.")
					.font(.subheadline.weight(.semibold))
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
			}
			.opacity(appeared ? 1 : 0)
		}
		.padding(.top, 32)
		.padding(.bottom, 24)
		.padding(.horizontal, 24)
	}

	// MARK: - Free vs Pro

	private var freeVsProSection: some View {
		VStack(spacing: 16) {

			// Free column
			VStack(alignment: .leading, spacing: 14) {
				HStack(spacing: 8) {
					Image(systemName: "checkmark.shield.fill")
						.foregroundStyle(AppTheme.forestGreen)
					Text("Always Free")
						.font(.headline.weight(.bold))
						.foregroundStyle(AppTheme.forestGreen)
				}
				VStack(alignment: .leading, spacing: 8) {
					ForEach(freeFeatures, id: \.self) { feature in
						HStack(alignment: .top, spacing: 10) {
							Image(systemName: "checkmark.circle.fill")
								.font(.caption.weight(.bold))
								.foregroundStyle(AppTheme.forestGreen)
								.padding(.top, 1)
							Text(feature)
								.font(.subheadline.weight(.semibold))
								.foregroundStyle(.primary)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
				}
			}
			.padding(16)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(AppTheme.forestGreen.opacity(0.06))
			.clipShape(.rect(cornerRadius: 16))

			// Pro column
			VStack(alignment: .leading, spacing: 14) {
				HStack(spacing: 8) {
					Image(systemName: "star.circle.fill")
						.foregroundStyle(AppTheme.gold)
					Text("Pro Features")
						.font(.headline.weight(.bold))
						.foregroundStyle(AppTheme.gold)
				}
				VStack(alignment: .leading, spacing: 8) {
					ForEach(proFeatures, id: \.0) { icon, feature in
						HStack(alignment: .top, spacing: 10) {
							Image(systemName: icon)
								.font(.caption.weight(.bold))
								.foregroundStyle(AppTheme.gold)
								.frame(width: 16)
								.padding(.top, 1)
							Text(feature)
								.font(.subheadline.weight(.semibold))
								.foregroundStyle(.primary)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
				}
			}
			.padding(16)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(AppTheme.gold.opacity(0.06))
			.clipShape(.rect(cornerRadius: 16))
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 24)
	}

	private let freeFeatures: [String] = [
		"Personalized roadmap and countdown",
		"Resume translator — all 6 branches",
		"Document vault with legal & estate checklist",
		"VA Home Loan Guide and Funding Fee Calculator",
		"TSP Options, Growth Estimator, and BRS Snapshot",
		"GI Bill BAH and Education Benefits calculators",
		"SCRA Protections reference guide",
		"State Benefits Finder",
		"VA Healthcare Guide",
		"Benefits by Disability Rating",
		"Financial Readiness resources by branch",
		"All basic financial calculators",
		"Readiness Score, XP, and badges",
		"Weekly missions",
	]

	private let proFeatures: [(String, String)] = [
		("person.fill.questionmark", "Interview Prep — flashcard practice by category"),
		("mic.fill", "Elevator Pitch Builder — 30, 60, and 90 second versions"),
		("person.3.fill", "Networking Hub — contact and follow-up tracker"),
		("person.crop.circle.badge.checkmark", "Personal Brand Audit — score your professional presence"),
		("calendar.badge.clock", "First 90 Days Planner — week-by-week post-hire roadmap"),
		("book.fill", "Transition Journal — guided daily prompts"),
		("chart.xyaxis.line", "Wellness Check-In — track readiness over time"),
		("map.fill", "Civilian Playbook — the unwritten rules of civilian work"),
		("flag.fill", "First 30 Days Guide — hit the ground running"),
	]

	// MARK: - Purchase

	private var purchaseSection: some View {
		VStack(spacing: 14) {
			if store.isLoading {
				ProgressView()
					.padding(32)
			} else if let offering = store.offerings?.current {
				ForEach(offering.availablePackages, id: \.identifier) { package in
					packageButton(package)
				}
			} else {
				// Fallback when offerings haven't loaded
				VStack(spacing: 10) {
					placeholderPackageButton(
						title: "Monthly",
						price: "$7.99",
						period: "per month",
						subprice: nil,
						badge: nil,
						isSelected: selectedPackageId == "monthly"
					)
					placeholderPackageButton(
						title: "Annual",
						price: "$59.99",
						period: "per year",
						subprice: "about $1.15 / week · save 37%",
						badge: "Best Value",
						isSelected: selectedPackageId == "annual"
					)
				}
			}

			// Auto-renewal disclosure ABOVE the CTA (App Review 3.1)
			autoRenewalDisclosure

			// CTA button
			Button {
				guard let package = selectedPackage(from: store.offerings) else { return }
				Task { await store.purchase(package: package) }
			} label: {
				Group {
					if store.isPurchasing {
						ProgressView()
							.progressViewStyle(.circular)
							.tint(.white)
					} else {
						Text("Start 3-Day Free Trial")
							.font(.headline.weight(.bold))
					}
				}
				.foregroundStyle(.white)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 18)
				.background(
					LinearGradient(
						colors: [AppTheme.forestGreen, AppTheme.darkGreen],
						startPoint: .leading,
						endPoint: .trailing
					)
				)
				.clipShape(.rect(cornerRadius: 14))
			}
			.disabled(store.isPurchasing || selectedPackageId == nil)
			.frame(minHeight: 44)

			Text("Then \(selectedRenewalSummary). Cancel anytime in Settings.")
				.font(.caption.weight(.semibold))
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

	private var autoRenewalDisclosure: some View {
		HStack(alignment: .top, spacing: 10) {
			Image(systemName: "arrow.triangle.2.circlepath")
				.font(.caption.weight(.bold))
				.foregroundStyle(.secondary)
				.padding(.top, 1)
			Text("After your 3-day free trial, your subscription will auto-renew at the price above until you cancel. Cancel at least 24 hours before the period ends to avoid charges. Manage in your App Store account at any time.")
				.font(.caption2.weight(.semibold))
				.foregroundStyle(.secondary)
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding(12)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(.tertiarySystemGroupedBackground))
		.clipShape(.rect(cornerRadius: 10))
	}

	private var selectedRenewalSummary: String {
		guard let pkg = selectedPackage(from: store.offerings) else {
			if selectedPackageId == "annual" { return "$59.99 / year auto-renews" }
			if selectedPackageId == "monthly" { return "$7.99 / month auto-renews" }
			return "your selected plan auto-renews"
		}
		let period = pkg.packageType == .annual ? "year" : "month"
		return "\(pkg.localizedPriceString) / \(period) auto-renews"
	}

	private func packageButton(_ package: Package) -> some View {
		let isAnnual = package.packageType == .annual
		let isSelected = selectedPackageId == package.identifier
		let periodText = isAnnual ? "per year" : "per month"
		let weeklyEquivalent: String? = isAnnual
			? "about \(weeklyEquivalentString(for: package)) / week · save 37%"
			: nil

		return Button {
			withAnimation(.spring(response: 0.3)) {
				selectedPackageId = package.identifier
			}
		} label: {
			packageButtonContent(
				title: isAnnual ? "Annual" : "Monthly",
				price: package.localizedPriceString,
				period: periodText,
				subprice: weeklyEquivalent,
				badge: isAnnual ? "Best Value" : nil,
				isSelected: isSelected
			)
		}
		.buttonStyle(.plain)
		.frame(minHeight: 44)
		.onAppear {
			if isAnnual && selectedPackageId == nil {
				selectedPackageId = package.identifier
			}
		}
	}

	private func weeklyEquivalentString(for package: Package) -> String {
		let price = NSDecimalNumber(decimal: package.storeProduct.price).doubleValue
		guard price > 0 else { return "$0" }
		let perWeek = price / 52.0
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = package.storeProduct.priceFormatter?.locale ?? Locale.current
		formatter.maximumFractionDigits = 2
		formatter.minimumFractionDigits = 2
		return formatter.string(from: NSNumber(value: perWeek)) ?? String(format: "$%.2f", perWeek)
	}

	@ViewBuilder
	private func packageButtonContent(title: String, price: String, period: String, subprice: String?, badge: String?, isSelected: Bool) -> some View {
		HStack(spacing: 14) {
			Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
				.font(.title2)
				.foregroundStyle(isSelected ? AppTheme.forestGreen : .secondary)

			VStack(alignment: .leading, spacing: 4) {
				HStack(spacing: 8) {
					Text(title)
						.font(.subheadline.weight(.heavy))
						.foregroundStyle(.primary)
					if let badge {
						Text(badge)
							.font(.caption2.weight(.heavy))
							.foregroundStyle(.white)
							.padding(.horizontal, 8)
							.padding(.vertical, 3)
							.background(AppTheme.gold)
							.clipShape(Capsule())
					}
				}
				if let subprice {
					Text(subprice)
						.font(.caption2.weight(.semibold))
						.foregroundStyle(.secondary)
				}
			}

			Spacer(minLength: 8)

			VStack(alignment: .trailing, spacing: 0) {
				Text(price)
					.font(.system(size: 22, weight: .heavy, design: .rounded))
					.foregroundStyle(.primary)
				Text(period)
					.font(.caption2.weight(.semibold))
					.foregroundStyle(.secondary)
			}
		}
		.padding(16)
		.background(
			isSelected
				? AppTheme.forestGreen.opacity(0.08)
				: Color(.secondarySystemGroupedBackground)
		)
		.overlay(
			RoundedRectangle(cornerRadius: 14)
				.stroke(
					isSelected ? AppTheme.forestGreen : Color.clear,
					lineWidth: 2
				)
		)
		.clipShape(.rect(cornerRadius: 14))
		.contentShape(Rectangle())
	}

	private func placeholderPackageButton(title: String, price: String, period: String, subprice: String?, badge: String?, isSelected: Bool) -> some View {
		Button {
			withAnimation(.spring(response: 0.3)) {
				selectedPackageId = title.lowercased()
			}
		} label: {
			packageButtonContent(
				title: title,
				price: price,
				period: period,
				subprice: subprice,
				badge: badge,
				isSelected: isSelected
			)
		}
		.buttonStyle(.plain)
		.frame(minHeight: 44)
		.onAppear {
			if title == "Annual" && selectedPackageId == nil {
				selectedPackageId = title.lowercased()
			}
		}
	}

	private func selectedPackage(from offerings: Offerings?) -> Package? {
		offerings?.current?.availablePackages.first { $0.identifier == selectedPackageId }
	}

	// MARK: - Restore / Redeem / Legal

	private var restoreButton: some View {
		Button {
			Task { await store.restore() }
		} label: {
			Text("Restore Purchases")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(.secondary)
				.frame(maxWidth: .infinity)
				.frame(minHeight: 44)
		}
		.padding(.horizontal, 16)
	}

	private var redeemCodeButton: some View {
		Button {
			showRedeemCode = true
		} label: {
			HStack(spacing: 6) {
				Image(systemName: "gift.fill")
					.font(.caption.weight(.bold))
				Text("Redeem a code")
					.font(.subheadline.weight(.semibold))
			}
			.foregroundStyle(.secondary)
			.frame(maxWidth: .infinity)
			.frame(minHeight: 44)
		}
		.padding(.horizontal, 16)
		.accessibilityLabel("Redeem an offer code")
	}

	private var legalSection: some View {
		VStack(spacing: 12) {
			HStack(spacing: 24) {
				Button("Terms of Use") { showTerms = true }
					.frame(minHeight: 44)
				Button("Privacy Policy") { showPrivacy = true }
					.frame(minHeight: 44)
			}
			.font(.caption.weight(.semibold))
			.foregroundStyle(.secondary)

			Text("General information only · Not financial or legal advice")
				.font(.caption2)
				.foregroundStyle(.secondary.opacity(0.7))
				.multilineTextAlignment(.center)
		}
		.padding(.horizontal, 24)
		.padding(.top, 8)
		.padding(.bottom, 40)
	}
}
