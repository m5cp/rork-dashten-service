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
		VStack(spacing: 12) {
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
						price: "$7.99 / month",
						badge: nil,
						isSelected: selectedPackageId == "monthly"
					)
					placeholderPackageButton(
						title: "Annual",
						price: "$59.99 / year · Save 37%",
						badge: "Best Value",
						isSelected: selectedPackageId == "annual"
					)
				}
			}

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
						Text("Start Free Trial")
							.font(.headline.weight(.bold))
					}
				}
				.foregroundStyle(.white)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 16)
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
			.padding(.top, 4)

			Text("3-day free trial · Cancel anytime · No commitment")
				.font(.caption.weight(.semibold))
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

	private func packageButton(_ package: Package) -> some View {
		let isAnnual = package.packageType == .annual
		let isSelected = selectedPackageId == package.identifier

		return Button {
			withAnimation(.spring(response: 0.3)) {
				selectedPackageId = package.identifier
			}
		} label: {
			HStack {
				VStack(alignment: .leading, spacing: 3) {
					Text(isAnnual ? "Annual" : "Monthly")
						.font(.subheadline.weight(.bold))
						.foregroundStyle(.primary)
					Text(package.localizedPriceString + (isAnnual ? " / year" : " / month"))
						.font(.caption.weight(.semibold))
						.foregroundStyle(.secondary)
				}
				Spacer()
				if isAnnual {
					Text("Save 37%")
						.font(.caption2.weight(.heavy))
						.foregroundStyle(.white)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(AppTheme.gold)
						.clipShape(Capsule())
				}
				Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
					.font(.title3)
					.foregroundStyle(isSelected ? AppTheme.forestGreen : .secondary)
			}
			.padding(14)
			.background(
				isSelected
					? AppTheme.forestGreen.opacity(0.08)
					: Color(.secondarySystemGroupedBackground)
			)
			.overlay(
				RoundedRectangle(cornerRadius: 14)
					.stroke(
						isSelected ? AppTheme.forestGreen : Color.clear,
						lineWidth: 1.5
					)
			)
			.clipShape(.rect(cornerRadius: 14))
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
		.onAppear {
			if isAnnual && selectedPackageId == nil {
				selectedPackageId = package.identifier
			}
		}
	}

	private func placeholderPackageButton(title: String, price: String, badge: String?, isSelected: Bool) -> some View {
		Button {
			withAnimation(.spring(response: 0.3)) {
				selectedPackageId = title.lowercased()
			}
		} label: {
			HStack {
				VStack(alignment: .leading, spacing: 3) {
					Text(title)
						.font(.subheadline.weight(.bold))
						.foregroundStyle(.primary)
					Text(price)
						.font(.caption.weight(.semibold))
						.foregroundStyle(.secondary)
				}
				Spacer()
				if let badge {
					Text(badge)
						.font(.caption2.weight(.heavy))
						.foregroundStyle(.white)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(AppTheme.gold)
						.clipShape(Capsule())
				}
				Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
					.font(.title3)
					.foregroundStyle(isSelected ? AppTheme.forestGreen : .secondary)
			}
			.padding(14)
			.background(isSelected ? AppTheme.forestGreen.opacity(0.08) : Color(.secondarySystemGroupedBackground))
			.overlay(RoundedRectangle(cornerRadius: 14).stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5))
			.clipShape(.rect(cornerRadius: 14))
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
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
			Text("Subscription auto-renews unless cancelled at least 24 hours before the end of the current period. Manage or cancel anytime in your App Store settings.")
				.font(.caption2)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)

			HStack(spacing: 24) {
				Button("Terms of Use") { showTerms = true }
				Button("Privacy Policy") { showPrivacy = true }
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
