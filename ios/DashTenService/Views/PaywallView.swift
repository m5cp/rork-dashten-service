import SwiftUI
import StoreKit
import RevenueCat

struct PaywallView: View {
    var store: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var appeared: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showRedeemCode: Bool = false
    @State private var selectedPackageId: String? = nil
    @State private var showNoneRestoredAlert: Bool = false

    var body: some View {
        ZStack(alignment: .top) {

            // Background
            LinearGradient(
                colors: [AppTheme.darkGreen, Color(.systemBackground)],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    heroSection
                    featuresSection
                    packagesSection
                    ctaSection
                    footerSection
                }
            }

            // Close button — always available, no cooldown
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .background(.white.opacity(0.12))
                        .clipShape(Circle())
                }
                .frame(minWidth: 44, minHeight: 44)
                .padding(.trailing, 16)
                .padding(.top, 16)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7)) { appeared = true }
            startShaking()
        }
        .onChange(of: store.isPremium) { _, isPremium in
            if isPremium { dismiss() }
        }
        .alert("No Purchases Restored", isPresented: $showNoneRestoredAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("No previous purchases were found for this account.")
        }
        .alert("Error", isPresented: .init(
            get: { store.error != nil },
            set: { if !$0 { store.error = nil } }
        )) {
            Button("OK") { store.error = nil }
        } message: {
            Text(store.error ?? "")
        }
        .sheet(isPresented: $showTerms) { TermsOfUseView() }
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
        .offerCodeRedemption(isPresented: $showRedeemCode) { _ in
            Task { await store.checkStatus() }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 60)

            // Animated icon
            ZStack {
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 130, height: 130)

                Circle()
                    .fill(LinearGradient(
                        colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 96, height: 96)
                    .overlay(
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: AppTheme.forestGreen.opacity(0.5), radius: 20, y: 8)
                    .offset(x: shakeOffset)
            }
            .scaleEffect(appeared ? 1.0 : 0.7)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: appeared)

            VStack(spacing: 10) {
                Text("DashTen Pro")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundStyle(.white)

                Text("Tools to land well — not just get out safely.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            .animation(.spring(response: 0.5).delay(0.15), value: appeared)

            Spacer(minLength: 8)
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(proFeatures.enumerated()), id: \.0) { i, feature in
                HStack(spacing: 14) {
                    Image(systemName: feature.0)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.gold)
                        .frame(width: 28, height: 28)
                        .background(AppTheme.gold.opacity(0.15))
                        .clipShape(.rect(cornerRadius: 8))
                    Text(feature.1)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)
                .animation(.spring(response: 0.4).delay(0.2 + Double(i) * 0.06), value: appeared)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private let proFeatures: [(String, String)] = [
        ("person.fill.questionmark", "Interview Prep — flashcard practice by category"),
        ("mic.fill", "Elevator Pitch Builder — 30, 60, and 90 second versions"),
        ("person.3.fill", "Networking Hub — contact and follow-up tracker"),
        ("person.crop.circle.badge.checkmark", "Personal Brand Audit — score your professional presence"),
        ("calendar.badge.clock", "First 90 Days Planner — week-by-week post-hire roadmap"),
        ("book.fill", "Transition Journal — guided daily prompts"),
        ("chart.xyaxis.line", "Wellness Check-In — track readiness over time"),
        ("map.fill", "Civilian Playbook — unwritten rules of civilian work"),
        ("flag.fill", "First 30 Days Guide — hit the ground running"),
    ]

    // MARK: - Packages

    private var packagesSection: some View {
        VStack(spacing: 10) {
            if store.isLoading {
                ProgressView().padding(24)
            } else if let offering = store.offerings?.current {
                ForEach(offering.availablePackages, id: \.identifier) { package in
                    packageRow(package)
                        .onAppear {
                            // Auto-select annual by default
                            if package.packageType == .annual && selectedPackageId == nil {
                                selectedPackageId = package.identifier
                            }
                        }
                }
            } else {
                // Fallback static display while products load
                staticPackageRow(
                    title: "Annual",
                    detail: "$59.99 per year",
                    isSelected: selectedPackageId == "annual" || selectedPackageId == nil
                ) { selectedPackageId = "annual" }

                staticPackageRow(
                    title: "Monthly",
                    detail: "$7.99 per month",
                    isSelected: selectedPackageId == "monthly"
                ) { selectedPackageId = "monthly" }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private func packageRow(_ package: Package) -> some View {
        let isAnnual = package.packageType == .annual
        let isSelected = selectedPackageId == package.identifier

        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedPackageId = package.identifier
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(isSelected ? AppTheme.forestGreen : .secondary)

                VStack(alignment: .leading, spacing: 3) {
                    Text(isAnnual ? "Annual" : "Monthly")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(package.localizedPriceString + (isAnnual ? " per year" : " per month"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isAnnual {
                    Text("Best Value")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.forestGreen)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private func staticPackageRow(title: String, detail: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(isSelected ? AppTheme.forestGreen : .secondary)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.headline.weight(.bold)).foregroundStyle(.primary)
                    Text(detail).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                }
                Spacer()
                if title == "Annual" {
                    Text("Best Value")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppTheme.forestGreen)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - CTA

    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button {
                if let pkg = selectedPackage {
                    Task { await store.purchase(package: pkg) }
                }
            } label: {
                ZStack {
                    if store.isPurchasing {
                        ProgressView().progressViewStyle(.circular).tint(.white)
                    } else {
                        Text(ctaLabel)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                    }
                }
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

            Text("3-day free trial · Cancel anytime in App Store settings")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var ctaLabel: String {
        guard let id = selectedPackageId,
              let pkg = store.offerings?.current?.availablePackages.first(where: { $0.identifier == id }),
              pkg.packageType != .annual else {
            return "Start Free Trial"
        }
        return "Start Free Trial"
    }

    private var selectedPackage: Package? {
        store.offerings?.current?.availablePackages.first { $0.identifier == selectedPackageId }
    }

    // MARK: - Footer

    private var footerSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                Button {
                    Task {
                        await store.restore()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            if !store.isPremium { showNoneRestoredAlert = true }
                        }
                    }
                } label: {
                    Text("Restore Purchases")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .underline()
                        .frame(minHeight: 44)
                }

                Button { showRedeemCode = true } label: {
                    Text("Redeem Code")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .underline()
                        .frame(minHeight: 44)
                }
            }

            HStack(spacing: 16) {
                Button("Terms of Use") { showTerms = true }
                Button("Privacy Policy") { showPrivacy = true }
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)

            Text("Subscription auto-renews unless cancelled at least 24 hours before the end of the current period. Manage or cancel anytime in your App Store account settings.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("General information only · Not financial or legal advice")
                .font(.caption2)
                .foregroundStyle(.secondary.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
    }

    // MARK: - Shake animation for icon

    private func startShaking() {
        let duration = 0.07
        let shakes = 4
        for i in 0..<shakes {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + Double(i) * duration * 2) {
                withAnimation(.easeInOut(duration: duration)) { shakeOffset = i % 2 == 0 ? 8 : -8 }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeInOut(duration: duration)) { shakeOffset = 0 }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { startShaking() }
    }
}
